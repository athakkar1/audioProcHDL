LIBRARY ieee;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.fixed_pkg.ALL;
LIBRARY work;
USE work.arraypkg.ALL;

ENTITY fir IS
  PORT (
    mask_i : IN mask;
    mclk : IN STD_LOGIC;
    data_in : IN INTEGER RANGE 0 TO 4095;
    data_out : OUT INTEGER RANGE 0 TO 4095 := 0
  );
END ENTITY fir;

ARCHITECTURE behavioral OF fir IS
  SIGNAL points_i : buf := (OTHERS => 0);
BEGIN

  PROCESS
    VARIABLE sum : sfixed(25 DOWNTO -15);
    VARIABLE delay : INTEGER := 0;
  BEGIN
    WAIT UNTIL rising_edge(mclk);
    sum := to_sfixed(0, 25, -15);
    --IF delay < (taps - 1/2) THEN
    delay := delay + 1;
    --END IF;
    FOR i IN taps - 1 DOWNTO 1 LOOP
      --IF delay = (taps - 1)/2 THEN
      sum := resize(sum + (points_i(i - 1) * mask_i(i)), sum'left, sum'right);
      --END IF;
      points_i(i) <= points_i(i - 1);
    END LOOP;
    --IF delay = (taps - 1)/2 THEN
    sum := resize(sum + (data_in * mask_i(0)), sum'left, sum'right);
    --END IF;
    points_i(0) <= data_in;
    IF sum < 0 THEN
      data_out <= 0;
    ELSIF sum > 4095 THEN
      data_out <= 4095;
    ELSE
      data_out <= to_integer(sum);
    END IF;
  END PROCESS;

END ARCHITECTURE;