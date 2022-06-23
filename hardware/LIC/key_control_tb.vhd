-- key_control test bench 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Key_control_tb IS
END Key_control_tb;

ARCHITECTURE arq OF Key_control_tb IS

	COMPONENT key_control IS
		PORT(
			clk : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			Kack : IN STD_LOGIC;
			Kpress : IN STD_LOGIC;
			Kval : OUT STD_LOGIC;
			Kscan : OUT STD_LOGIC
		);
	END COMPONENT;
	
	CONSTANT MCLK_PERIOD : TIME := 20 ns;
	CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;

	SIGNAL clk_tb, reset_tb, Kack_tb, Kpress_tb, Kval_tb, Kscan_tb : STD_LOGIC;
	
BEGIN
	UUT : key_control
	PORT MAP(
		clk => clk_tb,
		reset => reset_tb,
		Kack => Kack_tb,
		Kpress => Kpress_tb,
		Kval => Kval_tb,
		Kscan => Kscan_tb
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
		
		wait for MCLK_PERIOD;
		Kpress_tb <= '0';
		
		wait for MCLK_PERIOD;
		Kpress_tb <= '1';
		
		wait for MCLK_PERIOD;
		Kack_tb <= '1';		
		
		wait for MCLK_PERIOD;
		Kpress_tb <= '0';
		
		
		wait for MCLK_PERIOD;
		Kpress_tb <= '1';
		
		wait for MCLK_PERIOD;
		Kack_tb <= '1';
		
		wait for MCLK_PERIOD;
		Kpress_tb <= '0';
		wait;
		
   end process;

END arq;
