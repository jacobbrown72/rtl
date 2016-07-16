library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is
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
end controller;

architecture rtl of controller is
	type state_type is (rom_load, ir_load, decode, nop, halt, adc, add, sub, sbc, adi, adci, sbi, sbci, ands, tst, andi, ors, ori, eor, eori, com, neg,
							  lsl, lrl, lsr, lrr, ins, outs, push, pop, mov, movw, ldi, lds, ld, lpm, sts, st, cmp, cpc, cpi, br, call, ret, outi,
							  add1, adc1, sub1, sbc1, adi1, adci1, sbi1, sbci1, ands1, andi1, ors1, ori1, eor1, eori1, com1, neg1, lsl1, lsr1, lrl1, lrr1, pop1, pop2, movw1,
							  lds1, lds2, lds3, ld1, lpm1, sts1, sts2, br1, br2, call1, call2, call3, call4, ret1, ret2, ret3, ret4);
	signal state, nstate : state_type;
begin
	process(clk, rst)
	begin
		if(rst = '1') then
			state <= rom_load;
		elsif(rising_edge(clk)) then
			state <= nstate;
		end if;
	end process;
	
	process(state, opcode, special, condition)
	begin
		--default values
		nstate <= state;
		pc_en <= '0';
		pcl_en <= '0';
		pch_en <= '0';
		ir_en <= '0';
		reg_en <= '0';
		res_en <= '0';
		v_en	<= '0';
		n_en 	<= '0';
		z_en 	<= '0';
		c_en	<= '0';
		io_wen <= '0';
		sp_en	<= '0';
		rom_enable <= '0';
		ram_enable <= '0';
		ram_wen	<= '0';
		pc_sel <= "00"	;
		byte_sel	<= '0';
		imd_sel 	<= '0';	
		func <= "0000";	
		sp_sel <= '0';		
		bus_sel <= "0000";	
		raddr_sel <= "00";
		movw_sel <= '0';
		done <= '0';
		
		case state is
			when rom_load =>
				rom_enable <= '1';
				nstate <= ir_load;
				
			when ir_load =>
				ir_en <= '1';
				nstate <= decode;
				
			when decode =>
				case opcode is
					when "00000" =>
						if(special = '1') then
							nstate <= halt;
						else
							nstate <= nop;
						end if;
					
					when "00001" =>
						if(special = '1') then
							nstate <= adc;
						else
							nstate <= add;
						end if;
					
					when "00010" =>
						if(special = '1') then
							nstate <= sbc;
						else
							nstate <= sub;
						end if;
					
					when "00011" =>
						nstate <= adi;
					
					when "00100" =>
						nstate <= adci;
						
					when "00101" =>
						nstate <= sbi;
					
					when "00110" =>
						nstate <= sbci;
					
					when "00111" =>
						if(special = '1') then
							nstate <= tst;
						else
							nstate <= ands;
						end if;
					
					when "01000" =>
						nstate <= andi;
					
					when "01001" =>
						if(special = '1') then
							nstate <= rom_load;
						else
							nstate <= ors;
						end if;
					
					when "01010" =>
						nstate <= ori;
					
					when "01011" =>
						if(special = '1') then
							nstate <= rom_load;
						else
							nstate <= eor;
						end if;
					
					when "01100" =>
						nstate <= eori;
					
					when "01101" =>
						if(special = '1') then
							nstate <= neg;
						else
							nstate <= com;
						end if;
						
					when "01110" =>
						if(special = '1') then
							nstate <= lrl;
						else 
							nstate <= lsl;
						end if;
						
					when "01111" =>
						if(special = '1') then
							nstate <= lrr;
						else
							nstate <= lsr;
						end if;
					
					when "10000" =>
						nstate <= ins;
						
					when "10001" =>
						nstate <= outs;
						
					when "10010" =>
						if(special = '1') then
							nstate <= pop;
						else
							nstate <= push;
						end if;
						
					when "10011" =>
						if(special = '1') then
							nstate <= movw;
						else
							nstate <= mov;
						end if;
						
					when "10100" =>
						nstate <= ldi;
						
					when "10101" =>
						if(special = '1') then
							nstate <= rom_load;
						else
							nstate <= lds;
						end if;
						
					when "10110" =>
						if(special = '1') then
							nstate <= lpm;
						else
							nstate <= ld;
						end if;
						
					when "10111" =>
						if(special = '1') then
							nstate <= rom_load;
						else
							nstate <= sts;
						end if;
						
					when "11000" =>
						if(special = '1') then
							nstate <= rom_load;
						else
							nstate <= st;
						end if;
						
					when "11001" =>
						if(special = '1') then
							nstate <= cmp;
						else
							nstate <= cpc;
						end if;
						
					when "11010" =>
						nstate <= cpi;
						
					when "11011" =>
						if(special = '1') then
							nstate <= rom_load;
						else
							nstate <= br;
						end if;
					
					when "11100" =>
						if(special = '1') then
							nstate <= rom_load;
						else
							nstate <= call;
						end if;
						
					when "11101" =>
						if(special = '1') then
							nstate <= rom_load;
						else
							nstate <= ret;
						end if;
						
					when "11110" =>
						nstate <= outi;
					
					when others =>
						nstate <= rom_load;
				end case;
			
			when nop =>
				pc_en <= '1';
				nstate <= rom_load;
			
			when halt =>
				done <= '1';
				nstate <= halt;
			
			when add =>
				func <= "0000";		--select add function for alu
				res_en <= '1';			--enable result register
				c_en <= '1';			--enable carry flag
				n_en <= '1';			--enable negative flag
				v_en <= '1';			--enable overflow flag
				z_en <= '1';			--enable zero flag
				nstate <= add1;		--proceed to next state
				
			when add1 =>
				bus_sel <= "0000";	--select result to drive bus
				reg_en <= '1';			--Write back result to register file
				pc_en <= '1';			--increment program counter
				nstate <= rom_load;	--Go back to get new instruction
			
			when adc =>
				func <= "0001"; 		--Select add w/ carry function 
				res_en <= '1';			--enable result register
				c_en <= '1';
				n_en <= '1';
				v_en <= '1';
				z_en <= '1';
				nstate <= adc1;
				
			when adc1 =>
				bus_sel <= "0000";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when sub =>
				func <= "0010";
				res_en <= '1';
				c_en <= '1';
				n_en <= '1';
				v_en <= '1';
				z_en <= '1';
				nstate <= sub1;
				
			when sub1 =>
				bus_sel <= "0000";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when sbc =>
				func <= "0011";
				res_en <= '1';
				c_en <= '1';
				n_en <= '1';
				v_en <= '1';
				z_en <= '1';
				nstate <= sbc1;
				
			when sbc1 =>
				bus_sel <= "0000";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when adi =>
				func <= "0000";
				imd_sel <= '1';
				res_en <= '1';
				c_en <= '1';
				n_en <= '1';
				v_en <= '1';
				z_en <= '1';
				nstate <= adi1;
			
			when adi1 =>
				bus_sel <= "0000";
				imd_sel <= '1';
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when adci =>
				func <= "0001";
				imd_sel <= '1';
				res_en <= '1';
				c_en <= '1';
				n_en <= '1';
				v_en <= '1';
				z_en <= '1';
				nstate <= adci1;
				
			when adci1 =>
				bus_sel <= "0000";
				imd_sel <= '1';
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when sbi =>
				func <= "0010";
				imd_sel <= '1';
				res_en <= '1';
				c_en <= '1';
				n_en <= '1';
				v_en <= '1';
				z_en <= '1';
				nstate <= sbi1;
				
			when sbi1 =>
				bus_sel <= "0000";
				imd_sel <= '1';
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when sbci =>
				func <= "0011";
				imd_sel <= '1';
				res_en <= '1';
				c_en <= '1';
				n_en <= '1';
				v_en <= '1';
				z_en <= '1';
				nstate <= sbci1;
				
			when sbci1 =>
				bus_sel <= "0000";
				imd_sel <= '1';
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when ands =>
				func <= "0100";
				res_en <= '1';
				z_en <= '1';
				n_en <= '1';
				nstate <= ands1;
				
			when ands1 =>
				bus_sel <= "0000";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when tst =>
				func <= "0100";
				z_en <= '1';
				n_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when andi =>
				func <= "0100";
				imd_sel <= '1';
				res_en <= '1';
				z_en <= '1';
				n_en <= '1';
				nstate <= andi1;
				
			when andi1 =>
				bus_sel <= "0000";
				imd_sel <= '1';
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when ors =>
				func <= "0101";
				res_en <= '1';
				z_en <= '1';
				n_en <= '1';
				nstate <= ors1;
				
			when ors1 =>
				bus_sel <= "0000";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when ori =>
				func <= "0101";
				imd_sel <= '1';
				res_en <= '1';
				z_en <= '1';
				n_en <= '1';
				nstate <= ori1;
				
			when ori1 =>
				bus_sel <= "0000";
				imd_sel <= '1';
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when eor =>
				func <= "0110";
				res_en <= '1';
				z_en <= '1';
				n_en <= '1';
				nstate <= eor1;
				
			when eor1 =>
				bus_sel <= "0000";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when eori =>
				func <= "0110";
				imd_sel <= '1';
				res_en <= '1';
				z_en <= '1';
				n_en <= '1';
				nstate <= eori1;
				
			when eori1 =>
				bus_sel <= "0000";
				imd_sel <= '1';
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when com =>
				func <= "0111";
				res_en <= '1';
				z_en <= '1';
				v_en <= '1';
				c_en <= '1';
				n_en <= '1';
				nstate <= com1;
				
			when com1 =>
				bus_sel <= "0000";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when neg =>
				func <= "1000";
				res_en <= '1';
				z_en <= '1';
				v_en <= '1';
				c_en <= '1';
				n_en <= '1';
				nstate <= neg1;
				
			when neg1 =>
				bus_sel <= "0000";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when lsl =>
				func <= "1001";
				res_en <= '1';
				z_en <= '1';
				v_en <= '1';
				c_en <= '1';
				n_en <= '1';
				nstate <= lsl1;
				
			when lsl1 =>
				bus_sel <= "0000";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when lrl =>
				func <= "1011";
				res_en <= '1';
				z_en <= '1';
				v_en <= '1';
				c_en <= '1';
				n_en <= '1';
				nstate <= lrl1;
				
			when lrl1 =>
				bus_sel <= "0000";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when lsr =>
				func <= "1010";
				res_en <= '1';
				z_en <= '1';
				v_en <= '1';
				c_en <= '1';
				n_en <= '1';
				nstate <= lsr1;
				
			when lsr1 =>
				bus_sel <= "0000";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when lrr =>
				func <= "1100";
				res_en <= '1';
				z_en <= '1';
				v_en <= '1';
				c_en <= '1';
				n_en <= '1';
				nstate <= lrr1;
				
			when lrr1 =>
				bus_sel <= "0000";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when ins =>
				bus_sel <= "0011";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when outs =>
				bus_sel <= "0100";
				io_wen <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when push =>
				raddr_sel <= "10";
				bus_sel <= "0100";
				ram_wen <= '1';
				ram_enable <= '1';
				sp_sel <= '1';
				sp_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when pop =>
				sp_sel <= '0';
				sp_en <= '1';
				nstate <= pop1;
				
			when pop1 =>
				raddr_sel <= "10";
				ram_wen <= '0';
				ram_enable <= '1';
				nstate <= pop2;
				
			when pop2 =>
				bus_sel <= "0001";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when mov =>
				bus_sel <= "0101";
				reg_en <= '1'; 
				pc_en <= '1';
				nstate <= rom_load;
			
			when movw =>
				bus_sel <= "0101";
				reg_en <= '1';
				nstate <= movw1;
				
			when movw1 =>
				movw_sel <= '1';
				bus_sel <= "0101";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when ldi =>
				bus_sel <= "0111";
				imd_sel <= '1';
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when lds =>
				pc_en <= '1';
				nstate <= lds1;
				
			when lds1 =>
				rom_enable <= '1';
				nstate <= lds2;
				
			when lds2 =>
				raddr_sel <= "00";
				ram_wen <= '0';
				ram_enable <= '1';
				nstate <= lds3;
				
			when lds3 =>
				bus_sel <= "0001";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when ld =>
				raddr_sel <= "01";
				ram_wen <= '0';
				ram_enable <= '1';
				nstate <= ld1;
				
			when ld1 =>
				bus_sel <= "0001";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when lpm =>
				rom_enable <= '1';
				nstate <= lpm1;
				
			when lpm1 =>
				bus_sel <= "0010";
				reg_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when sts =>
				pc_en <= '1';
				nstate <= sts1;
				
			when sts1 =>
				rom_enable <= '1';
				nstate <= sts2;
				
			when sts2 =>
				raddr_sel <= "00";
				ram_wen <= '1';
				bus_sel <= "0100";
				ram_enable <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when st =>
				raddr_sel <= "01";
				ram_wen <= '1';
				bus_sel <= "0100";
				ram_enable <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when cmp =>
				func <= "0010";
				c_en <= '1';
				n_en <= '1';
				v_en <= '1';
				z_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when cpc =>
				func <= "0011";
				c_en <= '1';
				n_en <= '1';
				v_en <= '1';
				z_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when cpi =>
				func <= "0011";
				imd_sel <= '1';
				c_en <= '1';
				n_en <= '1';
				v_en <= '1';
				z_en <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when br =>
				if(condition = '1') then
					pc_en <= '1';
					nstate <= br1;
				else
					pc_sel <= "01";
					pc_en <= '1';
					nstate <= rom_load;
				end if;
				
			when br1 =>
				rom_enable <= '1';
				nstate <= br2;
			
			when br2 =>
				pc_sel <= "10";
				pc_en <= '1';
				nstate <= rom_load;
			
			when call =>
				pc_en <= '1';
				nstate <= call1;
				
			when call1 =>
				rom_enable <= '1';
				pc_en <= '1';
				nstate <= call2;
			
			when call2 =>
				byte_sel <= '0';
				raddr_sel <= "10";
				bus_sel <= "0110";
				ram_wen <= '1';
				ram_enable <= '1';
				sp_sel <= '1';
				sp_en <= '1';
				nstate <= call3;
				
			when call3 =>
				byte_sel <= '1';
				bus_sel <= "0110";
				raddr_sel <= "10";
				ram_wen <= '1';
				ram_enable <= '1';
				sp_sel <= '1';
				sp_en <= '1';
				nstate <= call4;
				
			when call4 =>
				pc_sel <= "10";
				pc_en <= '1';
				nstate <= rom_load;
			
			when ret =>
				sp_sel <= '0';
				sp_en <= '1';
				nstate <= ret1;
				
			when ret1 =>
				raddr_sel <= "10";
				ram_wen <= '0';
				ram_enable <= '1';
				sp_sel <= '0';
				sp_en <= '1';
				nstate <= ret2;
				
			when ret2 =>
				raddr_sel <= "10";
				ram_wen <= '0';
				ram_enable <= '1';
				bus_sel <= "0001";
				pch_en <= '1';
				nstate <= ret3;
				
			when ret3 =>
				bus_sel <= "0001";
				pcl_en <= '1';
				nstate <= ret4;
				
			when ret4 =>
				pc_sel <= "11";
				pc_en <= '1';
				nstate <= rom_load;
				
			when outi =>
				bus_sel <= "0111";
				imd_sel <= '1';
				io_wen <= '1';
				pc_en <= '1';
				nstate <= rom_load;
			
			when others =>
				nstate <= rom_load;
		end case;
	end process;
end rtl;