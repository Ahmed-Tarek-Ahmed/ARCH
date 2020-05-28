LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Control IS
	PORT(
		opcode : IN  std_logic_vector(5 DOWNTO 0);
		INT : IN std_logic;
		AlUF :OUT std_logic_vector(3 DOWNTO 0);
		currfun,BatE,WB,Ccontrol,ImmSel,flgsel :OUT std_logic_vector(1 DOWNTO 0);
		BatM,Outen,MR,MW,MWsel,WBsel,IMDTRSRC,stacken,stackcont,Flgen: OUT std_logic);
END ENTITY Control;

ARCHITECTURE Control1 OF Control IS
BEGIN
process(opcode,INT)
Begin
if INT='1' then
	    currfun<="00";
	BatE<="00";
	WB<="00";
	BatM<='0';
	ccontrol<="10";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="0000";
	IMDTRSRC<='0';
	stacken<='1';
	stackcont<='1';
	flgsel<="00";
	flgen<='0';
elsif (opcode="000000")
	 then     currfun<="00";
	BatE<="00";
	WB<="00";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="0000";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='0';
elsif (opcode="000010")
	then     currfun<="00";
	BatE<="00";
	WB<="00";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="0010";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='1';
elsif (opcode="000100")
	then     currfun<="00";
	BatE<="00";
	WB<="00";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="0011";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='1';
elsif (opcode="000110")then
     currfun<="01";
	BatE<="00";
	WB<="01";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="0100";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='1';
elsif (opcode="001000")
	then     currfun<="01";
	BatE<="00";
	WB<="01";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="0101";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='1';
elsif (opcode="001010")
	then     currfun<="01";
	BatE<="00";
	WB<="01";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="0110";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='1';
elsif (opcode="001100")
	then     currfun<="01";
	BatE<="00";
	WB<="00";
	BatM<='0';
	ccontrol<="00";
	Outen<='1';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="0000";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='0';
elsif (opcode="001110")
	then     currfun<="00";
	BatE<="00";
	WB<="01";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="01";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="0001";
	IMDTRSRC<='1';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='0';
elsif (opcode="010000")
	then     currfun<="11";
	BatE<="00";
	WB<="11";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="0000";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='0';
elsif (opcode="010010")
	then     currfun<="11";
	BatE<="00";
	WB<="01";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="0111";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='1';
elsif (opcode="010101")
	then     currfun<="11";
	BatE<="00";
	WB<="01";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="0111";
	IMDTRSRC<='1';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='1';
elsif (opcode="010110")
	then     currfun<="11";
	BatE<="00";
	WB<="01";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="1000";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='1';
elsif (opcode="011000")
	then     currfun<="11";
	BatE<="00";
	WB<="01";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="1001";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='1';
elsif (opcode="011010")
	then     currfun<="11";
	BatE<="00";
	WB<="01";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="1010";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='1';
elsif (opcode="011101")
	then     currfun<="01";
	BatE<="00";
	WB<="01";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="1011";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='1';
elsif (opcode="011111")
	then     currfun<="01";
	BatE<="00";
	WB<="01";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="1100";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='1';
elsif (opcode="100000")
	then     currfun<="01";
	BatE<="00";
	WB<="00";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='1';
	mwsel<='0';
	wbsel<='0';
	aluf<="0000";
	IMDTRSRC<='0';
	stacken<='1';
	stackcont<='1';
	flgsel<="00";
	flgen<='0';
elsif (opcode="100010")
	then     currfun<="00";
	BatE<="00";
	WB<="01";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='1';
	mw<='0';
	mwsel<='0';
	wbsel<='1';
	aluf<="0000";
	IMDTRSRC<='0';
	stacken<='1';
	stackcont<='0';
	flgsel<="00";
	flgen<='0';
elsif (opcode="100101")
	then     currfun<="00";
	BatE<="00";
	WB<="01";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="0001";
	IMDTRSRC<='1';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='0';
elsif (opcode="100111")
	then     currfun<="00";
	BatE<="00";
	WB<="01";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="10";
	mr<='1';
	mw<='0';
	mwsel<='0';
	wbsel<='1';
	aluf<="0001";
	IMDTRSRC<='1';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='0';
elsif (opcode="101001")
	then     currfun<="01";
	BatE<="00";
	WB<="00";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="10";
	mr<='0';
	mw<='1';
	mwsel<='0';
	wbsel<='0';
	aluf<="0001";
	IMDTRSRC<='1';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='0';
elsif (opcode="110000")
	then     currfun<="01";
	BatE<="10";
	WB<="00";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="1101";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="00";
	flgen<='1';
elsif (opcode="110010")
	then     currfun<="01";
	BatE<="10";
	WB<="00";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="1110";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="01";
	flgen<='1';
elsif (opcode="110100")
	then     currfun<="01";
	BatE<="10";
	WB<="00";
	BatM<='0';
	ccontrol<="00";
	Outen<='0';
	immsel<="00";
	mr<='0';
	mw<='0';
	mwsel<='0';
	wbsel<='0';
	aluf<="0011";
	IMDTRSRC<='0';
	stacken<='0';
	stackcont<='0';
	flgsel<="10";
	flgen<='1';
elsif (opcode="110110") --JMP RSRC
    then     currfun<="01";
    BatE<="01";
    WB<="00";
    BatM<='0';
    ccontrol<="00";
    Outen<='0';
    immsel<="00";
    mr<='0';
    mw<='0';
    mwsel<='0';
    wbsel<='0';
    aluf<="0000";
    IMDTRSRC<='0';
    stacken<='0';
    stackcont<='0';
    flgsel<="00";
    flgen<='0';
elsif (opcode="111000") --CALL RSRC
    then     currfun<="01";
    BatE<="01";
    WB<="00";
    BatM<='0';
    ccontrol<="00";
    Outen<='0';
    immsel<="00";
    mr<='0';
    mw<='1';
    mwsel<='1';
    wbsel<='0';
    aluf<="0000";
    IMDTRSRC<='0';
    stacken<='1';
    stackcont<='1';
    flgsel<="00";
    flgen<='0';
elsif (opcode="111010") --RET
    then     currfun<="00";
    BatE<="00";
    WB<="00";
    BatM<='1';
    ccontrol<="00";
    Outen<='0';
    immsel<="00";
    mr<='1';
    mw<='0';
    mwsel<='0';
    wbsel<='0';
    aluf<="0000";
    IMDTRSRC<='0';
    stacken<='1';
    stackcont<='0';
    flgsel<="00";
    flgen<='0';
elsif (opcode="111110") --RTI
    then     currfun<="00";
    BatE<="00";
    WB<="00";
    BatM<='0';
    ccontrol<="01";
    Outen<='0';
    immsel<="00";
    mr<='1';
    mw<='0';
    mwsel<='0';
    wbsel<='0';
    aluf<="0000";
    IMDTRSRC<='0';
    stacken<='1';
    stackcont<='0';
    flgsel<="00";
    flgen<='0';
end if;
end process;



END ARCHITECTURE;
