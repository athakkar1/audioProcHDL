LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY dac IS
  GENERIC (
    dword : INTEGER := 16
  );
  PORT (
    mclk : IN STD_LOGIC;
    sclk : OUT STD_LOGIC;
    cs : OUT STD_LOGIC;
    data : OUT STD_LOGIC;
    data_word : IN STD_LOGIC_VECTOR(dword - 1 DOWNTO 0);
    reset : in STD_LOGIC
  );
END ENTITY dac;

ARCHITECTURE behavioral OF dac IS
  SIGNAL data_word_i : STD_LOGIC_VECTOR(dword - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL cs_i : STD_LOGIC := '1';
  SIGNAL sclk_i : STD_LOGIC := '0';
  SIGNAL data_i : STD_LOGIC := '0';
BEGIN
  PROCESS(mclk, reset)
    VARIABLE count : INTEGER := 0;
  BEGIN
    if reset = '1' then
      count := 0;
      sclk_i <= '0';
    elsif rising_edge(mclk) then
    count := count + 1;
    IF count = 1 THEN
      count := 0;
      sclk_i <= NOT sclk_i;
    END IF;
  end if;
  END PROCESS;

  PROCESS(sclk_i, reset)
    VARIABLE count : INTEGER := 0;
  BEGIN
    if reset = '1' then
      count := 0;
      cs_i <= '1';
      data_i <= '0';
      data_word_i <= (OTHERS => '0');
    elsif rising_edge(sclk_i) then
    cs_i <= '0';
    count := count + 1;
    IF count < 17 THEN
      IF cs_i = '0' THEN
        data_i <= data_word_i(15);
        data_word_i <= data_word_i(dword - 2 DOWNTO 0) & '0';
      ELSE
        data_word_i <= data_word;
        count := 0;
      END IF;
    ELSIF count >= 17 AND count < 19 THEN
      cs_i <= '1';
      data_word_i <= data_word;
      count := count + 1;
    ELSE
      cs_i <= '0';
      count := 0;
    END IF;
  end if;
  END PROCESS;
  cs <= cs_i;
  sclk <= sclk_i;
  data <= data_i;
END ARCHITECTURE;