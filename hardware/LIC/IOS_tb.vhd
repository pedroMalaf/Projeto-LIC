-- IOS Testbench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY IOS_tb IS
END IOS_tb;

ARCHITECTURE arq OF IOS_tb IS

	COMPONENT IOS IS
		PORT (
			SCLK : IN STD_LOGIC;
			SDX : IN STD_LOGIC;
			notSS : IN STD_LOGIC;
			Fsh : IN STD_LOGIC; --> Fn -> fsh
			WrT : OUT STD_LOGIC; --> Wrt -> Prt
			Dout : OUT STD_LOGIC; --> Dout -> DId; Dout -> D
			WrL : OUT STD_LOGIC; --> wrl -> E 
			busy : OUT STD_LOGIC
		);
	END COMPONENT;

	CONSTANT MCLK_PERIOD : TIME := 20 ns;
	CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;

	SIGNAL SCLK_tb, SDX_tb, notSS_tb, Fsh_tb, WrT_tb, Dout_tb, WrL_tb, busy_tb : STD_LOGIC;

BEGIN
	-- Unit Under Test
	UUT : IOS
	PORT MAP(
		SCLK => SCLK_tb, 
		SDX => SDX_tb, 
		notSS => notSS_tb, 
		Fsh => Fsh_tb, 
		WrT => WrT_tb, 
		Dout => Dout_tb, 
		WrL => WrL_tb, 
		busy => busy_tb
	);
 
	-- Generate Clock
	clk_gen : PROCESS
	BEGIN
		SCLK_tb <= '0';
		WAIT FOR MCLK_HALF_PERIOD;
		SCLK_tb <= '1';
		WAIT FOR MCLK_HALF_PERIOD;
	END PROCESS;
 
	-- Stimulus Generator
	stimulus : PROCESS
	BEGIN
	END PROCESS;
 
END arq;