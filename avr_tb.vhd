library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity avr_tb is
end avr_tb;

architecture rtl of avr_tb is
	component avr8
		port(
			clk	: in  std_logic;
			rst	: in  std_logic;
			done	: out std_logic
		);
	end component;
	
	signal clk, rst, done: std_logic;
begin
	U1_AVR8 : avr8
		port map(
			clk => clk,
			rst => rst,
			done => done
		);
		
	U2_PROC : process
	begin
		clk <= '0' and (not done);
		wait for 10 ns;
		clk <= '1' and (not done);
		wait for 10 ns;
	end process;
	
	U3_PROC : process
	begin
		rst <= '1';
		wait for 40 ns;
		rst <= '0';
		wait until done = '1';
		wait;
	end process;

end rtl;