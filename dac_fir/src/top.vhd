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
    data : out std_logic;
    freq1_inc : in std_logic;
    freq1_dec : in std_logic;
    freq2_inc : in STD_LOGIC;
    freq2_dec : in std_logic);
end entity top;

architecture behavioral of top is
signal mclk_dac : std_logic := '0';
signal filtered_data : point := 0;
signal filtered_data_vec : std_logic_vector(15 downto 0);
SIGNAL i : INTEGER RANGE 0 TO num_points := 0;
SIGNAL j : INTEGER RANGE 0 TO num_points := 0;
SIGNAL data_in : point := 0;
SIGNAL sample_clk : STD_LOGIC := '0';
signal reset : std_logic := '0';
signal count1 : integer range 0 to 1220;
signal count2 : integer range 0 to 1220;
signal frequency1 : integer range 0 to 22000 := 1000;
signal frequency2 : integer range 0 to 22000 := 2000;
signal added_wave : unsigned(12 downto 0) := (others => '0');
begin
filtered_data_vec <= std_logic_vector(to_unsigned(filtered_data, 12)) & "0000";
reset <= freq1_dec OR freq1_inc OR freq2_dec OR freq2_inc;
count1 <= count_const / frequency1;
count2 <= count_const / frequency2;
fir_inst: entity work.fir
 port map(
    mask_i => decimal_numbers,
    mclk => sample_clk,
    data_in => data_in,
    data_out => filtered_data,
    reset => reset
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
    data_word => filtered_data_vec,
    reset => reset
);

PROCESS(mclk)
    VARIABLE count : INTEGER := 0;
  BEGIN
    if rising_edge(mclk) then
    count := count + 1;
    IF count = 1134 THEN
      sample_clk <= NOT sample_clk;
      count := 0;
    END IF;
  end if;
  END PROCESS;

  PROCESS(mclk, reset)
    VARIABLE count : INTEGER := 0;
  BEGIN
    if reset = '1' then
      count := 0;
      i <= 0;
    elsif rising_edge(mclk) then
    count := count + 1;
    IF count >= count1 THEN
      IF i < num_points - 1 THEN
        i <= i + 1;
      ELSE
        i <= 0;
      END IF;
      count := 0;
    END IF;
  end if;
  END PROCESS;

  PROCESS(mclk, reset)
    VARIABLE count : INTEGER := 0;
  BEGIN
    if reset = '1' then
      count := 0;
      j <= 0;
    elsif rising_edge(mclk) then
    count := count + 1;
    IF count >= count2 THEN
      IF j < num_points - 1 THEN
        j <= j + 1;
      ELSE
        j <= 0;
      END IF;
      count := 0;
    END IF;
  end if;
  END PROCESS;
  added_wave <= to_unsigned(wave(i) + wave(j), 13);
  data_in <= to_integer(added_wave(12 downto 1));
end architecture;