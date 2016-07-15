-- components
-- full adder component --
----------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity f_adder_comp is
port (
x, y, c_in: in std_logic;
c_out, s: out std_logic
);
end f_adder_comp;

ARCHITECTURE f_adder_arch OF f_adder_comp IS
BEGIN
c_out <= (x and y) or (c_in and (x xor y));
s <= x xor y xor c_in;
END ARCHITECTURE;
-------------------------------------



-- ripple-carry adder component  4 bits--
----------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
entity adder_4bit is
port (
A, B: in std_logic_vector(3 downto 0);
Co: in std_logic;
sums: out std_logic_vector (3 downto 0);
carries: out std_logic_vector (3 downto 0)
);
end adder_4bit;

ARCHITECTURE adder_4bit_arch OF adder_4bit IS
component f_adder_comp is
port (
x, y, c_in: in std_logic;
c_out, s: out std_logic
);
end component;
SIGNAL carr: std_logic_vector (3 downto 0);

BEGIN

compon3: f_adder_comp PORT MAP
		(x=>A(3), y=>B(3), c_in=>carr(2), c_out=>carr(3), s=>sums(3));
		
compon2: f_adder_comp PORT MAP
		(x=>A(2), y=>B(2), c_in=>carr(1), c_out=>carr(2), s=>sums(2));

compon1: f_adder_comp PORT MAP
		(x=>A(1), y=>B(1), c_in=>carr(0), c_out=>carr(1), s=>sums(1));
		
compon0: f_adder_comp PORT MAP
		(x=>A(0), y=>B(0), c_in=>Co, c_out=>carr(0), s=>sums(0));

carries <= carr;
 
END ARCHITECTURE;


-- ripple-carry adder component 5 bits--
----------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
entity adder_5bit is
port (
A, B: in std_logic_vector(4 downto 0);
Co: in std_logic;
sums: out std_logic_vector (4 downto 0);
carries: out std_logic_vector (4 downto 0)
);
end adder_5bit;

ARCHITECTURE adder_5bit_arch OF adder_5bit IS
component f_adder_comp is
port (
x, y, c_in: in std_logic;
c_out, s: out std_logic
);
end component;
SIGNAL carr: std_logic_vector (4 downto 0);

BEGIN
compon4: f_adder_comp PORT MAP
		(x=>A(4), y=>B(4), c_in=>carr(3), c_out=>carr(4), s=>sums(4));

compon3: f_adder_comp PORT MAP
		(x=>A(3), y=>B(3), c_in=>carr(2), c_out=>carr(3), s=>sums(3));
		
compon2: f_adder_comp PORT MAP
		(x=>A(2), y=>B(2), c_in=>carr(1), c_out=>carr(2), s=>sums(2));

compon1: f_adder_comp PORT MAP
		(x=>A(1), y=>B(1), c_in=>carr(0), c_out=>carr(1), s=>sums(1));
		
compon0: f_adder_comp PORT MAP
		(x=>A(0), y=>B(0), c_in=>Co, c_out=>carr(0), s=>sums(0));

carries <= carr;
 
END ARCHITECTURE;

-- BCD adder component --
-----------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity bcd_adder_8bit is
  port(
	X, Y: in std_logic_vector(7 downto 0);
    result_add: out std_logic_vector(11 downto 0)
  );
end bcd_adder_8bit;
  
architecture bcd_adder_8bit_arch of bcd_adder_8bit is

signal res_low: std_logic_vector(3 downto 0);
signal res_high: std_logic_vector(3 downto 0);
signal overflow: std_logic_vector(3 downto 0);

signal carrs1: std_logic_vector(3 downto 0);
signal carrs11: std_logic_vector(4 downto 0);
signal carrs2: std_logic_vector(3 downto 0);
signal carrs22: std_logic_vector(4 downto 0);

signal overflow_res1: std_logic_vector(4 downto 0);
signal overflow_res11: std_logic_vector(4 downto 0);
signal overflow_res1_add: std_logic_vector(4 downto 0);
signal new_res1: std_logic_vector(4 downto 0);



signal overflow_res2: std_logic_vector(4 downto 0);
signal overflow_res22: std_logic_vector(4 downto 0);
signal overflow_res2_add: std_logic_vector(4 downto 0);
signal new_res2: std_logic_vector(4 downto 0);

component adder_4bit is
port (
A, B: in std_logic_vector(3 downto 0);
Co: in std_logic;
sums: out std_logic_vector (3 downto 0);
carries: out std_logic_vector (3 downto 0)
);
end component;
component adder_5bit is
port (
A, B: in std_logic_vector(4 downto 0);
Co: in std_logic;
sums: out std_logic_vector (4 downto 0);
carries: out std_logic_vector (4 downto 0)
);
end component;

BEGIN
	compon0: adder_4bit PORT MAP
		(A=>X(3 downto 0), B=>Y(3 downto 0), Co=>'0', sums =>res_low, carries=>carrs1);
    
    overflow_res1(3 downto 0) <= res_low (3 downto 0);
    overflow_res1(4) <= carrs1(3);
    
    
    compon1: adder_5bit PORT MAP
		(A=>overflow_res1, B=>"00110", Co=>'0', sums =>overflow_res1_add, carries=>carrs11);
    
    
    new_res1 <= overflow_res1_add when overflow_res1 > "01001" else
    			overflow_res1;
                
            
    compon2: adder_4bit PORT MAP
		(A=>X(7 downto 4), B=>Y(7 downto 4), Co=>new_res1(4), sums =>res_high, carries=>carrs2);
    
    
    overflow_res2(3 downto 0) <= res_high (3 downto 0);
    overflow_res2(4) <= carrs2(3);
    
    compon3: adder_5bit PORT MAP
		(A=>overflow_res2, B=>"00110", Co=>'0', sums =>overflow_res2_add, carries=>carrs22);
	
    new_res2 <= overflow_res2_add when overflow_res2 > "01001" else
    			overflow_res2;
                
    result_add(3 downto 0) <= new_res1(3 downto 0);
    result_add(7 downto 4) <= new_res2(3 downto 0);
    result_add(8) <= new_res2(4);

end architecture;


--- 10's complement component
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity tens_cmp is 
  port(
	input_t: in std_logic_vector(7 downto 0);
    result_t: out std_logic_vector(11 downto 0)
  );
end tens_cmp;
ARCHITECTURE tens_cmp_arch OF tens_cmp IS
	function to_9cmp(digit: in std_logic_vector (3 downto 0))
    return std_logic_vector is
    begin 
    	if digit = "0000" then return "1001"; -- 0
        elsif digit = "0001" then return "1000"; -- 1
        elsif digit = "0010" then return "0111"; -- 2
        elsif digit = "0011" then return "0110"; -- 3
        elsif digit = "0100" then return "0101"; -- 4
        elsif digit = "0101" then return "0100"; -- 5
        elsif digit = "0110" then return "0011"; -- 6
        elsif digit = "0111" then return "0010"; -- 7
        elsif digit = "1000" then return "0001"; -- 8
        else return "0000"; -- 9
		  end if;
		  end to_9cmp;


		  
component bcd_adder_8bit is
  port(
	X, Y: in std_logic_vector(7 downto 0);
    result_add: out std_logic_vector(11 downto 0)
  );
end component;		  

		  
signal val1: std_logic_vector(7 downto 0);

BEGIN

val1(3 downto 0) <= to_9cmp(input_t(3 downto 0));
val1(7 downto 4) <= to_9cmp(input_t(7 downto 4));
compon0: bcd_adder_8bit PORT MAP
		(X => val1, Y => "00000001", result_add => result_t);

end architecture;











-- The main circuit
library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity lab7 is
	port (
	sw: in std_logic_vector(17 downto 0);
	ledr: out std_logic_vector (11 downto 0);
	hex0,hex1,hex2, hex3, hex4, hex5, hex6, hex7: out std_logic_vector (6 downto 0));
end entity;

architecture sample of lab7 is
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
 


-- components

component bcd_adder_8bit is
port (
X, Y: in std_logic_vector(7 downto 0);
result_add: out std_logic_vector (11 downto 0)
);
end component;

component tens_cmp is
port (
input_t: in std_logic_vector(7 downto 0);
result_t: out std_logic_vector (11 downto 0)
);
end component;
----------------------------------------
-- signals
signal check1:std_logic;
signal check2:std_logic;
signal check3:std_logic;

signal A_cmp: std_logic_vector(11 downto 0);
signal B_cmp: std_logic_vector(11 downto 0);

signal new_A: std_logic_vector(8 downto 0);
signal new_B: std_logic_vector(8 downto 0);

signal result: std_logic_vector(11 downto 0);
signal result_cmp: std_logic_vector(11 downto 0);
signal result_f: std_logic_vector(11 downto 0);

signal overflow:std_logic;

signal cm_rep: std_logic_vector(6 downto 0);

-----------------------------------------

BEGIN

check1 <= '1' when (sw(16) = '0' and sw(17) = '0') else '0';
check2 <= '1' when (sw(16) = '0' and sw(17) = '1') else '0';
check3 <= '1' when (sw(16) = '1' and sw(17) = '0') else '0';

cm_rep <= "1110110" when sw(15 downto 8) = sw(7 downto 0) else
			 "1110000" when sw(15 downto 8) > sw(7 downto 0) else
			 "1000110";
			 

		
 compon0: tens_cmp PORT MAP
		(input_t => sw(15 downto 8), result_t =>A_cmp);
 compon1: tens_cmp PORT MAP
		(input_t => sw(7 downto 0), result_t =>B_cmp);

 
 new_A <= '0'& sw(15 downto 8)  when check1 = '1' else
		  '0'&sw(15 downto 8)  when check2 = '1' else
		  '0'&sw(7 downto 0)  when check3 = '1' else
		  '0'&sw(7 downto 0);
          
new_B <= '0'&sw(7 downto 0)  when check1 = '1' else 
		 B_cmp(8 downto 0) when check2 = '1' else 
		 '0'&sw(15 downto 8) when check3 = '1' else
		 A_cmp(8 downto 0);

compon2: bcd_adder_8bit PORT MAP
		(X=>new_A(7 downto 0), Y=>new_B(7 downto 0), result_add =>result);

overflow <= '1' when (result(8) = '1' or new_B(8) = '1') else
				'0';
compon3: tens_cmp PORT MAP
		(input_t => result(7 downto 0), result_t =>result_cmp);

result_f(8 downto 0) <= result_cmp(8 downto 0) when (overflow = '0' and sw(17) = '1') else
								result (8 downto 0);
		 
	

-- displaying	
ledr <= result_f;

hex7<= To_7seg(sw(15 downto 12));
hex6<= To_7seg(sw(11 downto 8));

hex5 <= To_7seg(sw(7 downto 4));
hex4 <= To_7seg(sw(3 downto 0));

hex3 <= cm_rep;

hex2 <=  "0111111" when (overflow = '0' and sw(17) = '1') else
			"1000000" when (sw(17) = '1') else
			To_7seg(result_f(11 downto 8));
		 
hex1 <= To_7seg(result_f(7 downto 4));
hex0 <= To_7seg(result_f(3 downto 0));

end architecture;
