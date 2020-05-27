LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity reg IS 
port(
  D1,D2:IN std_logic_vector(31 downto 0);
  Q:OUT std_logic_vector(31 downto 0):=(others =>'0');
  clk,rst,enable1,enable2:IN std_Logic
);
END ENTITY;

Architecture a_reg OF reg IS

begin

PROCESS(clk,rst)
begin
  IF(rst='1') THEN
  Q <=(others=>'0');
ELSIF falling_edge(clk) THEN
  if(enable1='1') then   
  Q<=D1;
END IF;
  if(enable2='1') then
  Q<=D2;
End IF;
  if(enable1='1' and enable2='1') then
  Q<=D1;
END IF;
END IF;
END PROCESS;
END Architecture;