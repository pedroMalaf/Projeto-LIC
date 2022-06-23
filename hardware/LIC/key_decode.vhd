-- key decode


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY key_decode IS
	PORT (
		reset : IN STD_LOGIC;
		Mclk : IN STD_LOGIC;
		Kack : IN STD_LOGIC;
		Lines : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		Columns : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		K : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		Kval : OUT STD_LOGIC
	);
END key_decode;

ARCHITECTURE arq OF key_decode IS

	COMPONENT key_scan IS
		PORT (
			Kscan : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			L : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			K : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			C : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			Kpress : OUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT key_control IS
		PORT (
			reset : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			Kack : IN STD_LOGIC;
			Kpress : IN STD_LOGIC;
			Kval : out STD_LOGIC;
			Kscan : OUT STD_LOGIC
		);
	END COMPONENT;
	
	SIGNAL s_Kscan, s_Kpress : STD_LOGIC;
	
BEGIN
	u_key_scan : key_scan
	PORT MAP(
		Kscan => s_Kscan,
		clk => Mclk,
		L => Lines,
		C => Columns,
		Kpress => s_Kpress,
		K => K
	);
	
	u_key_control : key_control
	PORT MAP(
		clk => Mclk,
		Kack => Kack,
		Kpress => s_Kpress,
		reset => reset,
		Kval => Kval,
		Kscan => s_Kscan
	); 
	
END arq;