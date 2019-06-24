----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:59:23 05/24/2019 
-- Design Name: 
-- Module Name:    bd - Behavioral 
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

entity bcd7seg is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           ud : in  STD_LOGIC_VECTOR (3 downto 0);
           dec : in  STD_LOGIC_VECTOR (3 downto 0);
           cen : in  STD_LOGIC_VECTOR (3 downto 0);
			  an : out  STD_LOGIC_VECTOR (7 downto 0);
           ca : out  STD_LOGIC;
           cb : out  STD_LOGIC;
           cc : out  STD_LOGIC;
           cd : out  STD_LOGIC;
           ce : out  STD_LOGIC;
           cf : out  STD_LOGIC;
           cg : out  STD_LOGIC);
end bcd7seg;

architecture Behavioral of bcd7seg is
   signal cont: unsigned( 18 downto 0);
	signal q_u: std_logic_vector(3 downto 0);
	signal visu: std_logic_vector(6 downto 0);
	signal an1: std_logic_vector(7 downto 0);
begin
   process(clk, reset)
	begin
	   if reset='1' then
		   cont<=(others=>'0');
		elsif rising_edge(clk) then
		   cont<= cont + 1;
		end if;
	end process;
	an(7 downto 3)<="11111";
	with cont (18 downto 17) select
	an1(2 downto 0)<="110" when "00",
		             "101" when "01",
						 "011" when "10",
						 "111" when others;
						 
	an(2 downto 0)<= an1(2 downto 0) when reset='0' else
	                 "111";
        	
	with cont(18 downto 17) select
	   q_u<= ud when "00",
		      dec when "01",
				cen when others;
				
	with q_u select
    visu <= "0000001" when "0000",  -- 0
            "1001111" when "0001",  -- 1
            "0010010" when "0010",  -- 2
            "0000110" when "0011",  -- 3
            "1001100" when "0100",  -- 4
            "0100100" when "0101",  -- 5
            "0100000" when "0110",  -- 6
            "0001111" when "0111",  -- 7
            "0000000" when "1000",  -- 8
            "0000100" when "1001",  -- 9
            "1111111" when others;  -- apagado
    
  ca <= visu(6);
  cb <= visu(5);
  cc <= visu(4);
  cd <= visu(3);
  ce <= visu(2);
  cf <= visu(1);
  cg <= visu(0);
            
		   
end Behavioral;

