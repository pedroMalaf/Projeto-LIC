 -- Counter Testbench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter_tc_tb IS
END counter_tc_tb;

ARCHITECTURE arq OF counter_tc_tb IS

	COMPONENT counter_tc IS
		PORT (
			D : in std_logic_vector(3 downto 0);
			TC10 : out std_logic;
			TC11 : out std_logic
		);
	END COMPONENT;

	CONSTANT MCLK_PERIOD : TIME := 20 ns;
	CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;

	SIGNAL D_tb : std_logic_vector(3 downto 0);
	SIGNAL TC10_tb, TC11_tb : STD_LOGIC;

BEGIN
	UUT : counter_tc
	PORT MAP(
		D => D_tb, 
		TC10 => TC10_tb, 
		TC11 => TC11_tb
	);

	stimulus : PROCESS
	BEGIN
		D_tb <= "1001"; -- all off
		WAIT FOR MCLK_PERIOD;
 
		D_tb <= "1010"; -- tc 10 on
		WAIT FOR MCLK_PERIOD;
		
		D_tb <= "1011"; -- tc 11 on
		WAIT FOR MCLK_PERIOD;
		
		D_tb <= "1001"; -- all off
		WAIT FOR MCLK_PERIOD;
 
		WAIT;
	END PROCESS;

END arq;