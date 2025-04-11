library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity pwm_generator is
    generic (
        C_END   : integer := 300  -- Total number of clock cycles for one PWM period
    );
    Port (
        clk     : in  STD_LOGIC;           -- Main clock
        rst     : in  STD_LOGIC;           -- Reset signal
        en      : in  STD_LOGIC;           -- Enable signal for PWM output
        POS     : in  STD_LOGIC_VECTOR(7 downto 0);  -- Position input to control the duty cycle (0 to C_END-1)
        pwm_out : out STD_LOGIC            -- PWM output signal
    );
end pwm_generator;

architecture Behavioral of pwm_generator is
    -- Calculate the number of bits required for the counter
    constant N : integer := integer(ceil(log2(real(C_END)))); -- Number of bits required for counting

    -- Signals
    signal sig_count    : unsigned(N-1 downto 0) := (others => '0'); -- Counter signal
    signal valid_pos    : unsigned(N-1 downto 0);  -- Processed position value
    signal pwm_state    : STD_LOGIC := '1'; -- PWM output signal (starts high)
begin

    -- Process to generate PWM signal
    process (clk)
    begin
        if rising_edge(clk) then
            -- Reset condition: if reset is active, reset counter and PWM output
            if rst = '1' then
                sig_count    <= (others => '0');
                pwm_state    <= '1'; -- PWM is high at reset
            elsif en = '1' then
                -- Ensure the position input (POS) is within valid range (0 to C_END-1)
                valid_pos <= unsigned(POS) mod C_END;  -- Keep POS within range [0, C_END-1]
               
                -- Increment the counter and reset it when it exceeds C_END
                if sig_count = C_END - 1 then
                    sig_count <= (others => '0');  -- Reset counter at the end of the period
                else
                    sig_count <= sig_count + 1;  -- Increment counter
                end if;

                -- PWM generation logic based on counter comparison
                if sig_count < valid_pos then
                    pwm_state <= '1';  -- Output high while counter is less than duty cycle
                else
                    pwm_state <= '0';  -- Output low when counter exceeds duty cycle
                end if;
            end if;
        end if;
    end process;

    -- Output PWM signal
    pwm_out <= pwm_state;

end Behavioral;

