LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.all;

ENTITY FIR IS
		PORT(fclk, rst	: IN STD_LOGIC;
			  data_in	: IN STD_LOGIC_VECTOR(23 downto 0);
			  data_out	: OUT STD_LOGIC_VECTOR(23 downto 0)
			  );
END FIR;

ARCHITECTURE behavior OF FIR IS

	COMPONENT d_flipflop
			PORT(clk		: IN STD_LOGIC;
				  din		: IN STD_LOGIC_VECTOR(23 downto 0);
				  qout	: OUT STD_LOGIC_VECTOR(23 downto 0));
	END COMPONENT;

	SIGNAL q0, q1, q2, q3, q4, q5, q6 							: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
	SIGNAL div0, div1, div2, div3, div4, div5, div6, div7 : integer; --STD_LOGIC_VECTOR(23 downto 0);
	SIGNAL a0, a1, a2, a3, a4, a5, a6							: integer; --STD_LOGIC_VECTOR(23 downto 0);
	SIGNAL FB0, FB1, FB2, FB3, FB4, FB5, FB6, FB7 			: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');

BEGIN

	dff1: d_flipflop PORT MAP(fclk, data_in, q0);
	dff2: d_flipflop PORT MAP(fclk, q0, q1);
	dff3: d_flipflop PORT MAP(fclk, q1, q2);
	dff4: d_flipflop PORT MAP(fclk, q2, q3);
	dff5: d_flipflop PORT MAP(fclk, q3, q4);
	dff6: d_flipflop PORT MAP(fclk, q4, q5);
	dff7: d_flipflop PORT MAP(fclk, q5, q6);

process(fclk, data_in, rst) begin
		if (rst = '1') then
			div1 <= 0;
			div2 <= 0; div3 <= 0; div4 <= 0; div5 <= 0; div6 <= 0; div7 <= 0;
			a0 <= 0; a1 <= 0; a2 <= 0; a3 <= 0; a4 <= 0; a5 <= 0; a6 <= 0;
		elsif ( rising_edge(fclk) ) then
			div0 <= to_integer(signed(data_in)) / 8;
			 
			div1 <= to_integer(signed(q0)) / 8;
			a0 <= div0 + div1;
			 
			div2 <= to_integer(signed(q1)) / 8;
			a1 <= a0 + div2;

			div3 <= to_integer(signed(q2)) / 8;
			a2 <= a1 + div3;
			 
			div4 <= to_integer(signed(q3)) / 8;
			a3 <= a2 + div4;
			 
			div5 <= to_integer(signed(q4)) / 8;
			a4 <= a3 + div5;
			 
			div6 <= to_integer(signed(q5)) / 8;
			a5 <= a4 + div6;
			 
			div7 <= to_integer(signed(q6)) / 8;
			a6 <= a5 + div7;
			 
			data_out <= std_logic_vector(to_signed(a6, 24));
		
		end if; 
	end process;

END behavior; 