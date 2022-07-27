LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following LIBRARY declaration IF using
-- arithmetic functions with Signed or Unsigned values 
USE IEEE.NUMERIC_STD.ALL;

-- Uncamment the following LIBRARY declaration IF instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Luci IS
   PORT (
      clk : IN STD_LOGIC;
      Lbutton : IN STD_LOGIC;
      RButton : IN STD_LOGIC;
      LampEnable : IN STD_LOGIC;
      IntManual : IN STD_LOGIC;
      DisSelect : IN STD_LOGIC;
      led : OUT STD_LOGIC
   );
END Luci;

ARCHITECTURE Behavioral OF Luci IS

   COMPONENT button
      PORT (
         clk : IN STD_LOGIC;
         button_in : IN STD_LOGIC;
         button_click : OUT STD_LOGIC
      );
   END COMPONENT;

   COMPONENT led_pwm
      GENERIC (
         pwmIntBitN : INTEGER
      );
      PORT (
         cik : IN STD_LOGIC;
         dimmer : IN STD_LOGIC;
         intensita : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
         EffIntensita : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
         IntManual : IN STD_LOGIC;
         led_pwr : OUT STD_LOGIC
      );
   END COMPONENT;

   COMPONENT Lamp_control
      PORT (
      clk : IN STD_LOGIC;
      Lampeggiatore : IN STD_LOGIC;
      Lamp_out : OUT STD_LOGIC
      );

   END COMPONENT;

   COMPONENT Dis_control
      GENERIC (
         DisSpdBitN : INTEGER;
         DislntBitN : INTEGER
      );
      PORT (
         clk : IN STD_LOGIC;
         Dis_type : IN STD_LOGIC;
         Dis_intensita : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
      );
   END COMPONENT;

   SIGNAL LButton_click : STD_LOGIC := '0';
   SIGNAL RButton_click : STD_LOGIC := '0';
   SIGNAL Up_button_click : STD_LOGIC := '0';

   SIGNAL LampSig : STD_LOGIC := '1';
   SIGNAL ledSig : STD_LOGIC := '0';
   SIGNAL Lamp_enable : STD_LOGIC := '1';
   SIGNAL led_intensita : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
   SIGNAL led_Eff_intensita : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
   SIGNAL display_data : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
   SIGNAL led_intensita_sig : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
   TYPE bcd_decode_state_type IS (take_actual_value, wait_update, dec_120_129);
   SIGNAL bcd_decode_state : bcd_deccde_state_type := take_actual_value;
   SIGNAL counter_10 : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');

BEGIN

   LButton_inst : button
   PORT MAP(
      clk => clk,
      button_in => LButton,
      button_click => LButton_click
   );

   RButton_inst : button
   PORT MAP(
      clk => clk,
      button_in => RButton,
      button_click => RButton_click
   );

   led_pwm_inst : led_pwm
   GENERIC MAP(
      pwmIntBitN => 7
   )

   PORT MAP(
      clk => clk,
      dimmer => LButton_click,
      intensita => led_intensita,
      Effintensita => led_Eff_intensita,
      IntManual => IntManual,
      led_pwr => ledSig
   );

   Lamp_control_inst : Lamp_control
   PORT MAP(
      clk => clk,
      Lampeggiatore => RButton_click,
      Lamp_out => LampSig
   );

   Dis_control_inst : Dis_control
   GENERIC MAP(
      DisSpdBitN => 19,
      DisIntBitN => 7
      )PORT MAP(
      clk => clk,
      Dis_type => DisSelect,
      Dis_intensita => led_intensita
   );

   led <= ledSig AND (LampSig OR LampEnable);

END Behavioral;

