-- mux 8x1 

LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;

ENTITY KT_mux IS
    PORT (
		D : in STD_LOGIC_VECTOR(7 downto 0);
		S : in STD_LOGIC_VECTOR(2 downto 0);
		Data_Out: out STD_LOGIC
    );
END KT_mux;

ARCHITECTURE arq OF KT_mux IS
BEGIN
    process(D, S)
			begin
				case S is
					when "000" => Data_Out <= D(0);
					when "001" => Data_Out <= D(1);
					when "010" => Data_Out <= D(2);
					when "011" => Data_Out <= D(3);
					when "100" => Data_Out <= D(4);
					when "101" => Data_Out <= D(5);
					when "110" => Data_Out <= D(6);
					when "111" => Data_Out <= D(7);
					when others => Data_Out <= '1'; -- 0
				end case;
			end process;
END arq;