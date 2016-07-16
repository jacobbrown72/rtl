library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
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
end alu;

architecture rtl of alu is
	signal add, adc, sub, sbc, land, lor, eor, com, neg, lsl, lsr, lrl, lrr : std_logic_vector(7 downto 0);
	signal res_s : std_logic_vector(7 downto 0);
	signal ff, zero : std_logic_vector(7 downto 0);
	signal lslc, lsrc, lrlc, lrrc : std_logic;
begin
	ff <= "11111111";
	zero <= "00000000";

	add <= std_logic_vector(unsigned(in1) + unsigned(in2));
	sub <= std_logic_vector(unsigned(in1) - unsigned(in2));
	
	process(cin, in1, in2)
	begin
		if(cin = '1') then
			adc <= std_logic_vector(unsigned(in1) + unsigned(in2) + to_unsigned(1, 8));
			sbc <= std_logic_vector(unsigned(in1) - unsigned(in2) - to_unsigned(1, 8));
		else
			adc <= std_logic_vector(unsigned(in1) + unsigned(in2));
			sbc <= std_logic_vector(unsigned(in1) - unsigned(in2));
		end if;
	end process;
	
	land <= in1 and in2;
	lor  <= in1 or in2;
	eor  <= in1 xor in2;
	
	com <= std_logic_vector(unsigned(ff) - unsigned(in1));
	neg <= std_logic_vector(unsigned(zero) - unsigned(in1));
	
	lslc   <= in1(7);
	lsl(7) <= in1(6);
	lsl(6) <= in1(5);
	lsl(5) <= in1(4);
	lsl(4) <= in1(3);
	lsl(3) <= in1(2);
	lsl(2) <= in1(1);
	lsl(1) <= in1(0);
	lsl(0) <= '0';
	
	lsr(7) <= '0';
	lsr(6) <= in1(7);
	lsr(5) <= in1(6);
	lsr(4) <= in1(5);
	lsr(3) <= in1(4);
	lsr(2) <= in1(3);
	lsr(1) <= in1(2);
	lsr(0) <= in1(1);
	lsrc   <= in1(0);
	
	lrlc   <= in1(7);
	lrl(7) <= in1(6);
	lrl(6) <= in1(5);
	lrl(5) <= in1(4);
	lrl(4) <= in1(3);
	lrl(3) <= in1(2);
	lrl(2) <= in1(1);
	lrl(1) <= in1(0);
	lrl(0) <= cin;
	
	lrr(7) <= cin;
	lrr(6) <= in1(7);
	lrr(5) <= in1(6);
	lrr(4) <= in1(5);
	lrr(3) <= in1(4);
	lrr(2) <= in1(3);
	lrr(1) <= in1(2);
	lrr(0) <= in1(1);
	lrrc   <= in1(0);
	
	process(func, add, adc, sub, sbc, land, lor, eor, com, neg, lsl, lsr, lrl, lrr, in1, in2, lslc, lsrc, lrlc, lrrc)
	begin
		case func is
			when "0000" =>
				res_s <= add;
				c <= (in1(7) and in2(7)) or (in2(7) and (not add(7))) or (in1(7) and (not add(7)));
				v <= (in1(7) and in2(7) and (not add(7))) or ((not in1(7)) and (not in2(7)) and add(7));
			when "0001" =>
				res_s <= adc;
				c <= (in1(7) and in2(7)) or (in2(7) and (not adc(7))) or (in1(7) and (not adc(7)));
				v <= (in1(7) and in2(7) and (not adc(7))) or ((not in1(7)) and (not in2(7)) and adc(7));
			when "0010" =>
				res_s <= sub;
				c <= ((not in1(7)) and in2(7)) or (in2(7) and sub(7)) or (sub(7) and (not in1(7)));
				v <= (in1(7) and (not in2(7)) and (not sub(7))) or ((not in1(7)) and in2(7) and sub(7));
			when "0011" =>
				res_s <= sbc;
				c <= ((not in1(7)) and in2(7)) or (in2(7) and sbc(7)) or (sbc(7) and (not in1(7)));
				v <= (in1(7) and (not in2(7)) and (not sbc(7))) or ((not in1(7)) and in2(7) and sbc(7));
			when "0100" =>
				res_s <= land;
				c <= '0';
				v <= '0';
			when "0101" =>
				res_s <= lor;
				c <= '0';
				v <= '0';
			when "0110" =>
				res_s <= eor;
				c <= '0';
				v <= '0';
			when "0111" =>
				res_s <= com;
				c <= '1';
				v <= '0';
			when "1000" =>
				res_s <= neg;
				c <= neg(7) or neg(6) or neg(5) or neg(4) or neg(3) or neg(2) or neg(1) or neg(0);
				v <= neg(7) and (not neg(6)) and (not neg(5)) and (not neg(4)) and (not neg(3)) and (not neg(1)) and (not neg(0));
			when "1001" =>
				res_s <= lsl;
				c <= lslc;
				v <= lsl(7) xor lslc;
			when "1010" =>	
				res_s <= lsr;
				c <= lsrc;
				v <= lsrc;
			when "1011" =>
				res_s <= lrl;
				c <= lrlc;
				v <= lrl(7) xor lrlc;
			when "1100" =>
				res_s <= lrr;
				c <= lrrc;
				v <= lrr(7) xor lrrc;
			when others =>
				res_s <= (others => '0');
				c <= '0';
				v <= '0';
		end case;	
	end process;
	z <= (not res_s(7)) and (not res_s(6)) and (not res_s(5)) and (not res_s(4)) and (not res_s(3)) and (not res_s(2)) and (not res_s(1)) and (not res_s(0));
	n <= res_s(7);
	res <= res_s;
end rtl;