-- Shift Register Testbench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY shift_register_tb IS
END shift_register_tb;

ARCHITECTURE arq OF shift_register_tb IS

	COMPONENT shift_register IS
		PORT (
			Sin : IN STD_LOGIC;
			clk, enable : IN STD_LOGIC;
			D : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
		);
	END COMPONENT;

	CONSTANT MCLK_PERIOD : TIME := 20 ns;
	CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;

	SIGNAL Sin_tb : STD_LOGIC;
	SIGNAL clk_tb, enable_tb : STD_LOGIC;
	SIGNAL D_tb : STD_LOGIC_VECTOR(9 DOWNTO 0);

BEGIN
	-- Unit Under Test
	UUT : shift_register
	PORT MAP(
		Sin => Sin_tb,
		clk => clk_tb,
		enable => enable_tb,
		D => D_tb
	);

	-- Generate clock
	clk_gen : PROCESS
	BEGIN
		clk_tb <= '0';
		WAIT FOR MCLK_HALF_PERIOD;
		clk_tb <= '1';
		WAIT FOR MCLK_HALF_PERIOD;
	END PROCESS;

	-- Stimulus generator
	stimulus : PROCESS
	BEGIN
		enable_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		Sin_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		Sin_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		Sin_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		Sin_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		Sin_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		Sin_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		Sin_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		Sin_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		Sin_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		Sin_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		enable_tb <= '0';

		WAIT;
	END PROCESS;

END arq;