LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY my_adder IS
PORT (a,b,Cin : IN  std_logic;
s, cout : OUT std_logic );
END my_adder;

ARCHITECTURE a_my_adder OF my_adder IS
	BEGIN
s <= a XOR b XOR Cin;
cout <= (a AND b) OR (cin AND (a XOR b));
END a_my_adder;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
entity NADDER is
GENERIC (n : integer := 32);  
port(A1,B1 :IN std_logic_vector (n-1 downto 0);
  Cin1:IN std_logic;
	Cout1:OUT std_Logic;
	sum: OUT std_logic_vector(n-1 downto 0));
end NADDER;

ARCHITECTURE A of NADDER is
COMPONENT my_adder IS	
PORT (a,b,Cin : IN  std_logic;
 s, cout : OUT std_logic ); 	
 END COMPONENT ;
signal temp :std_logic_vector(n-1 downto 0);
begin 
temp(0) <= Cin1;
loop1: FOR i IN 0 TO n-2 GENERATE
fx: my_adder PORT MAP(A1(i),B1(i),temp(i),sum(i),temp(i+1));
END GENERATE;
f31: my_adder PORT MAP(A1(31),B1(31),temp(31),sum(31),Cout1);
end ARCHITECTURE;