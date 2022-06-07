----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2019 07:41:58 PM
-- Design Name: 
-- Module Name: luci_top_TESTBENCH - Behavioral
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

entity luci_top_testbench is
--  Port ( );
end luci_top_testbench;

architecture Behavioral of luci_top_TESTBENCH is

    component luci_top is
    port (
        clk             : in  std_logic;
        leftButton      : in  std_logic;
        rightButton     : in  std_logic;
        manualIntensity : in  std_logic;
        fadeSelect      : in  std_logic;
        led             : out std_logic;
        
        --7 segments dispaly I/Os
        CA, CB, CC, CD, CE, CF, CG, DP : out std_logic;
        AN : out std_logic_vector( 7 downto 0 )
    );
end component;

    signal clk        : std_logic := '0';
    signal leftButton : std_logic := '0';
    signal led        : std_logic := '0';
    signal rightButton : std_logic := '0';
    signal manualIntensity : std_logic := '0';
    signal fadeSelect : std_logic := '0';
    
    signal CA,CB,CC,CD,CE,CF,CG,DP : std_logic;
    signal AN : std_logic_vector(7 downto 0);
    
    constant clkPeriod : time := 10 ns;

begin
    
    clk <= not(clk) after clkPeriod/2;
    
    uut:luci_top
    port map (
        clk        => clk,
        leftButton => leftButton,
        led        => led,
        rightButton => rightButton,
        manualIntensity => manualIntensity,
        fadeSelect => fadeSelect,
        CA => CA,
        CB => CB,
        CC => CC,
        CD => CD,
        CE => CE,
        CF => CF,
        CG => CG,
        DP => DP,
        AN => AN
    );

    test_process : process
    begin
    
        wait for 1500 ms;
        fadeSelect <= '1';

        wait;
    end process;

end Behavioral;
