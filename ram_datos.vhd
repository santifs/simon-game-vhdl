----------------------------------------------------------------------------------
-- Company: DTE-US
-- Engineer: CJJF
-- 
-- Create Date:    10:51:41 04/19/2018 
-- Design Name: 
-- Module Name:    bram_2p_nxm - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Memoria RAM de doble puerto: un puerto de escritura/lectura y otro
--              de lectura. Sólo un reloj. Para generar un block RAM
--              Parametrizable
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity ram_datos is
    Generic( N: integer :=7;    -- Numero de entradas de dirección
             M: integer := 3);  -- Numero de columnas
    Port ( clk :   in  STD_LOGIC;
           wea :   in  STD_LOGIC;
           ena :   in  STD_LOGIC;
           enb :   in  STD_LOGIC;
           addra : in  STD_LOGIC_VECTOR (6 downto 0);
           addrb : in  STD_LOGIC_VECTOR (6 downto 0);
           dia :  in   STD_LOGIC_VECTOR (M-1 downto 0);
           doa :  out  STD_LOGIC_VECTOR (M-1 downto 0);
           dob :  out  STD_LOGIC_VECTOR (M-1 downto 0));
end ram_datos;

architecture Behavioral of ram_datos is

   type   ram_type is array (2**N -1 downto 0) of std_logic_vector (M-1 downto 0);
   signal ram_mem: ram_type;

begin

  -- Proceso de escritura de la memoria
  P_escritura:process(clk)
  begin
      if rising_edge(clk) then
         if ena = '1' then
            if wea = '1' then
               ram_mem(to_integer(unsigned(addra))) <= dia;
            end if;
            doa <= ram_mem(to_integer(unsigned(addra))) ;
         end if;
      end if;
   end process;
   
   -- Proceso de lectura
   P_lectura:process (clk)
   begin
      if rising_edge(clk) then
         if enb = '1' then
            dob <= ram_mem(to_integer(unsigned(addrb))) ;
         end if;
      end if;
   end process;

end Behavioral;

