library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Calcolatrice_testbench is
-- Port ( );
end Calcolatrice_testbench;

architecture Behavioral of Calcolatrice testbench is

component Calcolatrice
	Port (clk, res: in std_logic;
		SW: in std_logic_vector(15 downto 0);
		led: out std_logic_vector(15 downto 0);
		CA, CB, CC, CD, CE, CF, CG, DP : out std_logic;
		AN: std_logic_vector (7 downto 0);
		BTNC, BTNU, BTNL, BTNR, BTND : in std_logic;
		output: out std_logic_vector(31 downto 0)
	);
end component;
signal clk, res, CA, CB, CC, CD, CE, CG, CF, DP, BTNC, BTNU, BTNL, BTNR, BTND : std_logic:='0';
signal SW, led : std_logic_vector(15 downto 0);
signal AN : std_logic_vector (7 dowto 0);
signal output: std_logic_vector (31 downto 0);

begin
uut: Calcolatrice
	port map(
	clk => clk,
	res => res,
	SW => SW,
	led => led,
	CA => CA,
	CB => CB,
	CC => CC,
	CD => CD,
	CE => CE,
	CF => CF,
	CG => CG,
	DP => DP,
	AN => AN,
	BTNC => BTNC,
	BTNU => BTNU,
	BTNL => BTNL,
	BTNR => BTNR,
	BTND => BTND,
	output => output
	);

clock : process begin clk<='1'; wait for 5 ns; clk<= not clk; wait for 5 ns; end process;

ciclo : process begin
	SW<="0000000000100100" ;--Impostiamo in input il mmero 36 sugli switch
	BINC <='1';
	wait for 10 ns;
	BINC <='0';
	wait for 100 ns;
	--Somma 1
	BTNU <='1';
	wait for 10 ns;
	BINU <='0';
	wait for 100 ns;
	--Somma 2
	SW<="0000000000000100";      --Imposto in input il numero 4 sugli switch
	BTNU <='1';
	wait for 10 ns;
	BTNU <='0';
	wait for 100 ns; 		--Devo ottenere 40 in output
	--Sottrazione
	SW<="0000000000011110";      --Imposto in input il numero 30 sugli switch
	BTNL <='1';
	wait for 10 ns;
	BTNL <='0';
	wait for 100 ns; 		--Devo ottenere 10 in output
	--Moltiplicazione
	SW<="0000000000001010";      --Imposto in input il numero 10 sugli switch
	BTNR <='1';
	wait for 10 ns;
	BTNR <='0';
	wait for 100 ns; 		--Devo ottenere 100 in output
	--Reset
	BTNC <='1';
	wait for 10 ns;
	BTNC <='0';			--Devo ottenere 0 in output
	wait;

end proces:
end Behavioral;
