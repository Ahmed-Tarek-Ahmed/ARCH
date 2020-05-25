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
 port(
     A,B : IN std_logic_vector(31 downto 0);
     S0: IN std_logic;
     Z: OUT std_logic_vector(31 downto 0)
  );
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

signal FLAGS_EXTENDED:  std_logic_vector(31 downto 0);
signal ALU_result_cut:  std_logic_vector(10 downto 0);
------------------Memory signals (TEMP)---------------
signal ALU_result:  std_logic_vector(31 downto 0);
signal RSRC1_data:  std_logic_vector(31 downto 0);
signal PC_OUT:  std_logic_vector(31 downto 0);
signal FLAGS:  std_logic_vector(2 downto 0);


signal multi_cycle_output: std_logic_vector(1 downto 0);
signal counter_control: std_logic_vector(1 downto 0);
------------------Memory signals (NOT TEMP)---------------
signal ADD_2: std_logic_vector(10 downto 0);
signal ADD_neg2: std_logic_vector(10 downto 0);
signal cin_SP: std_logic;
signal cout_SP: std_logic;
signal NADDER_output: std_logic_vector(10 downto 0);
signal MUX_2x1_beforeadd_out: std_logic_vector(10 downto 0);----------SP

signal WRITE_DATA: std_logic_vector(31 downto 0);


begin
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
imdtValueSelected<= imdtExtend when imdtSelector="00"
ELSE  inputPort when imdtSelector="01"
ELSE  EAExtend  when imdtSelector="10";
-------------MEMORY_MAPPING_(MUXES BEFORE RAM)-----------------
	--(without multi_cycle)--
FLAGS_EXTENDED <="00000000000000000000000000000"&FLAGS;
ALU_result_cut <= ALU_result(10 downto 0);
--extend flags--
MUX_4X1_to_WriteData: mux_4x1 generic map(32) port map(A=>RSRC1_data,B=>PC_OUT,C=>FLAGS_EXTENDED,D=>FLAGS_EXTENDED,S1=>multi_cycle_output(1),S0=>multi_cycle_output(0),Z=>WRITE_DATA);
--MUX_2x1_to_mem: mux_2x1 generic map(11) port map(A=>ALU_result_cut--,B=>--other 2x1 mux from sp);
--MUX_4X1_to_Address: mux_4x1 generic map(11) port map(A=>RSRC1_data,B=>PC_OUT,C=>FLAGS_EXTENDED,D=>FLAGS_EXTENDED,S1=>multi_cycle_output(1),S0=>multi_cycle_output(0),Z=>WRITE_DATA);

--------------MEMORY_MAPPING_(SP circuit)-----------------------
ADD_2<="00000000010";
ADD_neg2<="11111111110";
cin_SP<='0';

MUX_2x1_beforeadd: mux_2x1 generic map(11) port map(A=>ADD_2,B=>ADD_neg2,S0=>from buffer register,Z=>MUX_2x1_beforeadd_out);
SP_ADDER: NADDER generic map(11) port map(A1=>ADD_2,B1=>ADD_neg2,cin1=>cin_SP,cout1=>cout_SP,sum=>NADDER_output);--add2 and add2 neg to be replaced


---------------------------------------------
END Architecture;