-- Counter (+1 in every clk)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter IS
	PORT (
		reset : IN STD_LOGIC;
		ce : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		flags : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END counter;

ARCHITECTURE arq OF counter IS

	-- Register (4 bits)
	COMPONENT reg
		PORT (
			F : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			CE, RESET : IN STD_LOGIC;
			CLK : IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;

	-- Adder (4 bits)
	COMPONENT adder
		PORT (
			A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Cin : IN STD_LOGIC;
			S : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			Cout : OUT STD_LOGIC
		);
	END COMPONENT;

	SIGNAL s_add, s_counter : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
	u_reg : reg
	PORT MAP(
		F => s_add,
		CLK => clk,
		RESET => reset,
		CE => ce,
		Q => s_counter
	);

	u_adder : adder
	PORT MAP(
		A => s_counter,
		B => "0001",
		Cin => '0',
		Cout => OPEN,
		S => s_add
	);

	flags <= s_counter;
END arq;