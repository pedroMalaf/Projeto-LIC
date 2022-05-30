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

COMPONENT CLKDIV
        GENERIC (div : NATURAL := 625000000);
        PORT (
            clk_in : IN STD_LOGIC;
            clk_out : OUT STD_LOGIC
        );
    END COMPONENT;


type STATE_TYPE is (STATE_AVAILABLE, STATE_SENDING_TICKET, STATE_SENDING_LCD, STATE_END);

signal CS, NS: STATE_TYPE; -- Current & Next State 
signal din_s: STD_LOGIC_VECTOR(8 downto 0); -- Remove indicator bit (LCD ou TD)
signal s_clk: STD_LOGIC;

BEGIN

    u_CLKDIV : CLKDIV PORT MAP(
        clk_in => clk,
        clk_out => s_clk
    );

-- Store current state 
CS <= STATE_AVAILABLE when reset = '1' else NS when rising_edge(s_clk);

-- Generate next state
generate_next_state: process (CS, Dval, Din, Fsh)
	begin
		case CS is
		
			when STATE_AVAILABLE => if (Dval = '0') then 
												NS <= STATE_AVAILABLE; 
											elsif (Dval = '1' and Din(0) = '1') then
												NS <= STATE_SENDING_TICKET;  
											elsif (Dval = '1' and Din(0) = '0') then
												NS <= STATE_SENDING_LCD;
											end if;
			
			when STATE_SENDING_TICKET => if (Fsh = '0') then
														NS <= STATE_SENDING_TICKET;
													elsif (Fsh = '1') then
														NS <= STATE_END;
													end if;
													
			when STATE_SENDING_LCD => NS <= STATE_END;
			
			when STATE_END => NS <= STATE_AVAILABLE;
								
		end case;
	end process;
	
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
WrT <= '1' when (CS = STATE_SENDING_TICKET) else '0';
WrL <= '1' when (CS = STATE_SENDING_LCD) else '0';
Dout <= din_s;
DONE <= '1' when (CS = STATE_END) else '0';
 
END arq;

											
