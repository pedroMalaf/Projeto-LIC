-- Serial Controller (state machine)
-- (check serialcontroller-asm.png for info)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY serial_control IS
	PORT (
		not_SS, accept, pFlag, dFlag, RXerror : IN STD_LOGIC;
		reset, clk : IN STD_LOGIC;
		wr, init, DXval, busy : OUT STD_LOGIC
	);
END serial_control;

ARCHITECTURE arq OF serial_control IS

	-- STATE_AVAILABLE: Available to receive bits
	-- STATE_RECEIVING: Receiving bits
	-- STATE_RECEIVED: Bits received
	-- STATE_END: Bits received and correct (send them to dispatcher)
	TYPE STATE_TYPE IS (STATE_AVAILABLE, STATE_RECEIVING, STATE_RECEIVED, STATE_END);

	SIGNAL CS, NS : STATE_TYPE; -- Current & Next state

BEGIN
	-- Store current state
	CS <= STATE_AVAILABLE WHEN reset = '1' ELSE
		NS WHEN rising_edge(clk);

	-- Generate next state
	generate_next_state : PROCESS (CS, not_SS, dFlag, pFlag, RXerror, accept)
	BEGIN
		CASE CS IS

			WHEN STATE_AVAILABLE =>
				IF (not_SS = '0') THEN
					NS <= STATE_RECEIVING;
				ELSE
					NS <= STATE_AVAILABLE;
				END IF;

			WHEN STATE_RECEIVING =>
				IF (dFlag = '1') THEN
					NS <= STATE_RECEIVED;
				ELSIF (not_SS = '1') THEN
					NS <= STATE_AVAILABLE;
				ELSE
					NS <= STATE_RECEIVING;
				END IF;

			WHEN STATE_RECEIVED =>
				IF (not_SS = '0') THEN
					NS <= STATE_RECEIVED;
				ELSIF (pFlag = '1' AND RXerror = '0') THEN
					NS <= STATE_END;
				ELSE NS <= STATE_AVAILABLE;
				END IF;

			WHEN STATE_END =>
				IF (accept = '1') THEN
					NS <= STATE_AVAILABLE;
				ELSE
					NS <= STATE_END;
				END IF;

		END CASE;
	END PROCESS;

	-- Generate outputs
	busy <= '1' WHEN (CS = STATE_END) ELSE '0';
	wr <= '1' WHEN (CS = STATE_RECEIVING) ELSE '0';
	init <= '1' WHEN (CS = STATE_AVAILABLE) ELSE '0';
	DXval <= '1' WHEN (CS = STATE_END) ELSE '0';

END arq;