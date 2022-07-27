COMPONENT led_pwm
   GENERIC (
      pwmIntBitN : INTEGER
   );
   PORT (
      cik : IN STD_LOGIC;
      dimmer : IN STD_LOGIC;
      intensita : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      Efflntensita : OUT STD_LOGIC vector(6 DOWNTO 0);
      IntManual : IN STD_LOGIC;
      led_pwr : OUT STD_LOGIC
   );
END COMPONENT;

COMPONENT Lamp_control
   PORT (
   clk : IN std logic;
   Lampeggiacore : IN STD_LOGIC;
   Lamp_out : OUT STD_LOGIC

END COMPONENT;

COMPONENT Dis_control
   GENERIC (
      DisSpdBlitN : INTEGER;
      DislntBitN : INTEGER
   );
   PORT (
      cik : IN STD_LOGIC;
      Dis_type : IN STD_LOGIC :
      Dis_intensita : OUT std logic vector(6 DOWNTO 0)
   );
END COMPONENT;

SIGNAL LButcon_click : STD_LOGIC := '0';
SIGNAL RButton_click : STD_LOGIC := '0';
SIGNAL Up_hutton_click : std logic := '0';

SIGNAL LampSig : STD_LOGIC := '1';
SIGNAL ledSig : STD_LOGIC := '0';
SIGNAL Lamp_enable : std logic := '1';
SIGNAL led_incensita : std logic_vector(6 downco 0) := (OTHERS => '0');

LIBRARY IEEE;
USE IEEE.STD_LOGIC_I164.ALL;
USE IEEE.STDUOGICUNSIGNED.ALL;
- Unc : 7.7 : the following LIBRARY declaration IF using
-- arithmetic functions with Signed or Unsigned values 
USE IMEAUMBRIC SMALL;

- Uncomment the following LIBRARY declaration IF instantiating
-- any Xilinx leaf cells in this code. 
--library UNISIW
--use UNISIM.VComponents.all;

ENTITY Luci IS
   PORT (
      clk : IN std logic;
      Lbutton : IN std logic;
      RButton : IN std logic;
      LampEnable : IN std logic;
      IntManual : IN std logic;
      DisSelect : IN std logic;
      led : OUT std logic
   );
END Luci;

ARCHITECTURE Behavioral OF Luci IS

   COMPONENT button
      PORT (
         clk : IN STD_LOGIC :
         button_in : IN STD_LOGIC :
         button_click : OUT STD_LOGIC
      );
   END COMPONENT;

   SIGNAL led_Eff_intensita : std logic vector(6 DOWNTO 0) := (OTHERS => '0');
   SIGNAL display_data : std logic_vector(31 DOWNTO 0) := (OTHERS => '0');
   SIGNAL led_intensita_sig : std logic vector(6 DOWNTO 0) := (OTHERS => '0');
   TYPE bcd_decode_state_type IS (take_actual_value, WAIT update, dec_120_129,
   SIGNAL bcd_decode_state : bcd_deccde_state_type := take_actual_value;
   SIGNAL counter_10 : std logic vector(3 DOWNTO 0) := (OTHERS => '0');

BEGIN

   LButton_inst : button
   PORT MAP(
   clk => clk,
   button_in => Mutton,
   button_click => LButton_click
   RBucton_inst : button
   PORT MAP(
   clk => clk,
   button_in => RButton,
   button_click => RButton_click
   led_pan_inat : led_pwm
   GENERIC MAP(
   pwmIntBitN => 7

   PORT MAP(
      clk => clk,
      dimmer => LButton_click,
      intensita => led_intensita,
      Effintensita => led_Eff_intensita,
      IntHanual => IntManual,
      led_pwr -> ledSig
   );

   Lamp_control_inst : Lamp_control
   PORT MAP(
      clk => clk,
      Lampeggiatore => RButton_click,

      Lamp _out => LampSig
   );
   Dis_control_inst : Dis_control
   GENERIC MAP(
   DisSpdBitN => 19,
   DislntBitN => 7
   )PORT MAP(
   clk => clk,
   Dis_type => DisSelect,
   Dis_intensita => led_intensita

   led <= ledSig AND (LampSig OR LampEnable);

END Behavioral;