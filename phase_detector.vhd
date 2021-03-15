LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

Entity phase_detector is
	port
		(
		d : in std_logic;
		clk_early, clk_edge, clk_late : in std_logic;
		up, down : out std_logic
		);
end phase_detector ;

ARCHITECTURE behavioural OF phase_detector IS
	
	signal or_early, or_edge, or_late, or_top, or_bot : std_logic;
	
	component RisingEdge_DFlipFlop
		port
		(
      D : in std_logic;    
      Clk :in std_logic;   
      Q :out  std_logic    
		);
	end component;
	
	component FallingEdge_DFlipFlop
		port
		(
      D : in std_logic;    
      Clk :in std_logic;   
      Q :out  std_logic    
		);
	end component;
	
	begin
	
	flip_a : RisingEdge_DFlipFlop
		port map(d, clk_early, or_early);
	flip_b : RisingEdge_DFlipFlop
		port map(d, clk_edge, or_edge);
	flip_c : RisingEdge_DFlipFlop
		port map(d, clk_late, or_late);
	
	or_top <= or_early XOR or_edge;
	or_bot <= or_edge XOR or_late;
	
	flip_d : FallingEdge_DFlipFlop
		port map(or_top, clk_late, up);
	flip_e : FallingEdge_DFlipFlop
		port map(or_bot, clk_late, down);	
	
end behavioural ;


-- rising edge flip flop
Library IEEE;
USE IEEE.Std_logic_1164.all;

entity RisingEdge_DFlipFlop is 
   port(
      D : in std_logic;    
      Clk :in std_logic;   
      Q :out  std_logic    
		);
end RisingEdge_DFlipFlop;

architecture Behavioral of RisingEdge_DFlipFlop is  
	begin  
	process(Clk)
		begin 
		if(rising_edge(Clk)) then
			Q <= D; 
		end if;       
	end process;  
end Behavioral; 

Library IEEE;
USE IEEE.Std_logic_1164.all;

-- falling edge flip flop
entity FallingEdge_DFlipFlop is 
   port(
      D : in std_logic;    
      Clk :in std_logic;   
      Q :out  std_logic    
		);
end FallingEdge_DFlipFlop;

architecture Behavioral of FallingEdge_DFlipFlop is  
	begin  
	process(Clk)
		begin 
		if(falling_edge(Clk)) then
			Q <= D; 
		end if;       
	end process;  
end Behavioral; 
