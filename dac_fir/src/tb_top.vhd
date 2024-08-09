LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top is
end entity tb_top;

architecture behavioral of tb_top is
    signal mclk : std_logic := '0';
    signal sclk : std_logic;
    signal cs : std_logic;
    signal data : std_logic;
    signal ldac : std_logic := '0';
    signal freq1_inc : std_logic := '0';
    signal freq1_dec : std_logic := '0';
    signal freq2_inc : std_logic := '0';
    signal freq2_dec : std_logic := '0';
begin
    top_inst: entity work.top
    port map(
        mclk => mclk,
        sclk => sclk,
        cs => cs,
        data => data,
        ldac => ldac,
        freq1_inc => freq1_inc,
        freq1_dec => freq1_dec,
        freq2_inc => freq2_inc,
        freq2_dec => freq2_dec
    );
    process
    begin
        mclk <= not mclk;
        wait for 5 ns;
    end process;

    process
    begin
    wait for 3 ms;
    freq1_inc <= '1';
    wait for 100 ns;
    freq1_inc <= '0';
    wait;
end process;
end architecture behavioral;