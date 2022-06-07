library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Calcolatrice is
Port (clk, res: in std_logic;
		SW: in std_logic_vector(15 downto 0);
		led: out std_logic_vector(15 downto 0);
		CA, CB, CC, CD, CE, CF, CG, DP : out std_logic;
		AN: std_logic_vector (7 downto 0);
		BTNC, BTNU, BTNL, BTNR, BTND : in std_logic;
		output: out std_logic_vector(31 downto 0)
	);

end Calcolatrice;

architecture Behavioral of Calcolatrice is

	signal center_edge, up_edge , left_edge , right_edge, down_edge : std_logic;
	signal acc_in, acc_out : signed(31 downto 0);
	-- signal acc_init, acc enable: std logic;
	signal do_add , do_sub , do_mult : std_logic;
	signal display_value : std_logic_vector(31 downto 0);
	signal sw_input : std_logic_vector(31 downto 0);

begin

	center_detect : entity work.edge_detector(Behavioral)
	port map(
		clk => clk,
		btn => BTNC,
		edge => center_edge,
		res => res
	);
	
	up_detect : entity work.edge_detector(Behavioral)
	port map(
		clk => clk,
		btn => BTNU,
		edge => up_edge,
		res => res
	);
	
	down_detect : entity work.edge_detector(Behavioral)
	port map(
		clk => clk,
		btn => BTND,
		edge => down_edge,
		res => res
	);
	
	left_detect : entity work.edge_detector(Behavioral)
	port map(
		clk => clk,
		btn => BTNL,
		edge => left_edge,
		res => res
	);
	
	right_detect : entity work.edge_detector(Behavioral)
	port map(
		clk => clk,
		btn => BTNR,
		edge => right_edge,
		res => res
	);

	thedriver : entity work.driver(behavioral)

	generic map(
		size => 21

	) port map(
		clk => clk,
		reset => res,
		digit0 => display_value(3 downto 0),
		digitl => display_value(7 downto 4),
		digit2 => display_value(11 downto 8),
		digit3 => display_value(15 downto 12),
		digit4 => display_value(19 downto l6),
		digit5 => display_value(23 downto 20),
		digit6 => display_value(27 downto 24),
		digit7 => display_value(31 downto 28),
		CA => CA,
		CB => cB,
		CC => CC,
		CD => CD,
		CE => CE,
		CF => CF,
		CG => CG,
		DP => DP,
		AN => AN
	);

	LED <= SW;

	sw_input <= SW(15) & SW(15) & SW(15) & SW(15) & SW(15) & SW(15) & SW(15) & SW(15) & SW(15)
	& SW(15) & SW(15) & SW(15) & SW(15) & SW(15) & SW(15) & SW(15) & SW;

	the_alu : entity work.alu(Behavioral) port map (
		acc => acc_out,
		number => signed(sw_input),
		up => do_add,
		left => do_sub,
		right => do_mult,
		result => acc_in
	);
	do_add <= up_edge;
	do_sub <= left_edge;
	do_mult <= right_edge;

	the_accumulator : entity work.accumlator(Behavioral)
	port map(
		clk => clk,
		center => center_edge,
		up => up_edge,
		left => left_edge,
		right => right_edge,
		result => acc_in,
		acc => acc_out
	);
	display_value <= std_logic_vector(acc_out);
	output <= std_logic_vector(acc_out);
	--acc_enable <= up_edge or left_edge or right _edge or down_edge;
	--acc_init <= center_edge;
	
end Behavioral;
