----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:29:23 05/23/2019 
-- Design Name: 
-- Module Name:    debouncer - Behavioral 
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

entity debounce is
    Port ( clk : in  STD_LOGIC;
           pul : in  STD_LOGIC;
           q : out  STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
   signal biestable : std_logic_vector(1 downto 0);
	signal rebote : std_logic;
	signal cuenta : unsigned(20 downto 0);

begin

   Pprincipal:process(clk)
   begin
      if rising_edge(clk) then
		   biestable(0) <= pul;
			biestable(1) <= biestable(0);
			if (rebote = '1') then
			   cuenta <= (others => '0');
				q <= '0';
			elsif (cuenta(20) = '0') then
			   cuenta <= cuenta + 1;
			else
			   q <= biestable(1);
			end if;
      end if;
   end process;
	
	rebote <= biestable(0) XOR biestable(1);

end Behavioral;

