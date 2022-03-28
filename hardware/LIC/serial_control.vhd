-- Serial Controller (state machine)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY serial_control IS
	PORT (
		not_SS, accept, pFlag, dFlag, RXerror: IN STD_LOGIC;
		reset, clk: IN STD_LOGIC;
		wr, init, DXval, busy: OUT STD_LOGIC
	);
END serial_control;

ARCHITECTURE arq OF serial_control IS

-- STATE_AVAILABLE: Available to receive bits
-- STATE_RECEIVING: Receiving bits
-- STATE_RECEIVED: Bits received
-- STATE_END: Bits received and correct (send them to dispatcher)
type STATE_TYPE is (STATE_AVAILABLE, STATE_RECEIVING, STATE_RECEIVED, STATE_END);

signal CS, NS: STATE_TYPE; -- Current & Next state

BEGIN

-- Store current state 
CS <= STATE_AVAILABLE when reset = '1' else NS when rising_edge(clk);

-- Generate next state
generate_next_state: process (CS, not_SS, dFlag, pFlag, RXerror, accept)
	begin
		case CS is
		
			when STATE_AVAILABLE => if (not_SS = '0') then 
												NS <= STATE_RECEIVING; 
											else 
												NS <= STATE_AVAILABLE; 
											end if;
												
			when STATE_RECEIVED =>  if (dFlag = '1') then 
												NS <= STATE_RECEIVED; 
											else 
												NS <= STATE_RECEIVING;
											END IF;
			
			when STATE_RECEIVED =>  if (pFlag = '0') then
												NS <= STATE_RECEIVED;
											elsif (pFlag = '1' and RXerror = '0') then
												NS <= STATE_AVAILABLE;
											else
												NS <= STATE_END; -- pFlag = '1' and RXerror = '1'
											end if;
											
			--when STATE_END => 		-- TODO accept
		end case;
	end process;

-- Generate outputs
busy <= '1' when (CS = STATE_END) else '0';
wr <= '0' when (CS = STATE_AVAILABLE) else '1';
init <= '0' when (CS = STATE_AVAILABLE) else '1';
DXval <= '1' when (CS = STATE_END) else '0';
 
END arq;