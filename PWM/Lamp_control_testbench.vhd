LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following LIBRARY declaration IF using
-- arithmetic functions with Signed or Unsigned values 
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following LIBRARY declaration IF instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Lamp_control IS
   PORT (
      clk : IN STD_LOGIC;
      Lampeggiatore : IN STD_LOGIC;
      Lamp_out : OUT STD_LOGIC
   );
END Lamp_control;

ARCHITECTURE Behavioral OF Lamp_control IS

   SIGNAL LampeggiatoreCounter : STD_LOGIC_VECTOR(26 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(100000000, 27));
   SIGNAL LampeggiatoreStart : STD_LOGIC_VECTOR(26 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(100000000, 27));
   SIGNAL LampSig : STD_LOGIC := '1';

   TYPE Lamp_state_type IS (LampUp_0, LampUp_1, LampUp_2, LampUp_3, LampDown_0, LampDown_1, LampDown_2, LampDown_3);
   SIGNAL Lamp_State : Lamp_state_type := LampUp_0;

BEGIN

   LampProc : PROCESS (clk)
   BEGIN
      IF (rising_edge(clk)) THEN
         LampeggiatoreCounter <= LampeggiatoreCounter - '1';
         IF (LampeggiatoreCounter = STD_LOGIC_VECTOR(to_unsigned(0, 27))) THEN
            LampeggiatoreCounter <= LampeggiatoreStart;
            LampSig <= NOT(LampSig);
         END IF;
      END IF;
   END PROCESS;
BEGIN
   --CASE BLA BLA
   IF (rising_edge(clk)) THEN

      CASE (LampState) IS
         WHEN LampDown_0 =>

            IF (Lampeggiatore = '1') THEN
               LampeggiatoreStart <= LampeggiatoreStart(25 DOWNTO 0) & '0';
               LampState <= LampDown_1;
            ELSE
               LampState <= LampDown_0;
            END IF;

         WHEN LampDown_1 =>

            IF (Lampeggiatore = '1') THEN
               LampeggiatoreStart <= LampeggiatoreStart(25 DOWNTO 0) & '0';
               LampState <= LampDown_2;
            ELSE
               LampState <= LampDown_1;
            END IF;

         WHEN LampDown_2 =>

            IF (Lampeggiatore = '1') THEN
               LampeggiatoreStart <= LampeggiatoreStart(25 DOWNTO 0) & '0';
               LampState <= LampDown_3;
            ELSE
               LampState <= LampDown_2;
            END IF;

         WHEN LampDown_3 =>

            IF (Lampeggiatore = '1') THEN
               LampeggiatoreStart <= LampeggiatoreStart(25 DOWNTO 0) & '0';
               LampState <= LampUp_0;
            ELSE
               LampState <= LampDown_3;
            END IF;
      END CASE;
   END IF;
END;

Lamp_out <= LampSig;

LampControlProc : PROCESS (clk)

BEGIN
   IF (rising_edge(clk)) THEN

      CASE (LampState) IS

         WHEN LampUp_0 =>

            IF (Lampeggiatore = '1') THEN
               LampeggiatoreStart <= '0' & LampeggiatoreStart(26 DOWNTO 1);
               LampState <= LampUp_1;
            ELSE
               LampState <= LampUp_0;
            END IF;

         WHEN LampUp_l =>

            IF (Lampeggiatore = '1') THEN
               LampeggiatoreStart <= '0' & LampeggiatoreStart(26 DOWNTO 1);
               LampState <= LampUp_2;
            ELSE
               LampState <= LampUp_l;
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
      END CASE;
   END IF;
END;