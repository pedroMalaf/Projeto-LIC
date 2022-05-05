-- Ticket Machine 

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ticket_machine IS
	PORT (
		collect : IN STD_LOGIC;
		MCLK : IN STD_LOGIC;
		Reset : IN STD_LOGIC;
		Prt : OUT STD_LOGIC; 
		HEX0, HEX1, HEX2: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END ticket_machine;


ARCHITECTURE arq OF ticket_machine IS

	COMPONENT UsbPort
	PORT (
		inputPort:  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		outputPort :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	END COMPONENT;

	COMPONENT ticket_dispenser
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
	END COMPONENT;

	COMPONENT IOS IS
	PORT (
		SCLK : IN STD_LOGIC;
		SDX : IN STD_LOGIC;
		not_SS : IN STD_LOGIC;
		Fsh : IN STD_LOGIC; --> Fn -> fsh
		WrT : OUT STD_LOGIC; --> Wrt -> Prt
		Dout : OUT STD_LOGIC_VECTOR(8 DOWNTO 0); --> Dout -> DId; Dout -> D
		WrL : OUT STD_LOGIC; --> wrl -> E 
		busy : OUT STD_LOGIC
	);	
	END COMPONENT;
	
	signal prt_s, rt_s, fn_s, sdx_s, not_ss_s, busy_s, clk_s: STD_LOGIC;
	signal di_s, oi_s: STD_LOGIC_VECTOR(3 DOWNTO 0);
	
BEGIN 

	u_usbport : UsbPort
	PORT MAP(
		inputPort(0) => busy_s,
		outputPort(1) => not_ss_s,
		outputPort(2) => clk_s,
		outputPort(3) => sdx_s
	);

	u_ios : IOS
	PORT MAP(
		SCLK => MCLK, 
		WrT => prt_s,
		not_SS => not_ss_s,
		Dout(0) => rt_s,
		DouT(1) => di_s(0),
		DouT(2) => di_s(1),
		DouT(3) => di_s(2),
		DouT(4) => di_s(3),
		DouT(5) => oi_s(0),
		DouT(6) => oi_s(1),
		DouT(7) => oi_s(2),
		DouT(8) => oi_s(3),
		Fsh => fn_s,
		busy => busy_s,
		SDX => sdx_s
	);
	
	u_td : ticket_dispenser
	PORT MAP(
		MCLK => MCLK,
		Prt => prt_s,
		reset => Reset,
		Rt => rt_s,
		d_id => di_s,
		o_id => oi_s,
		Fn => fn_s,
		HEX0 => HEX0,
		HEX1 => HEX1,
		HEX2 => HEX2,
		collect => collect
	);
	Prt <= prt_s;
	clk_s <= MCLK;
END arq;

