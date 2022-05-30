 -- Ticket dispenser

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ticket_dispenser IS
	PORT (
		MCLK: IN STD_LOGIC;
		reset: IN STD_LOGIC;
		collect: IN STD_LOGIC; -- collect ticket: tirar o bilhete, simular com meter um switch a 1 e dps 0
		
		HEX0, HEX1, HEX2: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		
		Prt : IN STD_LOGIC;
		Rt : IN STD_LOGIC;
		d_id, o_id: STD_LOGIC_VECTOR(3 DOWNTO 0); -- destination & origin
		Fn : OUT STD_LOGIC -- busy
	);
END ticket_dispenser;

ARCHITECTURE arq OF ticket_dispenser IS

	COMPONENT decoderHex IS
        PORT (
				A: in std_logic_vector(3 downto 0);		
				clear : in std_logic;
				HEX0 : out std_logic_vector(7 downto 0));	
    END COMPONENT;
	 
begin
	
	UdecoderHex : decoderHex PORT MAP(
        A => o_id,
        clear => not(Prt),
        HEX0 => HEX0
    );
	 
	 UdecoderHex1 : decoderHex PORT MAP(
        A => d_id,
        clear => not(Prt),
        HEX0 => HEX1
    );
	 
	 UdecoderHex2 : decoderHex PORT MAP(
        A(0) => Rt,
		  A(1) => '0',
		  A(2) => '0',
		  A(3) => '0',
        clear => not(Prt),
        HEX0 => HEX2
    );
	
	Fn <= collect;
	
END arq;