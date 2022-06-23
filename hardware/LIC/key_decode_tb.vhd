-- key_decode test bench 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY Key_decode_tb IS
END Key_decode_tb;

ARCHITECTURE arq OF Key_decode_tb IS

	COMPONENT Key_decode IS
		PORT(
			reset : IN STD_LOGIC;
			Mclk : IN STD_LOGIC;
			Kack : IN STD_LOGIC;
			Lines : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Columns : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			K : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			Kval : OUT STD_LOGIC
		);
	END COMPONENT;
	
	CONSTANT MCLK_PERIOD : TIME := 20 ns;
	CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;

	SIGNAL reset_tb, Mclk_tb, Kack_tb, Kval_tb : STD_LOGIC;
	SIGNAL Lines_tb, K_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Columns_tb : STD_LOGIC_VECTOR(2 DOWNTO 0);
	
BEGIN
	UUT : key_decode 
	PORT MAP(
		reset => reset_tb,
		Mclk => Mclk_tb,
		Kack => Kack_tb,
		Lines => Lines_tb,
		Columns => Columns_tb,
		K => K_tb,
		Kval => Kval_tb
	);
	
		clk_gen : PROCESS
	BEGIN
		Mclk_tb <= '0';
		WAIT FOR MCLK_HALF_PERIOD;
		Mclk_tb <= '1';
		WAIT FOR MCLK_HALF_PERIOD;
	END PROCESS;
	
	stimulus : PROCESS
	BEGIN
		wait for MCLK_PERIOD*2;
		Kack_tb <= '0';
		reset_tb <= '1';
		Lines_tb <= "1111";
		
		wait for MCLK_PERIOD;
		reset_tb <= '0';
		
		wait for MCLK_PERIOD;
		Lines_tb <= "0101";
		
		wait for MCLK_PERIOD;
		Kack_tb <= '1';
		Lines_tb <= "1111";
		
		wait;
   end process;

END arq;
	
