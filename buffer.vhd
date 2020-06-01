LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity G_Register1 IS
 Generic (n:integer:=32);
port(
  D:IN std_logic_vector(n-1 downto 0);
  Q:OUT std_logic_vector(n-1 downto 0):=(others =>'0');
  clk,rst,enable,flush:IN std_Logic
);
END ENTITY;

Architecture a_G_Register OF G_Register1 IS

begin

PROCESS(clk,rst,flush)
begin
  IF(rst='1') THEN
  Q <=(others=>'0');
elsif rising_edge(flush) then	
 Q <=(others=>'0');
ELSIF rising_edge(clk) THEN
  if(enable='1') then   
  Q<=D;
END IF;
END IF;
END PROCESS;
END Architecture;
