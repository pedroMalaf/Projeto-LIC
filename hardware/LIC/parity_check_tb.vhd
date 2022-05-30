-- Parity check Testbench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY parity_check_tb IS
END parity_check_tb;

ARCHITECTURE arq OF parity_check_tb IS

	COMPONENT parity_check IS
		PORT (
			data : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			init : IN STD_LOGIC;
			err : OUT STD_LOGIC
		);
	END COMPONENT;

	CONSTANT MCLK_PERIOD : TIME := 20 ns;
	CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;

	SIGNAL data_tb, clk_tb, init_tb, err_tb : STD_LOGIC;

BEGIN
	UUT : parity_check
	PORT MAP(
		data => data_tb,
		clk => clk_tb,
		init => init_tb,
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
		init_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		init_tb <= '1';
		--WAIT FOR MCLK_PERIOD; -- ?

		data_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		data_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		data_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		data_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		data_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		data_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		data_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		init_tb <= '0';
		WAIT;
	END PROCESS;

END arq;