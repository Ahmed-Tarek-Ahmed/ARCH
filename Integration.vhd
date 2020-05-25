LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity processor IS 
port(
	input :IN std_logic_vector (31 downto 0);
	output :OUT std_logic_vector (31 downto 0);
	reset,intr :IN std_logic;
);
END ENTITY;

Architecture p1 OF processor IS
begin

END Architecture;