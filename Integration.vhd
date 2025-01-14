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
component G_Register1 IS
 Generic (n:integer:=32);
port(
  D:IN std_logic_vector(n-1 downto 0);
  Q:OUT std_logic_vector(n-1 downto 0):=(others =>'0');
  clk,rst,enable,flush:IN std_Logic
);
END component;
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
		C,CControl: IN  std_logic_vector(1 DOWNTO 0);
		BatM,RM,WM,Stack,WSel : IN  std_logic;
		NBatM,NRM,NWM,NStack,cenable: OUT std_logic;
		NWSel: OUT std_logic_vector(1 DOWNTO 0));
END component;
component Forward IS
Port(
  Rsrc1,Rsrc2,RdstMem,RdstWB: IN std_logic_vector (2 downto 0);
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
    WriteBack1,WriteBack2,CLK,RST: IN std_logic;
	r0,r1,r2,r3,r4,r5,r6,r7 : OUT std_logic_vector (31 downto 0)
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
component stack IS

port(
  D:IN std_logic_vector(10 downto 0);
  Q:OUT std_logic_vector(10 downto 0):="11111111110";
  clk,rst,enable:IN std_Logic
);
END component;
-------------------4x1 mux-----------------------
component mux_4x1 is
GENERIC (n : integer := 32);
 port(
     A,B,C,D : IN std_logic_vector(n-1 downto 0);
     S0,S1: IN std_logic;
     Z: OUT std_logic_vector(n-1 downto 0)
  );
end component;
-------------------2x1 mux----------------------
component mux_2x1 is
GENERIC (n : integer := 32); 
 port(
     A,B : IN std_logic_vector(n-1 downto 0);
     S0: IN std_logic;
     Z: OUT std_logic_vector(n-1 downto 0)
  );
end component;
-------------------RAM---------------------------
component ram is
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(10 DOWNTO 0);
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END component;
signal r0,r1,r2,r3,r4,r5,r6,r7 :  std_logic_vector (31 downto 0);
--------------------Fetch-----------------------
signal PcE1,pcm01,pcadd,npc,FPC,PCE: std_logic_vector(10 downto 0);
signal BatE,pcen,flag,Fflush,resetf:std_logic;
signal zero:std_logic:='0';
signal opcodeF:std_logic_vector(5 downto 0);
signal ONE:std_logic:='1';
signal branchE :std_logic_vector(1 downto 0);
signal inst  :std_logic_vector(31 downto 0);
signal pcInc:std_logic_vector(10 downto 0);
signal Finbuffer,Foutbuffer:std_logic_vector(75 downto 0);
---------------------Decode--------------------
signal opCode : std_logic_vector (5 downto 0);
signal intrpt : std_logic ;
signal PC : std_logic_vector  (10 downto 0);
signal Rsrc1,Rsrc2,Rdst : std_logic_vector(2 downto 0);
signal inputPort : std_logic_vector(31 downto 0);
signal imdtValue: std_logic_vector (15 downto 0);
signal EAadress : std_logic_vector (10 downto 0);
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


signal FLAGS_EXTENDED:  std_logic_vector(31 downto 0);
signal ALU_result_cut:  std_logic_vector(10 downto 0);
------------------Memory signals (TEMP)---------------
signal ALU_result:  std_logic_vector(31 downto 0);
signal RSRC1_data:  std_logic_vector(31 downto 0);
signal PC_OUT:  std_logic_vector(10 downto 0);
signal PC_OUT_EXTEND:  std_logic_vector(31 downto 0);
signal FLAGS:  std_logic_vector(2 downto 0);

signal TEMP_MUX_BEFOREMEM : std_logic_vector(1 downto 0);

signal multi_cycle_write_select: std_logic;
signal counter_control: std_logic_vector(1 downto 0);
signal branch_atMEM,mem_read_control,mem_write_control,stack_enable,inc_dec: std_logic;
signal stack1 : std_logic;
signal WIRE_MEM_TO_EXEC: std_logic;

------------------Memory signals (NOT TEMP)---------------
signal ADD_2: std_logic_vector(10 downto 0);
signal ADD_neg2: std_logic_vector(10 downto 0);
signal ADD_0: std_logic_vector(10 downto 0);

signal cin_SP: std_logic;
signal cout_SP: std_logic;
signal NADDER_output: std_logic_vector(10 downto 0);
signal SP_OUTPUT: std_logic_vector(10 downto 0);

signal MUX_2x1_beforeadd_out,MUX_2x1_afteradd_out: std_logic_vector(10 downto 0);
signal MUX_2x1_to_mem_out: std_logic_vector(10 downto 0); 
signal MUX_4X1_to_Counter_LOAD0:std_logic_vector(1 downto 0);
signal MUX_4X1_to_Counter_LOAD2:std_logic_vector(1 downto 0);
signal MUX_4X1_to_Counter_LOAD3:std_logic_vector(1 downto 0);
signal MUX_4X1_to_Counter_LOADVOID:std_logic_vector(1 downto 0);
signal MUX_4X1_to_Counter_OUT:std_logic_vector(1 downto 0);

signal counter_output: std_logic_vector(1 downto 0);

signal MEMORY_ADDRESS: std_logic_vector(10 downto 0);
signal WRITE_DATA: std_logic_vector(31 downto 0);
signal READ_DATA: std_logic_vector(31 downto 0);

signal stall_memory: std_logic;
signal NEW_BRANCH_atMEM: std_logic;
signal new_read_mem,new_write_mem,new_stack_enable,new_counter_enable: std_logic;
signal new_write_select_toMux4x1: std_logic_vector(1 downto 0);
signal MSB_SELEC_MUX4x1_Address: std_logic;
--------------------------------------------------------------------
---------------------MEM/WB BUFFER_OUT_SIGNALS----------------------
--read data already 
signal Rsrc1MemB,Rsrc2MemB,RdstMemB: std_logic_vector(2 downto 0);
signal Rsrc2dataMemB : std_logic_vector(31 downto 0);
--RESULT already declared
signal WBMemB : std_logic_vector(2 downto 0);
signal opregMemB : std_logic;
signal BUS_TO_MEM_WB_BUFFER_IN: std_logic_vector(108 downto 0); 
signal BUS_TO_MEM_WB_BUFFER_OUT: std_logic_vector(108 downto 0); 
signal ENABLE_BUFFER_MEM_TO_WB: std_logic;
---------------------WB_SIGNALS_FROMBUFFER---------------------
signal Rsrc1MemB_WB,Rsrc2MemB_WB,RdstMemB_WB: std_logic_vector(2 downto 0);
signal Rsrc2dataMemB_WB : std_logic_vector(31 downto 0);
signal WBMemB_WB : std_logic_vector(2 downto 0);
signal opregMemB_WB : std_logic;
signal ALU_result_WB:  std_logic_vector(31 downto 0);
signal READ_DATA_WB: std_logic_vector(31 downto 0); 
---------------------WB_SIGNALS--------------------------------
signal MUX2x1_WB_OUT:std_logic_vector(31 downto 0);
signal ENABLE_OUTPUT_PORT: std_logic;
------------------Control Unit Signals-------------------------
signal DAlUF : std_logic_vector(3 DOWNTO 0);
signal Dcurrfun,DBatE,DWB,DCcontrol,DImmSel,Dflgsel : std_logic_vector(1 DOWNTO 0);
signal DBatM,DOuten,DMR,DMW,DMWsel,DWBsel,DIMDTRSRC,Dstacken,Dstackcont,DFlgen: std_logic;
signal BeforeCUMUX : std_logic_vector (21 downto 0);
signal AfterCUMUX : std_logic_vector (21 downto 0);
signal OrOUT : std_logic;
-----------------------------------------------

-----------------------Execute-----------------
signal Aluin1,Aluin2,ALURes : std_logic_vector(31 downto 0);
signal Rsrc1D,Rscr2D,Immval : std_logic_vector(31 downto 0);
signal BranchatMem,FlagED,AndMem,FlagEnable,ALUCont : std_logic;
signal FlagsMem : std_logic_vector(2 downto 0);
signal FlagSelec : std_logic_vector(1 downto 0);
signal AluCon : std_logic_vector(3 downto 0);
signal FlagsE,Flagsin,FlagsO : std_logic_vector(2 downto 0);
signal PCEX : std_logic_vector(10 downto 0);
signal CounterConDB,CounterConE : std_logic_vector(1 downto 0);
signal BrnchMemDB,BrnchMemE,OpRegEnDB,OpRegEnE : std_logic;
signal MEMDB,MEME : std_logic_vector(4 downto 0);
signal WBDB,WBE : std_logic_vector(2 downto 0);
signal trashcan : std_logic;
signal Rsc1DB,Rsc1E,Rsc2DB,Rsc2E,RdstDB,RdstE : std_logic_vector(2 downto 0);
signal newnew : std_logic_vector(10 downto 0);
signal EXBufferin,EXBufferout : std_logic_vector(130 downto 0);
------------------ID/EXE Buffer signal---------
signal INbuffer_D: std_logic_vector(137 downto 0);
signal OUTbuffer_D : std_logic_vector(137 downto 0);
-----------------------------------------------
----------------------ForUnit-----------------------
signal Rsrc1MUX,Rsrc2MUX :std_logic_vector (2 downto 0);
signal fuMUX : std_logic_vector (31 downto 0);
signal wbf:std_logic_vector (1 downto 0);
-----------------------------------------------
signal MEMR_WB : std_logic;
signal DecodeFlush,PC_Stall,IfIdSignal,nDecodeFlush,nPC_Stall,nIfIdSignal : std_logic;
-----------------------------------------------
begin
------------------fetch------------------------------------
pcen<='1';
pcm01<=READ_DATA(10 downto 0);
pce1<= Aluin1(10 downto 0);
ControlUnit : Control port map (opCode,intrpt,DAlUF,Dcurrfun,DBatE,DWB,DCcontrol,DImmSel,Dflgsel,DBatM,DOuten,DMR,DMW,DMWsel,DWBsel,DIMDTRSRC,Dstacken,Dstackcont,DFlgen);
pcmux1:pcmux port map(NEW_BRANCH_atMEM,bate,reset,pce1,pcm01,pcadd,pcm01,npc);
pcreg: G_register generic map(11) port map(npc,FPC,clk,zero,nPC_Stall);
instmem1:instmem port map(Fpc,inst);
RegFile : RegisterFile port map (Rsrc1,Rsrc2,WriteReg1,WriteReg2,ReadData1,ReadData2,WriteData1,WriteData2_MEM,WriteBack1_MEM,WriteBack2_MEM,clk,reset,r0,r1,r2,r3,r4,r5,r6,r7);
BatE<=(flag and branchE(1)) or branchE(0);
pcADDER: NADDER generic map(11) port map(pcinc,fpc,zero,open,pcadd);
pcinc<= "00000000001" when inst(26)='0' else
	"00000000010";
opcodeF <= inst(31 downto 26);
fflush<=BatE or NEW_BRANCH_atMEM;
Finbuffer<= opcodeF & inst(25 downto 0) & intr & fpc & input;
fdbuffer:G_register1 generic map(76) port map(Finbuffer,Foutbuffer,clk,reset,nIfIdSignal,fflush);

---------------------------------------------------------------
opcode<= foutbuffer(75 downto 70);
intrpt<=foutbuffer(43);
pc<=foutbuffer(42 downto 32);
Rsrc1<=foutbuffer(69 downto 67);
Rdst<=foutbuffer(66 downto 64);
Rsrc2<=foutbuffer(63 downto 61);
imdtvalue<=foutbuffer(59 downto 44);
EAadress<=foutbuffer(54 downto  44);
inputport<=foutbuffer(31 downto 0);
-------------------Decode Write Register MUX---
WriteReg1<= RdstMEM when (WriteBack2_MEM='0') ELSE  Rsrc2MEM ;
-----------------------------------------------
-------------------Extend MUX------------------
imdtSelector<=DImmSel;
imdtExtend<="0000000000000000"&imdtValue;
EAExtend <= "000000000000000000000"&EAadress;
imdtValueSelected<= imdtExtend when imdtSelector="00"
ELSE  inputPort when imdtSelector="01"
ELSE  EAExtend  when imdtSelector="10";
-------------MEMORY_MAPPING_(MUXES BEFORE RAM)-----------------
	--(without multi_cycle)--
--extend flags--
FLAGS_EXTENDED <="00000000000000000000000000000"&FLAGS;
ALU_result_cut <= ALU_result(10 downto 0);
ADD_0<="00000000000";
PC_OUT_EXTEND<="000000000000000000000" & PC_OUT;

MUX_4X1_to_WriteData: mux_4x1 generic map(32) port map(A=>RSRC1_data,B=>PC_OUT_EXTEND,C=>FLAGS_EXTENDED,D=>FLAGS_EXTENDED,S1=>new_write_select_toMux4x1(1),S0=>new_write_select_toMux4x1(0),Z=>WRITE_DATA);

MUX_2x1_to_mem: mux_2x1 generic map(11) port map(A=>ALU_result_cut,B=>MUX_2x1_afteradd_out,S0=>new_stack_enable,Z=>MUX_2x1_to_mem_out);--
stack1<=not(counter_control(0)or  branch_atMEM) ;
MUX_4X1_to_Address: mux_4x1 generic map(11) port map(A=>MUX_2x1_to_mem_out,B=>ADD_0,C=>ADD_2,D=>ADD_0,S1=>MSB_SELEC_MUX4x1_Address,S0=>reset,Z=>MEMORY_ADDRESS); ----SELECTION LINES NEED TO BE REVIEWED

--------------MEMORY_MAPPING_(SP circuit)-----------------------
ADD_2<="00000000010";
ADD_neg2<="11111111110";
cin_SP<='0';

STACK_POINTER: stack  port map(D=>NADDER_output,Q=>SP_OUTPUT,clk=>clk,rst=>reset,enable=>new_stack_enable);

MUX_2x1_beforeadd: mux_2x1 generic map(11) port map(A=>ADD_2,B=>ADD_neg2,S0=>inc_dec,Z=>MUX_2x1_beforeadd_out);

SP_ADDER: NADDER generic map(11) port map(A1=>SP_OUTPUT,B1=>MUX_2x1_beforeadd_out,cin1=>cin_SP,cout1=>cout_SP,sum=>NADDER_output);--

MUX_2x1_afteradd: mux_2x1 generic map(11) port map(A=>NADDER_output,B=>SP_OUTPUT,S0=>stack1,Z=>MUX_2x1_afteradd_out);--
------------MEMORY_MAPPING_(MULTI_CYCLE _CIRCUIT)------------------
MUX_4X1_to_Counter_LOAD0<="00";
MUX_4X1_to_Counter_LOAD2<="10";
MUX_4X1_to_Counter_LOAD3<="11";
MUX_4X1_to_Counter_LOADVOID<="00";
BranchatMem<=NEW_BRANCH_atMEM;

MUX_4X1_to_Counter: mux_4x1 generic map(2) port map(A=>MUX_4X1_to_Counter_LOAD0,B=>MUX_4X1_to_Counter_LOAD2,C=>MUX_4X1_to_Counter_LOAD3,D=>MUX_4X1_to_Counter_LOADVOID,S1=>counter_control(1),S0=>counter_control(0),Z=>MUX_4X1_to_Counter_OUT);

Counter_multi_cycle: down_counter port map(clock=>clk,reset=>reset,enable=>new_counter_enable,load_data=>MUX_4X1_to_Counter_OUT,output=>counter_output);

multi_cycle_control: MultCyc port map(C=>counter_output,CControl=>counter_control,WSel=>multi_cycle_write_select,BatM=>branch_atMEM,RM=>mem_read_control,WM=>mem_write_control,Stack=>stack_enable,NRM=>new_read_mem,NWM=>new_write_mem,NStack=>new_stack_enable,cenable=>new_counter_enable,NBatM=>NEW_BRANCH_atMEM,NWSel=>new_write_select_toMux4x1);

stall_memory<=not counter_output(1) ;
WIRE_MEM_TO_EXEC<=counter_output(0) and counter_control(0);

AndMem<=WIRE_MEM_TO_EXEC;

MSB_SELEC_MUX4x1_Address<=new_read_mem and counter_control(1);
--------------------MEMORY_MAPPING_RAM------------------

MEMORY: ram port map(clk=>clk,we=>new_write_mem,address=>MEMORY_ADDRESS,datain=>WRITE_DATA,dataout=>READ_DATA);

---------------------MEM/WB BUFFER_MAPPING----------------------
--signal opregMemB 
--signal WBMemB 
--read data already 
--ALU_RESULT already declared
--signal Rsrc1MemB,Rsrc2MemB,RdstMemB
--signal Rsrc2dataMemB 

BUS_TO_MEM_WB_BUFFER_IN<=opregMemB & WBMemB & READ_DATA & ALU_RESULT & RdstMemB & Rsrc2dataMemB & Rsrc2MemB & Rsrc1MemB;
ENABLE_BUFFER_MEM_TO_WB<='1';

MEM_WB_BUFFER: G_Register1 generic map(109) port map(D=>BUS_TO_MEM_WB_BUFFER_IN,Q=>BUS_TO_MEM_WB_BUFFER_OUT,clk=>clk,rst=>reset,enable=>ENABLE_BUFFER_MEM_TO_WB,flush=>zero);

------------------Control Unit MUX-------------
OrOut<= BatE or NEW_BRANCH_atMEM or DecodeFlush;
BeforeCUMUX<= DCcontrol&DBatM&DBatE&DOuten&DWB&DWBsel&DMR&DMW&Dstacken&Dstackcont&DMWsel&DAlUF&DIMDTRSRC&DFlgen&Dflgsel;
AfterCUMUX<= BeforeCUMUX when (OrOUT='0') ELSE "0000000000000000000000";
-----------------------------------------------

-----------------------Execute-----------------
FlagEnable <= (FlagED AND (not BranchatMem)) OR AndMem;
FlagsE <= FlagsO when AndMem='0'
else FlagsMem when AndMem='1';
flagsmem<=read_data(2 downto 0);
FlagReg : G_Register generic map(3) port map(FlagsE,Flagsin,clk,reset,FlagEnable);
Flag <= Flagsin(0) when FlagSelec = "00"
else Flagsin(1) when FlagSelec = "01"
else Flagsin(2) when FlagSelec = "10";
-----------------------------------------
Aluin1 <= Rsrc2dataMemB_WB when Rsrc1MUX="000"
else  Rsrc1D when Rsrc1MUX="001"
else  ALU_result when Rsrc1MUX="010"
else MUX2x1_WB_OUT when  Rsrc1MUX="011"
else Rsrc2dataMemB when  Rsrc1MUX="100";

fuMUX <= Rsrc2dataMemB_WB when Rsrc2MUX="000"
else  Rscr2D when Rsrc2MUX="001"
else  ALU_result when Rsrc2MUX="010"
else  MUX2x1_WB_OUT when  Rsrc2MUX="011"
else  Rsrc2dataMemB when  Rsrc2MUX="100";   

Aluin2 <= fuMUX when ALUCont ='0'
-----------------------------------------
else Immval when ALUCont='1';
ALUMain : ALU port map(Aluin1,Aluin2,AluCon,Immval(5 downto 0),Flagsin(2),Flagsin(1),Flagsin(0),Flagso(2),Flagso(1),Flagso(0),ALURes);
newnew <= "00000000000" when CounterConDB(1)='1'
else "00000000001";
AdderEX : NADDER generic map(11) port map(PCE,newnew,'0',trashcan,PCEX);
CounterConE <= CounterConDB when BranchatMem='0'
else "00" when BranchatMem ='1';
BrnchMemE  <= BrnchMemDB when BranchatMem='0'
else '0' when BranchatMem ='1';
OpRegEnE  <= OpRegEnDB when BranchatMem='0'
else '0' when BranchatMem ='1';
MEME   <= MEMDB when BranchatMem='0'
else "00000" when BranchatMem ='1';
WBE  <= WBDB when BranchatMem='0'
else "000" when BranchatMem ='1'; 
Rsc1E  <= Rsc1DB;
Rsc2E <= Rsc2DB;
RdstE <= RdstDB;

EXBufferin <= CounterConE & BrnchMemE & OpRegEnE & MEME & WBE & Flagsin & ALURes & ALuin1 & PCEX & RdstE & ALuin2 & Rsc2E & Rsc1E;

EXecBuffer : G_Register1 generic map (131) port map (EXBufferin,EXBufferout,clk,reset,stall_memory,zero);
counter_control <= EXBufferout(130 downto 129);
branch_atMEM <= EXBufferout(128);
opregMemB <= EXBufferout(127);
mem_read_control <= EXBufferout(126);
mem_write_control <= EXBufferout(125);
stack_enable <= EXBufferout(124);
inc_dec <= EXBufferout(123);
multi_cycle_write_select <= EXBufferout(122);
WBMemB <= EXBufferout(121 downto 119);
FLAGS <= EXBufferout(118 downto 116);
ALU_result <= EXBufferout(115 downto 84);
RSRC1_data <= EXBufferout(83 downto 52);
PC_OUT <= EXBufferout(51 downto 41);
RdstMemB <= EXBufferout(40 downto 38);
Rsrc2dataMemB <= EXBufferout(37 downto 6);
Rsrc2MemB <= EXBufferout(5 downto 3);
Rsrc1MemB <= EXBufferout(2 downto 0);


-----------------------------------------------

------------------ID/EXE Buffer----------------
INbuffer_D<=AfterCUMUX&PC&ReadData1&ReadData2&imdtValueSelected&Rdst&Rsrc2&Rsrc1;
ID_EXE: G_register1 generic map (138) port map (INbuffer_D,OUTbuffer_D,clk,reset,ONE,zero);
CounterConDB<=OUTbuffer_D(137 downto 136);
BrnchMemDB<=OUTbuffer_D(135);
BranchE<=OUTbuffer_D(134 downto 133);
OpRegEnDB<=OUTbuffer_D(132);
WBDB<=OUTbuffer_D(131 downto 129);
MEMDB<=OUTbuffer_D(128 downto 124);
ALUCON<=OUTbuffer_D(123 downto 120);
AlUCONT<=OUTbuffer_D(119);
FlagEd<=OUTbuffer_D(118);
FlagSelec<=OUTbuffer_D(117 downto 116);
PCE<=OUTbuffer_D(115 downto 105);
Rsrc1D<=OUTbuffer_D(104 downto 73);
Rscr2D<=OUTbuffer_D(72 downto 41);
Immval<=OUTbuffer_D(40 downto 9);
RdstDB<=OUTbuffer_D(8 downto 6);
Rsc2DB<=OUTbuffer_D(5 downto 3);
Rsc1DB<=OUTbuffer_D(2 downto 0);
-----------------------------------------------
---------------WB_STAGE------------------------ 

opregMemB_WB<=BUS_TO_MEM_WB_BUFFER_OUT(108);
WBMemB_WB<=BUS_TO_MEM_WB_BUFFER_OUT(107 downto 105);
READ_DATA_WB<=BUS_TO_MEM_WB_BUFFER_OUT(104 downto 73);
ALU_result_WB<=BUS_TO_MEM_WB_BUFFER_OUT(72 downto 41);
RdstMemB_WB<=BUS_TO_MEM_WB_BUFFER_OUT(40 downto 38);
Rsrc2dataMemB_WB<=BUS_TO_MEM_WB_BUFFER_OUT(37 downto 6);
Rsrc2MemB_WB<=BUS_TO_MEM_WB_BUFFER_OUT(5 downto 3);
Rsrc1MemB_WB<=BUS_TO_MEM_WB_BUFFER_OUT(2 downto 0);

RdstMEM<=RdstMemB_WB;
WriteData2_MEM<=Rsrc2dataMemB_WB;
Rsrc2MEM<=Rsrc2MemB_WB;
WriteReg2<=Rsrc1MemB_WB;
WriteBack2_MEM<=BUS_TO_MEM_WB_BUFFER_OUT(107);
WriteBack1_MEM<=BUS_TO_MEM_WB_BUFFER_OUT(106);
wbf<=WriteBack2_MEM&WriteBack1_MEM;
---------------WB_STAGE_MAPPING------------------------ 
MUX2x1_FROM_MEM_WB_BUFFER: mux_2x1 generic map(32) port map(A=>ALU_result_WB,B=>READ_DATA_WB,S0=>WBMemB_WB(0),Z=>MUX2x1_WB_OUT);

WriteData1<=MUX2x1_WB_OUT;

OUTPUT_PORT: G_Register generic map(32) port map(D=>ALU_result_WB,Q=>output,clk=>clk,rst=>reset,enable=>opregMemB_WB);

-----------------------------------------------
forwarding:Forward port map (Rsc1DB,Rsc2DB,RdstMemB,RdstMemB_WB,WBMemB(2 downto 1),wbf,opregMemB,opregMemB_WB,Rsrc1MUX,Rsrc2MUX);
-----------------------------------------------
MEMR_WB<=WBDB(0)and WBDB(1);
Hazard : HazardDetection port map (RdstDB,Rsrc1,Rsrc2,MEMR_WB,Dcurrfun,DecodeFlush,PC_Stall,IfIdSignal);
nDecodeFlush<=not(DecodeFlush);
nPC_Stall<=not(PC_Stall);
nIfIdSignal<=not(IfIdSignal);
END Architecture;