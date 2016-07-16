library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity regfile is
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
end regfile;

architecture rtl of regfile is
	signal r0, r1, r2, r3, r4, r5, r6, r7 : std_logic_vector(7 downto 0);
	signal r8, r9, r10, r11, r12, r13, r14, r15 : std_logic_vector(7 downto 0);
	signal r16, r17, r18, r19, r20, r21, r22, r23 : std_logic_vector(7 downto 0);
	signal r24, r25, r26, r27, r28, r29, r30, r31 : std_logic_vector(7 downto 0);
begin
	process(clk, rst)
	begin
		if(rst = '1') then
			r0  <= (others => '0');
			r1  <= (others => '0');
			r2  <= (others => '0');
			r3  <= (others => '0');
			r4  <= (others => '0');
			r5  <= (others => '0');
			r6  <= (others => '0');
			r7  <= (others => '0');
			r8  <= (others => '0');
			r9  <= (others => '0');
			r10 <= (others => '0');
			r11 <= (others => '0');
			r12 <= (others => '0');
			r13 <= (others => '0');
			r14 <= (others => '0');
			r15 <= (others => '0');
			r16 <= (others => '0');
			r17 <= (others => '0');
			r18 <= (others => '0');
			r19 <= (others => '0');
			r20 <= (others => '0');
			r21 <= (others => '0');
			r22 <= (others => '0');
			r23 <= (others => '0');
			r24 <= (others => '0');
			r25 <= (others => '0');
			r26 <= (others => '0');
			r27 <= (others => '0');
			r28 <= (others => '0');
			r29 <= (others => '0');
			r30 <= (others => '0');
			r31 <= (others => '0');
		elsif(rising_edge(clk)) then
			if(wen = '1') then
				case dsel is
					when "00000" =>
						r0 <= din;
					when "00001" =>
						r1 <= din;
					when "00010" =>
						r2 <= din;
					when "00011" =>
						r3 <= din;
					when "00100" =>
						r4 <= din;
					when "00101" =>
						r5 <= din;
					when "00110" =>
						r6 <= din;
					when "00111" =>
						r7 <= din;
					when "01000" =>
						r8 <= din;
					when "01001" =>
						r9 <= din;
					when "01010" =>
						r10 <= din;
					when "01011" =>
						r11 <= din;
					when "01100" =>
						r12 <= din;
					when "01101" =>
						r13 <= din;
					when "01110" =>
						r14 <= din;
					when "01111" =>
						r15 <= din;
					when "10000" =>
						r16 <= din;
					when "10001" =>
						r17 <= din;
					when "10010" =>
						r18 <= din;
					when "10011" =>
						r19 <= din;
					when "10100" =>
						r20 <= din;
					when "10101" =>
						r21 <= din;
					when "10110" =>
						r22 <= din;
					when "10111" =>
						r23 <= din;
					when "11000" =>
						r24 <= din;
					when "11001" =>
						r25 <= din;
					when "11010" =>
						r26 <= din;
					when "11011" =>
						r27 <= din;
					when "11100" =>
						r28 <= din;
					when "11101" =>
						r29 <= din;
					when "11110" =>
						r30 <= din;
					when "11111" =>
						r31 <= din;
					when others =>
						r0 <= din;
				end case;
			end if;
		end if;
	end process;
	
	process(dsel, r0, r1, r2, r3, r4, r5, r6, r7,
			  r8, r9, r10, r11, r12, r13, r14, r15,
			  r16, r17, r18, r19, r20, r21, r22, r23,
			  r24, r25, r26, r27, r28, r29, r30, r31)
	begin
		case dsel is
			when "00000" =>
				rd <= r0;
			when "00001" =>
				rd <= r1;
			when "00010" =>
				rd <= r2;
			when "00011" =>
				rd <= r3;
			when "00100" =>
				rd <= r4;
			when "00101" =>
				rd <= r5;
			when "00110" =>
				rd <= r6;
			when "00111" =>
				rd <= r7;
			when "01000" =>
				rd <= r8;
			when "01001" =>
				rd <= r9;
			when "01010" =>
				rd <= r10;
			when "01011" =>
				rd <= r11;
			when "01100" =>
				rd <= r12;
			when "01101" =>
				rd <= r13;
			when "01110" =>
				rd <= r14;
			when "01111" =>
				rd <= r15;
			when "10000" =>
				rd <= r16;
			when "10001" =>
				rd <= r17;
			when "10010" =>
				rd <= r18;
			when "10011" =>
				rd <= r19;
			when "10100" =>
				rd <= r20;
			when "10101" =>
				rd <= r21;
			when "10110" =>
				rd <= r22;
			when "10111" =>
				rd <= r23;
			when "11000" =>
				rd <= r24;
			when "11001" =>
				rd <= r25;
			when "11010" =>
				rd <= r26;
			when "11011" =>
				rd <= r27;
			when "11100" =>
				rd <= r28;
			when "11101" =>
				rd <= r29;
			when "11110" =>
				rd <= r30;
			when "11111" =>
				rd <= r31;
			when others =>
				rd <= (others => '0');
		end case;
	end process;
	
	process(rsel, r0, r1, r2, r3, r4, r5, r6, r7,
			  r8, r9, r10, r11, r12, r13, r14, r15,
			  r16, r17, r18, r19, r20, r21, r22, r23,
			  r24, r25, r26, r27, r28, r29, r30, r31)
	begin
		case rsel is
			when "00000" =>
				rr <= r0;
			when "00001" =>
				rr <= r1;
			when "00010" =>
				rr <= r2;
			when "00011" =>
				rr <= r3;
			when "00100" =>
				rr <= r4;
			when "00101" =>
				rr <= r5;
			when "00110" =>
				rr <= r6;
			when "00111" =>
				rr <= r7;
			when "01000" =>
				rr <= r8;
			when "01001" =>
				rr <= r9;
			when "01010" =>
				rr <= r10;
			when "01011" =>
				rr <= r11;
			when "01100" =>
				rr <= r12;
			when "01101" =>
				rr <= r13;
			when "01110" =>
				rr <= r14;
			when "01111" =>
				rr <= r15;
			when "10000" =>
				rr <= r16;
			when "10001" =>
				rr <= r17;
			when "10010" =>
				rr <= r18;
			when "10011" =>
				rr <= r19;
			when "10100" =>
				rr <= r20;
			when "10101" =>
				rr <= r21;
			when "10110" =>
				rr <= r22;
			when "10111" =>
				rr <= r23;
			when "11000" =>
				rr <= r24;
			when "11001" =>
				rr <= r25;
			when "11010" =>
				rr <= r26;
			when "11011" =>
				rr <= r27;
			when "11100" =>
				rr <= r28;
			when "11101" =>
				rr <= r29;
			when "11110" =>
				rr <= r30;
			when "11111" =>
				rr <= r31;
			when others =>
				rr <= (others => '0');
		end case;
	end process;
	
	process(rsel, r0, r1, r2, r3, r4, r5, r6, r7,
			  r8, r9, r10, r11, r12, r13, r14, r15,
			  r16, r17, r18, r19, r20, r21, r22, r23,
			  r24, r25, r26, r27, r28, r29, r30, r31)
	begin
		case rsel is
			when "00000" =>
				addr <= r0&r1;
			when "00010" =>
				addr <= r2&r3;
			when "00100" =>
				addr <= r4&r5;
			when "00110" =>
				addr <= r6&r7;
			when "01000" =>
				addr <= r8&r9;
			when "01010" =>
				addr <= r10&r11;
			when "01100" =>
				addr <= r12&r13;
			when "01110" =>
				addr <= r14&r15;
			when "10000" =>
				addr <= r16&r17;
			when "10010" =>
				addr <= r18&r19;
			when "10100" =>
				addr <= r20&r21;
			when "10110" =>
				addr <= r22&r23;
			when "11000" =>
				addr <= r24&r25;
			when "11010" =>
				addr <= r26&r27;
			when "11100" =>
				addr <= r28&r29;
			when "11110" =>
				addr <= r30&r31;
			when others =>
				addr <= (others => '0');
		end case;
	end process;
end rtl;