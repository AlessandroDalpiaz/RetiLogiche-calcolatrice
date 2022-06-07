----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2020 12:56:59 PM
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fade_control_testbench is
--  Port ( );
end fade_control_testbench;

architecture Behavioral of fade_control_testbench is

   component fade_control
    generic (
        fadeSpdBitN  : integer; --fade speed is 100 MHz / (2x2^fadeSpdBitN)
        fadeIntBitN  : integer --nr of intensity levels (should be coherent with nr of bits of 'led_pwm'))
    );
    port (
        clk            : in  std_logic;
        fade_type      : in  std_logic; -- 0 = sawtooth fade, 1 = triangular fade
        fade_intensity : out std_logic_vector(fadeIntBitN-1 downto 0)  -- output to PWM controller
    );   
   end component;

   constant fadeSpdBitN : integer := 19;
   constant fadeIntBitN : integer := 7;
   
   signal clk : std_logic := '0';
   signal fade_type : std_logic := '0';
   signal fade_intensity : std_logic_vector(fadeIntBitN-1 downto 0) := (others=>'0');
   
   constant clk_T : time := 10 ns;

begin

   uut : fade_control
   generic map (
      fadeSpdBitN => fadeSpdBitN,
      fadeIntBitN => fadeIntBitN
   )
   port map (
      clk => clk,
      fade_type => fade_type,
      fade_intensity => fade_intensity
   );

   clk <= not(clk) after clk_T/2;
   
   test_proc : process
   begin

   fade_type <= '0';
   wait for 1500 ms;
   fade_type <= '1'; 
     
   wait;
   end process;

end Behavioral;
