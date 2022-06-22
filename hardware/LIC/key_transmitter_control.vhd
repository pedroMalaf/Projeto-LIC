-- key transmitter control 

LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;

ENTITY key_transmitter_control IS
    PORT (
		DAV : IN STD_LOGIC;
		Tcount : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		DAC : OUT STD_LOGIC;
		Ereg : OUT STD_LOGIC;
		Ecounter : OUT STD_LOGIC;
		Rcounter : OUT STD_LOGIC
    );
END key_transmitter_control;

ARCHITECTURE arq OF key_transmitter_control IS

	-- STATE_WAITING_DATA : Waiting for key to be pressed
	-- STATE_DATA_RECEIVED : Data saved in register
	-- STATE_SEND_DATA : Data sent to software

	TYPE STATE_TYPE IS (STATE_WAITING_DATA, STATE_DATA_RECEIVED, STATE_SEND_DATA);
	
	SIGNAL CS, NS : STATE_TYPE; -- Current & Next State 
		
BEGIN
	--store current state
	CS <= STATE_WAITING_DATA when reset = '1' ELSE
		NS WHEN rising_edge(clk);
	
	--generate next state 
	generate_next_state : PROCESS (DAV, Tcount)
	
	BEGIN 	
	CASE CS IS 
	
	WHEN STATE_WAITING_DATA =>
		IF (DAV = '0') THEN
			NS <= STATE_WAITING_DATA;
		ELSE
			NS <= STATE_DATA_RECEIVED;
		END IF;
	
	WHEN STATE_DATA_RECEIVED => 
		IF (DAV = '1') THEN
			NS <= STATE_DATA_RECEIVED;
		ELSE 
			NS <= STATE_SEND_DATA;
		END IF;
			
	WHEN STATE_SEND_DATA => 
		IF (Tcount = '0') THEN
			NS <= STATE_SEND_DATA;
		ELSE 
			NS <= STATE_WAITING_DATA;
		END IF;
		
		END CASE;
	END PROCESS;
	
	-- Generate outputs
	
	Rcounter <= '0' WHEN (CS = STATE_SEND_DATA) ELSE '1';
	DAC <= '1' WHEN (CS = STATE_DATA_RECEIVED) ELSE '0';
	Ereg <= '1' WHEN (CS = STATE_DATA_RECEIVED) ELSE '0';
	Ecounter <= '1' WHEN (CS = STATE_SEND_DATA) ELSE '0';
	
END arq;