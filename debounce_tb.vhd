--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:48:48 05/23/2019
-- Design Name:   
-- Module Name:   D:/LabDigital/Simon/debounce_tb.vhd
-- Project Name:  Simon
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: debouncer
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY debounce_tb IS
END debounce_tb;
 
ARCHITECTURE behavior OF debounce_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT debouncer
    PORT(
         clk : IN  std_logic;
         pul : IN  std_logic;
         q : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal pul : std_logic := '0';

 	--Outputs
   signal q : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: debouncer PORT MAP (
          clk => clk,
          pul => pul,
          q => q
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      pul <= '0';
		wait for 10 us;
		pul <= '1';
		wait for 10 us;
		pul <= '0';
		wait for 5 us;
		pul <= '1';
		wait for 15 us;
		pul <= '0';
		wait for 3 us;
		pul <= '1';
		wait for 7 us;
		pul <= '0';
		wait for 10 us;
		pul <= '1';
		wait for 12 ms;
		pul <= '0';
		wait for 3 us;
		pul <= '1';
		wait for 7 us;
		pul <= '0';
		wait for 3 us;
		pul <= '1';
		wait for 70 us;
		pul <= '0';
		wait for 10 us;
		pul <= '1';
		wait for 50 us;
		pul <= '0';
		wait for 3 us;
		pul <= '1';
		wait for 7 us;
		pul <= '0';
		wait for 3 us;
		pul <= '1';
		wait for 12 ms;
		pul <= '0';
		wait for 30 us;
		pul <= '1';
		wait for 70 us;
		pul <= '0';
		wait for 15 us;
		pul <= '1';
		wait for 40 us;
		pul <= '0';
		wait for 11 ms;
		pul <= '1';
		wait for 1 ms;
		pul <= '0';
      wait;
   end process;

END;
