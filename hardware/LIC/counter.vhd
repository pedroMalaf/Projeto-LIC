-- Counter

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY counter IS
	PORT (
		clr : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		err : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END counter;

ARCHITECTURE arq OF counter IS

	COMPONENT counter_register 
		PORT (
			CLK : IN STD_LOGIC;
			CE : IN STD_LOGIC;
			M : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			reset : IN STD_LOGIC
        );
	END COMPONENT;
	
	COMPONENT counter_adder 
        PORT (
			A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Cin : IN STD_LOGIC;
			S : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			Cout : OUT STD_LOGIC
        );
	END COMPONENT;

	SIGNAL sSom, sM, sQ : STD_LOGIC_VECTOR(3 DOWNTO 0);
	 
BEGIN

	u_cd_registo : counter_register PORT MAP(
        CE => '1',
        CLK => clk,
        M => sM,
        Q => sQ,
        reset => clr
    );

	u_somador : counter_adder PORT MAP(
		A => sQ,
		B => "0001", 
		Cin => '0',
		Cout => OPEN,
		S => sSom
    );
	 
END arq;

