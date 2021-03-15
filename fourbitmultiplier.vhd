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
	COMPONENT Seven_Segment_Decoder
		PORT( V : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			output : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	END COMPONENT ;
	COMPONENT Double_Seven_Segment_Decoder
		PORT( D : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			HEX0, HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	END COMPONENT ;
	COMPONENT multiplier
		PORT( dataa, datab : IN STD_LOGIC_VECTOR(3 downto 0);
			result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT ;
	
BEGIN -- DEFINE THE FLIP FLOPS
	PROCESS (KEY)
	BEGIN
		IF (KEY(1) = '0') THEN -- reset 
			Areg <= (OTHERS => '0'); Breg <= (OTHERS => '0'); D <= (OTHERS => '0');
		ELSIF (KEY(0)'EVENT AND KEY(0) = '1') THEN
			Areg<= SW(3 downto 0); Breg<= SW(7 downto 4); D <= result;
		END IF ;
	END PROCESS ;
	--Define combinational circuit, multiplier
	multiplier_four: multiplier
		PORT MAP(Areg, Breg, result) ;
	first_number : Seven_Segment_Decoder
		PORT MAP(Areg, HEX5) ;
	second_number : Seven_Segment_Decoder
		PORT MAP(Breg, HEX4) ;
	leresult : Double_Seven_Segment_Decoder
		PORT MAP(D, HEX0, HEX1) ;
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
output <= "0000001"; -- 0
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

-- Double 7 Segment Decoder ***********NOT DONE******************
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity Double_Seven_Segment_Decoder is
Port ( D : in STD_LOGIC_VECTOR (7 downto 0);
HEX0 : out STD_LOGIC_VECTOR (6 downto 0);
HEX1 : out STD_LOGIC_VECTOR (6 downto 0));
end Double_Seven_Segment_Decoder;
 
architecture Behavioral of Double_Seven_Segment_Decoder is
 
begin
 
process(D)
begin
 
case D is
when "00000000" =>
HEX0 <= "0000001"; -- 0
when "00000001" =>
HEX0 <= "1111001"; -- 1
when "00000010" =>
HEX0 <= "0100100"; -- 2 0100100
when "00000011" => 
HEX0 <= "0110000"; -- 3 0110000
when "00000100" =>
HEX0 <= "0011001"; -- 4 0011001
when "00000101" =>
HEX0 <= "0010010"; -- 5 0010010
when "00000110" =>
HEX0 <= "0000010"; -- 6 0000010
when "00000111" =>
HEX0 <= "1111000"; -- 7 1111000
when "00001000" =>
HEX0 <= "0000000"; -- 8 
when "00001001" =>
HEX0 <= "0010000"; -- 9 0010000
when "00001010" =>
HEX1 <= "1111001"; HEX0 <= "0000001"; -- 10 
when "00001011" =>
HEX1 <= "1111001"; HEX0 <= "1111001"; -- 11
when "00001100" =>
HEX1 <= "1111001"; HEX0 <= "0100100"; -- 12
when "00001101" =>
HEX1 <= "1111001"; HEX0 <= "0110000"; -- 13
when "00001110" =>
HEX1 <= "1111001"; HEX0 <= "0011001"; -- 14
when "00001111" =>
HEX1 <= "1111001"; HEX0 <= "0010010"; -- 15
when others =>
HEX1 <= "1111111"; HEX0 <= "1111111";
end case;
 
end process;
 
end Behavioral;

-- 4 bit multiplier	
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY lpm;
USE lpm.all;

ENTITY multiplier IS
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END multiplier;


ARCHITECTURE SYN OF multiplier IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (7 DOWNTO 0);



	COMPONENT lpm_mult
	GENERIC (
		lpm_hint		: STRING;
		lpm_representation		: STRING;
		lpm_type		: STRING;
		lpm_widtha		: NATURAL;
		lpm_widthb		: NATURAL;
		lpm_widthp		: NATURAL
	);
	PORT (
			dataa	: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			datab	: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			result	: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	result    <= sub_wire0(7 DOWNTO 0);

	lpm_mult_component : lpm_mult
	GENERIC MAP (
		lpm_hint => "MAXIMIZE_SPEED=5",
		lpm_representation => "UNSIGNED",
		lpm_type => "LPM_MULT",
		lpm_widtha => 4,
		lpm_widthb => 4,
		lpm_widthp => 8
	)
	PORT MAP (
		dataa => dataa,
		datab => datab,
		result => sub_wire0
	);


END SYN;




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