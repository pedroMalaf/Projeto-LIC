-- Key_scan test bench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Key_scan_tb IS
END Key_scan_tb;

ARCHITECTURE arq OF Key_scan_tb IS

	COMPONENT Key_scan IS
		PORT(
			Kscan : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			L : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			K : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			C : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			Kpress : OUT STD_LOGIC
		);
	END COMPONENT;
	
	CONSTANT MCLK_PERIOD : TIME := 20 ns;
	CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;
	
	SIGNAL Kscan_tb, clk_tb, reset_tb, Kpress_tb : STD_LOGIC;
	SIGNAL L_tb, K_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL C_tb : STD_LOGIC_VECTOR(2	DOWNTO 0);
	
BEGIN
	UUT : key_scan
	PORT MAP(
		Kscan => Kscan_tb,
		clk => clk_tb,
		reset => reset_tb,
		L => L_tb,
		K => K_tb,
		C => C_tb,
		Kpress => Kpress_tb
	);
	
		clk_gen : PROCESS
	BEGIN
		clk_tb <= '0';
		WAIT FOR MCLK_HALF_PERIOD;
		clk_tb <= '1';
		WAIT FOR MCLK_HALF_PERIOD;
	END PROCESS;
	
	stimulus : PROCESS
	BEGIN
		wait for MCLK_PERIOD;
		reset_tb <= '1';	
		
		wait for MCLK_PERIOD;
		reset_tb <= '0';	
		Kscan_tb <= '1';
		
		wait for MCLK_PERIOD;	
		L_tb <= "1101";	
		Kscan_tb <= '0'; -- para parar a contagem 	
		
		wait;
		
   end process;

END arq;
