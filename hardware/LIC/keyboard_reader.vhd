-- Keyboard Reader Top entity 

LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;

ENTITY keyboard_reader IS
	PORT (
		clk : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		Kack : IN STD_LOGIC;
		Kpress : IN STD_LOGIC;
		Kval : out STD_LOGIC;
		Kscan : OUT STD_LOGIC
	);
END keyboard_reader;

ARCHITECTURE arq OF keyboard_reader IS
	
	COMPONENT key_decode IS
		PORT (
			Mclk : IN STD_LOGIC;
			Kack : IN STD_LOGIC;
			Kin : IN STD_LOGIC;
			Lines : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Columns : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			K : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT key_transmitter IS
		PORT (
			DAV: IN STD_LOGIC; 
			D: IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
			TX_clk: IN STD_LOGIC;
			DAC: OUT STD_LOGIC;
			TX_D: OUT STD_LOGIC
		);
	END COMPONENT;
	
BEGIN

END arq;
