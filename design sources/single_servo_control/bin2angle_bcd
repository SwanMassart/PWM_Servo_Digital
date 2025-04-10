library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin2angle_bcd is
    Port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        bin_in : in  std_logic_vector(7 downto 0); -- position entre 100 et 200
        sign   : out std_logic;                    -- '1' si angle < 0
        bcd10  : out std_logic_vector(3 downto 0); -- dizaines
        bcd1   : out std_logic_vector(3 downto 0)  -- unités
    );
end bin2angle_bcd;

architecture Behavioral of bin2angle_bcd is
begin
    process(clk)
        variable bin_signed : integer;
        variable angle_int  : integer;
        variable abs_angle  : integer;
        variable tens       : integer;
        variable ones       : integer;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sign  <= '0';
                bcd10 <= (others => '0');
                bcd1  <= (others => '0');
            else
                -- Convertit bin_in en entier
                bin_signed := to_integer(unsigned(bin_in));
                
                -- Convertit en angle (-90 à +90)
                angle_int := (bin_signed - 150) * 9 / 5; -- équivalent à *1.8

                -- Détermine le signe
                if angle_int < 0 then
                    sign <= '1';
                    abs_angle := -angle_int;
                else
                    sign <= '0';
                    abs_angle := angle_int;
                end if;

                -- Découpe en dizaines et unités
                tens := abs_angle / 10;
                ones := abs_angle mod 10;

                -- Convertit en vecteurs de 4 bits
                bcd10 <= std_logic_vector(to_unsigned(tens, 4));
                bcd1  <= std_logic_vector(to_unsigned(ones, 4));
            end if;
        end if;
    end process;
end Behavioral;
