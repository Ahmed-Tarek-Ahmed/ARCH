Library ieee;
use ieee.std_logic_1164.all;

Entity Forward IS
Port(
  Rsrc1,Rsrc2,RdstMem,RdstWB : IN std_logic_vector (2 downto 0);
  WB_SMem,WB_SWB : IN std_logic_vector (1 downto 0);
  outMem,outWB: IN std_logic;
  Rsrc1MUX,Rsrc2MUX : OUT std_logic_vector (2 downto 0)
);
END ENTITY;

Architecture a_Forward OF Forward IS
  begin
PROCESS(Rsrc1,Rsrc2,RdstMem,RdstWB,WB_SMem,WB_SWB,outMem,outWB)
  begin
  IF (Rsrc1=RdstMem) then
    IF (WB_SMem= "01") then
        Rsrc1MUX<= "010";
        --Rsrc2MUX<= "001";
    ELSIF (WB_SMem(1)='1')then
        Rsrc1MUX<= "100";
        --Rsrc2MUX<= "001";
    ELSE
    IF (Rsrc1=RdstWB ) then
    IF (WB_SWB= "01") then
        Rsrc1MUX<= "011";
        --Rsrc2MUX<= "001";
    ELSIF (WB_Swb(1)='1')then
        Rsrc1MUX<= "000";
        --Rsrc2MUX<= "001";
    ELSE
      Rsrc1MUX<= "001";
    END IF;
         ELSE
      Rsrc1MUX<= "001";
    END IF;
    End if;
  ELSIF (Rsrc1=RdstWB ) then
    IF (WB_SWB= "01") then
        Rsrc1MUX<= "011";
        --Rsrc2MUX<= "001";
    ELSIF (WB_Swb(1)='1')then
        Rsrc1MUX<= "000";
        --Rsrc2MUX<= "001";
    ELSE
      Rsrc1MUX<= "001";
    END IF;
   ELSE  Rsrc1MUX<= "001";
  END IF;
  IF (Rsrc2=RdstMem ) then
    IF (WB_SMem= "01") then
        Rsrc2MUX<= "010";
        --Rsrc1MUX<= "001";
    ELSIF (WB_SMem(1)='1')then
        Rsrc2MUX<= "100";
        --Rsrc1MUX<= "001";
    ELSE
      IF (Rsrc2=RdstWB ) then
    IF (WB_SWB= "01") then
        Rsrc2MUX<= "011";
        --Rsrc1MUX<= "001";
    ELSIF (WB_Swb(1)='1')then
        Rsrc2MUX<= "000";
        --Rsrc1MUX<= "001";
    ELSE
      Rsrc2MUX<= "001";
    END IF;
	else
   Rsrc2MUX<= "001";
    END IF;
    END IF;
    
  ELSIF (Rsrc2=RdstWB ) then
    IF (WB_SWB= "01") then
        Rsrc2MUX<= "011";
        --Rsrc1MUX<= "001";
    ELSIF (WB_Swb(1)='1')then
        Rsrc2MUX<= "000";
        --Rsrc1MUX<= "001";
    ELSE
      Rsrc2MUX<= "001";
    END IF;
  ELSE
    Rsrc2MUX<= "001";
END IF;
END PROCESS;
END Architecture;