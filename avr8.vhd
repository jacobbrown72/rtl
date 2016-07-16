library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity avr8 is
	port(
		clk	: in  std_logic;
		rst	: in  std_logic;
		done	: out std_logic
	);
end avr8;

architecture rtl of avr8 is
	component datapath
		port(
			clk			: in  std_logic;
			rst			: in  std_logic;
			--register enable signals
			pc_en 		: in  std_logic;
			pcl_en		: in  std_logic;
			pch_en 		: in  std_logic;
			ir_en			: in  std_logic;
			reg_en		: in  std_logic;
			res_en 		: in  std_logic;
			v_en			: in  std_logic;
			n_en 			: in  std_logic;
			z_en 			: in  std_logic;
			c_en			: in  std_logic;
			io_wen		: in  std_logic;
			sp_en			: in  std_logic;
			rom_enable	: in  std_logic;
			ram_enable	: in  std_logic;
			ram_wen		: in  std_logic;
			--mux select signals
			pc_sel		: in  std_logic_vector(1 downto 0);
			byte_sel		: in  std_logic;
			imd_sel 		: in  std_logic;
			func			: in  std_logic_vector(3 downto 0);
			sp_sel		: in  std_logic;
			bus_sel		: in  std_logic_vector(3 downto 0);
			raddr_sel	: in  std_logic_vector(1 downto 0);
			movw_sel		: in  std_logic;
			--output control signals
			opcode		: out std_logic_vector(4 downto 0);
			special		: out std_logic;
			condition	: out std_logic
		);
	end component;
	
	component controller
		port(
			clk			: in  std_logic;
			rst			: in  std_logic;
			--input control signals
			opcode		: in  std_logic_vector(4 downto 0);
			special 		: in  std_logic;
			condition	: in  std_logic;
			--register enable signals
			pc_en 		: out std_logic;
			pcl_en		: out std_logic;
			pch_en 		: out std_logic;
			ir_en			: out std_logic;
			reg_en		: out std_logic;
			res_en 		: out std_logic;
			v_en			: out std_logic;
			n_en 			: out std_logic;
			z_en 			: out std_logic;
			c_en			: out std_logic;
			io_wen		: out std_logic;
			sp_en			: out std_logic;
			rom_enable	: out std_logic;
			ram_enable	: out std_logic;
			ram_wen		: out std_logic;
			--mux select signals
			pc_sel		: out std_logic_vector(1 downto 0);
			byte_sel		: out std_logic;
			imd_sel 		: out std_logic;
			func			: out std_logic_vector(3 downto 0);
			sp_sel		: out std_logic;
			bus_sel		: out std_logic_vector(3 downto 0);
			raddr_sel	: out std_logic_vector(1 downto 0);
			movw_sel		: out std_logic;
			done			: out std_logic
		);
	end component;
	
	signal pc_sel, raddr_sel : std_logic_vector(1 downto 0);
	signal byte_sel, imd_sel, sp_sel : std_logic;
	signal func, bus_sel : std_logic_vector(3 downto 0);
	signal ram_wen, ram_enable, rom_enable, sp_en, io_wen : std_logic;
	signal c_en, z_en, n_en, v_en : std_logic;
	signal res_en, reg_en, ir_en, pch_en, pcl_en, pc_en : std_logic;
	signal opcode : std_logic_vector(4 downto 0);
	signal special, condition : std_logic;
	signal movw_sel : std_logic;
begin
	U1_DATAPATH : datapath
		port map(
			clk => clk,
			rst => rst,
			pc_en => pc_en,
			pcl_en => pcl_en,
			pch_en => pch_en,
			ir_en => ir_en,
			reg_en => reg_en,
			res_en => res_en,
			v_en => v_en,
			n_en => n_en,
			z_en => z_en,
			c_en => c_en,
			io_wen => io_wen,
			sp_en => sp_en,
			rom_enable => rom_enable,
			ram_enable => ram_enable,
			ram_wen => ram_wen,
			pc_sel => pc_sel, 
			byte_sel	=> byte_sel,
			imd_sel => imd_sel,
			func => func,			
			sp_sel => sp_sel,		
			bus_sel => bus_sel,		
			raddr_sel => raddr_sel,
			movw_sel => movw_sel,
			opcode => opcode,
			special => special,
			condition => condition
		);
		
	U2_CONTROLLER : controller
		port map(
			clk => clk,
			rst => rst,
			opcode => opcode,
			special => special,
			condition => condition,
			pc_en => pc_en,
			pcl_en => pcl_en,
			pch_en => pch_en,
			ir_en => ir_en,
			reg_en => reg_en,
			res_en => res_en,
			v_en => v_en,
			n_en => n_en,
			z_en => z_en,	
			c_en => c_en,	
			io_wen => io_wen,
			sp_en	=> sp_en,
			rom_enable => rom_enable,
			ram_enable => ram_enable,
			ram_wen => ram_wen,
			pc_sel => pc_sel,
			byte_sel => byte_sel,
			imd_sel => imd_sel,
			func => func,
			sp_sel => sp_sel,	
			bus_sel => bus_sel,
			raddr_sel => raddr_sel,
			movw_sel => movw_sel,
			done => done
		);
end;