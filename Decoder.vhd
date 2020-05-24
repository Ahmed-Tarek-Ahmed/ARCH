LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity decoder IS 
port(
  Sel:IN std_logic_vector(2 downto 0);
  Decoderout:out std_logic_vector(7 downto 0);
  enable:IN std_logic
);
END ENTITY;

Architecture a_decoder OF decoder IS
begin 
PROCESS(enable,Sel)
  begin
    if (enable = '1') then
    case sel is
    when "000"=>
    Decoderout<="00000001"; 
    when "001"=>
    Decoderout<="00000010";
    when "010"=>
    Decoderout<="00000100";
    when "011"=>
    Decoderout<="00001000";
    when "100"=>
    Decoderout<="00010000";
    when "101"=>
    Decoderout<="00100000";
    when "110"=>
    Decoderout<="01000000";
    when others =>
    Decoderout<="10000000";
    END CASE;
    END IF;
END PROCESS;
END Architecture;