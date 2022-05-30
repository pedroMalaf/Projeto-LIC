-- IOS Testbench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY IOS_tb IS
END IOS_tb;

ARCHITECTURE arq OF IOS_tb IS

	COMPONENT IOS IS
		PORT (
			SCLK, MCLK : IN STD_LOGIC;
			SDX : IN STD_LOGIC;
			not_SS, reset : IN STD_LOGIC;
			Fsh : IN STD_LOGIC; --> Fn -> fsh
			WrT : OUT STD_LOGIC; --> Wrt -> Prt
			Dout : OUT STD_LOGIC_VECTOR(8 DOWNTO 0); --> Dout -> DId; Dout -> D
			WrL : OUT STD_LOGIC; --> wrl -> E 
			busy : OUT STD_LOGIC
		);
	END COMPONENT;

	CONSTANT MCLK_PERIOD : TIME := 20 ns;
	CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;

	SIGNAL MCLK_tb, SCLK_tb, SDX_tb, not_SS_tb, Fsh_tb, WrT_tb, WrL_tb, busy_tb, reset_tb : STD_LOGIC;
	SIGNAL Dout_tb : STD_LOGIC_VECTOR(8 DOWNTO 0);

BEGIN
	-- Unit Under Test
	UUT : IOS
	PORT MAP(
		MCLK => MCLK_tb,
		SCLK => SCLK_tb,
		SDX => SDX_tb,
		not_SS => not_SS_tb,
		Fsh => Fsh_tb,
		WrT => WrT_tb,
		Dout => Dout_tb,
		WrL => WrL_tb,
		busy => busy_tb,
		reset => reset_tb
	);

	-- Generate Clock
	clk_gen : PROCESS
	BEGIN
		MCLK_tb <= '0';
		WAIT FOR MCLK_HALF_PERIOD;
		MCLK_tb <= '1';
		WAIT FOR MCLK_HALF_PERIOD;
	END PROCESS;

	-- Stimulus Generator
	stimulus : PROCESS
	BEGIN
		reset_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		reset_tb <= '0';
		not_SS_tb <= '1';
		SCLK_tb <= '1';
		Fsh_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		not_SS_tb <= '0';
		SDX_tb <= '1'; --1
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '0'; --2
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '0'; --3
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '0'; --4
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '0'; --5
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '0'; --6
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '1'; --7
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '0'; --8
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '1'; --9
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '1'; --10
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '0'; --11
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		not_SS_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		Fsh_tb <= '1';
		WAIT FOR MCLK_PERIOD;
		WAIT FOR MCLK_PERIOD;
		WAIT FOR MCLK_PERIOD;
		Fsh_tb <= '0';
		WAIT;

		WAIT;
	END PROCESS;

END arq;