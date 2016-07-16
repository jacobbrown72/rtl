library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity regsel is
	port(
		clk		: in  std_logic;
		rst		: in  std_logic;
		din		: in  std_logic_vector(7 downto 0);
		addr		: in  std_logic_vector(5 downto 0);
		wen		: in  std_logic;
		reg_sel	: out std_logic_vector(7 downto 0)
	);
end regsel;

architecture rtl of regsel is
	signal reg_sel_r : std_logic_vector(7 downto 0);
begin
	process(clk, rst)
	begin
		if(rst = '1') then
			reg_sel_r <= (others => '0');
		elsif(rising_edge(clk)) then
			if(wen = '1') then
				if(addr = "000011") then
					reg_sel_r <= din;
				end if;
			end if;
		end if;
	end process;
	reg_sel <= reg_sel_r;
end rtl;