-- key scan

LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;

ENTITY key_scan IS
	PORT (
		Kscan : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		L : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		K : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		C : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		Kpress : OUT STD_LOGIC
	);
END key_scan;

ARCHITECTURE arq OF key_scan IS
	
	COMPONENT CLKDIV 
	GENERIC (div : NATURAL := 50000000); 
	PORT (
		clk_in : IN STD_LOGIC;
		clk_out : OUT STD_LOGIC);
END component;
	
	
	COMPONENT mux
		PORT (
			S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Y : OUT STD_LOGIC
		);

	END COMPONENT;

	COMPONENT counter_keyscan
		PORT (
			ce : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);

	END COMPONENT;

	COMPONENT dec
		PORT (
			S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			CL : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);

	END COMPONENT;

	SIGNAL Q_s : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL y_s : STD_LOGIC;
	SIGNAL C_s : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL clk_s : STD_LOGIC;
	
BEGIN

	u_CLKDIV: CLKDIV generic map(250000) port map(CLK_in => clk, clk_out=> clk_s);

	K(0) <= Q_s(0);
	K(1) <= Q_s(1);
	K(2) <= Q_s(2);
	K(3) <= Q_s(3);
	Kpress <= not y_s;
	C <= not C_s;
	
	u_mux : mux
	PORT MAP(
		A => L,
		Y => y_s,
		S(0) => Q_s(0),
		S(1) => Q_s(1)
	);

	u_counter : counter_keyscan
	PORT MAP(
		ce => Kscan,
		clk => clk_s,
		Q(0) => Q_s(0),
		Q(1) => Q_s(1),
		Q(2) => Q_s(2),
		Q(3) => Q_s(3)
	);

	u_dec : dec
	PORT MAP(
		S(0) => Q_s(2),
		S(1) => Q_s(3),
		CL => C_s
	);

END arq;