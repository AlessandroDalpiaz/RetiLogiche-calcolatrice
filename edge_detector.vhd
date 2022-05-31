library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity edge_detector is
Port (clk, res, btn : in std_logic;
	edge : out std_logic
);
end edge_detector;

architecture Behavioral of edge_detector is
	type stato is (at_zero, at_edge, at_one);
	signal present_state, next_state : stato;
	begin

	seq: process(res, clk) is
	begin
		if res='l' then
		present_state<=at_zero;
		elsif rising edge(clk) then
		present_state<=next_state;
		end if;
	end process seq;

	futuro: process(present_state, btn) is
	begin
		case present_state is
		when at_zero=>
		if btn='0' then
		next_state<=at_zero;
		else
		next_state<=at_edge;
		end if;
		
		when at_edge=>
		if btn='0' then
		next_state<=at_zero;
		else
		next_state<=at_one;
		end if;
		
		when at_one=>
		if btn='0' then
		next_state<=at_zero;
		else
		next_state<=at_one;
		end if;
		end case;
	end process futuro;

	uscite: process(present_state) is
	begin
		edge<='0';
		if present_state=at_edge then
		edge<='1';
		end if;
	end process uscite;

end Behavioral;
