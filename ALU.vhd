LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;   

entity ALU is
GENERIC (n : integer := 32);  
port(A,B :IN std_logic_vector (n-1 downto 0);
	Sel :IN std_logic_vector (3 downto 0);
	Imm :IN std_logic_vector(5 downto 0);
	Coutin,Negin,Zeroin : IN std_logic;
	Cout:OUT std_Logic;
	Neg: OUT std_logic;
	Zero:OUT std_logic;
	F: OUT std_logic_vector(n-1 downto 0));
end ALU;

ARCHITECTURE ALU1 of ALU is
 COMPONENT NADDER is
GENERIC (n : integer := 32);  
port(A1,B1 :IN std_logic_vector (n-1 downto 0);
	Cin1: IN std_logic;
	Cout1:OUT std_Logic;
	sum: OUT std_logic_vector(n-1 downto 0));
 END COMPONENT ; 
 signal in1,in2,out1,out2,out3,Mout : std_logic_vector (n-1 downto 0);
 signal cout1,C : std_Logic;
 begin 
 in1 <= A when Sel="0000"
 else (Others => '0') when Sel="0001"
 else A when Sel="0100"
 else A when Sel="0101"  
 else A when Sel="0110"
 else A when Sel="0111"  
 else A when Sel="1000"
 else A when Sel="1001"
 else A when Sel="1010"
 else A when Sel="1011"
 else A when Sel="1100";  
   
 in2 <= (Others => '0') when Sel="0000"  
 else B  when Sel="0001"
 else "00000000000000000000000000000001"  when Sel="0101"
 else "11111111111111111111111111111111"  when Sel="0110"
 else B  when Sel="0111"
 else not B  when Sel="1000"
 else B  when Sel="1001"
 else B  when Sel="1010";
   
c <= '1' when Sel="1000"
else '0';
u0 : NADDER GENERIC MAP (n) PORT MAP(in1(31 downto 0),in2(31 downto 0),C,cout1,out1(31 downto 0)) ;
   
  out2 <= std_logic_vector(shift_left(unsigned(A),to_integer(unsigned(Imm)))) ;
  out3 <= std_logic_vector(shift_right(unsigned(A),to_integer(unsigned(Imm)))) ;  
   
 Mout <= in1 when Sel="0000"
 else in2 when Sel="0001"
 else in1 when Sel="0010"
 else in1 when Sel="0011"
 else not in1 when Sel="0100"
 else out1 when Sel="0101"
 else out1 when Sel="0110"
 else out1 when Sel="0111"
 else out1 when Sel="1000"
 else in1 and in2 when Sel="1001"
 else in1 or in2 when Sel="1010"
 else out2 when Sel="1011"
 else out3 when Sel="1100"
 else in1 when Sel="1101"  
 else in1 when Sel="1110";
   
Cout <= Coutin when (Sel="0000") or (Sel="0001") or (Sel="0100") or (Sel="1001") or (Sel="1010") or (Sel="1101") or (Sel="1110")
else '1' when Sel="0010"
else '0' when Sel="0011"
else cout1;
   
Neg <= '0' when Sel="1110"
else Negin when Sel="0000" or Sel="0001" or Sel="0010" or Sel="0011" or Sel="1101"
else '1' when Mout(31)='1'
else '0';
 
Zero <= '0' when Sel="1101"
else Zeroin when Sel="0000" or Sel="0001" or Sel="0010" or Sel="0011" or Sel="1110"
else '1' when Mout="00000000000000000000000000000000"
else '0';

F<=Mout;
  
 end architecture;