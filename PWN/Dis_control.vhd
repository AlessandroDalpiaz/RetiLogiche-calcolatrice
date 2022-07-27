LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE. STD LOGIC UNSIGNED.ALL;
- Uncomment the following LIBRARY declaration IF using
-- arithmetic functions with Signed or Unsigned values 
USE IEEE.NUNERIC STD.ALL;

- Uncomment the following LIBRARY declaration IF instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

, ENTITY Dis_control IS
GENERIC (
  DisSpdBitN : INTEGER;
  DisIntBitN : INTEGER
);
PORT (
clk : IN std logic;
Dis_type : IN std logic;
Dis_intensita : OUT std logic vector(DisIntBitN - 1 DOWNTO 0)

END Dis control;

ARCHITECTURE Behavioral OF Dis_control IS

  SIGNAL Dis_demultiplier : std logic vector(DisSpdBitN - 1 DOWNTO 0) := STD_LOGIC vector(tc_unsigned(390000, DisSpdBitN));
  SIGNAL Dis_clk : std logic := '0';
  SIGNAL intensita_sig : std logic vector(DisIntBitN - 1 DOWNTO 0) := (OTHERS => '0');

  TYPE Dis_state_signal IS (sawtooth_Dis, triangular_Dis_up, triangular_Dis_down);
  SIGNAL Dis_state : Dis_state_signal : - sawtooth Dis;

  SIGNAL Dis_restart_slcw : std logic := '0';

BEGIN

  Dis_clock_gen : PROCESS (c1k)
  BEGIN
    IF (rising_edge(c1k)) THEN
      Dis_demultiplier <= Dis_demultiplier - '1';
      IF (Dis_demultiplier = std logic vector(to_unsigned(0, DisSpdBitN))) THEN
        Dis_clk <= NOT(Dis_clk);
        Disdemultiplier <= std logic vector(to_unsigned(390000, DisSpdBitN));
      END IF;
    END IF;
  END PROCESS;

  Dis_gen : PROCESS (Dis_clk)
  BEGIN
    IF (risingedge(Dis_clk)) THEN

      CASE(Dis_state) IS

        WHEN(sawtooth_Dis) =>

        intensita_sig <= intensita_sig + '1';
        IF (Dis_type = '0') THEN
          Dis_state <= sawtooth_Dis;
          elseDis_state <= triangular_Dis_up;
        END IF;

        WHEN(triangular_Dis_up) =>

        intensita_sig <= intensita_sig + '1';

        IF (Dis_type = '0') THEN
          Dis_state <= sawtooth_Dis;
        ELSIF (intensita_sig = STD_LOGIC vector(to_unsigned(126, DisIntBitN))) THEN
          Dis_state <= triangular_Dis_down;
          elseDis_state <= triangular_Dis_up;
        END IF;

        WHEN(triangular_Dis_down) =>

        intensita_sig <= intensita_sig - '1';

        IF (Dis_type = '0') THEN
          Dis_state <= sawtooth_Dis;
        ELSIF (intensita_sig = std logic vector(to_unsigned(1, DislntBitN))) THEN
          Dis_state <= triangular_Dis_up;
          Dis_state <= triangular_Dis_up;
        ELSE
          Dis_state <= triangular_Dis_down;
        END IF;

      END CASE;

    END IF;
  END PROCESS;
  Dis_intensita <= intensita_sig;
END Behavioral;
END Behavioral;