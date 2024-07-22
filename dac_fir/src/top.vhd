LIBRARY ieee;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.fixed_pkg.ALL;
LIBRARY work;
USE work.arraypkg.all;
USE work.sinewave.ALL;
USE work.mask_gen.ALL;

entity top is
port(
    mclk : in std_logic;
    sclk : out std_logic;
    cs : out std_logic;
    data : out std_logic);
end entity top;

architecture behavioral of top is
signal mclk_dac : std_logic := '0';
signal filtered_data : point := 0;
signal filtered_data_vec : std_logic_vector(15 downto 0);
SIGNAL i : INTEGER RANGE 0 TO num_points := 0;
SIGNAL data_in : point := 0;
SIGNAL sample_clk : STD_LOGIC := '0';
begin
filtered_data_vec <= std_logic_vector(to_unsigned(filtered_data, 12)) & "0000";
    --make
fir_inst: entity work.fir
 port map(
    mask_i => decimal_numbers,
    mclk => sample_clk,
    data_in => data_in,
    data_out => filtered_data
);
dac_inst: entity work.dac
 generic map(
    dword => 16
)
 port map(
    mclk => mclk_dac,
    sclk => sclk,
    cs => cs,
    data => data,
    data_word => filtered_data_vec
);

PROCESS
    VARIABLE count : INTEGER := 0;
  BEGIN
    WAIT UNTIL rising_edge(mclk);
    count := count + 1;
    IF count = 1134 THEN
      sample_clk <= NOT sample_clk;
      count := 0;
    END IF;
  END PROCESS;

  PROCESS
    VARIABLE count : INTEGER := 0;
  BEGIN
    WAIT UNTIL rising_edge(mclk);
    count := count + 1;
    IF count >= 80 THEN
      IF i < num_points - 1 THEN
        i <= i + 1;
      ELSE
        i <= 0;
      END IF;
      count := 0;
    END IF;
  END PROCESS;
  data_in <= wave(i);
end architecture;