library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2s is
    generic(
        data_len : integer := 24
    );
    port(
        mclk          : in  std_logic;
        bclk          : out std_logic;
        pbdat         : out std_logic;
        pblrc         : out std_logic;
        recdat        : in  std_logic;
        reclrc        : out std_logic;
        pbword_left   : in  std_logic_vector(data_len - 1 downto 0);
        pbword_right  : in  std_logic_vector(data_len - 1 downto 0);
        recword_left  : out std_logic_vector(data_len - 1 downto 0);
        recword_right : out std_logic_vector(data_len - 1 downto 0);
        reset : in std_logic
    );
end entity i2s;

architecture RTL of i2s is
    signal bclk_i : std_logic := '1';
    signal pblrc_i : std_logic := '0';
    signal reclrc_i : std_logic := '0';
    signal pbshift : std_logic_vector(data_len -1 downto 0) := (others => '0');
    signal recshift : std_logic_vector(data_len -1 downto 0) := (others => '0');
begin
    bclk_gen : process(mclk)
        variable count : integer := 0;
    begin
        if rising_edge(mclk) then
            if count < 128 then
                count := count + 1;
            else
                bclk_i <= not bclk_i;
                count  := 0;
            end if;
        end if;
    end process bclk_gen;

    playback : process(bclk_i)
        variable count : integer := 0;
    begin
        if falling_edge(bclk_i) then
            if reset = '1' then
                if count = 0 then
                    if pblrc_i = '0' then
                        pblrc_i <= '1';
                    else
                        pblrc_i <= '0';
                    end if;
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

    recording : process(bclk_i)
        variable count : integer := 0;
    begin
        if rising_edge(bclk_i) then
            if reset = '1' then
                if count = 0 then
                  count := count + 1;
                elsif count <= data_len then
                    count := count + 1;
                else
                    count := 0;
                end if;
                recshift <= (others => '0');
                recword_left <= (others => '0');
                recword_right <= (others => '0');
            else
                if count = 0 then
                    count := count + 1;
                elsif count <= data_len then
                    recshift <= recshift(data_len -2 downto 0) & recdat;
                    count := count + 1;

                else
                    if pblrc_i = '0' then
                       recword_left <= recshift; 
                    else
                        recword_right <= recshift; 
                    end if;
                    count := 0;
                end if;
            end if;
        end if;
    end process recording;
    bclk <= bclk_i;
    pblrc <= pblrc_i;
    reclrc <= pblrc_i;
end architecture RTL;