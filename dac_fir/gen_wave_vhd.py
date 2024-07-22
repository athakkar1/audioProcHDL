with open ('num.txt', 'r') as file:
  values = file.read().splitlines()

vhdl_package = """
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library WORK;
USE work.arraypkg.ALL;

package sinewave is
  constant wave : mem := (
"""

vhdl_package += ", ".join(values)

vhdl_package += """
);
end sinewave;
"""

with open('sinewave.vhd', 'w') as file:
  file.write(vhdl_package)