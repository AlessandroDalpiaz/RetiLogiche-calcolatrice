LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC UNSIGNED.ALL;
- Uncomment the following LIBRARY declaration IF using
-- arithmetic functions with Signed or Unsigned values 
USE IEEE.NUMERICSTD.ALL;

- Uncamment the following LIBRARY declaration IF instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

'ENTITY Lamp_control IS
PORT (
cik : IN std logic;
Lamptggiatore : IN std logic;
Lamp_out : OUT STD_LOGIC
);
END Lamp_control;

ARCHITECTURE Behavioral OF Lamp_control IS

SIGNAL LampeggiatoreCounter : STD_LOGIC vector(26 DOWNTO 0) := std logic vector(to_unsigned(100000000, 27));
SIGNAL LampeggiatoreStart : std logic vector(26 DOWNTO 0) := STD_LOGIC vector(to_unsigned(100000000, 27));
SIGNAL LampSig : std logic := '1';

TYPE Lamp_state_type IS (LampUp_O, LampUp_1, LampUp_2, LampUp_3, LampDown_0, LampDown_l, LampDown_2, LampDown_3);
SIGNAL LampState : Lamp_state_type := LampUp_0;

BEGIN

LampProc : PROCESS (c1k)
BEGIN
  IF (rising_edge(c1k)) THEN
    LampeggiatoreCounter <- LampeggiatoreCounter - '1';
    IF (LampeggiatoreCounter = std logic vector(to_unsigned(0, 27))) THEN
      LampeggiatoreCounter <= LampeggiatoreStart;
      LampSig <= NOT(LampSig);
    END IF;
  END IF;
END PROCESS;

LampControlProc : PROCESS (c1k)
BEGIN
  IF (rising_edge(c1k)) THEN

    CASE (LampState) IS

      WHEN LampUp_O =>

        IF (Lampeggiatore = '1') THEN
          LampeggiatoreStart ‹■ '0' t LampeggiatoreStart(26 DOWNTO 1);
          LampState <= LampUp_1;
        ELSE
          LampState <= LampUp_0;
        END IF;

      WHEN LampUp_l

        IF (Lampeggiatore = '1') THEN
          LampeggiatoreStart <= '0' & LampeggiatoreStart(26 DOWNTO 1);
          LampState <= LampUp_2;
        ELSE
          LampState <= LampUp_1;
        END IF;

      WHEN LampUp_2 =>

        IF (Lampeggiatore = '1') THEN
          LampeggiatoreStart <= '0' & LampeggiatoreStart(26 DOWNTO 1);
          LampState <= LampUp_3;
        ELSE
          LampState <= LampUp_2;
        END IF;

      WHEN LampUp_3 =>

        IF (Lampeggiatore = '1') THEN
          LampeggiatoreStart <= '0' & LampeggiatoreStart(26 DOWNTO 1);
          LampState <= LampDown_0;
        ELSE
          LampState <= LampUp_3;
        END IF;

      WHEN LampDown_O =>

        IF (Lampeggiatore • '!') THEN
          LampeggiatoreStart <= LampeggiatoreStart(25 DOWNTO 0) c '0';
          LampState <= LampDown_l;
        ELSE
          Lamp5tate <= LampDown_0;
        END IF;

      WHEN LampDown_l =>

        IF (Lampeggiatore = '!') THEN
          LampeggiatoreStart <= LampeggiatoreStart(25 DOWNTO 0) s '0';
          LampState <= LampDown_2;
        ELSE
          LampState <= LampDown_l;
        END IF;

      WHEN LampDown_2 =>

        IF (Lampeggiatore • '!') THEN
          LampeggiatoreStart <= LampeggiatoreStart(25 DOWNTO 0) a '0';
          Lamp5tate <= LampDown_3;
        ELSE
          LampState <= LampDown_2;
        END IF;

      WHEN LampDown_3 =>

        IF (Lampeggiatore = '!') THEN
          LampeggiatoreStart <= LampeggiatoreStart(25 DOWNTO 0) s '0';
          LampState <= LampUp_0;
        ELSE
          LampState <= LampDown_3;
        END IF;

    END CASE;

  END IF;
END PROCESS;

Lamp_out <= LampSig;