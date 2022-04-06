-- Serial Receiver Testbench TODO

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY serial_receiver_tb IS
END serial_receiver_tb;

ARCHITECTURE arq OF serial_receiver_tb IS

	COMPONENT serial_receiver IS
		PORT (
			SDX : IN STD_LOGIC;
			SCLK : IN STD_LOGIC;
			not_SS : IN STD_LOGIC;
			accept : IN STD_LOGIC;
			D : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			DXval : OUT STD_LOGIC;
			busy : OUT STD_LOGIC
		);
	END COMPONENT;

	CONSTANT MCLK_PERIOD : TIME := 20 ns;
	CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;

	SIGNAL SDX_tb, SCLK_tb, not_SS_tb, accept_tb : STD_LOGIC;
	SIGNAL D_tb : STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL DXval_tb, busy_tb : std_logic;

BEGIN
	UUT : serial_receiver
	PORT MAP(
		SDX => SDX_tb, 
		SCLK => SCLK_tb, 
		not_SS => not_SS_tb, 
		accept => accept_tb, 
		D => D_tb, 
		DXval => DXval_tb, 
		busy => busy_tb
	);

	clk_gen : PROCESS
	BEGIN
		SCLK_tb <= '0';
		WAIT FOR MCLK_HALF_PERIOD;
		SCLK_tb <= '1';
		WAIT FOR MCLK_HALF_PERIOD;
	END PROCESS;

	stimulus : PROCESS
	BEGIN
		WAIT FOR MCLK_PERIOD;
		
		-- entrada normal, 
		SDX_tb <= '1';
		SDX_tb <= '1';
		SDX_tb <= '1';
		SDX_tb <= '1';
		SDX_tb <= '1';
		SDX_tb <= '1';
		SDX_tb <= '1';
		SDX_tb <= '1';
		SDX_tb <= '1';
		SDX_tb <= '1';
		SDX_tb <= '1'; --parity
		
		
		-- uma entrada incompleta e de seguida outra entrada para ver se aquilo começava de novo
		
		
		
		-- uma entrada com o bit de paridade errado
 
		WAIT;
	END PROCESS;

END arq;