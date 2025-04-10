library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_servo_control is
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
end entity;

architecture Behavioral of single_servo_control is
    component position is
        port (
            rst     : in STD_LOGIC;
            left    : in STD_LOGIC;
            right   : in STD_LOGIC;
            clk     : in STD_LOGIC;
            en      : in STD_LOGIC;
            comp_en : in STD_LOGIC;
            pos     : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    component pwm_generator is
        generic (
            C_END   : integer := 300
        );
        Port ( 
            clk     : in STD_LOGIC;
            rst     : in STD_LOGIC;
            en      : in STD_LOGIC;
            POS     : in STD_LOGIC_VECTOR(7 downto 0);
            pwm_out : out STD_LOGIC
        );
    end component;

    component bin2angle_bcd is
        Port (
            clk    : in STD_LOGIC;
            rst    : in STD_LOGIC;
            bin_in : in STD_LOGIC_VECTOR (7 downto 0);
            sign   : out STD_LOGIC;
            bcd10  : out STD_LOGIC_VECTOR (3 downto 0);
            bcd1   : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    component bin2seg is
        Port (
            clear : in STD_LOGIC;
            bin   : in STD_LOGIC_VECTOR (3 downto 0);
            seg   : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

    component sign2seg is
    Port (
        clear : in  std_logic;
        sign  : in  std_logic;
        seg   : out std_logic_vector(6 downto 0)
    );
end component;

    signal sig_pos        : STD_LOGIC_VECTOR (7 downto 0);
    signal sig_sign       : STD_LOGIC;
    signal sig_bcd1       : STD_LOGIC_VECTOR (3 downto 0);
    signal sig_bcd10      : STD_LOGIC_VECTOR (3 downto 0);
    signal sig_seg1       : STD_LOGIC_VECTOR (6 downto 0);
    signal sig_seg10      : STD_LOGIC_VECTOR (6 downto 0);
    signal sig_seg_sign   : STD_LOGIC_VECTOR (6 downto 0);

begin
    pos: position
        port map (
            clk     => CLK,
            rst     => BTNC,
            en      => CLK_POS,
            comp_en => EN,
            left    => BTNL,
            right   => BTNR,
            pos     => sig_pos
        );

    pwm_gen: pwm_generator
        port map (
            clk     => CLK,
            rst     => RST,
            en      => CLK_PWM_COUNTER,
            pos     => sig_pos,
            pwm_out => PWM
        );

    angle_converter: bin2angle_bcd
        port map (
            clk    => CLK,
            rst    => RST,
            bin_in => sig_pos,
            sign   => sig_sign,
            bcd10  => sig_bcd10,
            bcd1   => sig_bcd1
        );

    display_ones: bin2seg
        port map (
            clear => RST,
            bin   => sig_bcd1,
            seg   => sig_seg1
        );

    display_tens: bin2seg
        port map (
            clear => RST,
            bin   => sig_bcd10,
            seg   => sig_seg10
        );

    display_sign: sign2seg
    port map (
        clear => RST,       -- ou un autre signal si tu préfères
        sign  => sig_sign,
        seg   => sig_seg_sign
    );

    -- Assign outputs
    SEG1   <= sig_seg1;
    SEG10  <= sig_seg10;
    SEG100 <= sig_seg_sign;

end Behavioral;
