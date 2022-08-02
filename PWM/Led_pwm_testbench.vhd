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

ENTITY led_pwm IS
   GENERIC (
      pwmIntBitN : INTEGER
   );
   PORT (
      clk : IN STD_LOGIC;
      dimmer : IN STD_LOGIC;
      intensita : IN STD_LOGIC_VECTOR(pwmIntBitN - 1 DOWNTO 0);
      EffIntensita : OUT STD_LOGIC_VECTOR(pwmIntBitN - 1 DOWNTO 0);
      IntManual : IN STD_LOGIC;
      led_pwr : OUT STD_LOGIC
   );
END led_pwm;

ARCHITECTURE Behavioral OF led_pwm IS

   SIGNAL counter : STD_LOGIC_VECTOR(pwmIntBitN - 1 DOWNTO 0) := (OTHERS => '0');
   SIGNAL intensita_sig : STD_LOGIC_VECTOR(pwmIntBitN - 1 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(63, pwmIntBitN));

   SIGNAL intensita_int : STD_LOGIC_VECTOR(pwmIntBitN - 1 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, pwmIntBitN));

BEGIN

   pwm_modulation : PROCESS (clk)
   BEGIN
      IF (rising_edge(clk)) THEN
         counter <= counter + '1';
         IF (counter < intensita_sig) THEN
            led_pwr <= '1';
         ELSE
            led_pwr <= '0';
         END IF;
      END IF;
   END PROCESS;

   intensita_control : PROCESS (clk)
   BEGIN
      IF (rising_edge(clk)) THEN
         IF (dimmer = '1') THEN
            intensita_int <= intensita_int + '1';
         END IF;
      END IF;
   END PROCESS;

   intensita_sig <= intensita WHEN IntManual = '0' ELSE
   intensita_int;

   EffIntensita <= intensita_sig;

END Behavioral;