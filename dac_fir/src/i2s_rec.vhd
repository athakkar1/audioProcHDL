library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2s_rec is
    generic(
        data_len : integer := 24
    );
    port(
        bclk : in std_logic;
        recdat : in std_logic;
        reclrc : in std_logic;
        recword_left : out std_logic_vector(data_len - 1 downto 0);
        recword_right : out std_logic_vector(data_len - 1 downto 0);
        reset : in std_logic
    );
end entity i2s_rec;

architecture RTL of i2s_rec is
    signal recshift : std_logic_vector(data_len - 1 downto 0) := (others => '0');
begin
    recording : process(bclk)
        variable count : integer := 0;
    begin
        if rising_edge(bclk) then
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
                    recshift <= recshift(data_len - 2 downto 0) & recdat;
                    count := count + 1;
                else
                    if reclrc = '0' then
                       recword_left <= recshift; 
                    else
                        recword_right <= recshift; 
                    end if;
                    count := 0;
                end if;
            end if;
        end if;
    end process recording;
end architecture RTL;
