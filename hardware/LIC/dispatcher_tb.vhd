 -- IOS Dispatcher Testbench TODO

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dispatcher_tb IS
END dispatcher_tb;

ARCHITECTURE arq OF dispatcher_tb IS

	COMPONENT dispatcher IS
		PORT (
			Fsh, Dval : IN STD_LOGIC;
			Din : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			Dout : OUT STD_LOGIC_VECTOR(7 downto 0);
			WrT, WrL : out std_logic;
			done : out std_logic
		);
	END COMPONENT;

	CONSTANT MCLK_PERIOD : TIME := 20 ns;
	CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;

	SIGNAL Fsh_tb, Dval_tb : STD_LOGIC;
	SIGNAL Din_tb: STD_LOGIC_VECTOR(9 downto 0);
	SIGNAL Dout_tb: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL WrT_tb, WrL_tb: STD_LOGIC;
	SIGNAL done_tb: STD_LOGIC;
	SIGNAL clk_tb: STD_LOGIC; 

BEGIN
	UUT : dispatcher
	PORT MAP(
		Fsh => Fsh_tb,
		Dval => Dval_tb,
		Din => Din_tb,
		Dout => Dout_tb,
		WrT => WrT_tb,
		WrL => WrL_tb,
		done => done_tb
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
		WAIT FOR MCLK_PERIOD;
 
		WAIT FOR MCLK_PERIOD * 5;
 
		WAIT;
	END PROCESS;

END arq;