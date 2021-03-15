LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
--use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity fifo is
	port
		(
		SW : in STD_LOGIC_VECTOR (9 downto 0);
		KEY : in std_logic_vector (1 downto 0);
		LEDR : out std_logic_vector (9 downto 0);
		HEX0 : out std_logic_vector (6 downto 0);
		HEX1 : out std_logic_vector (6 downto 0);
		HEX2 : out std_logic_vector (6 downto 0);
		HEX3 : out std_logic_vector (6 downto 0);
		HEX4 : out std_logic_vector (6 downto 0);
		HEX5 : out std_logic_vector (6 downto 0)
		);
	end fifo;
	
architecture behavioural of fifo is
	
	signal wr_pointer, rd_pointer : std_logic_vector (2 downto 0); -- pointers to ram location
	signal cnt : std_logic_vector (3 downto 0); -- count for flags
	signal data : std_logic_vector (7 downto 0);  -- input data
	signal q : std_logic_vector (7 downto 0); -- output signal
	signal rden, wren, empty, full	: STD_LOGIC; -- Enable signals, flags
	
	COMPONENT Seven_Segment_Decoder
		PORT
			( 
			V : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			output : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
			);
	END COMPONENT ;
	
	
	component ramlpm
		PORT
		(
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0); 		-- data 
			rdaddress		: IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- read address
			rden		: IN STD_LOGIC  := '1';                   -- read signal *active high* 
			wraddress		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);	-- write address
			wren		: IN STD_LOGIC  := '0';							-- write signal *active high*
			q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)				-- output data bits
		);
	end component ;

	BEGIN 
	
	process(KEY)
	begin
		rden <= SW(9); -- read enable at switch 9
		wren <= SW(8); -- write enable at switch 8
		LEDR(9) <= SW(9); -- LED output for read
		LEDR(8) <= SW(8); -- LED output for write	
		data <= SW(7 downto 0); -- used for input and display
		if KEY(1) = '0' then -- if RESET
			wr_pointer <= (others => '0'); -- set to 0 when reset
			rd_pointer <= (others => '0'); -- set to 0 when reset
			rden <= '1'; -- initially read should be on
			wren <= '0'; -- initially write should be off
			data <= (others => '0'); -- incoming data goes to 0, this will change if switches are still selected
			cnt <= (others => '0'); -- inital count of 0, or empty
		elsif KEY(0)' event and KEY(0) = '1' then -- clock input
		
			if (wren = '1' and rden = '1') then -- condition for when both read and write are on
				if cnt = "1000" then -- when full
					rd_pointer <= rd_pointer + "001";						-- increment rd_pointer                     
					cnt <= cnt - '1';										-- decrement cnt 
				elsif cnt = "0000" then -- when empty
					wr_pointer <= wr_pointer + "001";						-- increment wr_pointer
					cnt <= cnt + '1';										-- increment cnt
				else -- when neither full or empty
					wr_pointer <= wr_pointer + "001";						-- increment wr_pointer
					rd_pointer <= rd_pointer + "001";						-- increment cnt					
				end if;	
			end if ;
			
			if (cnt /= "0000") and (rden = '1') and (wren = '0') then -- When empty and read on, write off
			
				rd_pointer <= rd_pointer + "001";						-- increment rd_pointer                     
				cnt <= cnt - '1';										-- decrement cnt
				
			end if ;				
			
			if  (cnt /= "1000") and (wren = '1') and (rden = '0') then -- When full and read off, write on  
			
				wr_pointer <= wr_pointer + "001";						-- increment wr_pointer
				cnt <= cnt + '1';										-- increment cnt
				
			end if ;
			
		end if ;
			
	end process	;	
	
	empty <= '1' when cnt = "0000" else '0'; -- updates the LEDS outside of the process
	LEDR(1) <= empty;
	full <= '1' when cnt = "1000" else '0'; -- updates the LEDS outside of the process
	LEDR(0) <= full;	
	
	ram : ramlpm
			PORT MAP
			(
				KEY(0),
				data,
				"00" & rd_pointer,
				rden,
				"00" & wr_pointer,
				wren,
				q
			);
	display_a : Seven_Segment_Decoder 	-- hex 0 display, data display LSD
			port map(data(7 downto 4), HEX1);
	display_b : Seven_Segment_Decoder 	-- hex 1 display, data display MSD 
			port map(data(3 downto 0), HEX0);
	display_c : Seven_Segment_Decoder 	-- hex 4 display, wren_display
			port map(('0' & wr_pointer), HEX4);
	display_d : Seven_Segment_Decoder 	-- hex 5 display, rden_display
			port map(('0' & rd_pointer), HEX5);
	q_result_a : Seven_Segment_Decoder -- hex 3 display, result left digit
			port map(q(7 downto 4), HEX3);
	q_result_b : Seven_Segment_Decoder -- hex 2 display, result right digit
			port map(q(3 downto 0), HEX2);
	
end behavioural ;

