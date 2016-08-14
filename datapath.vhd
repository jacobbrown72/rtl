library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
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
end datapath;

architecture struct of datapath is
	
	component rom
		port(
			clk : in std_logic;
			addra : in std_logic_vector(15 downto 0);
			addrb : in std_logic_vector(15 downto 0);
			qa : out std_logic_vector(15 downto 0);
			qb : out std_logic_vector(15 downto 0)
		);
	end component;
	
	component pc
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
	end component;
	
	component regfile
		port(
			clk	: in  std_logic;
			rst	: in  std_logic;
			din	: in  std_logic_vector(7 downto 0);
			dsel	: in  std_logic_vector(4 downto 0);
			rsel	: in  std_logic_vector(4 downto 0);
			wen	: in  std_logic;
			rd		: out std_logic_vector(7 downto 0);
			rr		: out std_logic_vector(7 downto 0);
			addr	: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component alu
		port(
			in1	: in  std_logic_vector(7 downto 0);
			in2	: in  std_logic_vector(7 downto 0);
			cin	: in  std_logic;
			func	: in  std_logic_vector(3 downto 0);
			res   : out std_logic_vector(7 downto 0);
			c		: out std_logic;
			z		: out std_logic;
			n		: out std_logic;
			v		: out std_logic
		);
	end component;
	
	component pswreg
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
	end component;
	
	component spreg
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
	end component;
	
	component regsel
		port(
			clk		: in  std_logic;
			rst		: in  std_logic;
			din		: in  std_logic_vector(7 downto 0);
			addr		: in  std_logic_vector(5 downto 0);
			wen		: in  std_logic;
			reg_sel	: out std_logic_vector(7 downto 0)
		);
	end component;
	
	component iobus
		port(
			addr		: in  std_logic_vector(5 downto 0);
			psw		: in  std_logic_vector(7 downto 0);
			spl		: in  std_logic_vector(7 downto 0);
			sph		: in  std_logic_vector(7 downto 0);
			regsel	: in  std_logic_vector(7 downto 0);
			io_data	: out std_logic_vector(7 downto 0)
		);
	end component;
	
	component ram
		port(
		  clk   : in  std_logic;
		  we    : in  std_logic;
		  data  : in  std_logic_vector(7 downto 0);
		  addr  : in  std_logic_vector(15 downto 0);
		  q     : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component databus
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
	end component;
	
	signal ir_addr, ind_addr, rom_addr, inst_data, inst_reg, ram_addr : std_logic_vector(15 downto 0);
	signal pc_data, rom_data, dbus : std_logic_vector(7 downto 0);
	signal imd_dsel, reg_dsel, rsel, dsel : std_logic_vector(4 downto 0);
	signal rsel1, dsel1, dselin, rselin : std_logic_vector(4 downto 0);
	signal immediate : std_logic_vector(7 downto 0);
	signal r_op, d_op : std_logic_vector(7 downto 0);
	signal op1, op2, res, res_reg : std_logic_vector(7 downto 0);
	signal io_addr, io_imd, io_reg : std_logic_vector(5 downto 0);
	signal psw, psw_in, psw_en : std_logic_vector(7 downto 0);
	signal sp : std_logic_vector(15 downto 0);
	signal reg_sel : std_logic_vector(7 downto 0);
	signal io_data : std_logic_vector(7 downto 0);
	signal rom_dataw : std_logic_vector(15 downto 0);
	signal ram_data : std_logic_vector(7 downto 0);
	signal cc : std_logic_vector(3 downto 0);
	signal address_b : std_logic_vector(15 downto 0);
begin
	U1_PC : pc
		port map(
			clk => clk,
			rst => rst,
			pc_sel => pc_sel,
			byte_sel => byte_sel,
			pc_en => pc_en,
			pcl_en => pcl_en,
			pch_en => pch_en,
			din => dbus,
			pc_in => inst_data,
			pc_out => ir_addr,
			dout => pc_data
		);
	
	address_b <= '0'&ind_addr(15 downto 1);
	U2_ROM : rom
		port map(
		  clk => clk,
			addra => ir_addr,
			addrb => address_b,
			qa => inst_data,
			qb => rom_dataw
		);
		
	U3_PROC : process(ind_addr(0), rom_dataw)
	begin
		if(ind_addr(0) = '1') then
			rom_data <= rom_dataw(15 downto 8);
		else
			rom_data <= rom_dataw(7 downto 0);
		end if;
	end process;
	
	U4_PROC : process(clk, rst)
	begin
		if(rst = '1') then
			inst_reg <= (others => '0');
		elsif(rising_edge(clk)) then
			if(ir_en = '1') then
				inst_reg <= inst_data;
			end if;
		end if;
	end process;
	opcode <= inst_reg(15 downto 11);
	special <= inst_reg(0);
	reg_dsel <= inst_reg(10 downto 6);
	imd_dsel <= reg_sel(1 downto 0)&inst_reg(10 downto 8);
	rsel <= inst_reg(5 downto 1);
	immediate <= inst_reg(7 downto 0);
	io_reg <= inst_reg(5 downto 0);
	io_imd <= "000"&inst_reg(10 downto 8);
	cc <= inst_reg(4 downto 1);
	
	process(imd_sel, io_reg, io_imd)
	begin
		if(imd_sel = '1') then
			io_addr <= io_imd;
		else
			io_addr <= io_reg;
		end if;
	end process;
	
	U5_PROC: process(imd_sel, reg_dsel, imd_dsel)
	begin
		if(imd_sel = '1') then
			dsel <= imd_dsel;
		else
			dsel <= reg_dsel;
		end if;
	end process;
	
	rsel1 <= std_logic_vector(unsigned(rsel) + to_unsigned(1, 5));
	dsel1 <= std_logic_vector(unsigned(dsel) + to_unsigned(1, 5));
	
	process(rsel, rsel1, dsel, dsel1, movw_sel)
	begin
		if(movw_sel = '1') then
			dselin <= dsel;
			rselin <= rsel;
		else
			dselin <= dsel1;
			rselin <= rsel1;
		end if;
	end process;
	
	U6_REGFILE : regfile
		port map(
			clk => clk,
			rst => rst,
			din => dbus,
			dsel => dselin,
			rsel => rselin,
			wen => reg_en,
			rd => d_op,
			rr => r_op,
			addr => ind_addr
		);
		
	U7_PROC : process(imd_sel, r_op, immediate)
	begin
		if(imd_sel = '1') then
			op2 <= immediate;
		else
			op2 <= r_op;
		end if;
	end process;
	op1 <= d_op;
	
	psw_in(7 downto 4) <= (others => '0');
	psw_en(7 downto 4) <= (others => '0');
	psw_en(3) <= v_en;
	psw_en(2) <= n_en;
	psw_en(1) <= z_en;
	psw_en(0) <= c_en;
	U8_ALU : alu
		port map(
			in1 => op1,
			in2 => op2,
			cin => psw(0),			
			func => func,
			res => res,
			c => psw_in(0),
			z => psw_in(1),
			n => psw_in(2),
			v => psw_in(3)
		);
	
	U9_PROC : process(clk, rst)
	begin
		if(rst = '1') then
			res_reg <= (others => '0');
		elsif(rising_edge(clk)) then
			if(res_en = '1') then
				res_reg <= res;
			end if;
		end if;
	end process;
	
	U10_PSWREG : pswreg
		port map(
			clk => clk,
			rst => rst,
			din => dbus,
			addr => io_addr,
			wen => io_wen,
			psw_in => psw_in,
			psw_en => psw_en,
			psw_out => psw
		);
		
	U11_SPREG : spreg
		port map(
			clk => clk,
			rst => rst,
			din => dbus,
			addr => io_addr,
			wen => io_wen,
			sp_en => sp_en,
			sp_sel => sp_sel,
			sp => sp
		);
		
	U12_REGSEL : regsel
		port map(
			clk => clk,
			rst => rst,
			din => dbus,
			addr => io_addr,
			wen => io_wen,
			reg_sel => reg_sel
		);
		
	U13_IOBUS : iobus
		port map(
			addr => io_addr,
			psw => psw,
			spl => sp(7 downto 0),
			sph => sp(15 downto 8),
			regsel => reg_sel,
			io_data => io_data
		);
		
	U14_RAM : ram	
		port map(
		  clk => clk,
		  we => ram_wen,
			data => dbus,
			addr => ram_addr,
			q => ram_data
		);
		
	U15_DATABUS: databus
		port map(
			bus_sel => bus_sel,
			res => res_reg,
			ram_data => ram_data,
			rom_data => rom_data,
			io_data => io_data,
			rd => d_op,
			rr => r_op,
			pc_data => pc_data,
			imd_data => immediate,
			dout => dbus
		);
		
	U16_PROC : process(raddr_sel, ind_addr, inst_data, sp)
	begin
		case raddr_sel is
			when "00" =>
				ram_addr <= inst_data;
			when "01" =>
				ram_addr <= ind_addr;
			when "10" =>
				ram_addr <= sp;
			when others =>
				ram_addr <= (others => '0');
		end case;
	end process;
	
	U17_PROC : process(psw, cc)
	begin
		case(cc) is
			when "0000" =>		--Always
				condition <= '1';
			when "0001" =>		--Equal
				condition <= psw(1);
			when "0010" =>		--Not equal
				condition <= not psw(1);
			when "0011" =>		--Overflow set
				condition <= psw(3);
			when "0100" =>		--Overflow cleared
				condition <= not psw(3);
			when "0101" =>		--Minus
				condition <= psw(2);
			when "0110" =>		--Plus
				condition <= not psw(2);
			when "0111" =>		--Carry set
				condition <= psw(0);
			when "1000" =>		--Carry cleared
				condition <= not psw(0);
			when "1001" => 	--Less than
				condition <= psw(3) xor psw(2);
			when "1010" =>		--Greter than or equal
				condition <= not(psw(3) xor psw(2));
			when "1011" =>		--Same or higher
				condition <= not psw(0);
			when "1100" =>		--Lower
				condition <= psw(0);
			when others =>
				condition <= '0';
		end case;
	end process;
end struct;
