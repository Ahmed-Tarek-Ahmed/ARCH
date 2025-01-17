LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ram IS
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(10 DOWNTO 0);
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY ram;

ARCHITECTURE syncrama OF ram IS

	TYPE ram_type IS ARRAY(0 TO 2047) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram : ram_type ;
	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF falling_edge(clk) THEN  
					IF we = '1' THEN
						ram(to_integer(unsigned(address))+1) <= datain(31 downto 16);
						ram(to_integer(unsigned(address))) <= datain(15 downto 0);
					END IF;
				END IF;
		END PROCESS;
		dataout <= ram(0) & ram(to_integer(unsigned(address)))  when address="11111111111"
			else
		ram(to_integer(unsigned(address))+1) & ram(to_integer(unsigned(address)));
END syncrama;
