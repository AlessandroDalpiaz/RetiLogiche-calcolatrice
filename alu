library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM:
--use UNISIM.VComponents.all;

entity alu is
Port (number: in signed(31 downto 0);
	up, left, right: in std_logic;
	acc: in signed(31 downto 0);
	result: out signed(31 downto 0)
	);
end alu:

architecture Behavioral of alu is
	signal mult: signed(63 downto 0);
begin
	process(up, left, right) begin
		--result<=number; --Inizialmente 11 risultato é indeterminato,
		--ma così non vengono effettuate operazioni non necessarie
		if(up='1') then result<=(number+acc); end if;
		if(left='l') then result<(acc-number); end if;
		if{right='1') then result<=mult(31 downto 0}; end if;
	end process:
	mult<=acc*number;

end Behavioral;
