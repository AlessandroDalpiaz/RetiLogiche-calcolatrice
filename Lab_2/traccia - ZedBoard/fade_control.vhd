----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2019 05:09:36 PM
-- Design Name: 
-- Module Name: fade_control - Behavioral
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

entity fade_control is
    generic(
        fadeSpdBitN  : integer; --numero di bit per la velocita' di modulazione 100 MHz / (2x2^fadeSpdBitN)
        fadeIntBitN  : integer  --numero di bit per i livelli di intensita'
    );
    port(
    -- * un ingresso di clock 'clk'
    -- * un ingresso per selezionare il tipo di modulazione 'fade_type'
    -- * una uscita che fornisce la soglia al modulatore PWM 'fade_intensity' di fadeIntBitN - bit
    );
end fade_control;

architecture Behavioral of fade_control is

    -- Dichiarazione architettura:sity fading controller
....-- Due effetti di modulazione da implementare
        --sawtooth fade : modulazione a dente di sega (loop intensity: 0->max)
        --triangular fade : modulazione triangolare (loop intensity:  0->max->0) 
    -- La velocita' di modulazione viene definita da un clock di fading 'fade_clk' con un periodo di 7.8 ms. 
    -- Per utilizzare tutti i 128 livelli di intensita' in ~1 s , l'intensita' del led va aggiornata ogni 7.8 ms tramite un clock di fading  'fade_clk'
    -- infatti si ha che 7.8 [ms] x 128 = 998.4 [ms]
    
    signal fade_demultiplier : std_logic_vector(fadeSpdBitN-1 downto 0) := std_logic_vector(to_unsigned(390000, fadeSpdBitN)); -- segnale utilizzato per ottenere il clock di fading (meta' del periodo di clock 7.8ms / 2 =3.9 ms)
    signal fade_clk : std_logic := '0'; 
    signal intensity_sig : std_logic_vector(fadeIntBitN-1 downto 0) := (others => '0');
    
    type fade_state_signal is (sawtooth_fade, triangular_fade_up, triangular_fade_down);
    signal fade_state : fade_state_signal := sawtooth_fade;
    
    signal fade_restart_slow : std_logic := '0';
    
begin
    -- processo sensibile al clock che genera il clock di fading. Il periodo di fade_clk e' 2 x 390000 x 10 [ns] = 7.8 [ms] 
    fade_clock_gen : process(clk) 
    begin
        if(...)then
            -- aggiorna il valoe di fade_demultiplier e controlla quando arriva a zero
            fade_demultiplier <= ...;
            if(fade_demultiplier = std_logic_vector(to_unsigned(0, fadeSpdBitN)))then
                --aggiorna il semiperiodo di fade_clk e fade_demultiplier 
                fade_clk <= ...; --each time we reach 390000 x 10 [ns] = 3.9 [ms] invert the 'fade_clk' signal
                                           --> the period is 2 x 3.9 [ms]
                fade_demultiplier <= std_logic_vector(to_unsigned(390000, fadeSpdBitN));
            end if;                        
            
            
        end if;
    end process;

    -- processo sensibile a fade_clk per generare i pattern di intensita'.Aggiorna soglia in ingresso al modulatore PWM ogni 7.8 ms
    fade_gen : process(fade_clk) 
    begin
        if(rising_edge(fade_clk))then
            
            case(fade_state) is
         
            when(sawtooth_fade) => 
                ---stato per la modulazione dente di sega (0->max). 
                intensity_sig <= intensity_sig + '1';
                if(fade_type = '0')then -- controlla selettore effetto
                    fade_state <= sawtooth_fade;
                else
                    fade_state <= triangular_fade_up;
                end if;
                
            when(...) => 
                ---stato per la modulazione triangolare  (rampa crescente : 0->max).
                intensity_sig <= ...;
                
                if(...)then 
                    fade_state <= ...;
                elsif(intensity_sig = std_logic_vector(to_unsigned(126, fadeIntBitN)))then 
                    --se il massimo valore e' stato raggiunto vai a 'triangular_fade_down'
                    fade_state <= ...;
                else
                    fade_state <= ...;
                end if;
                
            when(...) => 
            ---stato per la modulazione triangolare  (rampa decrescente : max->0).
            
                intensity_sig <= ...;
                
                if(...)then --check wheter to change effect or not
                    fade_state <= ...;
                elsif(intensity_sig = std_logic_vector(to_unsigned(1, fadeIntBitN)))then 
                    --se il minimo e' stato raggiunto vai a 'triangular_fade_up'
                    fade_state <= ...;
                else
                    fade_state <= ...;
                end if;                
            
            end case;
            
        end if;
    end process;

    --Assegna il valore di soglia in uscita
    fade_intensity <= intensity_sig;

end Behavioral;
