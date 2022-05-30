-- Serial Control Testbench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY serial_control_tb IS
END serial_control_tb;

ARCHITECTURE arq OF serial_control_tb IS

	COMPONENT serial_control IS
		PORT (
			not_SS, accept, pFlag, dFlag, RXerror : IN STD_LOGIC;
			reset, clk : IN STD_LOGIC;
			wr, init, DXval, busy : OUT STD_LOGIC
		);
	END COMPONENT;

	CONSTANT MCLK_PERIOD : TIME := 20 ns;
	CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;

	SIGNAL not_SS_tb, accept_tb, pFlag_tb, dFlag_tb, RXerror_tb : STD_LOGIC;
	SIGNAL reset_tb, clk_tb : STD_LOGIC;
	SIGNAL wr_tb, init_tb, DXval_tb, busy_tb : STD_LOGIC;

BEGIN
	UUT : serial_control
	PORT MAP(
		not_SS => not_SS_tb,
		accept => accept_tb,
		pFlag => pFlag_tb,
		dFlag => dFlag_tb,
		RXerror => RXerror_tb,
		reset => reset_tb,
		clk => clk_tb,
		wr => wr_tb,
		init => init_tb,
		DXval => DXval_tb,
		busy => busy_tb
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

		-- input: not_SS, accept, pFlag, dFlag, RXerror
		-- statebefore -> stateafter
		reset_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		-- 00 -> 00
		not_SS_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		-- 00 -> 01
		not_SS_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		-- 01 -> 01
		not_SS_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		-- 01 -> 01
		not_SS_tb <= '1';
		dFlag_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		-- 01 -> 10
		not_SS_tb <= '1';
		dFlag_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		-- 10 -> 10
		pFlag_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		-- TO TEST: RXerror = 1 (10 -> 00)

		-- 10 -> 11
		pFlag_tb <= '1';
		RXerror_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		-- 11 -> 11
		accept_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		-- 11 -> 00
		accept_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		reset_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		WAIT;
	END PROCESS;

END arq;