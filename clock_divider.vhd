library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity clock_divider is
	port 
		( 
		KEY: in std_logic_vector(1 downto 0);
		clock_out: out std_logic
		);
end clock_divider;
  
architecture behavioural of clock_divider is
  
	signal count: integer:=1;
	signal tmp : std_logic := '0';
  
	begin
	  
	process(KEY)
	
	begin
	
	if KEY(1) = '0' then
		count<=1;
		tmp<='0';
	elsif KEY(0)' event and KEY(0) = '1' then
		count <=count+1;
		if (count = 2) then
			tmp <= NOT tmp;
			count <= 1;
		end if;
	end if;
	
	clock_out <= tmp;
	
	end process;
	  
end behavioural;