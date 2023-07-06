LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

ENTITY noise_generator IS
	PORT(CLOCK_50, read_s 	:IN STD_LOGIC;
		  noise					:OUT STD_LOGIC_VECTOR(23 downto 0));
END noise_generator;

ARCHITECTURE behavior OF noise_generator IS 

	SIGNAL counter	:STD_LOGIC_VECTOR(13 downto 0); --2
	SIGNAL Q			:STD_LOGIC_VECTOR(9 downto 0);
	
BEGIN

	PROCESS(CLOCK_50)
	BEGIN
		IF(CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
			IF(read_s = '1') THEN
				counter <= counter + 1;
			END IF;
		END IF;
	END PROCESS;
	Q <= (OTHERS => counter(2));
	noise <= Q&counter; --"00000000000";
END behavior;