LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

Entity phase_generator is
	port
		(
		KEY : in std_logic_vector (1 downto 0);
		q : out std_logic_vector (7 downto 0)
		);
end phase_generator ;

ARCHITECTURE behavioural OF phase_generator IS
	
	signal p : std_logic_vector(7 downto 0);
	
	begin
	
	process(KEY)
	
	begin
	
		if KEY(1) = '0' then -- if RESET
		
			p <= "10000000";
			
		elsif KEY(0)' event and KEY(0) = '1' then -- clock input
			
			p(0) <= p(7);
			p(7 downto 1) <= p(6 downto 0);
			
		end if ;
		
		q(7 downto 0) <= p(7 downto 0);
		
	end process ;

end behavioural ;

entity mux is
	port 
		(
		s: in std_logic_vector(2 downto 0);
		p: in std_logic_vector(7 downto 0);
		clk_out: out std_logic
		);
end mux;