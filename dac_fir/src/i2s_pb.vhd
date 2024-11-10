library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2s_pb is
    generic(
        data_len : integer := 24
    );
    port(
        bclk : in std_logic;
        pbdat : out std_logic;
        pblrc : out std_logic;
        pbword_left : in std_logic_vector(data_len - 1 downto 0);
        pbword_right : in std_logic_vector(data_len - 1 downto 0);
        reset : in std_logic
    );
end entity i2s_pb;

architecture RTL of i2s_pb is
    signal pbshift : std_logic_vector(data_len - 1 downto 0) := (others => '0');
    signal pblrc_i : std_logic := '0';
begin
    playback : process(bclk)
        variable count : integer range 0 to 30 := 0;
    begin
        if falling_edge(bclk) then
            if reset = '1' then
                if count = 0 then
                    pblrc_i <= not pblrc_i;
                    count := count + 1;
                elsif count <= data_len then
                    count := count + 1;
                else
                    count := 0;
                end if;
                pbshift <= (others => '0');
                pbdat <= '0';
            else
                if count = 0 then
                    if pblrc_i = '0' then
                        pbshift <= pbword_right;
                        pblrc_i <= '1';
                    else
                        pbshift <= pbword_left;
                        pblrc_i <= '0';
                    end if;
                    count := count + 1;
                elsif count <= data_len then
                    pbdat <= pbshift(data_len - 1);
                    pbshift <= pbshift(data_len - 2 downto 0) & '0';
                    count := count + 1;
                else
                    count := 0;
                end if;
            end if;
        end if;
    end process playback;
    pblrc <= pblrc_i;
end architecture RTL;
