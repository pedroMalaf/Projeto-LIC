--counter

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter IS
	PORT (
		ce : in std_logic;
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		Q: out std_logic_vector(3 downto 0)
	);
END counter;

ARCHITECTURE arq OF counter IS

COMPONENT reg
	PORT (
		F : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		CE, RESET : IN STD_LOGIC;
		CLK : IN STD_LOGIC;
		Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
	END COMPONENT;

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
			clk => clk,
			reset => reset,
			CE => ce,
			Q => s_counter
		);
		
		u_adder : adder
		PORT MAP(
			A => s_counter, 
			B => "0000", 
			Cin => '1', 
			Cout => OPEN, 
			S => s_add
		);
		
END arq;