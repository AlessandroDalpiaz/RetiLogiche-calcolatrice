----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2019 05:47:41 PM
-- Design Name: 
-- Module Name: luci_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
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

entity luci_top is
    port(
        clk             : in  std_logic;
        leftButton      : in  std_logic;
        rightButton     : in  std_logic;
        blinkEnable     : in  std_logic;
        manualIntensity : in  std_logic;
        fadeSelect      : in  std_logic;
        led             : out std_logic;
        
        --7 segments dispaly I/Os
        CA, CB, CC, CD, CE, CF, CG, DP : out std_logic;
        AN : out std_logic_vector( 7 downto 0 )
    );
end luci_top;

architecture Behavioral of luci_top is

    component button
    port(
        clk       : in  std_logic;
        btn_in    : in  std_logic;
        btn_click : out std_logic
    );
    end component;

    component led_pwm
    generic(
        pwmIntBitN : integer --PWM clock frequency = 100 MHz / (2^(n+1))
    );
    port(
        clk              : in  std_logic;
        dimmer           : in  std_logic; 
        intensity        : in  std_logic_vector(6 downto 0);
        actualIntensity  : out std_logic_vector(6 downto 0);
        manual_intensity : in  std_logic;
        led_pwr          : out std_logic
    );
    end component;
    
    component fade_control
    generic(
        fadeSpdBitN  : integer; --fade speed is 100 MHz / (2x2^fadeSpdBitN)
        fadeIntBitN  : integer --nr of intensity levels (should be coherent with nr of bits of 'led_pwm')
    );
    port(
        clk            : in  std_logic;
        fade_type      : in  std_logic; --0 = sawtooth fade, 1 = triangular fade
        fade_intensity : out std_logic_vector(6 downto 0)
    );
    end component;
   
    signal left_button_click   : std_logic := '0';
    signal right_button_click  : std_logic := '0';
    signal up_button_click     : std_logic := '0';
    
    signal blinkSig  : std_logic := '1';
    signal ledSig : std_logic := '0';
    signal blink_enable : std_logic := '1';
    signal led_intensity : std_logic_vector(6 downto 0) := (others => '0');
    signal led_actual_intensity : std_logic_vector(6 downto 0) := (others => '0');
    
    signal display_data : std_logic_vector(31 downto 0) := (others => '0');
    
    signal led_intensity_sig : std_logic_vector(6 downto 0) := (others => '0');
    type bcd_decode_state_type is (take_actual_value, wait_update, dec_120_129, dec_110_119, dec_100_109, dec_90_99, dec_80_89, dec_70_79, dec_60_69, dec_50_59, dec_40_49, dec_30_39, dec_20_29, dec_10_19, dec_0_9, add_168, add_162, add_156, add_54, add_48, add_42, add_36, add_30, add_24, add_18, add_12, add_6, add_0);
    signal bcd_decode_state : bcd_decode_state_type := take_actual_value;
    
    signal counter_10 : std_logic_vector(3 downto 0) := (others => '0');
   
begin
     
    left_button_inst : button --change led intensity (when manual mode is selected). Manual mode can be selected with SW1
    port map(
        clk       => clk,
        btn_in    => leftButton,
        btn_click => left_button_click
    );
    
    right_button_inst : button --blink frequency
    port map(
        clk       => clk,
        btn_in    => rightButton,
        btn_click => right_button_click
    );
     
    led_pwm_inst : led_pwm
    generic map(
        pwmIntBitN => 7 
    )port map(
        clk              => clk,
        dimmer           => left_button_click,
        intensity        => led_intensity,
        actualIntensity  => led_actual_intensity,
        manual_intensity => manualIntensity,
        led_pwr          => ledSig
    );   

    blink_control_inst : blink_control
    port map(
        clk       => clk,
        blinker   => right_button_click,
        blink_out => blinkSig
    );
    
    fade_control_inst : fade_control
    generic map(
        fadeSpdBitN => 19,
        fadeIntBitN => 7
    )port map(
        clk            => clk,
        fade_type      => fadeSelect, --0 = sawtooth fade, 1 = triangular fade. Selection is made through SW2.
        fade_intensity => led_intensity
    );    

    --assign LED output.
    led <= ledSig and (blinkSig or blinkEnable); --blinkEnable comes from SW0 (mask the blink signal) 

  -- Instantiate the seven segment display driver
  thedriver : entity work.seven_segment_driver( Behavioral ) generic map ( size => 21 ) port map (
    clock => clk,
    reset => '1',
    digit0 => display_data( 3 downto 0 ),
    digit1 => display_data( 7 downto 4 ),
    digit2 => display_data( 11 downto 8 ),
    digit3 => display_data( 15 downto 12 ),
    digit4 => display_data( 19 downto 16 ),
    digit5 => display_data( 23 downto 20 ),
    digit6 => display_data( 27 downto 24 ),
    digit7 => display_data( 31 downto 28 ),
    CA => CA, CB => CB, CC => CC, CD => CD, CE => CE, CF => CF, CG => CG, DP => DP,
    AN => AN
  );

    --decode the 7-bit binary number into BCD to display the current led intensity value
    bcd_decode_proc : process(clk)
    begin
        if(rising_edge(clk))then
            case(bcd_decode_state) is
            
            when take_actual_value =>
            
                led_intensity_sig <= led_actual_intensity(6 downto 0);
                counter_10 <= std_logic_vector(to_unsigned(0,4));
                bcd_decode_state <= wait_update;
            
            when wait_update =>
            
                if(led_intensity_sig /= led_actual_intensity(6 downto 0))then
                    led_intensity_sig <= led_actual_intensity(6 downto 0);
                    bcd_decode_state <= dec_0_9;
                else
                    bcd_decode_state <= wait_update;
                end if;
            
            when dec_0_9 =>
                
                led_intensity_sig <= led_intensity_sig - '1';
                counter_10 <= counter_10 + '1';
                if(led_intensity_sig = "0000000")then
                    bcd_decode_state <= add_0;
                elsif(counter_10 = std_logic_vector(to_unsigned(9,4)))then
                    counter_10 <= std_logic_vector(to_unsigned(0,4));
                    bcd_decode_state <= dec_10_19;
                else
                    bcd_decode_state <= dec_0_9;
                end if;
                
            when dec_10_19 =>
            
                led_intensity_sig <= led_intensity_sig - '1';
                counter_10 <= counter_10 + '1';
                if(led_intensity_sig = "0000000")then
                    bcd_decode_state <= add_6;
                elsif(counter_10 = std_logic_vector(to_unsigned(9,4)))then
                    counter_10 <= std_logic_vector(to_unsigned(0,4));
                    bcd_decode_state <= dec_20_29;
                else
                    bcd_decode_state <= dec_10_19;
                end if;
                
            when dec_20_29 =>
            
                led_intensity_sig <= led_intensity_sig - '1';
                counter_10 <= counter_10 + '1';
                if(led_intensity_sig = "0000000")then
                    bcd_decode_state <= add_12;
                elsif(counter_10 = std_logic_vector(to_unsigned(9,4)))then
                    counter_10 <= std_logic_vector(to_unsigned(0,4));
                    bcd_decode_state <= dec_30_39;
                else
                    bcd_decode_state <= dec_20_29;
                end if;
                
            when dec_30_39 =>
            
                led_intensity_sig <= led_intensity_sig - '1';
                counter_10 <= counter_10 + '1';
                if(led_intensity_sig = "0000000")then
                    bcd_decode_state <= add_18;
                elsif(counter_10 = std_logic_vector(to_unsigned(9,4)))then
                    counter_10 <= std_logic_vector(to_unsigned(0,4));
                    bcd_decode_state <= dec_40_49;
                else
                    bcd_decode_state <= dec_30_39;
                end if;
                
            when dec_40_49 =>
            
                led_intensity_sig <= led_intensity_sig - '1';
                counter_10 <= counter_10 + '1';
                if(led_intensity_sig = "0000000")then
                    bcd_decode_state <= add_24;
                elsif(counter_10 = std_logic_vector(to_unsigned(9,4)))then
                    counter_10 <= std_logic_vector(to_unsigned(0,4));
                    bcd_decode_state <= dec_50_59;
                else
                    bcd_decode_state <= dec_40_49;
                end if;
                
            when dec_50_59 =>
            
                led_intensity_sig <= led_intensity_sig - '1';
                counter_10 <= counter_10 + '1';
                if(led_intensity_sig = "0000000")then
                    bcd_decode_state <= add_30;
                elsif(counter_10 = std_logic_vector(to_unsigned(9,4)))then
                    counter_10 <= std_logic_vector(to_unsigned(0,4));
                    bcd_decode_state <= dec_60_69;
                else
                    bcd_decode_state <= dec_50_59;
                end if;
                
            when dec_60_69 =>
            
                led_intensity_sig <= led_intensity_sig - '1';
                counter_10 <= counter_10 + '1';
                if(led_intensity_sig = "0000000")then
                    bcd_decode_state <= add_36;
                elsif(counter_10 = std_logic_vector(to_unsigned(9,4)))then
                    counter_10 <= std_logic_vector(to_unsigned(0,4));
                    bcd_decode_state <= dec_70_79;
                else
                    bcd_decode_state <= dec_60_69;
                end if;
                
            when dec_70_79 =>
            
                led_intensity_sig <= led_intensity_sig - '1';
                counter_10 <= counter_10 + '1';
                if(led_intensity_sig = "0000000")then
                    bcd_decode_state <= add_42;
                elsif(counter_10 = std_logic_vector(to_unsigned(9,4)))then
                    counter_10 <= std_logic_vector(to_unsigned(0,4));
                    bcd_decode_state <= dec_80_89;
                else
                    bcd_decode_state <= dec_70_79;
                end if;
                
            when dec_80_89 =>
            
                led_intensity_sig <= led_intensity_sig - '1';
                counter_10 <= counter_10 + '1';
                if(led_intensity_sig = "0000000")then
                    bcd_decode_state <= add_48;
                elsif(counter_10 = std_logic_vector(to_unsigned(9,4)))then
                    counter_10 <= std_logic_vector(to_unsigned(0,4));
                    bcd_decode_state <= dec_90_99;
                else
                    bcd_decode_state <= dec_80_89;
                end if;
                
            when dec_90_99 =>
            
                led_intensity_sig <= led_intensity_sig - '1';
                counter_10 <= counter_10 + '1';
                if(led_intensity_sig = "0000000")then
                    bcd_decode_state <= add_54;
                elsif(counter_10 = std_logic_vector(to_unsigned(9,4)))then
                    counter_10 <= std_logic_vector(to_unsigned(0,4));
                    bcd_decode_state <= dec_100_109;
                else
                    bcd_decode_state <= dec_90_99;
                end if;
                
            when dec_100_109 =>
            
                led_intensity_sig <= led_intensity_sig - '1';
                counter_10 <= counter_10 + '1';
                if(led_intensity_sig = "0000000")then
                    bcd_decode_state <= add_156;
                elsif(counter_10 = std_logic_vector(to_unsigned(9,4)))then
                    counter_10 <= std_logic_vector(to_unsigned(0,4));
                    bcd_decode_state <= dec_110_119;
                else
                    bcd_decode_state <= dec_100_109;
                end if;
                
            when dec_110_119 =>
            
                led_intensity_sig <= led_intensity_sig - '1';
                counter_10 <= counter_10 + '1';
                if(led_intensity_sig = "0000000")then
                    bcd_decode_state <= add_162;
                elsif(counter_10 = std_logic_vector(to_unsigned(9,4)))then
                    counter_10 <= std_logic_vector(to_unsigned(0,4));
                    bcd_decode_state <= dec_120_129;
                else
                    bcd_decode_state <= dec_110_119;
                end if;
                
            when dec_120_129 =>
            
                led_intensity_sig <= led_intensity_sig - '1';
                counter_10 <= counter_10 + '1';
                if(led_intensity_sig = "0000000")then
                    bcd_decode_state <= add_168;
                elsif(counter_10 = std_logic_vector(to_unsigned(9,4)))then
                    counter_10 <= std_logic_vector(to_unsigned(0,4));
                    bcd_decode_state <= add_168;
                else
                    bcd_decode_state <= dec_120_129;
                end if;

            when add_168 =>
            
                display_data(11 downto 0) <= "000" & (("00" & led_actual_intensity(6 downto 0)) + std_logic_vector(to_unsigned(168, 9)));
                bcd_decode_state <= take_actual_value;
            
            when add_162 =>
            
                display_data(11 downto 0) <= "000" & (("00" & led_actual_intensity(6 downto 0)) + std_logic_vector(to_unsigned(162, 9)));
                bcd_decode_state <= take_actual_value;
            
            when add_156 =>
            
                display_data(11 downto 0) <= "000" & (("00" & led_actual_intensity(6 downto 0)) + std_logic_vector(to_unsigned(156, 9)));
                bcd_decode_state <= take_actual_value;
            
            when add_54 =>
            
                display_data(11 downto 0) <= "0000" & (('0' &led_actual_intensity(6 downto 0)) + std_logic_vector(to_unsigned(54, 8)));
                bcd_decode_state <= take_actual_value;
            
            when add_48 =>
            
                display_data(11 downto 0) <= "0000" & (('0' & led_actual_intensity(6 downto 0)) + std_logic_vector(to_unsigned(48, 8)));
                bcd_decode_state <= take_actual_value;
            
            when add_42 =>
            
                display_data(11 downto 0) <= "00000" & (led_actual_intensity(6 downto 0) + std_logic_vector(to_unsigned(42, 7)));
                bcd_decode_state <= take_actual_value;
            
            when add_36 =>
            
                display_data(11 downto 0) <= "00000" & (led_actual_intensity(6 downto 0) + std_logic_vector(to_unsigned(36, 7)));
                bcd_decode_state <= take_actual_value;
            
            when add_30 =>
            
                display_data(11 downto 0) <= "00000" & (led_actual_intensity(6 downto 0) + std_logic_vector(to_unsigned(30, 7)));
                bcd_decode_state <= take_actual_value;
            
            when add_24 =>
            
                display_data(11 downto 0) <= "00000" & (led_actual_intensity(6 downto 0) + std_logic_vector(to_unsigned(24, 7)));
                bcd_decode_state <= take_actual_value;
            
            when add_18 =>
            
                display_data(11 downto 0) <= "00000" & (led_actual_intensity(6 downto 0) + std_logic_vector(to_unsigned(18, 7)));
                bcd_decode_state <= take_actual_value;
            
            when add_12 =>
            
                display_data(11 downto 0) <= "00000" & (led_actual_intensity(6 downto 0) + std_logic_vector(to_unsigned(12, 7)));
                bcd_decode_state <= take_actual_value;
            
            when add_6 =>
            
                display_data(11 downto 0) <= "00000" & (led_actual_intensity(6 downto 0) + std_logic_vector(to_unsigned(6, 7)));
                bcd_decode_state <= take_actual_value;
            
            when add_0 =>
            
                display_data(11 downto 0) <= "00000" & led_actual_intensity(6 downto 0);
                bcd_decode_state <= take_actual_value;
            
            end case;
        end if;
    end process;
    
--    bcd_decode : process(led_actual_intensity(6 downto 0))
--    begin
--    
--        if(led_actual_intensity(6 downto 0) < "0001010")then -- 0-9
--        
--            oled_data(11 downto 0) <= "00000" & led_actual_intensity(6 downto 0);
--        
--        elsif(led_actual_intensity(6 downto 0) < "0010100")then -- 10-19
--        
--            oled_data(11 downto 0) <= "00000" & (led_actual_intensity(6 downto 0) + std_logic_vector(to_unsigned(6, 7)));
--        
--        elsif(led_actual_intensity(6 downto 0) < "0011110")then -- 20-29
--        
--            oled_data(11 downto 0) <= "00000" & (led_actual_intensity(6 downto 0) + std_logic_vector(to_unsigned(12, 7)));
--        
--        elsif(led_actual_intensity(6 downto 0) < "0101000")then -- 30-39
--        
--            oled_data(11 downto 0) <= "00000" & (led_actual_intensity(6 downto 0) + std_logic_vector(to_unsigned(18, 7)));
--        
--        elsif(led_actual_intensity(6 downto 0) < "0110010")then -- 40-49
--        
--            oled_data(11 downto 0) <= "00000" & (led_actual_intensity(6 downto 0) + std_logic_vector(to_unsigned(24, 7)));
--        
--        elsif(led_actual_intensity(6 downto 0) < "0111100")then -- 50-59
--        
--            oled_data(11 downto 0) <= "00000" & (led_actual_intensity(6 downto 0) + std_logic_vector(to_unsigned(30, 7)));
--        
--        elsif(led_actual_intensity(6 downto 0) < "1000110")then -- 60-69
--        
--            oled_data(11 downto 0) <= "00000" & (led_actual_intensity(6 downto 0) + std_logic_vector(to_unsigned(36, 7)));
--        
--        elsif(led_actual_intensity(6 downto 0) < "1010000")then -- 70-79
--        
--            oled_data(11 downto 0) <= "00000" & (led_actual_intensity(6 downto 0) + std_logic_vector(to_unsigned(42, 7)));
--        
--        elsif(led_actual_intensity(6 downto 0) < "1011010")then -- 80-89
--        
--            oled_data(11 downto 0) <= "0000" & (('0' & led_actual_intensity(6 downto 0)) + std_logic_vector(to_unsigned(48, 8)));
--      
--       elsif(led_actual_intensity(6 downto 0) < "1100100")then -- 90-99
--        
--            oled_data(11 downto 0) <= "0000" & (('0' &led_actual_intensity(6 downto 0)) + std_logic_vector(to_unsigned(54, 8)));
--        
--        elsif(led_actual_intensity(6 downto 0) < "1101110")then -- 100-109
--        
--            oled_data(11 downto 0) <= "000" & (("00" & led_actual_intensity(6 downto 0)) + std_logic_vector(to_unsigned(156, 9)));
--        
--        elsif(led_actual_intensity(6 downto 0) < "1111000")then -- 110-119
--        
--            oled_data(11 downto 0) <= "000" & (("00" & led_actual_intensity(6 downto 0)) + std_logic_vector(to_unsigned(162, 9)));
--        
--        else -- 120-129
--        
--            oled_data(11 downto 0) <= "000" & (("00" & led_actual_intensity(6 downto 0)) + std_logic_vector(to_unsigned(168, 9)));
--        
--        end if;
--    
--    end process;
    

end Behavioral;
