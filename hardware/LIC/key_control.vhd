-- key control 

LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;

ENTITY key_control IS
	PORT (
		clk : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		Kack : IN STD_LOGIC;
		Kpress : IN STD_LOGIC;
		Kval : OUT STD_LOGIC;
		Kscan : OUT STD_LOGIC
	);
END key_control;

ARCHITECTURE arq OF key_control IS

	--STATE_SCANNING: scanning waiting for input
	--STATE_SENDING: sending input to key transmitter
	
	TYPE STATE_TYPE IS (STATE_SCANNING, STATE_SENDING);
	
	SIGNAL CS, NS : STATE_TYPE; -- Current & Next state
BEGIN
	--store current state
	CS <= STATE_SCANNING when reset = '1' ELSE
		NS WHEN rising_edge(clk);
	
	--generate next state 
	generate_next_state : PROCESS (Kack, Kpress)
	
	BEGIN 	
	CASE CS IS 
	
	WHEN STATE_SCANNING =>
		IF (Kpress = '0') THEN
			NS <= STATE_SCANNING;
		ELSE 
			NS <= STATE_SENDING;
		END IF;
		
	WHEN STATE_SENDING => 
		IF (Kack = '0') THEN
			NS <= STATE_SENDING;
		ELSIF (kack = '1' AND Kpress = '0') THEN 
			NS <= STATE_SCANNING;
		ELSE 
			NS <= STATE_SENDING;
		END IF;
		
		END CASE;
	END PROCESS;
	
	-- Generate outputs
	Kscan <= '1' WHEN (CS = STATE_SCANNING AND Kpress = '0') ELSE '0'; 
	Kval <= '1' WHEN (CS = STATE_SENDING) ELSE '0';

end arq;