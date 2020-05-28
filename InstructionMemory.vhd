LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY instmem IS
	PORT(
		address : IN  std_logic_vector(10 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY instmem;

ARCHITECTURE instmem1 OF instmem IS

	TYPE ram_type IS ARRAY(0 TO 2047) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram : ram_type ;
BEGIN
	dataout <=   ram(to_integer(unsigned(address))) & ram(0) when address="11111111111"
			else
		ram(to_integer(unsigned(address))) & ram(to_integer(unsigned(address))+1);
END instmem1;