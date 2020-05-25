LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity processor IS 
port(
	clk:IN std_logic;
	input :IN std_logic_vector (31 downto 0);
	output :OUT std_logic_vector (31 downto 0);
	reset,intr :IN std_logic
);
END ENTITY;

Architecture p1 OF processor IS
component ALU is
GENERIC (n : integer := 32);  
port(A,B :IN std_logic_vector (n-1 downto 0);
	Sel :IN std_logic_vector (3 downto 0);
	Imm :IN std_logic_vector(5 downto 0);
	Coutin,Negin,Zeroin : IN std_logic;
	Cout:OUT std_Logic;
	Neg: OUT std_logic;
	Zero:OUT std_logic;
	F: OUT std_logic_vector(n-1 downto 0));
end component;
component HazardDetection is
port(
  RdstMem,Rsrc1,Rsrc2 : IN std_logic_vector (2 downto 0);
  WB_MemRead :IN std_logic;
  currentFunction : IN std_logic_vector (1 downto 0);
  DecodeFlush,PC_Stall,IfIdSignal : OUT std_logic
);
END component;
component down_counter is
  port (
    clock: in std_logic;
    reset: in std_logic;
    enable: in std_logic;
    load_data: in std_logic_vector(1 downto 0);
    output: out std_logic_vector(1 downto 0)
  );
end component;
component instmem IS
	PORT(
		address : IN  std_logic_vector(10 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END component;
component Control IS
	PORT(
		opcode : IN  std_logic_vector(5 DOWNTO 0);
		INT : IN std_logic;
		AlUF :OUT std_logic_vector(3 DOWNTO 0);
		currfun,BatE,WB,Ccontrol,ImmSel,flgsel :OUT std_logic_vector(1 DOWNTO 0);
		BatM,Outen,MR,MW,MWsel,WBsel,IMDTRSRC,stacken,stackcont,Flgen: OUT std_logic);
END component ;
component MultCyc IS
	PORT(
		C,CControl,WSel: IN  std_logic_vector(1 DOWNTO 0);
		BatM,RM,WM,Stack : IN  std_logic;
		NBatM,NRM,NWM,NStack,cenable: OUT std_logic;
		NWSel: OUT std_logic_vector(1 DOWNTO 0));
END component;
component Forward IS
Port(
  Rsrc1,Rsrc2,RdstMem,RdstWB : IN std_logic_vector (2 downto 0);
  WB_SMem,WB_SWB : IN std_logic_vector (1 downto 0);
  outMem,outWB: IN std_logic;
  Rsrc1MUX,Rsrc2MUX : OUT std_logic_vector (2 downto 0)
);
END component;
component RegisterFile IS
PORT(
    ReadReg1,ReadReg2,WriteReg1,WriteReg2 : IN std_logic_vector (2 downto 0);
    ReadData1,ReadData2 : OUT std_logic_vector (31 downto 0);
    WriteData1,WriteData2 : IN std_logic_vector (31 downto 0);
    WriteBack1,WriteBack2,CLK,RST: IN std_logic

);
END component;
component G_Register IS
 Generic (n:integer:=32);
port(
  D:IN std_logic_vector(n-1 downto 0);
  Q:OUT std_logic_vector(n-1 downto 0);
  clk,rst,enable:IN std_Logic
);
END component;
component pcmux IS
	PORT(
		BatM,BatE,Rst: IN  std_logic;
		PcE,pcM,Pcadd,pcm01 : IN  std_logic_vector(10 DOWNTO 0);
		Naddress: OUT std_logic_vector(10 DOWNTO 0)
);
END component ;
component NADDER is
GENERIC (n : integer := 32);  
port(A1,B1 :IN std_logic_vector (n-1 downto 0);
  Cin1:IN std_logic;
	Cout1:OUT std_Logic;
	sum: OUT std_logic_vector(n-1 downto 0));
end component;
--------------------Fetch-----------------------
signal PcE,PcM,pcm01,pcadd,npc,FPC: std_logic_vector(10 downto 0);
signal BatE,BatM,pcen,flag,Fflush:std_logic;
signal zero:std_logic:='0';
signal branchE :std_logic_vector(1 downto 0);
signal inst  :std_logic_vector(31 downto 0);
signal pcInc:std_logic_vector(10 downto 0);
---------------------Decode--------------------
signal opCode : std_logic_vector (5 downto 0);
signal intrpt : std_logic ;
signal pc : std_logic_vector  (10 downto 0);
signal Rsrc1,Rsrc2,Rdst : std_logic_vector(2 downto 0);
signal inputPort : std_logic_vector(31 downto 0);
signal imdtValue: std_logic_vector (15 downto 0);
signal EAadress : std_logic_vector (19 downto 0);
-----------------------------------------------
---------------------RegFile Signals-----------
signal WriteReg1,WriteReg2 : std_logic_vector(2 downto 0);
signal WriteData1,WriteData2_MEM : std_logic_vector(31 downto 0);
signal ReadData1,ReadData2 : std_logic_vector (31 downto 0);
signal WriteBack1_MEM,WriteBack2_MEM: std_logic;
-----------------------------------------------
-------------------Decode Write Register MUX---
signal RdstMEM,Rsrc2MEM : std_logic_vector(2 downto 0);
-----------------------------------------------
-------------------Extend Signals--------------
signal imdtExtend:  std_logic_vector(31 downto 0);
signal EAExtend:  std_logic_vector(31 downto 0);
signal imdtValueSelected : std_logic_vector(31 downto 0);
signal imdtSelector : std_logic_vector(1 downto 0);
-----------------------------------------------
------------------Control Unit Signals---------
signal DAlUF : std_logic_vector(3 DOWNTO 0);
signal Dcurrfun,DBatE,DWB,DCcontrol,DImmSel,Dflgsel : std_logic_vector(1 DOWNTO 0);
signal DBatM,DOuten,DMR,DMW,DMWsel,DWBsel,DIMDTRSRC,Dstacken,Dstackcont,DFlgen: std_logic;
signal BeforeCUMUX : std_logic_vector (18 downto 0);
signal AfterCUMUX : std_logic_vector (18 downto 0);
signal OrOUT : std_logic;
-----------------------------------------------
-----------------------Execute-----------------
signal Aluin1,Aluin2,ALURes : std_logic_vector(31 downto 0);
signal Rsrc1D,Rscr2D,Immval : std_logic_vector(31 downto 0);
signal BranchatMem,FlagED,AndMem,FlagEnable,Flag2F,ALUCont : std_logic;
signal FlagsMem : std_logic_vector(2 downto 0);
signal FlagSelec : std_logic_vector(1 downto 0);
signal AluCon : std_logic_vector(3 downto 0);
signal FlagsE,Flagsin,FlagsO : std_logic_vector(2 downto 0);
signal PCEX : std_logic_vector(10 downto 0);
signal CounterConDB,CounterConE : std_logic_vector(1 downto 0);
signal BrnchMemDB,BrnchMemE,OpRegEnDB,OpRegEnE : std_logic;
signal MEMDB,MEME : std_logic_vector(2 downto 0);
signal WBDB,WBE : std_logic_vector(2 downto 0);
signal trashcan : std_logic;
signal Rsc1DB,Rsc1E,Rsc2DB,Rsc2E,RdstDB,RdstE : std_logic_vector(2 downto 0);
-----------------------------------------------
begin
ControlUnit : Control port map (opCode,intrpt,DAlUF,Dcurrfun,DBatE,DWB,DCcontrol,DImmSel,Dflgsel,DBatM,DOuten,DMR,DMW,DMWsel,DWBsel,DIMDTRSRC,Dstacken,Dstackcont,DFlgen);
pcmux1:pcmux port map(batm,bate,reset,pce,pcm,pcadd,pcm01,npc);
pcreg: G_register generic map(11) port map(npc,PC,clk,reset,pcen);
instmem1:instmem port map(Fpc,inst);
RegFile : RegisterFile port map (Rsrc1,Rsrc2,WriteReg1,WriteReg2,ReadData1,ReadData2,WriteData1,WriteData2_MEM,WriteBack1_MEM,WriteBack2_MEM,clk,reset);
BatE<=((not flag)and branchE(1)) or branchE(0);
pcADDER: NADDER generic map(11) port map(pcinc,fpc,zero,open,pcadd);
pcinc<= "00000000001" when inst(26)='1' else
	"00000000010";
-------------------Decode Write Register MUX---
WriteReg2<= RdstMEM when (WriteBack2_MEM='0') ELSE  Rsrc2MEM ;
-------------------------------------------
-------------------Extend MUX--------------
imdtExtend<="0000000000000000"&imdtValue;
EAExtend <= "000000000000"&EAadress;
imdtValueSelected<= imdtExtend when DImmSel="00"
ELSE  inputPort when DImmSel="01"
ELSE  EAExtend  when DImmSel="10";
-----------------------------------------------
------------------Control Unit MUX-------------
BeforeCUMUX<= DCcontrol&DBatM&DBatE&DOuten&DWB&DWBsel&DMR&DMW&DMWsel&DAlUF&DFlgen&Dflgsel;--212121111412
AfterCUMUX<= BeforeCUMUX when (OrOUT='0') ELSE "0000000000000000000";
-----------------------------------------------

-----------------------Execute-----------------
FlagEnable <= (FlagED AND BranchatMem) OR AndMem;
FlagsE <= FlagsO when AndMem='0'
else FlagsMem when AndMem='1';
FlagReg : G_Register generic map(3) port map(FlagsE,Flagsin,clk,reset,FlagEnable);
Flag2F <= Flagsin(0) when FlagSelec = "00"
else Flagsin(1) when FlagSelec = "01"
else Flagsin(2) when FlagSelec = "10";
Aluin1 <= Rsrc1D;
Aluin2 <= Rscr2D when ALUCont ='0'
else Immval when ALUCont='1';
ALUMain : ALU port map(Aluin1,Aluin2,AluCon,Immval(5 downto 0),Flagsin(2),Flagsin(1),Flagsin(0),FlagsE(2),FlagsE(1),FlagsE(0),ALURes);
AdderEX : NADDER generic map(11) port map(PCE,"00000000001",'0',trashcan,PCEX);
CounterConE <= CounterConDB when BranchatMem='0'
else "00" when BranchatMem ='1';
BrnchMemE  <= BrnchMemDB when BranchatMem='0'
else '0' when BranchatMem ='1';
OpRegEnE  <= OpRegEnDB when BranchatMem='0'
else '0' when BranchatMem ='1';
MEME   <= MEMDB when BranchatMem='0'
else "000" when BranchatMem ='1';
WBE  <= WBDB when BranchatMem='0'
else "000" when BranchatMem ='1'; 
Rsc1E  <= Rsc1DB;
Rsc2E <= Rsc2DB;
RdstE <= RdstDB;
-----------------------------------------------



END Architecture;