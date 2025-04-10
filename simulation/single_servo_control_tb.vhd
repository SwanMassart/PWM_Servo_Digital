library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Aucune entrée/sortie ici car c'est un testbench
entity single_servo_control_tb is
end single_servo_control_tb;

architecture tb of single_servo_control_tb is

    -- Déclarer les signaux de test
    signal EN              : std_logic := '0';
    signal BTNC            : std_logic := '0';
    signal BTNL            : std_logic := '0';
    signal BTNR            : std_logic := '0';
    signal CLK_POS         : std_logic := '0';
    signal CLK_PWM_COUNTER : std_logic := '0';
    signal CLK             : std_logic := '0';
    signal RST             : std_logic := '0';
    signal PWM             : std_logic;
    signal SEG1            : std_logic_vector(6 downto 0);
    signal SEG10           : std_logic_vector(6 downto 0);
    signal SEG100          : std_logic_vector(6 downto 0);

    -- On instancie le composant à tester
    component single_servo_control is
        port (
            EN              : in STD_LOGIC;
            BTNC            : in STD_LOGIC;
            BTNL            : in STD_LOGIC;
            BTNR            : in STD_LOGIC;
            CLK_POS         : in STD_LOGIC;
            CLK_PWM_COUNTER : in STD_LOGIC;
            CLK             : in STD_LOGIC;
            RST             : in STD_LOGIC;
            PWM             : out STD_LOGIC;
            SEG1            : out STD_LOGIC_VECTOR (6 downto 0);
            SEG10           : out STD_LOGIC_VECTOR (6 downto 0);
            SEG100          : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

begin
    ------------------------------------------------------------------------
    --  UUT : Unit Under Test
    ------------------------------------------------------------------------
    uut: single_servo_control
        port map (
            EN              => EN,
            BTNC            => BTNC,
            BTNL            => BTNL,
            BTNR            => BTNR,
            CLK_POS         => CLK_POS,
            CLK_PWM_COUNTER => CLK_PWM_COUNTER,
            CLK             => CLK,
            RST             => RST,
            PWM             => PWM,
            SEG1            => SEG1,
            SEG10           => SEG10,
            SEG100          => SEG100
        );

    ------------------------------------------------------------------------
    --  Horloge principale (CLK)
    --  Exemple : période de 10 ns => 100 MHz
    ------------------------------------------------------------------------
    clk_process : process
    begin
        CLK <= '0';
        wait for 5 ns;
        CLK <= '1';
        wait for 5 ns;
    end process;

    ------------------------------------------------------------------------
    --  Génération du signal pour CLK_POS (basse fréquence, ex. 1 µs)
    --  Dans la vraie carte, c’est 100 Hz ou 10 Hz ; ici, on réduit pour la simu
    ------------------------------------------------------------------------
    clk_pos_process : process
    begin
        CLK_POS <= '0';
        wait for 50 ns;  -- demi période
        CLK_POS <= '1';
        wait for 50 ns;
    end process;

    ------------------------------------------------------------------------
    --  Génération du signal pour CLK_PWM_COUNTER (plus fréquent, ex. 1 MHz)
    --  Dans la vraie carte, c’est 100 kHz ; ici, on choisit plus rapide
    ------------------------------------------------------------------------
    clk_pwm_process : process
    begin
        CLK_PWM_COUNTER <= '0';
        wait for 5 ns;   -- demi période
        CLK_PWM_COUNTER <= '1';
        wait for 5 ns;
    end process;

    ------------------------------------------------------------------------
    --  Séquence de test
    ------------------------------------------------------------------------
    stim_proc : process
    begin
        -- Phase 0 : reset actif
        RST <= '1';
        EN  <= '0';
        BTNL <= '0';
        BTNR <= '0';
        BTNC <= '0';
        wait for 100 ns;

        -- Phase 1 : fin du reset
        RST <= '0';
        wait for 100 ns;

        -- Phase 2 : Activer le servo
        EN <= '1';
        wait for 200 ns;

        -- Phase 3 : Appui sur bouton LEFT
        BTNL <= '1';
        wait for 200 ns;
        BTNL <= '0';
        wait for 100 ns;

        -- Phase 4 : Appui sur bouton RIGHT
        BTNR <= '1';
        wait for 200 ns;
        BTNR <= '0';
        wait for 100 ns;

        -- Phase 5 : Appui sur BTNC pour recentrer
        BTNC <= '1';
        wait for 200 ns;
        BTNC <= '0';
        wait for 100 ns;

        -- Fin de la simulation
        wait;
    end process;

end architecture tb;
