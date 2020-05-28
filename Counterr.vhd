library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

entity down_counter is
  port (
    clock: in std_logic;
    reset: in std_logic;
    enable: in std_logic;
    load_data: in std_logic_vector(1 downto 0);
    output: out std_logic_vector(1 downto 0)
  );
end;

architecture a_down_counter of down_counter is
    signal count: std_logic_vector(1 downto 0):="00";
begin
    process (clock, reset,enable) begin
        if reset='1' then
            count <= (others => '0');
        elsif rising_edge(clock) then
            if count /="00" then
                count <= count - 1;
            end if;
	elsif rising_edge(enable) then
		count<=load_data;
        end if;
	
    end process;

    output <= count;
end;

