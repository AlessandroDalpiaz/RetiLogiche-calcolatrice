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
    generic(
        pwmIntBitN : integer
    );
    port(
    -- * Un ingresso di clock "clk"
    -- * Un ingresso per aumentare l'intensita' tramite bottone "dimmer_up"
	-- * Un ingresso per ridurre l'intensita' tramite bottone "dimmer_down"
    -- * Un ingresso per definire la soglia esterna a pwmIntBitN bit "intensity"
    -- * Una uscita per il valore attuale di intensita' pwmIntBitN bit "actualIntensity"
    -- * Una uscita per pilotare il led "led_pwr"
    -- * Un ingresso per impostare l'intensita' tramite switch "manual_intensity"
    );
end led_pwm;

architecture Behavioral of led_pwm is

    -- definizione dell'architettura del modulatore PWM.
    -- Il duty cycle e' definito dal rapporto tra il segnale 'counter' e 'intensity_sig'. I due vettori devono avere la stessa dimensione 
    -- Il numero di livelli di intensita' e' dato dal numero di bit dei 2 vettori ( 2^7=128 livelli in questo caso_)

    signal counter       : std_logic_vector(pwmIntBitN-1 downto 0) := (others => '0'); 
    signal intensity_sig : std_logic_vector(pwmIntBitN-1 downto 0) := std_logic_vector(to_unsigned(63, pwmIntBitN));
    signal intensity_int : std_logic_vector(pwmIntBitN-1 downto 0) := std_logic_vector(to_unsigned(0, pwmIntBitN));

begin

    --Processo che genera un segnale PWM in funzione del clock
    pwm_modulation : process(...)
    begin
        -- aggiorna il valore di 'counter' e 'led_pwr in base alla soglia.
        if(...)then
            counter <= ...
            if(...)then
                led_pwr <= '1';
            else
                led_pwr <= '0';
            end if;
        end if;
    end process;

    -- processo che incrementa o decrementa il valore della soglia ad ogni pressione del bottone. Anche questo sensibile al clock.
    intensity_control : process(...)
    begin
        if(...)then
            if(...)then
                intensity_int <= ...;
             elsif(...) then
                intensity_int <= ...;
             end if;
            end if;
        end if;
    end process;
    

    -- istruzione che consente di selezionare la soglia (manuale o fornita dal modulatore di intensita')
    intensity_sig <= ... when manual_intensity = '...' else
                     ...;
    
    actualIntensity <= intensity_sig;    
               
end Behavioral;










