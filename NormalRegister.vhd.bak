LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity G_Register IS
 Generic (n:integer:=31);
port(
  D:IN std_logic_vector(2 downto 0);
  Q:OUT std_logic_vector(2 downto 0);
  clk,rst,enable:IN std_Logic
);
END ENTITY;

Architecture a_G_Register OF G_Register IS

begin

PROCESS(clk,rst)
begin
  IF(rst='1') THEN
  Q <=(others=>'0');
ELSIF falling_edge(clk) THEN
  if(enable='1') then   
  Q<=D;
END IF;
END IF;
END PROCESS;
END Architecture;
