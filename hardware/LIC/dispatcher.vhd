-- Dispatcher

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dispatcher IS
	PORT (
		reset, clk : IN STD_LOGIC;
		Fsh : IN STD_LOGIC;
		Dval : IN STD_LOGIC;
		Din : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		WrT : OUT STD_LOGIC;
		Dout : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		WrL : OUT STD_LOGIC;
		done : OUT STD_LOGIC
	);
END dispatcher;

ARCHITECTURE arq OF dispatcher IS

	-- STATE_AVAILABLE: Available to receive bits
	-- STATE_SENDING_TICKET: Sending bits to ticket dispenser
	-- STATE_SENDING_LCD: Sending bits to LCD
	-- STATE_END: Ticket is issued 

	COMPONENT CLKDIV
		GENERIC (div : NATURAL := 30); -- FIXME: Change value when testing on board (25 - 50)
		PORT (
			clk_in : IN STD_LOGIC;
			clk_out : OUT STD_LOGIC
		);
	END COMPONENT;
	TYPE STATE_TYPE IS (STATE_AVAILABLE, STATE_SENDING_TICKET, STATE_SENDING_LCD, STATE_END);

	SIGNAL CS, NS : STATE_TYPE; -- Current & Next State 
	SIGNAL din_s : STD_LOGIC_VECTOR(8 DOWNTO 0); -- Remove indicator bit (LCD ou TD)
	SIGNAL s_clk : STD_LOGIC;

BEGIN

	u_CLKDIV : CLKDIV PORT MAP(
		clk_in => clk,
		clk_out => s_clk
	);

	-- Store current state 
	CS <= STATE_AVAILABLE WHEN reset = '1' ELSE
		NS WHEN rising_edge(s_clk);

	-- Generate next state
	generate_next_state : PROCESS (CS, Dval, Din, Fsh)
	BEGIN
		CASE CS IS

			WHEN STATE_AVAILABLE =>
				IF (Dval = '0') THEN
					NS <= STATE_AVAILABLE;
				ELSIF (Dval = '1' AND Din(9) = '1') THEN
					NS <= STATE_SENDING_TICKET;
				ELSIF (Dval = '1' AND Din(9) = '0') THEN
					NS <= STATE_SENDING_LCD;
				END IF;

			WHEN STATE_SENDING_TICKET =>
				IF (Fsh = '0') THEN
					NS <= STATE_SENDING_TICKET;
				ELSIF (Fsh = '1') THEN
					NS <= STATE_END;
				END IF;

			WHEN STATE_SENDING_LCD => NS <= STATE_END;

			WHEN STATE_END => NS <= STATE_AVAILABLE;

		END CASE;
	END PROCESS;

	din_s(0) <= Din(0);
	din_s(1) <= Din(1);
	din_s(2) <= Din(2);
	din_s(3) <= Din(3);
	din_s(4) <= Din(4);
	din_s(5) <= Din(5);
	din_s(6) <= Din(6);
	din_s(7) <= Din(7);
	din_s(8) <= Din(8);

	-- Generate outputs
	WrT <= '1' WHEN (CS = STATE_SENDING_TICKET) ELSE '0';
	WrL <= '1' WHEN (CS = STATE_SENDING_LCD) ELSE '0';
	Dout <= din_s;
	DONE <= '1' WHEN (CS = STATE_END) ELSE '0';

END arq;