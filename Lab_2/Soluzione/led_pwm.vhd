library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity led_pwm is
    generic (
        pwmIntBitN : integer
    );
    port (
        clk              : in  std_logic;
        dimmer_up        : in  std_logic;
        dimmer_down      : in  std_logic;
        intensity        : in  std_logic_vector(pwmIntBitN-1 downto 0);
        actualIntensity  : out std_logic_vector(pwmIntBitN-1 downto 0);
        manual_intensity : in  std_logic;
        led_pwr          : out std_logic
    );
end led_pwm;

architecture Behavioral of led_pwm is

    --this architecture describes a PWM (Pulse Width Modulation) controller to set the LED luminosity level.
    --the PWM duty cycle is given by the ratio between signals 'counter' and 'intensity_sig'
    --those vectors shall be the same size in order to have the full 0%-100% duty cycle swing
    --the number of led intensity levels is given by the nr of bits of the two vectors (n=7 bit -> 128 levels in this example)

    signal counter       : std_logic_vector(pwmIntBitN-1 downto 0) := (others => '0'); 
    signal intensity_sig : std_logic_vector(pwmIntBitN-1 downto 0) := std_logic_vector(to_unsigned(63, pwmIntBitN));
    signal intensity_int : std_logic_vector(pwmIntBitN-1 downto 0) := std_logic_vector(to_unsigned(0, pwmIntBitN));

begin

    --process that generates the PWM modulation based on the FPGA clock signal
    pwm_modulation : process(clk)
    begin
        if(rising_edge(clk))then
            counter <= counter + '1';
            if(counter < intensity_sig)then
                led_pwr <= '1';
            else
                led_pwr <= '0';
            end if;
        end if;
    end process;

    --this process is simply used to increase a second LED intensity signal each time a pushbutton is pressed
    intensity_control : process(clk)
    begin
        if(rising_edge(clk))then
            if(dimmer_up = '1')then
                intensity_int <= intensity_int + '1';
            elsif(dimmer_down = '1')then
                intensity_int <= intensity_int - '1';
            end if;
        end if;
    end process;

    --select between manual_intensity (from the pushbutton) and 'fade_control' intensity (from the 'fade_control' entity)
    intensity_sig <= intensity when manual_intensity = '0' else
                     intensity_int;

    actualIntensity <= intensity_sig;
               
end Behavioral;










