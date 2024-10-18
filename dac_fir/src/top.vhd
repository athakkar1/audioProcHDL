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
    ldac : out std_logic := '0';
    vauxp14 : in std_logic;
    vauxn14 : in std_logic;
    freq1_inc : in std_logic;
    freq1_dec : in std_logic;
    freq2_inc : in STD_LOGIC;
    freq2_dec : in std_logic);
end entity top;

architecture behavioral of top is
signal mclk_dac : std_logic := '0';
signal raw_adc_out : std_logic_vector(15 downto 0);
signal adc_out : std_logic_vector(15 downto 0);
signal adc_rd_vec : std_logic_vector(0 downto 0);
signal adc_rd : std_logic;
signal eoc_out_i : std_logic;
signal filtered_data : point := 0;
signal filtered_data_vec : std_logic_vector(15 downto 0);
signal temp_data_vec : std_logic_vector(15 downto 0);
SIGNAL i : INTEGER RANGE 0 TO num_points := 0;
SIGNAL j : INTEGER RANGE 0 TO num_points := 0;
SIGNAL data_in : point := 0;
SIGNAL sample_clk : STD_LOGIC := '0';
signal reset : std_logic := '0';
signal count1 : integer range 0 to 1220;
signal count2 : integer range 0 to 1220;
signal frequency1 : integer range 0 to 22000 := 2000;
signal frequency2 : integer range 0 to 22000 := 8000;
signal added_wave : STD_LOGIC_VECTOR(12 downto 0) := (others => '0');
signal sclk_i : std_logic := '0';
signal cs_i : std_logic := '1';
signal data_i : std_logic := '0';
begin
filtered_data_vec <= std_logic_vector(to_unsigned(filtered_data, 12)) & "0000";
reset <= freq1_dec OR freq1_inc OR freq2_dec OR freq2_inc;
count1 <= count_const / frequency1;
count2 <= count_const / frequency2;
sclk <= sclk_i;
cs <= cs_i;
data <= data_i;
adc_rd_vec(0) <= adc_rd;

ila_inst: entity work.ila_0
PORT map(
clk => mclk,
probe0 => adc_out,
probe1 => adc_rd_vec
);
fir_inst: entity work.fir
 port map(
    mask_i => decimal_numbers,
    mclk => adc_rd,
    data_in => to_integer(unsigned(adc_out)),
    data_out => filtered_data,
    reset => reset
);
dac_inst: entity work.dac
 port map(
    mclk => mclk_dac,
    sclk => sclk_i,
    cs => cs_i,
    data => data_i,
    data_word => adc_out,
    reset => reset);

xadc_wiz_0_inst : entity work.xadc_wiz_0
  port map(
    daddr_in    => "0011110", --fill
    den_in      => eoc_out_i, --fill
    di_in       => (others => '0'),
    dwe_in      => '0',
    do_out      => raw_adc_out,
    drdy_out    => adc_rd,
    dclk_in     => mclk,
    vauxp14     => vauxp14,
    vauxn14     => vauxn14,
    busy_out    => open,
    channel_out => open,
    eoc_out     => eoc_out_i,
    eos_out     => open,
    alarm_out   => open,
    vp_in       => '0',
    vn_in       => '0'
  );


process(mclk)
variable count : integer := 0;
begin
if rising_edge(mclk) then
    if count < 2 then
        count := count + 1;
    else
        mclk_dac <= not mclk_dac;
        count := 0;
    end if;
end if;
end process;

PROCESS(mclk)
    VARIABLE count : INTEGER := 0;
  BEGIN
    if rising_edge(mclk) then
    count := count + 1;
    IF count = 1417 THEN
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

  process (freq1_dec, freq1_inc, freq2_dec, freq2_inc)
  begin
    if freq1_dec = '1' then
      if frequency1 > 1000 then
        frequency1 <= frequency1 - 1000;
      end if;
    elsif freq1_inc = '1' then
      if frequency1 < 22000 then
        frequency1 <= frequency1 + 1000;
      end if;
    elsif freq2_dec = '1' then
      if frequency2 > 1000 then
        frequency2 <= frequency2 - 1000;
      end if;
    elsif freq2_inc = '1' then
      if frequency2 < 22000 then
        frequency2 <= frequency2 + 1000;
      end if;
    end if;
  end process;

  process(adc_rd)
  begin
    if adc_rd = '1' then
      adc_out <= raw_adc_out;
    end if;
  end process;

  --PROCESS(mclk, reset)
  --  VARIABLE count : INTEGER := 0;
  --BEGIN
  --  if reset = '1' then
  --    count := 0;
  --    j <= 0;
  --  elsif rising_edge(mclk) then
  --  count := count + 1;
  --  IF count >= count2 THEN
  --    IF j < num_points - 1 THEN
  --      j <= j + 1;
  --    ELSE
  --      j <= 0;
  --    END IF;
  --    count := 0;
  --  END IF;
  --end if;
  --END PROCESS;
  --added_wave <= STD_LOGIC_VECTOR(to_unsigned(wave(i) + wave(j), added_wave'length));
  --data_in <= to_integer(unsigned(added_wave(12 downto 1)));
end architecture;