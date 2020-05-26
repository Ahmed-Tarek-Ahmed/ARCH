LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY MultCyc IS
	PORT(
		C,CControl: IN  std_logic_vector(1 DOWNTO 0);
		BatM,RM,WM,Stack,WSel : IN  std_logic;
		NBatM,NRM,NWM,NStack,cenable: OUT std_logic;
		NWSel: OUT std_logic_vector(1 DOWNTO 0));
END ENTITY MultCyc;

ARCHITECTURE MultCyc1 OF MultCyc IS
BEGIN
Process(C,CControl,WSel,BatM,RM,WM,Stack)
BEGIN
if(C="00")then
	NBATM<=BatM;
	NRM<=Rm;
	nwm<=wm;
	nstack<=stack;
	nwsel(0)<=wsel;
    	nwsel(1)<='0';
elsif(C="10" )then
	if(ccontrol="01")then
	nbatm<='1';
	nrm<=rm;
	nwm<=wm;
	nwsel<="--";
	nstack<=stack;
	elsif(ccontrol="10")then
	nbatm<='0';
	nrm<='0';
	nwm<='1';
	nwsel<="01";
	nstack<='1';
	end if;
elsif(c="01")then
	if(ccontrol="01")then
	nbatm<='0';
	nrm<=rm;
	nwm<=wm;
	nwsel<="--";
	nstack<=stack;
	elsif(ccontrol="10")then
	nbatm<='1';
	nrm<='1';
	nwm<='0';
	nwsel<="--";
	nstack<='0';
	end if;
elsif(c="11")then
	nbatm<='0';
	nrm<='0';
	nwm<='1';
	nwsel<="10";
	nstack<='1';
END if;
if ccontrol/="00" and c="00" then
	cenable<='1';
else
	cenable<='0';
end if;
END Process;
END ARCHITECTURE;
