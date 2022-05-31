library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity driver is generic (
		size : integer := 20
	);
	Port (
		clk : in std_logic;
		reset : in std_logic;
		digit0 : in std_logic_vector( 3 downto 0 );
		digitl : in std_logic_vector( 3 downto 0 );
		digit2 : in std_logic_vector( 3 downto 0 );
		digit3 : in std_logic_vector( 3 downto 0 );
		digit4 : in std_logic_vector( 3 downto 0 );
		digit5 : in std_logic_vector( 3 downto 0 );
		digit6 : in std_logic_vector( 3 downto 0 );
		digit7 : in std_logic_vector( 3 downto 0 );
		CA, CB, CC, CD, CE, CF, CG, DP : out std_logic;
		AN : out std_logic_vector( 7 downto 0 )
	);
end driver;
