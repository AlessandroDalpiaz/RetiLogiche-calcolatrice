LIBRARY IEEE;
USE IEEE.STD LOGIC 1164.ALL;

- Uncomment the following LIBRARY declaration IF using
-- arithmetic functions with Signed or Unsigned values 
USE IEEE.NUMERIC STD.ALL;

- Uncomment the following LIBRARY declaration IF instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Luci_TESTBENCH IS
   - P.rt ();
END Luci_TESTBENCH;

'ARCHITECTURE Behavioral OF Luci_TESTBENCH IS

COMPONENT Luci
   PORT (
   clk : IN std logic;
   LButton : IN STD_LOGIC;
   RButton : IN std logic;
   led : OUT STD_LOGIC;
   LappEnable : IN STD_LOGIC;
   IntManual : IN STD_LOGIC;
   DisSelect : IN STD_LOGIC

END COMPONENT;

SIGNAL clk : STD_LOGIC := '0';
SIGNAL LButton : STD_LOGIC := '0';
SIGNAL RButton : STD_LOGIC := '0';
SIGNAL led : STD_LOGIC := '0';
SIGNAL LampEnable : STD_LOGIC := '0';
SIGNAL IntManual : STD_LOGIC := '0';
SIGNAL DisSelect : std logic := '0';

CONSTANT clkPeriod : TIME := 10 ns;

BEGIN

clk <= NOT(c1k) AFTER clkPeriod/2;

uut : Luci
PORT MAP(
   clk => clk,
   LButton => LButton,
   RButton => RButton,
   led => led,
   LampEnable => LampEnable,
   IntHanual => IntHanual,
   DisSelect => DisSelect
);