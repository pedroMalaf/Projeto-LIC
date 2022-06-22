-- key transmitter 

LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;

ENTITY key_transmitter IS
    PORT (
		clk: IN STD_LOGIC;
		DAV: IN STD_LOGIC; -- (from K_val - "Key Decode")
		D: IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- (from K - "Key Decode")
		TX_clk: IN STD_LOGIC; -- (from RX_clk - "Control")
		reset : IN STD_LOGIC;
		DAC: OUT STD_LOGIC; -- data accepted (to K_ack - "Key Decode")
		TX_D: OUT STD_LOGIC -- (to RX_D - "Control")
    );
END key_transmitter;

ARCHITECTURE arq OF key_transmitter IS

	COMPONENT key_transmitter_control
		PORT(
			DAV : IN STD_LOGIC;
			Tcount : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			DAC : OUT STD_LOGIC;
			Ereg : OUT STD_LOGIC;
			Ecounter : OUT STD_LOGIC;
			Rcounter : OUT STD_LOGIC
		);
	
	END COMPONENT;
	
	COMPONENT KT_counter 
		PORT(
			CE, clk, reset: IN STD_LOGIC;
			TC: OUT STD_LOGIC;
			Count : OUT STD_LOGIC_VECTOR(2 downto 0)
		);
		
		END COMPONENT;
		
	COMPONENT reg
		PORT(
			F : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			CE, RESET : IN STD_LOGIC;
			CLK : IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
		
		END COMPONENT;

	COMPONENT KT_mux 
		PORT( 
			D : in STD_LOGIC_VECTOR(7 downto 0);
			S : in STD_LOGIC_VECTOR(2 downto 0);
			Data_Out: out STD_LOGIC
		);
		
		END COMPONENT;

	
	SIGNAL reset_s, TX_D_s, TC_s, Ecounter_s, Rcounter_s, Ereg_s: STD_LOGIC;
	SIGNAL Count_s : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL Q_s : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	
BEGIN

	TX_D <= TX_D_s;
	reset_s <= reset; -- TODO: reset

	u_key_transmitter_control : key_transmitter_control
		PORT MAP(
			DAV => DAV,
			Tcount => TC_s,
			clk => clk,
			reset => reset_s,
			DAC => DAC,
			Ereg => Ereg_s,
			Ecounter => Ecounter_s,
			Rcounter => Rcounter_s
			
		);
		
	u_KT_Scounter : KT_counter
		PORT MAP(
			reset => Rcounter_s,
			clk => TX_clk,
			CE => Ecounter_s,
			TC => TC_s,
			Count => Count_s
		);
		
	u_reg : reg 
		PORT MAP(
			reset => reset_s,
			F => D,
			CE => EReg_s,
			clk => clk,
			Q => Q_s
		);
	
	u_KT_mux : KT_mux
		PORT MAP(
			D(0) => Rcounter_s,
			D(1) => '1',
			D(2) => Q_s(0),
			D(3) => Q_s(1),
			D(4) => Q_s(2),
			D(5) => Q_s(3),
			D(6) => '0',
			D(7) => '1',
			
			S => Count_s,
			Data_Out => TX_D_s
		);

END arq;