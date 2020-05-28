Library ieee;
use ieee.std_logic_1164.all;

Entity RegisterFile IS
PORT(
    ReadReg1,ReadReg2,WriteReg1,WriteReg2 : IN std_logic_vector (2 downto 0);
    ReadData1,ReadData2: OUT std_logic_vector (31 downto 0);
    WriteData1,WriteData2 : IN std_logic_vector (31 downto 0);
    WriteBack1,WriteBack2,CLK,RST: IN std_logic;
	r0,r1,r2,r3,r4,r5,r6,r7 : OUT std_logic_vector (31 downto 0)
);
END ENTITY;

Architecture A_RegisterFile OF RegisterFile IS
  
  
  COMPONENT reg IS 
port(
  D1,D2:IN std_logic_vector(31 downto 0);
  Q:OUT std_logic_vector(31 downto 0);
  clk,rst,enable1,enable2:IN std_Logic
);
END COMPONENT;

COMPONENT decoder IS 
port(
  Sel:IN std_logic_vector(2 downto 0);
  Decoderout:out std_logic_vector(7 downto 0);
  enable:IN std_logic
);
END COMPONENT;
 
signal q0,q1,q2,q3,q4,q5,q6,q7: std_logic_vector (31 downto 0);
signal read1,read2,write1,write2 :std_logic_vector(7 downto 0);
signal enableread :std_logic ;
      
BEGIN
  enableread <= '1';
  
  decoderRead1: decoder port map(ReadReg1,read1,enableread);
  decoderRead2: decoder port map(ReadReg2,read2,enableread);
  
  decoderWrite1: decoder port map (WriteReg1,write1,writeback1);
  decoderWrite2: decoder port map (WriteReg2,write2,writeback2);

  Reg0 : reg  PORT MAP (WriteData1,WriteData2,q0,CLK,RST,write1(0),write2(0));
  Reg1 : reg  PORT MAP (WriteData1,WriteData2,q1,CLK,RST,write1(1),write2(1));
  Reg2 : reg  PORT MAP (WriteData1,WriteData2,q2,CLK,RST,write1(2),write2(2));
  Reg3 : reg  PORT MAP (WriteData1,WriteData2,q3,CLK,RST,write1(3),write2(3));
  Reg4 : reg  PORT MAP (WriteData1,WriteData2,q4,CLK,RST,write1(4),write2(4));
  Reg5 : reg  PORT MAP (WriteData1,WriteData2,q5,CLK,RST,write1(5),write2(5));
  Reg6 : reg  PORT MAP (WriteData1,WriteData2,q6,CLK,RST,write1(6),write2(6));
  Reg7 : reg  PORT MAP (WriteData1,WriteData2,q7,CLK,RST,write1(7),write2(7));  

r0<=q0; r1<=q1 ;r2<=q2;r3<=q3;r4<=q4;r5<=q5;r6<=q6;r7<=q7;
--------------------Buffer1---------------------------
ReadData1 <= q0 when read1(0)='1'
	else (others=>'Z');
ReadData1 <= q1 when read1(1)='1'
	else (others=>'Z');
ReadData1 <= q2 when read1(2)='1'
	else (others=>'Z');
ReadData1 <= q3 when read1(3)='1'
	else (others=>'Z');
ReadData1 <= q4 when read1(4)='1'
	else (others=>'Z');
ReadData1 <= q5 when read1(5)='1'
	else (others=>'Z');
ReadData1 <= q6 when read1(6)='1'
	else (others=>'Z');
ReadData1 <= q7 when read1(7)='1'
	else (others=>'Z');
-------------------------------------------------------
--------------------Buffer2----------------------------
ReadData2 <= q0 when read2(0)='1'
	else (others=>'Z');
ReadData2 <= q1 when read2(1)='1'
	else (others=>'Z');
ReadData2 <= q2 when read2(2)='1'
	else (others=>'Z');
ReadData2 <= q3 when read2(3)='1'
	else (others=>'Z');
ReadData2 <= q4 when read2(4)='1'
	else (others=>'Z');
ReadData2 <= q5 when read2(5)='1'
	else (others=>'Z');
ReadData2 <= q6 when read2(6)='1'
	else (others=>'Z');
ReadData2 <= q7 when read2(7)='1'
	else (others=>'Z');	  
--------------------------------------------------------  
END ARCHITECTURE;