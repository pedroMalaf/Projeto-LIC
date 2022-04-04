-- Dispatcher

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dispatcher IS
	Port (
		reset, clk: IN STD_LOGIC;
		Fsh: IN STD_LOGIC;
		Dval: IN STD_LOGIC;
		Din: IN STD_LOGIC_VECTOR(9 downto 0);
		WrT: OUT STD_LOGIC;
		Dout: OUT STD_LOGIC_VECTOR(8 downto 0);
		WrL: OUT STD_LOGIC;
		done: OUT STD_LOGIC
	);
END dispatcher;

ARCHITECTURE arq OF dispatcher IS

-- STATE_AVAILABLE: Available to receive bits
-- STATE_SENDING_TICKET: Sending bits to ticket dispenser
-- STATE_SENDING_LCD: Sending bits to LCD
-- STATE_END: Ticket is issued 

type STATE_TYPE is (STATE_AVAILABLE, STATE_SENDING_TICKET, STATE_SENDING_LCD, STATE_END);

signal CS, NS: STATE_TYPE; -- Current & Next State 

BEGIN

-- Store current state 
CS <= STATE_AVAILABLE when reset = '1' else NS when rising_edge(clk);

-- Generate next state
generate_next_state: process (CS, Dval, Din, Fsh)
	begin
		case CS is
		
			when STATE_AVAILABLE => if (Dval = '0') then 
												NS <= STATE_AVAILABLE; 
											elsif (Dval = '1' and Din(9) = '1') then
												NS <= STATE_SENDING_TICKET;  
											elsif (DVAL = '1' and Din(9) = '0') then
												NS <= STATE_SENDING_LCD;
											end if;
			
			when STATE_SENDING_TICKET => NS <= STATE_END;
		
			when STATE_SENDING_LCD => NS <= STATE_END;
			
			when STATE_END => if (Fsh = '0') then 
										NS <= STATE_END;
									else
										NS <= STATE_AVAILABLE;
									end if;
									
			--when STATE_END => 		-- TODO accept
		end case;
	end process;

-- Generate outputs
WrT <= '1' when (CS = STATE_SENDING_TICKET) else '0';
Dout <= Din when (CS = STATE_SENDING_TICKET or CS = STATE_SENDING_LCD) else '1'; ----- ns como se faz 
WrL <= '1' when (CS = STATE_SENDING_LCD) else '1';
DONE <= '1' when (CS = STATE_END) else '0';
 
END arq;

											
