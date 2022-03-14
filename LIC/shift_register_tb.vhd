library ieee;
use ieee.std_logic_1164.all;

entity shift_register_tb is 
end shift_register_tb;

architecture arq of shift_register_tb is

COMPONENT shift_register IS
	PORT (
		Sin : IN STD_LOGIC;
		clk, enable : IN STD_LOGIC;
		D : OUT STD_LOGIC_VECTOR(9 downto 0)
	);
END component;

constant MCLK_PERIOD : time := 20 ns;
constant MCLK_HALF_PERIOD : time := MCLK_PERIOD / 2;

signal Sin_tb : STD_LOGIC;
signal clk_tb, enable_tb : STD_LOGIC;
signal D_tb : STD_LOGIC_VECTOR(9 downto 0);

begin

-- Unit Under Test
UUT: shift_register port map (
	Sin => Sin_tb,
	clk => clk_tb,
	enable => enable_tb,
	D => D_tb
);

-- Generate clock
clk_gen : process
begin
	clk_tb <= '0';
	wait for MCLK_HALF_PERIOD;
	clk_tb <= '1';
	wait for MCLK_HALF_PERIOD;
end process;

-- Stimulus generator
stimulus: process
begin
	enable_tb <= '1';
	Sin_tb <= '1';
	wait for MCLK_HALF_PERIOD*2;
	
	Sin_tb <= '1';
	wait for MCLK_HALF_PERIOD*2;
	
	Sin_tb <= '0';
	wait for MCLK_HALF_PERIOD*2;
	
	Sin_tb <= '1';
	wait for MCLK_HALF_PERIOD*2;
	
	Sin_tb <= '1';
	wait for MCLK_HALF_PERIOD*2;
	
	Sin_tb <= '0';
	wait for MCLK_HALF_PERIOD*2;
	
	Sin_tb <= '1';
	wait for MCLK_HALF_PERIOD*2;
	
	Sin_tb <= '0';
	wait for MCLK_HALF_PERIOD*2;
	
	Sin_tb <= '1';
	wait for MCLK_HALF_PERIOD*2;
	
	Sin_tb <= '1';
	wait for MCLK_HALF_PERIOD*2;
	
	wait;
end process;

end arq;