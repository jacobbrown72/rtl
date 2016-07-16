library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity pswreg is
	port(
		clk		: in  std_logic;
		rst		: in  std_logic;
		din		: in  std_logic_vector(7 downto 0);
		addr		: in  std_logic_vector(5 downto 0);
		wen		: in  std_logic;
		psw_in	: in  std_logic_vector(7 downto 0);
		psw_en	: in  std_logic_vector(7 downto 0);
		psw_out	: out std_logic_vector(7 downto 0)	
	);
end pswreg;

architecture rtl of pswreg is
	signal psw_reg : std_logic_vector(7 downto 0);
begin

	process(clk, rst)
	begin
		if(rst = '1') then
			psw_reg <= (others => '0');
		elsif(rising_edge(clk)) then
			if(wen = '1') then
				if(addr = "000000") then
					psw_reg <= din;
				else
					psw_reg <= psw_reg;
				end if;
			else
				if(psw_en(0) = '1') then
					psw_reg(0) <= psw_in(0);
				end if;
				if(psw_en(1) = '1') then
					psw_reg(1) <= psw_in(1);
				end if;
				if(psw_en(2) = '1') then
					psw_reg(2) <= psw_in(2);
				end if;
				if(psw_en(3) = '1') then
					psw_reg(3) <= psw_in(3);
				end if;
				if(psw_en(4) = '1') then
					psw_reg(4) <= psw_in(4);
				end if;
				if(psw_en(5) = '1') then
					psw_reg(5) <= psw_in(5);
				end if;
				if(psw_en(6) = '1') then
					psw_reg(6) <= psw_in(6);
				end if;
				if(psw_en(7) = '1') then
					psw_reg(7) <= psw_in(7);
				end if;
			end if;
		end if;
	end process;
	psw_out <= psw_reg;
	
end rtl;