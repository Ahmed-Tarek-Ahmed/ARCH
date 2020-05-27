LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity stack IS

port(
  D:IN std_logic_vector(10 downto 0);
  Q:OUT std_logic_vector(10 downto 0):="11111111110";
  clk,rst,enable:IN std_Logic
);
END ENTITY;

Architecture stack1 OF stack IS

begin

PROCESS(clk,rst)
begin
  IF(rst='1') THEN
  Q <="11111111110";
ELSIF falling_edge(clk) THEN
  if(enable='1') then   
  Q<=D;
END IF;
END IF;
END PROCESS;
END Architecture;
