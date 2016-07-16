library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
	port(
		clk		: in  std_logic;
		rst		: in  std_logic;
		
		pc_sel	: in  std_logic_vector(1 downto 0);
		byte_sel	: in  std_logic;
		
		pc_en		: in  std_logic;
		pcl_en	: in  std_logic;
		pch_en	: in  std_logic;
		
		din		: in  std_logic_vector(7 downto 0);
		pc_in		: in  std_logic_vector(15 downto 0);
		
		pc_out	: out std_logic_vector(15 downto 0);
		dout		: out std_logic_vector(7 downto 0)
	);
end pc;

architecture rtl of pc is
	signal pc_rt, pc_cb, pc_1, pc_2, pc_r, pc_new : std_logic_vector(15 downto 0);
	signal pcl, pch : std_logic_vector(7 downto 0);
begin
	pc_cb <= pc_in;
	
	process(clk, rst)
	begin
		if(rst = '1') then
			pcl <= (others => '0');
			pch <= (others => '0');
		elsif(rising_edge(clk)) then
			if(pcl_en = '1') then
				pcl <= din;
			end if;
			if(pch_en = '1') then
				pch <= din;
			end if;
		end if;
	end process;
	pc_rt(15 downto 8) <= pch;
	pc_rt(7 downto 0) <= pcl;
	
	pc_1 <= std_logic_vector(unsigned(pc_r) + to_unsigned(1, 16));
	pc_2 <= std_logic_vector(unsigned(pc_r) + to_unsigned(2, 16));
	
	process(pc_rt, pc_cb, pc_2, pc_1, pc_sel)
	begin
		case pc_sel is
			when "00" =>
				pc_new <= pc_1;
			when "01" =>
				pc_new <= pc_2;
			when "10" =>
				pc_new <= pc_cb;
			when "11" =>
				pc_new <= pc_rt;
			when others =>
				pc_new <= (others => '0');
		end case;
	end process;
	
	process(clk, rst)
	begin
		if(rst = '1') then
			pc_r <= (others => '0');
		elsif(rising_edge(clk)) then
			if(pc_en = '1') then
				pc_r <= pc_new;
			end if;
		end if;
	end process;
	pc_out <= pc_r;
	
	process(pc_r, byte_sel)
	begin
		if(byte_sel = '1') then
			dout <= pc_r(15 downto 8);
		else
			dout <= pc_r(7 downto 0);
		end if;
	end process;
end rtl;