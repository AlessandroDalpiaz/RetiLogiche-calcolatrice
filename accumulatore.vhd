library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity accumlator is
	Port (clk, up, left, right, center : in std_logic;
	result: in signed(31 downto 0);
	acc: out signed(31 downto 0)
	);
end accumulator;

architecture Behavioral of accumulator is
begin
--result<="00000000000000000000000000000000"; --Per reset iniziale
	process(clk, center) is
		begin
		if center='l' then
		acc<=(others=>'0');
		elsif rising_edge(clk) and (up='1' or left='1' or right='1') then
		acc<=result;
		end if;
	end process;
end Behavioral;
