----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2019 05:09:36 PM
-- Design Name: 
-- Module Name: fade_control - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fade_control is
    generic(
        fadeSpdBitN  : integer; --fade speed is 100 MHz / (2x2^fadeSpdBitN)
        fadeIntBitN  : integer --nr of intensity levels (should be coherent with nr of bits of 'led_pwm'))
    );
    port(
        clk            : in  std_logic;
        fade_type      : in  std_logic; -- 0 = sawtooth fade, 1 = triangular fade
        fade_intensity : out std_logic_vector(fadeIntBitN-1 downto 0)  -- output to PWM controller
    );
end fade_control;

architecture Behavioral of fade_control is

    --this architecture describes the intensity fading controller
    --the fading effect is obtained by changing the LED intensity with the desired effect
    --there are two fading effect: 
        --sawtooth fade (loop intensity: 0->max)
        --triangular fade (loop intensity:  0->max->0) 
    --the fade speed (i.e. the speed at which the LED intensity is changed) is given by the fading clock signal 'fade_clk' 
    --the period of the fading clock signal is equal to 7.8 [ms]
    --so, we update the LED intensity each 7.8 [ms]. Since we have 128 LED intensity levels, we cover all values in 7.8 [ms] x 128 = 998.4 [ms]
    
    signal fade_demultiplier : std_logic_vector(fadeSpdBitN-1 downto 0) := std_logic_vector(to_unsigned(390000, fadeSpdBitN)); --this signal is used to demultiply the 100 MHz base clock to obtain the fading clock
    signal fade_clk : std_logic := '0'; 
    signal intensity_sig : std_logic_vector(fadeIntBitN-1 downto 0) := (others => '0');
    
    type fade_state_signal is (sawtooth_fade, triangular_fade_up, triangular_fade_down);
    signal fade_state : fade_state_signal := sawtooth_fade;
    
    signal fade_restart_slow : std_logic := '0';
    
begin

    fade_clock_gen : process(clk) --generates the fade clock : default period is 2x390000x10 [ns] = 7.8 [ms] 
    begin
        if(rising_edge(clk))then
            fade_demultiplier <= fade_demultiplier - '1';
            if(fade_demultiplier = std_logic_vector(to_unsigned(0, fadeSpdBitN)))then
                fade_clk <= not(fade_clk); --each time we reach 390000 x 10 [ns] = 3.9 [ms] invert the 'fade_clk' signal
                                           --> the period is 2 x 3.9 [ms]
                fade_demultiplier <= std_logic_vector(to_unsigned(390000, fadeSpdBitN));
            end if;                        
            
            
        end if;
    end process;
    
    fade_gen : process(fade_clk) --generate the fade signal: each 7.8 [ms] increase/decrease the intensity by 1
    begin
        if(rising_edge(fade_clk))then
            
            case(fade_state) is
         
            when(sawtooth_fade) => --state for the sawtooth effect (0->max) 
                
                intensity_sig <= intensity_sig + '1';
                if(fade_type = '0')then --check wheter to change effect or not
                    fade_state <= sawtooth_fade;
                else
                    fade_state <= triangular_fade_up;
                end if;
                
            when(triangular_fade_up) => --state for the positive triangular ramp (0->max)
            
                intensity_sig <= intensity_sig + '1';
                
                if(fade_type = '0')then --check wheter to change effect or not
                    fade_state <= sawtooth_fade;
                elsif(intensity_sig = std_logic_vector(to_unsigned(126, fadeIntBitN)))then --if maximum value has been reached, go to 'triangular_fade_down'
                    fade_state <= triangular_fade_down;
                else
                    fade_state <= triangular_fade_up;
                end if;
                
            when(triangular_fade_down) => --state for the negative triangular ramp (max->0)
            
                intensity_sig <= intensity_sig - '1';
                
                if(fade_type = '0')then --check wheter to change effect or not
                    fade_state <= sawtooth_fade;
                elsif(intensity_sig = std_logic_vector(to_unsigned(1, fadeIntBitN)))then --if minimum value has been reached, go to 'triangular_fade_up'
                    fade_state <= triangular_fade_up;
                else
                    fade_state <= triangular_fade_down;
                end if;                
            
            end case;
            
        end if;
    end process;

    --assign the intensity value to the output
    fade_intensity <= intensity_sig;

end Behavioral;
