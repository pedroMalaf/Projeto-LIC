-- IOS Dispatcher Testbench TODO

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dispatcher_tb IS
END dispatcher_tb;

ARCHITECTURE arqui OF dispatcher_tb IS

    COMPONENT dispatcher IS
        PORT (
            reset, clk : IN STD_LOGIC;
            Fsh, Dval : IN STD_LOGIC;
            Din : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            WrT, WrL : OUT STD_LOGIC;
            Dout : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
            done : OUT STD_LOGIC
        );
    END COMPONENT;

    CONSTANT MCLK_PERIOD : TIME := 20 ns;
    CONSTANT MCLK_HALF_PERIOD : TIME := MCLK_PERIOD / 2;

    SIGNAL Fsh_tb, Dval_tb : STD_LOGIC;
    SIGNAL Din_tb : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL Dout_tb : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL WrT_tb, WrL_tb : STD_LOGIC;
    SIGNAL done_tb : STD_LOGIC;
    SIGNAL clk_tb, reset_tb : STD_LOGIC;

BEGIN
    UUT : dispatcher
    PORT MAP(
        Fsh => Fsh_tb,
        Dval => Dval_tb,
        Din => Din_tb,
        Dout => Dout_tb,
        WrT => WrT_tb,
        WrL => WrL_tb,
        done => done_tb,
        reset => reset_tb,
        clk => clk_tb
    );

    clk_gen : PROCESS
    BEGIN
        clk_tb <= '0';
        WAIT FOR MCLK_HALF_PERIOD;
        clk_tb <= '1';
        WAIT FOR MCLK_HALF_PERIOD;
    END PROCESS;

    stimulus : PROCESS
    BEGIN
		-- idk 
		reset_tb <= '1';
		WAIT FOR MCLK_PERIOD;
		reset_tb <= '0';
		WAIT FOR MCLK_PERIOD;
		
        -- 00 -> 00
        Dval_tb <= '0';
        WAIT FOR MCLK_PERIOD;

        -- 00 -> 01 wrT 1!
        Dval_tb <= '1';
        Din_tb <= "1000011111";
        WAIT FOR MCLK_PERIOD;

        -- 11 -> 00
        Fsh_tb <= '1';
        WAIT FOR MCLK_PERIOD*10;

        -- 00 -> 10 wrL 0!
        Dval_tb <= '1';
        Din_tb <= "0000011110";
        Fsh_tb <= '0'; -- Test if goes back to 11
        WAIT FOR MCLK_PERIOD;

        WAIT;
    END PROCESS;

END arqui;