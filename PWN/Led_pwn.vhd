LIBRARY IEEE;
USE IEEE. STD UDGIC 1164.ALL;
USE IEEE. STD LOGIC UNSIGNED.ALL;

- Uncomment the following LIBRARY declaration IF using
-- arithmetic functions with Signed or Unsigned values 
USE IKEE.NUMERIC STD.ALL;

-- Uncomment the following library declarcation if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ntity led_pwm IS
GENERIC (
  pwmIntBitN : INTEGER
);
PORT (
  clk : IN STD_LOGIC;
  dimmer : IN STD_LOGIC;
  intensita : IN STD_LOGIC vector(pwmIntBitN - 1 DOWNTO 0);
  Efflntensita : OUT STD_LOGIC vector(pwmIntBitN - 1 DOWNTO 0); --Uscita aggiuntiva per visualizzare valore ne2 diagramma
  IntManual : IN STD_LOGIC;
  led_pwr : OUT std logic
);
END led_pwm;

ARCHITECTURE Behavioral OF ledpwm IS

  SIGNAL counter : std logic vector(pwmIntBitN - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL intensita_sig : std logic vector(pwmIntBitN - 1 DOWNTO 0) := STD_LOGIC vector(to_unsigned(63, pwmIntBitN));

  SIGNAL intensita_int : std logic vector(pwmIntBitN - 1 DOWNTO 0) := std logic vector(to_unsigned(0, pwmintBitN));

BEGIN

  pwrijnodulation : PROCESS (clk)
  BEGIN
    IF (rising edge(c1k)) THEN
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
    IF (rising edge(c1k)) THEN
      IF (dimmer = '1') THEN
        intensita_int <= intensita_int + '1';
      END IF;
    END IF;
  END PROCESS;

  intensita_sig <= intensita WHEN Inthanual = '0' ELSE
    intensitaint;

  Efflntensita <= intensita_sig;

END Behavioral;