----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2020 06:20:42 PM
-- Design Name: 
-- Module Name: led_pwm_testbench - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity led_pwm_testbench is
--  Port ( );
end led_pwm_testbench;

architecture Behavioral of led_pwm_testbench is

   component led_pwm
    generic(
        pwmIntBitN : integer
    );
    port(
        clk              : in  std_logic;
        dimmer_up        : in  std_logic;
        dimmer_down      : in  std_logic;
        intensity        : in  std_logic_vector(pwmIntBitN-1 downto 0);
        actualIntensity  : out std_logic_vector(pwmIntBitN-1 downto 0);
        manual_intensity : in  std_logic;
        led_pwr          : out std_logic
    );   
   end component;

   constant pwmIntBitN : integer := 7;

   signal  clk : std_logic := '0';
   signal dimmer_up : std_logic := '0';
   signal dimmer_down : std_logic := '0';
   signal intensity : std_logic_vector(pwmIntBitN-1 downto 0);
   signal actualIntensity : std_logic_vector(pwmIntBitN-1 downto 0);
   signal manual_intensity : std_logic := '0';
   signal led_pwr : std_logic := '0';

   constant clk_T : time := 10 ns;

begin

   uut : led_pwm
   generic map (
      pwmIntBitN => pwmIntBitN
   )
   port map (
      clk => clk,
      dimmer_up => dimmer_up,
      dimmer_down => dimmer_down,
      intensity => intensity,
      actualIntensity => actualIntensity,
      manual_intensity => manual_intensity,
      led_pwr => led_pwr
   );
  
   --generate clock 
   clk <= not(clk) after clk_T/2;
   
   testProc : process
   begin
   
      intensity <= "0111111"; --intensity = half range (50% led intensity);
      wait for 10 us;
      
      intensity <= "1111111"; --intensity = full range (100% led intensity);
      wait for 10 us;
      
      intensity <= "0000010"; --intensity = almost min range (approx 0% led intensity);
      wait for 10 us;
      
      manual_intensity <= '1';
      for i in 0 to 127 loop
         dimmer_up <= '1';
         wait for 10 ns;
         dimmer_up <= '0';
         wait for 5 us;
      end loop;

      for i in 0 to 127 loop
         dimmer_down <= '1';
         wait for 10 ns;
         dimmer_down <= '0';
         wait for 5 us;
      end loop;
   
   wait;
   end process;

end Behavioral;
