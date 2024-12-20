LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.fixed_pkg.ALL;

PACKAGE arraypkg IS
  CONSTANT taps : INTEGER := 59;
  CONSTANT num_points : INTEGER := 4096;
  CONSTANT mask_points : INTEGER := 59;
  CONSTANT mclk_freq : integer := 125000000;
  constant count_const : integer := mclk_freq/num_points;
  SUBTYPE point IS SIGNED(23 downto 0);
  TYPE mem IS ARRAY (0 TO num_points - 1) OF point;
  TYPE buf IS ARRAY (0 TO taps - 1) OF point;
  SUBTYPE mask_point IS sfixed(12 DOWNTO -15);
  TYPE mask IS ARRAY (0 TO mask_points - 1) OF mask_point;
END PACKAGE;