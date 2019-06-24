----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:21:22 05/22/2019 
-- Design Name: 
-- Module Name:    Rom_simon - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Rom_simon is
    Port ( addr_fila : in  STD_LOGIC_VECTOR (5 downto 0);
           data_fila : out  STD_LOGIC_VECTOR(7 DOWNTO 0));
end Rom_simon;

architecture Behavioral of Rom_simon is

	type rom_type is array (63 downto 0) of std_logic_vector (7 downto 0);
	constant mem_rom: rom_type:=(
      "00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000", -- blanco
		"00000000","00000000","00000000","00000000","00000000","00000000","00000000","00000000", -- blanco
      "00000000","01000010","00100100","00011000","00011000","00100100","01000010","00000000", --cruz HEX:42241818244200
	   "00010000","00110000","01111111","11111111","01111111","00110000","00010000","00000000", --flecha hacia la derecha -- 0010307fff7f3010
	   "00001000","00001100","11111110","11111111","11111110","00001100","00001000","00000000", --flecha hacia la izquierda -- 00080cfefffe0c08
      "00011100","00011100","00011100","00011100","01111111","00111110","00011100","00001000", --flecha hacia abajo -- 081c3e7f1c1c1c1c
      "00001000","00011100","00111110","01111111","00011100","00011100","00011100","00011100", --flecha hacia arriba -- 1c1c1c1c7f3e1c08
	   "00000000","00111100","01111110","01111110","01111110","01111110","00111100","00000000"); --circulo -- 003c7e7e7e7e3c00
	
begin

   data_fila <= mem_rom(to_integer(unsigned(addr_fila)));

end Behavioral;

