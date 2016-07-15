--- component file

---- to BCD ----------
----------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity BCD_converter_9bit is
port (
X: in std_logic_vector(8 downto 0);
Result: out std_logic_vector(11 downto 0)
);
end BCD_converter_9bit;


ARCHITECTURE BCD_converter_arch OF BCD_converter_9bit IS


function add_3 (digit: in std_logic_vector (3 downto 0)) 
		return std_logic_vector is
		begin 
			if digit = "0000" then return "0000";  
			elsif digit = "0001" then return "0001"; 
			elsif digit = "0010" then return "0010"; 
			elsif digit = "0011" then return "0011";  
			elsif digit = "0100" then return "0100";  
			elsif digit = "0101" then return "1000";  
			elsif digit = "0110" then return "1001";  
			elsif digit = "0111" then return "1010";  
			elsif digit = "1000" then return "1011";  
			elsif digit = "1001" then return "1100";  
			elsif digit = "1010" then return "1101";  
			elsif digit = "1011" then return "1110"; 
			else return "1111";  
			
			end if;
        end add_3;


BEGIN

proc: process(X)
	variable tmp : std_logic_vector (8 downto 0);
    variable D : std_logic_vector (11 downto 0) := (others => '0');
    variable summs: std_logic_vector(3 downto 0);
    variable carrs: std_logic_vector(3 downto 0);
    begin
    	D := (others => '0'); -- initialize to '00..0'
        tmp(8 downto 0) := X;
        
        for i in 0 to 8 loop

			 D(3 downto 0) := add_3(D(3 downto 0)); 
          D(7 downto 4) := add_3(D(7 downto 4));
          D(11 downto 8) := add_3(D(11 downto 8));


          D := D(10 downto 0) & tmp(8);
          tmp := tmp(7 downto 0) & '0';
        
        end loop;
        
        Result <= D;
        
    end process proc;
          
END ARCHITECTURE;
-----------------------------------------------------------


-- The main circuit
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity lab6 is
	port (
	sw: in std_logic_vector(8 downto 0);
	hex0,hex1,hex2, hex3: out std_logic_vector (6 downto 0));
end entity;


architecture sample of lab6 is



component BCD_converter_9bit is
port (
X: in std_logic_vector(8 downto 0);
Result: out std_logic_vector(11 downto 0)
);
end component;

signal sign: std_logic;
signal new_X: std_logic_vector(8 downto 0);
signal pos_X: std_logic_vector(8 downto 0);
signal cmp_X: std_logic_vector(8 downto 0);
signal carrs: std_logic_vector(8 downto 0);
signal result: std_logic_vector(11 downto 0);

signal sign_enc: std_logic_vector(6 downto 0);

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



BEGIN
	sign <= sw(8);
    cmp_X <= not sw(8 downto 0);
    pos_X <= cmp_X + '1';
    
    new_X <= sw(8 downto 0) when sign = '0' else
    		 pos_X(8 downto 0);
    
	comp0: BCD_converter_9bit PORT MAP
    	(X=>new_X, Result=> result);
    
    sign_enc <= "0111111" when sign = '1' else
    		    "1111111"; 
    
    -- displaying
    hex0<= To_7seg(result(3 downto 0));
    hex1<= To_7seg(result(7 downto 4));
    hex2<= To_7seg(result(11 downto 8));
    hex3<= sign_enc;

end architecture;

