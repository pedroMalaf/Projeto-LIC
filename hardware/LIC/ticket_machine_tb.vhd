-- Ticket Machine TestBench
 
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ticket_machine_tb IS
END ticket_machine_tb;

ARCHITECTURE arq OF ticket_machine_tb IS

	COMPONENT ticket_machine IS
		PORT (
			collect : IN STD_LOGIC;
			MCLK : IN STD_LOGIC;
			Reset : IN STD_LOGIC;
			Prt : OUT STD_LOGIC;
			HEX0, HEX1, HEX2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;

	CONSTANT MCLK_PERIOD : TIME := 20 ns;
	CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;

	SIGNAL clk_tb : STD_LOGIC;

	SIGNAL reset_tb : STD_LOGIC;
	SIGNAL collect_tb : STD_LOGIC;

	SIGNAL HEX0_tb, HEX1_tb, HEX2_tb : STD_LOGIC_VECTOR(7 DOWNTO 0);

	SIGNAL Prt_tb : STD_LOGIC;

BEGIN
	UUT : ticket_machine
	PORT MAP(
		Reset => reset_tb,
		collect => collect_tb,
		HEX0 => HEX0_tb,
		HEX1 => HEX1_tb,
		HEX2 => HEX2_tb,
		Prt => Prt_tb,
		MCLK => clk_tb
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
		collect_tb <= '1';
		reset_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		WAIT;
	END PROCESS;

END arq;