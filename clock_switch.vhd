

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.MATH_REAL.ALL;

entity clock_enable_flexible is
    generic (
        PERIOD  : integer := 6; -- base period in clock cycles
        RATIO   : integer := 5  -- multiplier when switch is active
    );
    Port ( 
        clk     : in  STD_LOGIC; -- input clock signal
        rst     : in  STD_LOGIC; -- synchronous reset
        switch  : in  STD_LOGIC; -- switch to control ratio (e.g. button press)
        pulse   : out STD_LOGIC  -- output pulse
    );
end clock_enable_flexible;

architecture Behavioral of clock_enable_flexible is
    constant MAX_PERIOD       : integer := PERIOD * RATIO;
    constant BITS_NEEDED      : integer := integer(ceil(log2(real(MAX_PERIOD + 1))));

    signal sig_count          : std_logic_vector(BITS_NEEDED - 1 downto 0) := (others => '0');
    signal sig_pulse          : std_logic := '0';
    signal active_period      : integer;
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sig_count <= (others => '0');
                sig_pulse <= '0';
            else
                if sig_count = active_period - 1 then
                    sig_count <= (others => '0');
                    sig_pulse <= '1';
                else
                    sig_count <= sig_count + 1;
                    sig_pulse <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Set period based on switch
    active_period <= PERIOD when switch = '0' else PERIOD * RATIO;

    -- Output pulse
    pulse <= sig_pulse;

end Behavioral;
