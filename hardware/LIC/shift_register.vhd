-- Shift Register

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY shift_register IS
	PORT (
		Sin : IN STD_LOGIC;
		clk, enable : IN STD_LOGIC;
		D : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END shift_register;

ARCHITECTURE arq OF shift_register IS

	COMPONENT FFD IS
		PORT (
			CLK : IN STD_LOGIC;
			RESET : IN STD_LOGIC;
			SET : IN STD_LOGIC;
			D : IN STD_LOGIC;
			EN : IN STD_LOGIC;
			Q : OUT STD_LOGIC
		);
	END COMPONENT;

	SIGNAL q : STD_LOGIC_VECTOR(9 DOWNTO 0);

BEGIN

	u_ffd0 : FFD
	PORT MAP(
		EN => enable,
		RESET => '0',
		SET => '0',
		CLK => clk,
		D => Sin,
		Q => q(0)
	);

	u_ffd1 : FFD
	PORT MAP(
		EN => enable,
		RESET => '0',
		SET => '0',
		CLK => clk,
		D => q(0),
		Q => q(1)
	);

	u_ffd2 : FFD
	PORT MAP(
		EN => enable,
		RESET => '0',
		SET => '0',
		CLK => clk,
		D => q(1),
		Q => q(2)
	);

	u_ffd3 : FFD
	PORT MAP(
		EN => enable,
		RESET => '0',
		SET => '0',
		CLK => clk,
		D => q(2),
		Q => q(3)
	);

	u_ffd4 : FFD
	PORT MAP(
		EN => enable,
		RESET => '0',
		SET => '0',
		CLK => clk,
		D => q(3),
		Q => q(4)
	);

	u_ffd5 : FFD
	PORT MAP(
		EN => enable,
		RESET => '0',
		SET => '0',
		CLK => clk,
		D => q(4),
		Q => q(5)
	);

	u_ffd6 : FFD
	PORT MAP(
		EN => enable,
		RESET => '0',
		SET => '0',
		CLK => clk,
		D => q(5),
		Q => q(6)
	);

	u_ffd7 : FFD
	PORT MAP(
		EN => enable,
		RESET => '0',
		SET => '0',
		CLK => clk,
		D => q(6),
		Q => q(7)
	);

	u_ffd8 : FFD
	PORT MAP(
		EN => enable,
		RESET => '0',
		SET => '0',
		CLK => clk,
		D => q(7),
		Q => q(8)
	);

	u_ffd9 : FFD
	PORT MAP(
		EN => enable,
		RESET => '0',
		SET => '0',
		CLK => clk,
		D => q(8),
		Q => q(9)
	);

	D(0) <= q(0); -- AND NOT(enable);
	D(1) <= q(1); -- AND NOT(enable);
	D(2) <= q(2); -- AND NOT(enable);
	D(3) <= q(3); -- AND NOT(enable);
	D(4) <= q(4); -- AND NOT(enable);
	D(5) <= q(5); -- AND NOT(enable);
	D(6) <= q(6); -- AND NOT(enable);
	D(7) <= q(7); -- AND NOT(enable);
	D(8) <= q(8); -- AND NOT(enable);
	D(9) <= q(9); -- AND NOT(enable);

END arq;