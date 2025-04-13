-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 10 Apr 2025 15:21:52 GMT

library ieee;
use ieee.std_logic_1164.all;

entity tb_pwm_generator is
end tb_pwm_generator;

architecture tb of tb_pwm_generator is

    -- Component Declaration for the Unit Under Test (UUT)
    component pwm_generator
        generic (
            C_END : integer := 300  -- Total number of clock cycles for one PWM period
        );
        port (
            clk     : in std_logic;
            rst     : in std_logic;
            en      : in std_logic;
            POS     : in std_logic_vector (7 downto 0);
            pwm_out : out std_logic
        );
    end component;

    -- Signals
    signal clk     : std_logic;
    signal rst     : std_logic;
    signal en      : std_logic;
    signal POS     : std_logic_vector (7 downto 0);
    signal pwm_out : std_logic;

    -- Testbench parameters
    constant TbPeriod : time := 10 ns;  -- Set the period of the testbench clock
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

    -- Define the value for C_END (to be used for testing different duty cycles)
    constant C_END_TEST : integer := 300;  -- Example C_END value for testing

    -- Calculate the total simulation duration for 20 duty cycles
    constant TotalSimTime : time := (20 * C_END_TEST * TbPeriod);

begin

    -- Instantiate the Unit Under Test (UUT) with the desired generic value
    dut : pwm_generator
        generic map (
            C_END => C_END_TEST  -- Set the generic C_END to the test value
        )
        port map (
            clk     => clk,
            rst     => rst,
            en      => en,
            POS     => POS,
            pwm_out => pwm_out
        );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;
    en <= '1';

    stimuli : process
    begin
        -- Initialization of signals
        POS <= "00001000";  -- Set POS to 8 initially (This can represent 8/300 for duty cycle control)

        -- Reset generation
        rst <= '1';
        wait for 30 ns;
        rst <= '0';
        wait for 30 ns;

        -- Stimuli 1: Duty cycle 8/300 = approximately 2.67%
        wait for 36 * TbPeriod;  -- Wait for 36 periods

        -- Stimuli 2: Duty cycle 3/300 = approximately 1%
        POS <= "00000011";  -- Update POS
        wait for 36 * TbPeriod;  -- Wait for 36 periods

        -- Ensure 20 full duty cycles (each cycle is C_END_TEST periods long)
        wait for TotalSimTime;  -- Wait for 20 full PWM cycles

        -- Stop the clock and end the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block (for certain simulators)
configuration cfg_tb_pwm_generator of tb_pwm_generator is
    for tb
    end for;
end cfg_tb_pwm_generator;
