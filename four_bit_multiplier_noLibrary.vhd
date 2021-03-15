-- Connor Warden
-- Lab 2
-- Part 2
-- Unsigned 4-bit Multiplier 

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY fourbitmultiplier IS
	PORT( SW : in STD_LOGIC_VECTOR (7 downto 0); -- Where to get the numbers
		KEY : in STD_LOGIC_VECTOR (1 downto 0);
		HEX0 : out STD_LOGIC_VECTOR (6 downto 0);
		HEX1 : out STD_LOGIC_VECTOR (6 downto 0);
		HEX4 : out STD_LOGIC_VECTOR (6 downto 0); -- Displays B 
		HEX5 : out STD_LOGIC_VECTOR (6 downto 0)); -- Displays A
END fourbitmultiplier ;

ARCHITECTURE Behaviour OF fourbitmultiplier IS
	SIGNAL Areg, Breg : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL result, D : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal carry : STD_LOGIC_VECTOR(10 downto 0);
	signal in_out : STD_LOGIC_VECTOR(5 downto 0);
	signal p_zero_three : STD_LOGIC_VECTOR(3 downto 0); -- New pipeline for result Po to P3
	signal p_four_nine : STD_LOGIC_VECTOR(5 downto 0); -- New pipeline for in_out(4,5), carry(7,6,5), Areg(3) and Breg(3)
	COMPONENT Seven_Segment_Decoder
		PORT( V : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			output : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	END COMPONENT ;
	COMPONENT full_adder 
	    Port (in_a : IN  STD_LOGIC;
          in_b : IN  STD_LOGIC;
          carry_in : IN STD_LOGIC;
          carry_out : out STD_LOGIC;
          output : out STD_LOGIC);
	END COMPONENT ;
	
BEGIN -- DEFINE THE FLIP FLOPS
	PROCESS (KEY)
	BEGIN
		IF (KEY(1) = '0') THEN -- reset 
			Areg <= (OTHERS => '0'); 
			Breg <= (OTHERS => '0'); 		
			D <= (OTHERS => '0'); 
		ELSIF (KEY(0)'EVENT AND KEY(0) = '1') THEN   
			Areg<= SW(3 downto 0); 
			Breg<= SW(7 downto 4);
			D (7 downto 4) <= result(7 downto 4);
			p_four_nine(0)<= carry(6); --			
			p_four_nine(1)<= in_out(4);
			p_four_nine(2)<= carry(7); --
			p_four_nine(3)<= in_out(5);
			p_four_nine(4)<= carry(8); --
			p_four_nine(5)<= Areg(3) and Breg(3);
			D (3 downto 0) <= p_zero_three;
			
		END IF ;
	END PROCESS ;
	--Define combinational circuit, multiplier
	p_zero_three(0) <= (Areg(0) and Breg(0)) ;
	A : full_adder
		PORT MAP(Areg(1) and Breg(0), Areg(0) and Breg(1), '0', carry(0), p_zero_three(1)) ;
	B : full_adder
		PORT MAP(Areg(2)  and Breg(0), Areg(1) and Breg(1), '0', carry(1), in_out(0)) ;
	C : full_adder
		PORT MAP(Areg(3)  and Breg(0), Areg(2) and Breg(1), '0', carry(2), in_out(1)) ;
	Dee : full_adder
		PORT MAP(in_out(0), Areg(0) and Breg(2), carry(0), carry(3), p_zero_three(2)) ;
	E : full_adder
		PORT MAP(in_out(1), Areg(1) and Breg(2), carry(1), carry(4), in_out(2)) ;
	F : full_adder
		PORT MAP(Areg(3) and Breg(1), Areg(2) and Breg(2), carry(2), carry(5), in_out(3)) ;
	G : full_adder
		PORT MAP(in_out(2), Areg(0) and Breg(3), carry(3), carry(6), p_zero_three(3)) ;
	H : full_adder
		PORT MAP(in_out(3), Areg(1) and Breg(3), carry(4), carry(7), in_out(4)) ;
	I : full_adder
		PORT MAP(Areg(3) and Breg(2), Areg(2) and Breg(3), carry(5), carry(8), in_out(5)) ;
	J : full_adder
		PORT MAP(p_four_nine(1), '0', p_four_nine(0), carry(9), result(4)) ;
	K : full_adder
		PORT MAP(p_four_nine(3), carry(9), p_four_nine(2), carry(10), result(5)) ;
	L : full_adder
		PORT MAP(p_four_nine(5), carry(10), p_four_nine(4), result(7), result(6)) ;
	first_number : Seven_Segment_Decoder
		PORT MAP(Areg, HEX5) ;
	second_number : Seven_Segment_Decoder
		PORT MAP(Breg, HEX4) ;
	leresultone : Seven_Segment_Decoder
		PORT MAP(D(7 downto 4), HEX1) ;
	leresulttwo : Seven_Segment_Decoder
		PORT MAP(D(3 downto 0), HEX0) ;
end Behaviour ;

-- Seven Segment Decoder
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity Seven_Segment_Decoder is
Port ( V : in STD_LOGIC_VECTOR (3 downto 0);
		output : out STD_LOGIC_VECTOR (6 downto 0));
end Seven_Segment_Decoder;
 
architecture Behavioral of Seven_Segment_Decoder is
 
begin
 
process(V)
begin
 
case V is
when "0000" =>
output <= "1000000"; -- 0
when "0001" =>
output <= "1111001"; -- 1
when "0010" =>
output <= "0100100"; -- 2 0100100
when "0011" => 
output <= "0110000"; -- 3 0110000
when "0100" =>
output <= "0011001"; -- 4 0011001
when "0101" =>
output <= "0010010"; -- 5 0010010
when "0110" =>
output <= "0000010"; -- 6 0000010
when "0111" =>
output <= "1111000"; -- 7 1111000
when "1000" =>
output <= "0000000"; -- 8 
when "1001" =>
output <= "0010000"; -- 9 0010000
when "1010" =>
output <= "0001000"; -- A 
when "1011" =>
output <= "0000011"; -- B 0000011
when "1100" =>
output <= "1000110"; -- C 1000110
when "1101" =>
output <= "0100001"; -- D 0100001
when "1110" =>
output <= "0000110"; -- E 0000110
when "1111" =>
output <= "0001110"; -- F 0001110
when others =>
output <= "1111111";
end case;
 
end process;
 
end Behavioral;		


-- full adder
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity full_adder is
    Port (in_a : IN  STD_LOGIC;
          in_b : IN  STD_LOGIC;
          carry_in : IN STD_LOGIC;
          carry_out : out STD_LOGIC;
          output : out STD_LOGIC);
end full_adder;
 
architecture Behavioral of full_adder is

  signal w_1 : std_logic;
  signal w_2 : std_logic;
  signal w_3 : std_logic;
 
begin

	 w_1 <= in_a xor in_b;
	 w_2 <= In_a and carry_in;
	 w_3 <= in_a and in_b;

    output <= (in_a xor in_b) xor carry_in;
    carry_out <= (in_a and in_b) or ((in_a xor in_b) and carry_in);
	 
end Behavioral;