-- Counter Testbench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter_tb IS
END counter_tb;

ARCHITECTURE arq OF counter_tb IS

	COMPONENT counter IS
		PORT (
			clr : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			err : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	CONSTANT MCLK_PERIOD : TIME := 20 ns;
	CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;

	SIGNAL clr_tb, clk_tb : STD_LOGIC;
	SIGNAL err_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
	UUT : counter
	PORT MAP(
		clr => clr_tb, 
		clk => clk_tb, 
		err => err_tb
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
		clr_tb <= '1';
		WAIT FOR MCLK_PERIOD;
 
		clr_tb <= '0';
		WAIT FOR MCLK_PERIOD * 5;
 
		WAIT;
	END PROCESS;

END arq;