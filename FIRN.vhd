LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.all;

ENTITY FIRN IS
		PORT(fclk, rst	: IN STD_LOGIC;
			  data_in	: IN STD_LOGIC_VECTOR(23 downto 0);
			  data_out	: OUT STD_LOGIC_VECTOR(23 downto 0)
			  );
END FIRN;

ARCHITECTURE behavior OF FIRN IS
	
	SIGnal times: integer := 16;
	
	type a_array is array(0 to times) of integer;
	type div_array is array(0 to times) of integer;
	type Q_array is array(0 to times) of std_logic_vector(23 downto 0);
	
	SIGNAL a : a_array := (others => 0);
	SIGNAL div :div_array := (others => 0);
	SIGNAL q : Q_array := (others => (others => '0'));
	
BEGIN

	process(fclk, data_in, rst) begin
		if (rst = '1') then
			a <= (others => 0);
			div <= (others => 0);
		elsif ( rising_edge(fclk) ) then
		
			div(0) <= to_integer(signed(data_in)) / times;
			q(0) <= data_in;
			div(1) <= to_integer(signed(q(0))) / times;
			a(0) <= div(0) + div(1);
			
			for i in 1 to 100 loop
				if (i = times - 1) then
					exit;
				end if;
				q(i) <= q(i - 1);
				div(i + 1) <= to_integer(signed(q(i))) / times;
				a(i) <= a(i - 1) + div(i + 1);
				
			end loop;
			 
			data_out <= std_logic_vector(to_signed(a(times - 2), 24));
		
		end if; 
	end process;

END behavior; 