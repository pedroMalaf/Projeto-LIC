LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity decoderHex IS
PORT (A: in std_logic_vector(3 downto 0);		
		clear : in std_logic;
		HEX0 : out std_logic_vector(7 downto 0));		
END decoderHex;

Architecture logicFuntion of decoderHex is

component int7seg
PORT(	d: IN STD_LOGIC_vector(3 downto 0);
		dOut: out std_logic_vector(7 downto 0)
		);
END component;


signal HEX0t: std_logic_vector(7 downto 0);

BEGIN

HEX0 <= HEX0t when clear = '0' else "11111111";


U0: int7seg port map(A, HEX0t);

									
END logicFuntion;	