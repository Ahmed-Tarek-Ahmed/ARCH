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
s <= (a XOR b) XOR Cin;
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
f0:my_adder port map(A1(0),B1(0),Cin1,sum(0),temp(0));
loop1: FOR i IN 1 TO n-1 GENERATE
fx: my_adder PORT MAP(A1(i),B1(i),temp(i-1),sum(i),temp(i));
END GENERATE;
Cout1<=temp(n-1);
end ARCHITECTURE;


