LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity mux_4x1 is
GENERIC (n : integer := 32);
 port(
     A,B,C,D : IN std_logic_vector(n-1 downto 0);
     S0,S1: IN std_logic;
     Z: OUT std_logic_vector(n-1 downto 0)
  );
end mux_4x1;
 
architecture mux_4x1_arch of mux_4x1 is
begin
process (A,B,C,D,S0,S1) is
begin
  if (S0 ='0' and S1 = '0') then
      Z <= A;
  elsif (S0 ='1' and S1 = '0') then
      Z <= B;
  elsif (S0 ='0' and S1 = '1') then
      Z <= C;
  else
      Z <= D;
  end if;
 
end process;
end mux_4x1_arch;
