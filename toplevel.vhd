LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

ENTITY toplevel IS
   PORT ( CLOCK_50, CLOCK2_50, AUD_DACLRCK   	: IN    	STD_LOGIC;
          AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT  	: IN    	STD_LOGIC;
          KEY                                	: IN    	STD_LOGIC_VECTOR(0 DOWNTO 0);
			 SWITCH1, SWITCH2								: IN 		STD_LOGIC;
          I2C_SDAT                      			: INOUT 	STD_LOGIC;
			 AUD_XCK											: OUT  	STD_LOGIC;
			 I2C_SCLK                      			: OUT 	STD_LOGIC;
			 AUD_DACDAT, LED1								: OUT 	STD_LOGIC
          --finish the rest of the ports			);
			 );
END toplevel;

ARCHITECTURE Behavior OF toplevel IS
   COMPONENT clock_generator --this component is completed for you
      PORT( CLOCK_27 : IN STD_LOGIC;
            reset    : IN STD_LOGIC;
            AUD_XCK  : OUT STD_LOGIC);
   END COMPONENT;

   COMPONENT audio_and_video_config --finish this component
      PORT(CLOCK_50	: IN STD_LOGIC;
			  reset		: IN STD_LOGIC;
			  I2C_SCLK	: OUT STD_LOGIC;
			  I2C_SDAT	: INOUT STD_LOGIC);
   END COMPONENT;   

   COMPONENT audio_codec --complete this component
		PORT(CLOCK_50, AUD_BCLK, AUD_ADCLRCK, AUD_DACLRCK, AUD_ADCDAT, read_s, write_s	: IN STD_LOGIC;
			  writedata_left, writedata_right															: IN STD_LOGIC_VECTOR(23 DOWNTO 0);
			  AUD_DACDAT, read_ready, write_ready														: OUT STD_LOGIC;
			  readdata_left, readdata_right																: OUT STD_LOGIC_VECTOR(23 DOWNTO 0));
   END COMPONENT;
	
	COMPONENT your_circuit
		PORT(read_ready, write_ready, yclk, rst, SWITCH2	: IN STD_LOGIC;
			  readdata_right, readdata_left						: IN STD_LOGIC_VECTOR(23 downto 0);
			  read_s, write_s											: OUT STD_LOGIC;
			  writedata_right, writedata_left					: OUT STD_LOGIC_VECTOR(23 downto 0));
	END COMPONENT;
	
	COMPONENT noise_generator 
		PORT(CLOCK_50, read_s 	:IN STD_LOGIC;
			  noise					:OUT STD_LOGIC_VECTOR(23 downto 0));
	END COMPONENT;

   SIGNAL read_ready, write_ready, read_s, write_s 	: STD_LOGIC;
   SIGNAL readdata_left, readdata_right            	: STD_LOGIC_VECTOR(23 DOWNTO 0);
   SIGNAL writedata_left, writedata_right         		: STD_LOGIC_VECTOR(23 DOWNTO 0);   
   SIGNAL reset                                   		: STD_LOGIC;
	SIGNAL noise													: STD_LOGIC_VECTOR(23 DOWNTO 0);
	SIGNAL read_sig, write_sig									: STD_LOGIC;
	SIGNAL data_left, data_right								: STD_LOGIC_VECTOR(23 DOWNTO 0);
 
BEGIN
	reset <= NOT(KEY(0));

   	--YOUR "glue" CODE GOES HERE
   	--connect the wires between the components in the correct direction
   
  	my_clock_gen: clock_generator PORT MAP (CLOCK2_50, reset, AUD_XCK);
	my_audio_and_video_config: audio_and_video_config PORT MAP (CLOCK_50, reset, I2C_SCLK, I2C_SDAT);
	my_audio_codec: audio_codec PORT MAP (CLOCK_50, AUD_BCLK, AUD_ADCLRCK, AUD_DACLRCK, AUD_ADCDAT,
													  read_s, write_s, writedata_left, writedata_right, AUD_DACDAT,
													  read_ready, write_ready, readdata_left, readdata_right);
													  
													  
													  
	noise_maker: noise_generator PORT MAP(CLOCK_50, read_s, noise);
	my_your_circuit: your_circuit PORT MAP(read_ready, write_ready, CLOCK_50, reset, SWITCH2, readdata_right + noise, readdata_left + noise,
														read_sig, write_sig, data_right, data_left);
														
	process(SWITCH1, reset) begin
		if (SWITCH1 = '0' and reset = '0') then
			LED1 <= '0';
			read_s <= read_sig;
			write_s <= write_sig;
			writedata_left <= data_left;
			writedata_right <= data_right;										  	
		elsif (SWITCH1 = '1' and reset = '0') then
			LED1 <= '1';
			read_s <= read_ready;
			write_s <= write_ready;
			writedata_left <= readdata_left + noise;
			writedata_right <= readdata_right + noise;
		end if;
	
	end process;
	
  
END Behavior;