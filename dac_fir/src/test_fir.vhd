LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.fixed_pkg.ALL;
LIBRARY std;
USE std.textio.ALL;
LIBRARY work;
USE work.arraypkg.ALL;

ENTITY test_fir IS
END ENTITY test_fir;

ARCHITECTURE behavioral OF test_fir IS
  IMPURE FUNCTION read_from_file(FileName : STRING) RETURN mem IS
    FILE FileHandle : text OPEN read_mode IS filename;
    VARIABLE currentline : line;
    VARIABLE tempword : INTEGER;
    VARIABLE result : mem := (OTHERS => 0);
  BEGIN
    FOR i IN 0 TO num_points - 1 LOOP
      EXIT WHEN endfile(filehandle);
      readline(filehandle, currentline);
      read(currentline, tempword);
      result(i) := tempword;
    END LOOP;
    RETURN result;
  END FUNCTION;

  IMPURE FUNCTION read_from_file_real(FileName : STRING) RETURN mask IS
    FILE FileHandle : text OPEN read_mode IS filename;
    VARIABLE currentline : line;
    VARIABLE tempword : real;
    VARIABLE result : mask := (OTHERS => (OTHERS => '0'));
  BEGIN
    FOR i IN 0 TO mask_points - 1 LOOP
      EXIT WHEN endfile(filehandle);
      readline(filehandle, currentline);
      read(currentline, tempword);
      result(i) := to_sfixed(tempword, mask_point'left, mask_point'right);
      result(i) := resize(result(i), mask_point'left, mask_point'right);
    END LOOP;
    RETURN result;
  END FUNCTION;
  SIGNAL points : mem := read_from_file("D:\\fir_filter\\num.txt");
  SIGNAL mask_i : mask := read_from_file_real("D:\\fir_filter\\mask.txt");
  SIGNAL mclk : STD_LOGIC := '0';
  SIGNAL filtered_data : point := 0;
  SIGNAL i : INTEGER RANGE 0 TO num_points := 0;
  SIGNAL data_in : point := 0;
  SIGNAL sample_clk : STD_LOGIC := '0';
BEGIN
  PROCESS
  BEGIN
    mclk <= NOT mclk;
    WAIT FOR 5 ns;
  END PROCESS;

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
  fir_inst : ENTITY work.fir
    PORT MAP(
      mask_i => mask_i,
      mclk => sample_clk,
      data_in => data_in,
      data_out => filtered_data
    );

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
  data_in <= points(i);
END ARCHITECTURE;