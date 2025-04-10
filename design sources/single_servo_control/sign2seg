library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sign2seg is
    Port (
        clear : in  std_logic;                 -- active pour éteindre l'affichage
        sign  : in  std_logic;                 -- '1' = négatif, afficher "-"
        seg   : out std_logic_vector(6 downto 0) -- segments pour affichage
    );
end sign2seg;

architecture Behavioral of sign2seg is
begin
    process(clear, sign)
    begin
        if clear = '1' then
            seg <= "1111111"; -- Afficheur éteint
        elsif sign = '1' then
            seg <= "0111111"; -- Affiche "-"
        else
            seg <= "1111111"; -- Rien affiché
        end if;
    end process;
end Behavioral;
