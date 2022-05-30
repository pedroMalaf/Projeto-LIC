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
			d_flag, p_flag : OUT STD_LOGIC
		);
	END COMPONENT;

	CONSTANT MCLK_PERIOD : TIME := 20 ns;
	CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;

	SIGNAL clr_tb, clk_tb : STD_LOGIC;
	SIGNAL d_flag_tb, p_flag_tb : STD_LOGIC;

BEGIN
	UUT : counter
	PORT MAP(
		clr => clr_tb,
		clk => clk_tb,
		d_flag => d_flag_tb,
		p_flag => p_flag_tb
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