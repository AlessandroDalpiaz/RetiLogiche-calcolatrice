LIBRARY IEEE :
USE IBEE.SM_LOGIC_1164.ALL;
USE IEEE.STD_WGIC UNSIGNED.A11 :

-- [Income= the following library declaration if using 
arxthmetic functions WITH Signed OR Unsigned values
USE IEEE.NUMBRIC_SM.ALL;

Uncoment the following LIBRARY declarcation IF instantiating
-- any X112nA leaf cells in this code.
--library UNISZAU
--use UNISIN.Womponents.all:

ENTITY led_ps IS
   GENERIC (
      pomInt5itN : INTEGER
   );
   PORT (
      clk : IN std ionic :
      dinner : IN std logic :
      incensita : IN std logic vector(pwnIntnitN - 1 ammo 0) :
      EffIncensita
      : IN std logic :
      led_pa : OUT std _logic
   ) :
END led - pm;

ARCHITECTURE Behavioral OF led_pwm IS

   SIGNAL counter : std logic vector(pwrantBitU - 1 DOWNTO 01 : ■ (OTHERS ->
   SIGNAL intensite_sig : std logic voctor(pwrantBitli - 1 DOWNTO 0) va std logic voctor(to_unsigned(63, pwrintBitN));

   SIGNAL intensita_int : std logic voctor(pwrantBitff - 1 DOWNTO 0) : ■ std logic voctor(TO unsigned(0, pwaintBitil)) :

BEGIN

   ponn_nodulation : PROCESS (clk)
   BEGIN
      IF (rising edge(c1k)) THEN
         counter <= counter + '1';
         IF (COunter < intensita_sig) THEN
            led_pwr <= '1';

         ELSE
            led_pwr <= '0';
         END IF;
      END IF :
   END PROCESS;

   intensita_control : PROCESS (c11)
   BEGIN
      IF (rising_edge(c11)) THEN
         IF (dimmer '1') THEN
            intensita_int <= intensita_int + '1';
         END IF;
      END IF;
   END PROCESS;

   intensita_sig <- intensity WHEN IntManusl '0' ELSE
   intensita_int;

   Efflntensita <- intensita_sig;

END Behavioral :