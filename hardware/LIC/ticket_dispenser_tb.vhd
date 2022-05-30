-- Ticket dispenser Testbench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ticket_dispenser_tb IS
END ticket_dispenser_tb;

ARCHITECTURE arq OF ticket_dispenser_tb IS

	COMPONENT ticket_dispenser IS
		PORT (
			MCLK : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			collect : IN STD_LOGIC;

			HEX0, HEX1, HEX2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);

			Prt : IN STD_LOGIC;
			Rt : IN STD_LOGIC;
			d_id, o_id : STD_LOGIC_VECTOR(3 DOWNTO 0);
			Fn : OUT STD_LOGIC -- busy
		);
	END COMPONENT;

	CONSTANT MCLK_PERIOD : TIME := 20 ns;
	CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;
	SIGNAL clk_tb : STD_LOGIC;

	SIGNAL reset_tb : STD_LOGIC;
	SIGNAL collect_tb : STD_LOGIC;

	SIGNAL HEX0_tb, HEX1_tb, HEX2_tb : STD_LOGIC_VECTOR(7 DOWNTO 0);

	SIGNAL Prt_tb : STD_LOGIC;
	SIGNAL Rt_tb : STD_LOGIC;
	SIGNAL d_id_tb, o_id_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Fn_tb : STD_LOGIC; -- busy

BEGIN
	UUT : ticket_dispenser
	PORT MAP(
		reset => reset_tb,
		collect => collect_tb,
		HEX0 => HEX0_tb,
		HEX1 => HEX1_tb,
		HEX2 => HEX2_tb,
		Prt => Prt_tb,
		Rt => Rt_tb,
		d_id => d_id_tb,
		o_id => o_id_tb,
		Fn => Fn_tb,
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
		reset_tb <= '1';
		reset_tb <= '0';
		o_id_tb <= "0010"; -- 2
		d_id_tb <= "0011"; -- 3
		Rt_tb <= '1';
		collect_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		-- TODO: testar collet e reset		
		WAIT FOR MCLK_PERIOD;

		WAIT;
	END PROCESS;

END arq;