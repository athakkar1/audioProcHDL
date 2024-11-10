with open ('num.txt', 'r') as file:
  values = file.read().splitlines()
  
for i in range(len(values)):
    values[i] = f"to_signed({values[i]}, 24)"

vhdl_package = """
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
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

with open('./src/sinewave.vhd', 'w') as file:
  file.write(vhdl_package)