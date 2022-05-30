-- keyscan

LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;

ENTITY keyscan IS
    PORT (
			Ksc : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			L : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			K : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			C : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			Kpress : OUT STD_LOGIC
    );
END keyscan;

architecture arq of keyscan is

component mux
	PORT (
		S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		Y : OUT STD_LOGIC
    );
	 
end component;

component counter
	PORT (
		ce : in std_logic;
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		Q: out std_logic_vector(3 downto 0)
	);

end component;

component dec
    PORT (
		S : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		CL : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );

end component;

signal Q_s : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal y_s : STD_LOGIC;

BEGIN

K(0) <= Q_s(0);
K(1) <= Q_s(1);
K(2) <= Q_s(2);
K(3) <= Q_s(3);
Kpress <= y_s;

	u_mux : mux
	PORT MAP(
		A => L,
		Y => y_s,
		S(0) => Q_s(0),
		S(1) => Q_s(1)
	);
	
	u_counter : counter
	PORT MAP(
		ce => Ksc,
		reset => reset,
		clk => clk,
		Q(0) => Q_s(0),
		Q(1) => Q_s(1),
		Q(2) => Q_s(2),
		Q(3) => Q_s(3)
	);
	
	u_dec : dec 
	PORT MAP(
		S(0) => Q_s(2),
		S(1) => Q_s(3),
		CL => C
	);

END arq;