LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY pcmux IS
	PORT(
		BatM,BatE,Rst: IN  std_logic;
		PcE,pcM,Pcadd,pcm01 : IN  std_logic_vector(10 DOWNTO 0);
		Naddress: OUT std_logic_vector(10 DOWNTO 0)
);
END ENTITY ;

ARCHITECTURE pcmux1 OF pcmux IS
	signal c1 :std_logic_vector(2 downto 0);
BEGIN
c1<= BatM & BatE & rst;
Naddress<= pcm01 when c1(0)='1' else
	   pcM   when c1(2)='1' else
	   pcE   when c1(1)='1' else
	   pcadd;
 END ARCHITECTURE;
