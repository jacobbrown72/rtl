library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
	port(
		addr	: in  std_logic_vector(15 downto 0);
		inst	: out std_logic_vector(15 downto 0);
		dout	: out std_logic_vector(7 downto 0)
	);
end rom;

architecture rtl of rom is
	--type mem is array (0 to 65535) of std_logic_vector(15 downto 0);
	--signal ir_rom : mem := (

	signal douts : std_logic_vector(15 downto 0);
	signal daddr : std_logic_vector(14 downto 0);
	signal byte_sel : std_logic;
begin
	daddr <= addr(15 downto 1);
	byte_sel <= addr(0);
	process(addr, daddr)
	begin
		--inst <= ir_rom(to_integer(unsigned(addr)));
		--douts <= ir_rom(to_integer(unsigned(daddr)));
		inst <= (others => '0');
		douts <= (others => '0');
	end process;
	
	process(byte_sel, douts)
	begin
		if(byte_sel = '1') then
			dout <= douts(15 downto 8);
		else
			dout <= douts(7 downto 0);
		end if;
	end process;
end rtl;