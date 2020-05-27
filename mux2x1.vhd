LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity mux_2x1 is
GENERIC (n : integer := 32); 
 port(
     A,B : IN std_logic_vector(n-1 downto 0);
     S0: IN std_logic;
     Z: OUT std_logic_vector(n-1 downto 0)
  );
end mux_2x1;
 
architecture mux_2x1_arch of mux_2x1 is
begin 
      Z <= A when S0='0'
  else
      B;
 
end mux_2x1_arch;
