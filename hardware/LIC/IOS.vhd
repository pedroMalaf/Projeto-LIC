-- IOS

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY IOS IS
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
END IOS;

ARCHITECTURE arq OF IOS IS

	COMPONENT serial_receiver
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

	COMPONENT dispatcher IS
		PORT (
			reset, clk : IN STD_LOGIC;
			Fsh, Dval : IN STD_LOGIC;
			Din : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			Dout : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
			WrT, WrL : OUT STD_LOGIC;
			done : OUT STD_LOGIC
		);
	END COMPONENT;

	SIGNAL s_done : STD_LOGIC; -- dispatcher::done -> serial_receiver::accept
	SIGNAL s_Dval : STD_LOGIC; -- serial_receiver::DXval -> dispatcher::Dval
	SIGNAL s_din : STD_LOGIC_VECTOR(9 DOWNTO 0); -- serial_receiver::D -> dispatcher::Din

BEGIN
	u_serial_receiver : serial_receiver
	PORT MAP(
		reset => reset,
		MCLK => MCLK,
		SCLK => SCLK,
		SDX => SDX,
		not_SS => not_SS,
		busy => busy,
		accept => s_done,
		DXval => s_Dval,
		D => s_din
	);

	u_dispatcher : dispatcher
	PORT MAP(
		Fsh => Fsh,
		Dval => s_Dval,
		done => s_done,
		WrT => WrT,
		Din => s_din,
		Dout => Dout,
		WrL => WrL,
		clk => MCLK,
		reset => reset
	);

END arq;