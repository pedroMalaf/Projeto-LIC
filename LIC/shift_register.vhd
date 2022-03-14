LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
 
ENTITY shift_register IS
	PORT (
		Sin : IN std_logic;
		clk, enable : IN STD_LOGIC;
		D : OUT STD_LOGIC_VECTOR(9 downto 0)
	);
END shift_register;

ARCHITECTURE arq OF shift_register IS

    COMPONENT FFD
        PORT (
            CLK : IN STD_LOGIC;
            RESET : IN STD_LOGIC;
            SET : IN STD_LOGIC;
            D : IN STD_LOGIC;
            EN : IN STD_LOGIC;
            Q : OUT STD_LOGIC
        );
    END COMPONENT;
	 
signal q : std_logic_vector(9 downto 0);

BEGIN

u_ffd0 : FFD PORT MAP(
        EN => enable,
        RESET => '0',
        SET => '0',
        CLK => clk,
        D => Sin,
        Q => q(0));
		  
u_ffd1 : FFD PORT MAP(
        EN => enable,
        RESET => '0',
        SET => '0',
        CLK => clk,
        D => q(0),
        Q => q(1));
		  
u_ffd2 : FFD PORT MAP(
        EN => enable,
        RESET => '0',
        SET => '0',
        CLK => clk,
        D => q(1),
        Q => q(2));
		  
u_ffd3 : FFD PORT MAP(
        EN => enable,
        RESET => '0',
        SET => '0',
        CLK => clk,
        D => q(2),
        Q => q(3));
		  
u_ffd4 : FFD PORT MAP(
        EN => enable,
        RESET => '0',
        SET => '0',
        CLK => clk,
        D => q(3),
        Q => q(4));
		  
u_ffd5 : FFD PORT MAP(
        EN => enable,
        RESET => '0',
        SET => '0',
        CLK => clk,
        D => q(4),
        Q => q(5));
		 
u_ffd6 : FFD PORT MAP(
        EN => enable,
        RESET => '0',
        SET => '0',
        CLK => clk,
        D => q(5),
        Q => q(6));
		  
u_ffd7 : FFD PORT MAP(
        EN => enable,
        RESET => '0',
        SET => '0',
        CLK => clk,
        D => q(6),
        Q => q(7));
		  
u_ffd8 : FFD PORT MAP(
        EN => enable,
        RESET => '0',
        SET => '0',
        CLK => clk,
        D => q(7),
        Q => q(8));
		  
u_ffd9 : FFD PORT MAP(
        EN => enable,
        RESET => '0',
        SET => '0',
        CLK => clk,
        D => q(8),
        Q => q(9));

END arq;