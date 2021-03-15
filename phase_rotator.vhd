LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY phase_rotator IS
	PORT
		( 
		inc : in std_logic;
		dec : in std_logic;
		KEY : in std_logic_vector(1 downto 0);
		clk_early, clk_edge, clk_late : out std_logic
		);
END phase_rotator ;

ARCHITECTURE behavioural OF phase_rotator IS

	signal x: std_logic_vector(2 downto 0); -- counter
	signal q: std_logic_vector(7 downto 0); -- phase generator output
	signal clk_div: std_logic;
	signal mux_a_in, mux_b_in, mux_c_in: std_logic_vector(7 downto 0);
	
	component counter
		port 
		(
			inc, dec: in std_logic;
			clk, rst: in std_logic;
			q: out std_logic_vector(2 downto 0)
			);
	end component;
	
	component phase_generator 
		port 
			(
			KEY : in std_logic_vector (1 downto 0);
			q : out std_logic_vector (7 downto 0)
			);
	end component;
	
	component clock_divider 
		port 
			( 
			KEY: in std_logic_vector(1 downto 0);
			clock_out: out std_logic
			);
	end component;
	
	component mux 
		port 
			(
			s: in std_logic_vector(2 downto 0);
			p: in std_logic_vector(7 downto 0);
			clk_out: out std_logic
			);
	end component;
	
	begin

	new_clock : clock_divider
		port map(KEY, clk_div);
	phase_gen : phase_generator
		port map(KEY, q);
	three_bit_counter : counter
		port map(inc, dec, clk_div, KEY(1), x);
		
	mux_a_in <= q;
	mux_b_in(5 downto 0) <= q(7 downto 2);
	mux_b_in(7 downto 6) <= q(1 downto 0);
	mux_c_in(3 downto 0) <= q(7 downto 4);
	mux_c_in(7 downto 4) <= q(3 downto 0);
	
	mux_a : mux
		port map(x, mux_a_in, clk_early);
	mux_b : mux
		port map(x, mux_b_in, clk_edge);	
	mux_c : mux
		port map(x, mux_c_in, clk_late);
		
end behavioural ;


-- phase generator
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

-- clock divider
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

-- 3 bit counter
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
  
entity counter is
	port 
		(
		inc, dec: in std_logic;
		clk, rst: in std_logic;
		q: out std_logic_vector(2 downto 0)
		);
end counter;
  
architecture behavioural of counter is
  
	signal count: std_logic_vector(2 downto 0);
	
  
	begin
	  
	process(clk,rst)
	
	begin
	
	if rst = '0' then
		count<= "000";
		
	elsif clk' event and clk = '1' then
		if inc = '1' and count = "111" then
			count <= "000";
		elsif inc = '1' and count /= "111" then
			count <= count + "001";
		elsif dec = '1' then
			count <= count - "001";
		end if;
	end if;
	
	q <= count;
	
	end process;
	  
end behavioural;
-- end of 3 bit counter

-- mux
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
entity mux is
	port 
		(
		s: in std_logic_vector(2 downto 0);
		p: in std_logic_vector(7 downto 0);
		clk_out: out std_logic
		);
end mux;
  
architecture behavioural of mux is
 
  
	begin
	  
	process(s,p)
	
	begin
		case s is
			when "000" => 
				clk_out<=p(0);
			when "001" => 
				clk_out<=p(1);
			when "010" => 
				clk_out<=p(2);
			when "011" => 
				clk_out<=p(3);
			when "100" => 
				clk_out<=p(4);
			when "101" => 
				clk_out<=p(5);
			when "110" => 
				clk_out<=p(6);
			when "111" => 
				clk_out<=p(7);
		end case;
	end process;
	  
end behavioural;
-- end of mux