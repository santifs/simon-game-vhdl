----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:01:49 05/23/2019 
-- Design Name: 
-- Module Name:    lfsr16 - Behavioral 
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

entity lfsr16 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  secuencia : out STD_LOGIC_VECTOR(15 downto 0));
end lfsr16;

architecture Behavioral of lfsr16 is

   signal secuencia_aux : std_logic_vector(15 downto 0);

begin

   P_Lfsr16:process(clk, reset)
   begin
      if (reset = '1') then
         secuencia_aux <= X"CAFE";
      elsif rising_edge(clk) then
		   secuencia_aux <= secuencia_aux(14 downto 0) & (secuencia_aux(10) XOR secuencia_aux(12) XOR secuencia_aux(13) XOR secuencia_aux(15));
      end if;
   end process;
	
	secuencia <= secuencia_aux;
	
end Behavioral;

