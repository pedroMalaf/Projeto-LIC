-- Keyboard Reader Top entity 

LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;

ENTITY keyboard_reader IS
	PORT (
		clk : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		Lines : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		RXclk : IN STD_LOGIC;
		TXD : OUT STD_LOGIC;
		Columns : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END keyboard_reader;

ARCHITECTURE arq OF keyboard_reader IS
	
	COMPONENT key_decode IS
		PORT (
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
			DAV: IN STD_LOGIC; 
			D: IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
			TX_clk: IN STD_LOGIC;
			DAC: OUT STD_LOGIC;
			TX_D: OUT STD_LOGIC
		);
	END COMPONENT;
	
	SIGNAL s_Kval, s_DAC : STD_LOGIC;
	SIGNAL s_K : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
BEGIN
	u_key_decode : key_decode
	PORT MAP (
		Mclk => clk,
		Lines => Lines,
		Columns => Columns,
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
		TX_D => TXD
	);

END arq;
