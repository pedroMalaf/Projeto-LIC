-- Serial Receiver (top entity) TODO

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY serial_receiver IS
	PORT (
		SDX : IN STD_LOGIC;
		SCLK, MCLK, reset : IN STD_LOGIC;
		not_SS : IN STD_LOGIC;
		accept : IN STD_LOGIC;
		D : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		DXval : OUT STD_LOGIC;
		busy : OUT STD_LOGIC
	);
END serial_receiver;

ARCHITECTURE arq OF serial_receiver IS

	COMPONENT shift_register
		PORT (
			Sin : IN STD_LOGIC;
			clk, enable : IN STD_LOGIC;
			D : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT counter IS
		PORT (
			clr : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			d_flag, p_flag : OUT STD_LOGIC
		);
	END COMPONENT;
 
	COMPONENT parity_check IS
		PORT (
			data : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			init : IN STD_LOGIC;
			err : OUT STD_LOGIC
		);
	END COMPONENT;
 
	COMPONENT serial_control IS
		PORT (
			not_SS : IN STD_LOGIC;
			accept : IN STD_LOGIC;
			pFlag : IN STD_LOGIC;
			dFlag : IN STD_LOGIC;
			RXerror : IN STD_LOGIC;
			reset, clk : IN STD_LOGIC;
			wr : OUT STD_LOGIC;
			init : OUT STD_LOGIC;
			DXval : OUT STD_LOGIC;
			busy : OUT STD_LOGIC
		);
	END COMPONENT;
 
	SIGNAL s_wr, s_init, s_pflag, s_dflag, s_err : STD_LOGIC;
 
BEGIN
	u_shift_register : shift_register
	PORT MAP(
		Sin => SDX, 
		clk => SCLK, 
		enable => s_wr, 
		D => D
	);
 
	u_counter : counter
	PORT MAP(
		clk => SCLK, 
		clr => s_init, 
		p_flag => s_pflag, 
		d_flag => s_dflag
	);
 
	u_parity_check : parity_check
	PORT MAP(
		clk => SCLK, 
		data => SDX, 
		init => s_init, 
		err => s_err
	);
 
	u_serial_control : serial_control
	PORT MAP(
		not_SS => not_SS, 
		accept => accept, 
		RXerror => s_err, 
		pFlag => s_pflag, 
		dFlag => s_dflag, 
		wr => s_wr, 
		init => s_init, 
		DXval => DXval, 
		reset => reset, 
		clk => MCLK,
		busy => busy
	);

END arq;