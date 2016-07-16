library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity databus is
	port(
		bus_sel 	: in  std_logic_vector(3 downto 0);
		res		: in  std_logic_vector(7 downto 0);
		ram_data	: in  std_logic_vector(7 downto 0);
		rom_data	: in  std_logic_vector(7 downto 0);
		io_data	: in  std_logic_vector(7 downto 0);
		rd			: in  std_logic_vector(7 downto 0);
		rr			: in  std_logic_vector(7 downto 0);
		pc_data	: in  std_logic_vector(7 downto 0);
		imd_data	: in  std_logic_vector(7 downto 0);
		dout		: out std_logic_vector(7 downto 0)
	);
end databus;

architecture rtl of databus is

begin
	process(bus_sel, res, ram_data, rom_data, io_data, rd, rr, pc_data, imd_data)
	begin
		case bus_sel is
			when "0000" =>
				dout <= res;
			when "0001" =>
				dout <= ram_data;
			when "0010" =>
				dout <= rom_data;
			when "0011" =>
				dout <= io_data;
			when "0100" =>
				dout <= rd;
			when "0101" =>
				dout <= rr;
			when "0110" =>
				dout <= pc_data;
			when "0111" =>
				dout <= imd_data;
			when others =>
				dout <= (others => '0');
		end case;
	end process;
end rtl;