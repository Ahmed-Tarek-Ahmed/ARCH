Library ieee;
use ieee.std_logic_1164.all;

Entity HazardDetection is
port(
  RdstMem,Rsrc1,Rsrc2 : IN std_logic_vector (2 downto 0);
  WB_MemRead :IN std_logic;
  currentFunction : IN std_logic_vector (1 downto 0);
  DecodeFlush,PC_Stall,IfIdSignal : OUT std_logic
);
END ENTITY;

Architecture a_HazardDetection of HazardDetection IS
  begin
  process (RdstMem,Rsrc1,Rsrc2,WB_MemRead,currentFunction)
  begin
IF(WB_MemRead='1')then
   IF(RdstMem=Rsrc1 and currentFunction(0)='1')then 
        DecodeFlush<='1';
        PC_Stall<='1';
        IfIdSignal<='1';
    ELSIF (RdstMem=Rsrc2 and currentFunction(1)='1')then
        DecodeFlush<='1';
        PC_Stall<='1';
        IfIdSignal<='1';
    ELSE
        DecodeFlush<='0';
        PC_Stall<='0';
        IfIdSignal<='0';
    END IF;
ELSE
  DecodeFlush<='0';
  PC_Stall<='0';
  IfIdSignal<='0';
    END IF;
END PROCESS;
END Architecture;