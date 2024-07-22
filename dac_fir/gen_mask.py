def generate_vhdl_from_decimals_with_sfixed(input_file, vhdl_file):
    vhdl_template = """
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.fixed_pkg.ALL;
LIBRARY work;
USE work.arraypkg.all;
package mask_gen is
    CONSTANT decimal_numbers: mask := (
"""
    try:
        with open(input_file, 'r') as file:
            decimal_numbers = file.readlines()
            print(len(decimal_numbers))
            i = 0
            for num in decimal_numbers:
                if i < len(decimal_numbers)-1:
                    vhdl_template += f"{i} => to_sfixed({num.strip()}, mask_point'left, mask_point'right),\n"
                else:
                    vhdl_template += f"{i} => to_sfixed({num.strip()}, mask_point'left, mask_point'right)\n"
                i += 1
        vhdl_template += """
);
END mask_gen;
"""
        with open(vhdl_file, 'w') as file:
            file.write(vhdl_template)
            
    except Exception as e:
        print(f"An error occurred: {e}")

# Example usage
generate_vhdl_from_decimals_with_sfixed("mask.txt", "src/mask_gen.vhd")