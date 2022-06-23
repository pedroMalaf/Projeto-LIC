-- Keyboard Reader Top entity 

LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;

ENTITY keyboard_reader IS
	PORT (
		reset : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		RXclk : IN STD_LOGIC;
		LINES : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		COLUMNS : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		TXD : OUT STD_LOGIC
	);
END keyboard_reader;

ARCHITECTURE arq OF keyboard_reader IS
	
	COMPONENT key_decode IS
		PORT (
			reset : IN STD_LOGIC;
			Mclk : IN STD_LOGIC;
			Kack : IN STD_LOGIC;
			Lines : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Columns : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			K : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			Kval : OUT STD_LOGIC
		);
	END COMPONENT;

	COMPONENT key_transmitter IS
		PORT (
			clk: IN STD_LOGIC;
			DAV: IN STD_LOGIC; -- (from K_val - "Key Decode")
			D: IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- (from K - "Key Decode")
			TX_clk: IN STD_LOGIC; -- (from RX_clk - "Control")
			reset: IN STD_LOGIC;
			DAC: OUT STD_LOGIC; -- data accepted (to K_ack - "Key Decode")
			TX_D: OUT STD_LOGIC -- (to RX_D - "Control")
		);
	END COMPONENT;
	
	SIGNAL s_Kval, s_DAC, s_reset : STD_LOGIC;
	SIGNAL s_K : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
BEGIN

	s_reset <= reset;

	u_key_decode : key_decode
	PORT MAP (
		reset => reset,
		Mclk => clk,
		Lines => LINES,
		Columns => COLUMNS,
		Kack => s_DAC,
		Kval => s_Kval,
		K => s_K
	);
	
	u_key_transmitter : key_transmitter
	PORT MAP (
		DAV => s_Kval,
		TX_clk => RXclk,
		clk => clk,
		D => s_K,
		DAC => s_DAC,
		TX_D => TXD,
		reset => reset
	);

END arq;
