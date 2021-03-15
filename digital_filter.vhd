LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

Entity digital_filter is
	port
		(
		in_p, in_n, clk : in std_logic;
		out_p, out_n : out std_logic
		);
end digital_filter ;

ARCHITECTURE behavioural OF digital_filter IS
	
	signal q : std_logic_vector(7 downto 0);
	signal or_sig, not_sig : std_logic_vector(1 downto 0);
	
	
	component RisingEdge_DFlipFlop
		port
		(
      D : in std_logic;    
      Clk :in std_logic;   
      Q :out  std_logic    
		);
	end component;
	
	begin
	
	flip_a : RisingEdge_DFlipFlop
		port map(in_p,clk,q(0));
	flip_b : RisingEdge_DFlipFlop
		port map(q(0),clk,q(1));
	flip_c : RisingEdge_DFlipFlop
		port map(q(1),clk,q(2));
	flip_d : RisingEdge_DFlipFlop
		port map(q(2),clk,q(3));
	flip_e : RisingEdge_DFlipFlop
		port map(in_n,clk,q(4));
	flip_f : RisingEdge_DFlipFlop
		port map(q(4),clk,q(5));
	flip_g : RisingEdge_DFlipFlop
		port map(q(5),clk,q(6));
	flip_h : RisingEdge_DFlipFlop
		port map(q(6),clk,q(7));
	
	or_sig(0) <= q(0) or q(1) or q(2) or q(3);
	or_sig(1) <= q(4) or q(5) or q(6) or q(7);
	not_sig(0) <= not or_sig(1);
	not_sig(1) <= not or_sig(0);
	
	out_p <= not_sig(0) and or_sig(0);
	out_n <= not_sig(1) and or_sig(1);
	
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