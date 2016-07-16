library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity spreg is
	port(
		clk	: in  std_logic;
		rst	: in  std_logic;
		din	: in  std_logic_vector(7 downto 0);
		addr	: in  std_logic_vector(5 downto 0);
		wen	: in  std_logic;
		sp_en	: in  std_logic;
		sp_sel: in  std_logic;
		sp		: out std_logic_vector(15 downto 0)
	);
end spreg;

architecture rtl of spreg is
	signal sp_reg : std_logic_vector(15 downto 0);
	signal sp_inc, sp_dec : std_logic_vector(15 downto 0);
begin

	sp_inc <= std_logic_vector(unsigned(sp_reg) + to_unsigned(1, 16));
	sp_dec <= std_logic_vector(unsigned(sp_reg) - to_unsigned(1, 16));
	
	process(clk, rst)
	begin
		if(rst = '1') then
			sp_reg <= (others => '0');
		elsif(rising_edge(clk)) then
			if(wen = '1') then
				if(addr = "000001") then
					sp_reg(7 downto 0) <= din;
					sp_reg(15 downto 8) <= sp_reg(15 downto 8);
				elsif(addr = "000010") then
					sp_reg(7 downto 0) <= sp_reg(7 downto 0);
					sp_reg(15 downto 8) <= din;
				else
					sp_reg <= sp_reg;
				end if;
			else
				if(sp_en = '1') then
					if(sp_sel = '1') then
						sp_reg <= sp_dec;
					else
						sp_reg <= sp_inc;
					end if;
				end if;
			end if;
		end if;
	end process;
	sp <= sp_reg;
	
end rtl;