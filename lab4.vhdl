-- for lab #4
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity lab4 is
	port (
	sw: in std_logic_vector(17 downto 0);
	ledr: out std_logic_vector (7 downto 0);
	hex0,hex1,hex2, hex3, hex4, hex5, hex6, hex7: out std_logic_vector (6 downto 0));
end entity;

architecture sample of lab4 is
function To_7seg (digit: in std_logic_vector (3 downto 0)) 
		return std_logic_vector is
		begin 
			if digit = "0000" then return "1000000";  -- 0
			elsif digit = "0001" then return "1111001";  -- 1
			elsif digit = "0010" then return "0100100";  -- 2
			elsif digit = "0011" then return "0110000";  -- 3
			elsif digit = "0100" then return "0011001";  -- 4
			elsif digit = "0101" then return "0010010";  -- 5
			elsif digit = "0110" then return "0000010";  -- 6
			elsif digit = "0111" then return "1111000";  -- 7
			elsif digit = "1000" then return "0000000";  -- 8
			elsif digit = "1001" then return "0010000";  -- 9
			elsif digit = "1010" then return "0001000";  -- A
			elsif digit = "1011" then return "0000011";  -- B
			elsif digit = "1100" then return "1000110";  -- C
			elsif digit = "1101" then return "0100001";  -- D
			elsif digit = "1110" then return "0000110";  -- E
			else return "0001110";  -- F
			
			end if;
        end To_7seg;
  signal Sum: std_logic_vector(7 downto 0);
  
 function cmp (A: in std_logic_vector (7 downto 0); 
					B: in std_logic_vector (7 downto 0)) 
 		return std_logic_vector is 
        begin
        	if A > B then return "1110000"; --- “]”
			elsif A = B then return "1110110"; --- “=”
			else return "1000110"; --- “[“ 
			
			end if;
        end cmp;
        
 begin 
 
 --- start with ledr (7 down_to 0)
 ledr(7 downto 0) <= (sw(15 downto 8) + sw(7 downto 0)) when sw(17) = '0' else -- S = 0
		          (sw(15 downto 8) - sw(7 downto 0)) when sw(16) = '0' else -- S = 1
		          (sw(7 downto 0) - sw(15 downto 8));
							
--- then hex7-6
hex6 <= To_7seg(sw(11 downto 8));
hex7 <= To_7seg(sw(15 downto 12));


--- Then hex5-4
hex4 <= To_7seg(sw(3 downto 0));
hex5 <= To_7seg(sw(7 downto 4));


--- then hex3	
hex3 <= cmp(sw(15 downto 8), sw(7 downto 0));

--- then hex1-0
Sum <= (sw(15 downto 8) + sw(7 downto 0)) when sw(17) = '0' else -- S = 0
		  (sw(15 downto 8) - sw(7 downto 0)) when sw(16) = '0' else -- S = 1, two cases
		  (sw(7 downto 0) - sw(15 downto 8));
		  
hex0 <= To_7seg(Sum(3 downto 0));
hex1 <= To_7seg(Sum(7 downto 4));
 
 
 end architecture;