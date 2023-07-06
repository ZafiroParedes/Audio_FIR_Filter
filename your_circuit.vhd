LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.all;

ENTITY your_circuit IS
		PORT(read_ready, write_ready, yclk, rst, SWITCH2	: IN STD_LOGIC;
			  readdata_right, readdata_left						: IN STD_LOGIC_VECTOR(23 downto 0);
			  read_s, write_s											: OUT STD_LOGIC;
			  writedata_right, writedata_left					: OUT STD_LOGIC_VECTOR(23 downto 0)
			  );
END your_circuit;

ARCHITECTURE behavior OF your_circuit IS

	COMPONENT d_flipflop
			PORT(clk		: IN STD_LOGIC;
				  din		: IN STD_LOGIC_VECTOR(23 downto 0);
				  qout	: OUT STD_LOGIC_VECTOR(23 downto 0));
	END COMPONENT;

	COMPONENT FIR
		PORT(fclk, rst	: IN STD_LOGIC;
			  data_in	: IN STD_LOGIC_VECTOR(23 downto 0);
			  data_out	: OUT STD_LOGIC_VECTOR(23 downto 0)
			  );
	END COMPONENT;
	
	COMPONENT FIRN IS
		PORT(fclk, rst	: IN STD_LOGIC;
			  data_in	: IN STD_LOGIC_VECTOR(23 downto 0);
			  data_out	: OUT STD_LOGIC_VECTOR(23 downto 0)
			  );
	END COMPONENT;
	
	signal rightFIRd, rightFIRNd 	: STD_LOGIC_VECTOR(23 downto 0);
	signal leftFIRd, leftFIRNd 	: STD_LOGIC_VECTOR(23 downto 0);
	signal data_right 	: STD_LOGIC_VECTOR(23 downto 0);
	signal data_left 	: STD_LOGIC_VECTOR(23 downto 0);

BEGIN
	
	rightFIR: FIR PORT MAP(yclk, rst, readdata_right, rightFIRd);
	leftFIR: FIR PORT MAP(yclk, rst, readdata_left, leftFIRd);
	
	rightFIRN: FIRN PORT MAP(yclk, rst, readdata_right, rightFIRNd);
	leftFIRN: FIRN PORT MAP(yclk, rst, readdata_left, leftFIRNd);
			
	
	--, readdata_right, readdata_left, data_right, data_left, rightFIRd, leftFIRd
	
	process(write_ready, SWITCH2, rst) begin
	if ((write_ready = '1')) then
		read_s <= '0';
		write_s <= '1';
		if (SWITCH2 = '0' and rst = '0') then --regular filter
			data_right <= rightFIRd;
			data_left <= leftFIRd;									  	
		elsif (SWITCH2 = '1' and rst = '0') then --N sample filter
			data_right <= rightFIRNd;
			data_left <= leftFIRNd;	
		end if;
		
	--end if;
	else	
		write_s <= '0';
		read_s <= '1';
		data_right <= readdata_right;
		data_left <= readdata_left;
	end if;
	end process;
	
	writedata_right <= data_right;
	writedata_left <= data_left;

END behavior; 