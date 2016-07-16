library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity iobus is
	port(
		addr		: in  std_logic_vector(5 downto 0);
		psw		: in  std_logic_vector(7 downto 0);
		spl		: in  std_logic_vector(7 downto 0);
		sph		: in  std_logic_vector(7 downto 0);
		regsel	: in  std_logic_vector(7 downto 0);
		io_data	: out std_logic_vector(7 downto 0)
	);
end iobus;

architecture rtl of iobus is
begin
	process(addr, psw, spl, sph, regsel)
	begin
		case addr is 
			when "000000" =>
				io_data <= psw;
			when "000001" =>
				io_data <= spl;
			when "000010" =>
				io_data <= sph;
			when "000011" =>
				io_data <= regsel;
			when others =>
				io_data <= (others => '0');
		end case;
	end process;
end rtl;