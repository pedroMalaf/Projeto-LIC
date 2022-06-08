-- key transmitter control 

LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;

ENTITY key_transmitter_control IS
    PORT (
		clk: IN STD_LOGIC;
		DAV: IN STD_LOGIC; -- (from K_val - "Key Decode")
		D: IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- (from K - "Key Decode")
		TX_clk: IN STD_LOGIC; -- (from RX_clk - "Control")
		
		DAC: OUT STD_LOGIC; -- data accepted (to K_ack - "Key Decode")
		TX_D: OUT STD_LOGIC -- (to RX_D - "Control")
    );
END key_transmitter_control;

ARCHITECTURE arq OF key_transmitter_control IS

	TYPE STATE_TYPE IS (STATE_AVAILABLE, STATE_SENDING_TICKET, STATE_SENDING_LCD, STATE_END);
	
	SIGNAL CS, NS : STATE_TYPE; -- Current & Next State 
		
BEGIN
	
	-- TODO: state machine
	
END arq;