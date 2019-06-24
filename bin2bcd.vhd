----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:29:14 05/23/2019 
-- Design Name: 
-- Module Name:    bin2bcd - Behavioral 
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

entity bin2bcd is
   Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  nivel: in STD_LOGIC_VECTOR(6 downto 0);
           ud : out  STD_LOGIC_VECTOR(3 downto 0);
           dec : out  STD_LOGIC_VECTOR(3 downto 0);
           cen : out  STD_LOGIC_VECTOR(3 downto 0));
end bin2bcd;

architecture Behavioral of bin2bcd is
	signal vectors: unsigned (19 downto 0);
begin
   process(clk, reset)
	begin
	   if reset='1' then
		   ud<=(others=>'0');
			dec<=(others=>'0');
			cen<=(others=>'0');
		elsif rising_edge(clk) then
		   ud<=std_logic_Vector(vectors(11 downto 8));
	      dec<=std_logic_vector(vectors(15 downto 12));
	      cen<=std_logic_vector(vectors(19 downto 16));
		end if;
	end process;
   process(nivel)
	variable vector: unsigned (19 downto 0);
	begin
         vector:=(others=>'0');
			vector(9 downto 3) := unsigned(nivel);
			for i in 0 to 4 loop
            if vector(11 downto 8) > 4 then
                vector(11 downto 8) := vector(11 downto 8) + 3;
            elsif vector(15 downto 12) > 4 then
                vector(15 downto 12) := vector(15 downto 12) + 3;
            elsif vector(19 downto 16) > 4 then
                vector(19 downto 16) := vector(19 downto 16) + 3;
            end if;
            vector(19 downto 1) := vector(18 downto 0);
        end loop;
		  vectors<=vector;
	end process;

			

end Behavioral;

	      