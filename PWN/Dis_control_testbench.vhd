LIBRARY IEEE;
se IEEE.STD_LOG/C 1164.ALL;
se IEEE.STD_LOG/C UNS/GNED.ALL;
-- Uncoscient the following library declaration if using 
-- ertthmet2c functions with Signed or Unsigned values 
USE IEEE.NOMERIC STD.ALL;

- Uncomment the following LIBRARY declaration IF instantiating
- any Xilim leaf cells IN this code.
- LIBRARY UNISIM;
- USE UNISIM.VComponents.a22;

ENTITY Dis_control IS
  GENERIC (
  DisSpdBitN : INTEGER;
  DisIntBitN : INTEGER

  PORT (
    clk : IN STD_LOGIC;
    Dis_type : IN STD_LOGIC;
    Dis_intensita : OUT std logic vector(DisIntBitN - 1 DOWNTO 0)
  );
END Dis_control :

rchiteckre Behavioral OF Dis_control IS

SIGNAL Dis_denultiplier : STD_LOGIC vector(DisSpdBitN - 1 DOWNTO 0) := STD_LOGIC vector(to_unsigned(390000, DisSpdBitN));
SIGNAL Dis_clk : std logic := '0';
SIGNAL intensita_sig : STD_LOGIC vector(DisIntBitN - 1 DOWNTO := (OTHERS => '0') :

TYPE Dis_state_signal IS (sawtooth_Dis, triangular_Dis_up, triangular_Dis_down);
SIGNAL Dis_state : Dis_state_signal := sawtooth_Dis :

SIGNAL Dis_restart_slow : std logic a = '0';

BEGIN
BEGIN

Dis_clock_gen : PROCESS (c1k)
BEGIN
  IF (rising_edge(c1k)) THEN
    Dis_demultiplier <= Dis_demultiplier - '1';
    IF (Dis_demultiplier = std logic vector(to_unsigned(0, DisSpdBitN))) THEN
      Dis_clk <= NOT(Dis_clk);

      Dis_demultiplier <= STD_LOGIC vector(to_unsigned(390000, DisSpdBitN));
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
        Dis_state <= sawtooth_Disd
          ELSE
          Dis_state <= triangular_Dis_up;
      END IF;

      WHEN(triangular_Dis_up) =>

      intensita_sig <= intensita_sig + '1';

      IF (Dis_type = '0') THEN
        Dis_state <= sawtooth_Dis :
          ELSIF (intensita_sig = STD_LOGIC_VECTOR(to_unsigned(12E, DislntBitN))) THEN
          Dis_state <= triangular_Dis_dcwn;
        Dis_state <= triangular_Dis_dcwn;
      ELSE
        Dis_state <= triangular_Dis_up;
      END IF;

      WHEN(triangular_Bis_down) =>

      intensita_sig <= intensita_sig - '1';

      IF (Dis_type = '0') THEN
        Dis_state <= sawtooth_Dis;
      ELSIF (intensita_sig = std logicyector(tc_unsigned(1, DisIntBitN))) THEN
        Dis_state <= triangular_Dis_up;
      ELSE
        Dis_state <= triangular_Dis_down;
      END IF;

    END CASE;

  END IF;
END PROCESS;
Dis_intensita <= intensita_sig;

END Behavioral;