-----------------------------------------------------------------------------
-- Title           : Title
-----------------------------------------------------------------------------
-- Author          : Daniel Pelikan
-- Date Created    : 01-07-2016
-----------------------------------------------------------------------------
-- Description     : Description
--							
--
-----------------------------------------------------------------------------
-- Copyright 2016. All rights reserved
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FreqOut_TB is
end entity;

architecture TB of FreqOut_TB is 

	constant PERIOD : time := 20 ns;
	component FreqOut is
	port (	
		clk				: in std_logic;
		reset_n			: in std_logic;
		reg0value		: in std_logic_vector(7 downto 0);
		reg1enable		: in std_logic;
		gpio0				: out std_logic
	);	
	end component;

		signal clk				: std_logic;
		signal reset_n			: std_logic;
		signal reg0value		: std_logic_vector(7 downto 0);
		signal reg1enable		: std_logic;
		signal gpio0			: std_logic;
		
begin  
		
		inst0: FreqOut
			port map (
			
			clk			=>clk,
			reset_n 		=>reset_n,
			reg0value	=>reg0value,
			reg1enable	=>reg1enable,
			gpio0			=>gpio0
			);
			
			
     clk_process :process
     begin
          CLK <= '1';
          wait for PERIOD/2;
          CLK <= '0';
          wait for PERIOD/2;
     end process;
	    
		P_resetn :process
			begin
 			reset_n <= '0';
       	wait for PERIOD/2;
       	reset_n <= '1';
				wait;
		end process;
	  
     stimulus : process
     begin
		reg0value <= "00000000";
		reg1enable <= '1';
		wait until gpio0 = '1';
		wait until gpio0='0';
		wait until gpio0 = '1';
		wait until gpio0='0';
		reg0value <= "00000001";
		reg1enable <= '1';
		wait until gpio0 = '1';
		wait until gpio0='0';
		wait until gpio0 = '1';
		wait until gpio0='0';
		reg0value <= "11111111";
		reg1enable <= '1';
		wait until gpio0 = '1';
		wait until gpio0='0';
		wait until gpio0 = '1';
		wait until gpio0='0';
		--wait;
     end process;
end TB ;

