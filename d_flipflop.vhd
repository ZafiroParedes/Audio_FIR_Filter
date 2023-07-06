LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

ENTITY d_flipflop IS
		PORT(clk		: IN STD_LOGIC;
			  din		: IN STD_LOGIC_VECTOR(23 downto 0);
			  qout	: OUT STD_LOGIC_VECTOR(23 downto 0)
			  );
END d_flipflop;

architecture behavior of d_flipflop is

signal qt : STD_LOGIC_VECTOR(23 downto 0) := (others => '0');

begin

qout <= qt;

process(clk, din)
begin

  if ( rising_edge(clk) ) then
    qt <= din;
  end if; 
  
end process;

end behavior;