-----------------------------------------------------------------------------
-- Title           : frequency generator
-----------------------------------------------------------------------------
-- Author          : Louis Aromatario & Alberto Badilini
-- Date Created    : 31-06-2022
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

 
entity FreqOut is 

	generic
	(
		MIN_COUNT : natural :=1000;
		MAX_COUNT : natural :=1000000;
		STEP      : natural :=3902
		
	);
	
	port 						-- Declares the different ports of the component
	(	clk			: in std_logic;
		reset_n			: in std_logic;
		reg0value		: in std_logic_vector(7 downto 0);
		reg1enable		: in std_logic;
		gpio0			: out std_logic
	);

end entity;

architecture rtl of FreqOut is 

	signal gpiobuff	: std_logic := '0';	-- These 2 signals are the values manipulated during the process, gpiobuff is used as a buffer before outputting the frequency
	signal cnt     	: natural :=0;
	
begin 

	gpio0 <= gpiobuff; 			--gpio is constantly following the value of gpiobuff
	
	process(clk)
		variable max: natural :=0;
	
	begin if (rising_edge(clk)) then
		gpiobuff<='0';
		
		if reset_n='0' then
			cnt<=0;
			max:=MIN_COUNT+to_integer(unsigned(reg0value))*3902; -- this formula translate the 8-bit value of reg0value to a certain counter value corresponding
										-- to a certain frequency between 50Hz and 50 kHz
		elsif reg1enable = '1' then
		
			if cnt = (0) then
				max:=MIN_COUNT+to_integer(unsigned(reg0value))*3902;
			end if;
		
			cnt<=cnt+1;
			
			if cnt = (max) then
				gpiobuff<='1'; 				-- when the counter reaches the max value (desired value to obtain the good frquency), a pulse is generated
									-- and will last for the period of the clock (gpiobuff is firt set to 0 at each rising edge of the clock).
				cnt<=0;
			end if;
		else
			cnt<=0;
			max:=MIN_COUNT+to_integer(unsigned(reg0value))*3902;
		end if;
	end if;
	
	end process;
	
end rtl;




-- Quartus Prime VHDL Template
-- Binary Counter


