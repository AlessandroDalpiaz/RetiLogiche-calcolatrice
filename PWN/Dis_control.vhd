LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following LIBRARY declaration IF using
-- arithmetic functions with Signed or Unsigned values 
USE IEEE.NUNERIC_STD.ALL;

-- Uncomment the following LIBRARY declaration IF instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Dis_control IS
  GENERIC (
  DisSpdBitN : INTEGER;
  DisIntBitN : INTEGER
  );
  PORT (
    clk : IN std_logic;
    Dis_type : IN std_logic;
    Dis_intensita : OUT std_logic_vector(DisIntBitN-1 DOWNTO 0)
  );
END Dis_control;

ARCHITECTURE Behavioral OF Dis_control IS

  SIGNAL Dis_demultiplier : std_logic_vector(DisSpdBitN - 1 DOWNTO 0) := std_logic_vector(to_unsigned(390000, DisSpdBitN));
  SIGNAL Dis_clk : std_logic := '0';
  SIGNAL intensita_sig : std_logic_vector(DisIntBitN - 1 DOWNTO 0) := (OTHERS => '0');

  TYPE Dis_state_signal IS (sawtooth_Dis, triangular_Dis_up, triangular_Dis_down);
  SIGNAL Dis_state : Dis_state_signal := sawtooth_Dis;

  SIGNAL Dis_restart_slow : std_logic := '0';

BEGIN

  Dis_clock_gen : PROCESS (clk)
  BEGIN
    IF (rising_edge(clk)) THEN
      Dis_demultiplier <= Dis_demultiplier - '1';
      IF (Dis_demultiplier = std_logic_vector(to_unsigned(0, DisSpdBitN))) THEN
        Dis_clk <= NOT(Dis_clk);
        Disdemultiplier <= std_logic_vector(to_unsigned(390000, DisSpdBitN));
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
            else
              Dis_state <= triangular_Dis_up;
          END IF;

        WHEN(triangular_Dis_up) =>

          intensita_sig <= intensita_sig + '1';

          IF (Dis_type = '0') THEN
            Dis_state <= sawtooth_Dis;
          ELSIF (intensita_sig = std_logic_vector(to_unsigned(126, DisIntBitN))) THEN
            Dis_state <= triangular_Dis_down;
            else
              Dis_state <= triangular_Dis_up;
          END IF;

        WHEN(triangular_Dis_down) =>

        intensita_sig <= intensita_sig - '1';

        IF (Dis_type = '0') THEN
          Dis_state <= sawtooth_Dis;
        ELSIF (intensita_sig = std_logic_vector(to_unsigned(1, DislntBitN))) THEN
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
