library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
  port(
    clk     : in  std_logic;
    we      : in  std_logic;
    data    : in  std_logic_vector(7 downto 0);
    addr    : in  std_logic_vector(15 downto 0);
    q       : out std_logic_Vector(7 downto 0)
  );
end ram;

architecture rtl of ram is
  type ram_type is array(0 to 65536) of std_logic_vector(7 downto 0);
  signal ram : ram_type;
  signal raddr : std_logic_vector(15 downto 0);
begin
  process(clk)
  begin
    if(rising_edge(clk)) then
      if(we = '1') then
        ram(to_integer(unsigned(addr))) <= data;
      end if;
      raddr <= addr;
    end if;
  end process;
  q <= ram(to_integer(unsigned(raddr)));
end rtl;
