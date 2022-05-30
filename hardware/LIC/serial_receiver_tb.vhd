-- Serial Receiver Testbench TODO

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY serial_receiver_tb IS
END serial_receiver_tb;

ARCHITECTURE arq OF serial_receiver_tb IS

	COMPONENT serial_receiver IS
		PORT (
			SDX : IN STD_LOGIC;
			SCLK, MCLK, reset : IN STD_LOGIC;
			not_SS : IN STD_LOGIC;
			accept : IN STD_LOGIC;
			D : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			DXval : OUT STD_LOGIC;
			busy : OUT STD_LOGIC
		);
	END COMPONENT;

	CONSTANT MCLK_PERIOD : TIME := 20 ns;
	CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;

	SIGNAL SDX_tb, MCLK_tb, SCLK_tb, not_SS_tb, accept_tb, reset_tb : STD_LOGIC;
	SIGNAL D_tb : STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL DXval_tb, busy_tb : STD_LOGIC;

BEGIN
	UUT : serial_receiver
	PORT MAP(
		SDX => SDX_tb,
		SCLK => SCLK_tb,
		MCLK => MCLK_tb,
		not_SS => not_SS_tb,
		accept => accept_tb,
		D => D_tb,
		DXval => DXval_tb,
		reset => reset_tb,
		busy => busy_tb
	);

	clk_gen : PROCESS
	BEGIN
		MCLK_tb <= '0';
		WAIT FOR MCLK_HALF_PERIOD;
		MCLK_tb <= '1';
		WAIT FOR MCLK_HALF_PERIOD;
	END PROCESS;

	stimulus : PROCESS
	BEGIN
		WAIT FOR MCLK_PERIOD;

		-- Trama invalida
		reset_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		reset_tb <= '0';
		accept_TB <= '0';
		not_SS_tb <= '1';

		SDX_tb <= '1';
		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		not_SS_tb <= '0';
		SDX_tb <= '1';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '0';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '0';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '1';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '0';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '1';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '1';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '0';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '0';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		not_ss_tb <= '1'; -- TEM QUE IR PARA STATE_AVAILABLE DNV
		WAIT FOR MCLK_PERIOD;
		WAIT FOR MCLK_PERIOD;
		-- TIME RANGE: 434 ns
		-- TRAMA VALIDA MAS VERIFICAR BIT PARIDADE MAIS ABAIXO
		reset_tb <= '1';
		WAIT FOR MCLK_PERIOD;
		reset_tb <= '0';
		not_ss_tb <= '0';
		SDX_tb <= '1';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '0';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '0';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '1';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '0';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '1';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '1';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '0';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '1';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		SDX_tb <= '1';
		SCLK_tb <= '0';
		not_ss_tb <= '1'; -- so we can go to state_end
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		WAIT FOR MCLK_PERIOD;

		-- README: MUDAR PARA 1 PARA TESTAR TRAMA INVALIDA (BIT PARIDADE INVALIDO)
		SDX_tb <= '0';
		SCLK_tb <= '0';
		WAIT FOR MCLK_PERIOD;

		SCLK_tb <= '1';
		not_ss_tb <= '1';

		WAIT FOR MCLK_PERIOD;

		WAIT;
	END PROCESS;

END arq;