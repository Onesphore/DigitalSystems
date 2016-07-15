-- full adder component --
-----------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

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



-- ripple-carry adder component --
----------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
entity adder_8bit is
port (
A, B: in std_logic_vector(7 downto 0);
Co: in std_logic;
sums: out std_logic_vector (7 downto 0);
carries: out std_logic_vector (7 downto 0)
);
end adder_8bit;


ARCHITECTURE adder_8bit_arch OF adder_8bit IS
component f_adder_comp is
port (
x, y, c_in: in std_logic;
c_out, s: out std_logic
);
end component;
SIGNAL carr: std_logic_vector (7 downto 0);

BEGIN

compon7: f_adder_comp PORT MAP
		(x=>A(7), y=>B(7), c_in=>carr(6), c_out=>carr(7), s=>sums(7));
		
compon6: f_adder_comp PORT MAP
		(x=>A(6), y=>B(6), c_in=>carr(5), c_out=>carr(6), s=>sums(6));
		
compon5: f_adder_comp PORT MAP
		(x=>A(5), y=>B(5), c_in=>carr(4), c_out=>carr(5), s=>sums(5));
		
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
-----------------------------------------


-- compare complement --
------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
entity compare is
port (
M, N: in std_logic_vector(7 downto 0);
repr: out std_logic_vector (6 downto 0)
);
end compare;

ARCHITECTURE compare_arch OF compare IS

component adder_8bit is
port (
A, B: in std_logic_vector(7 downto 0);
Co:in std_logic;
sums: out std_logic_vector (7 downto 0);
carries: out std_logic_vector (7 downto 0)
);
end component;

SIGNAL Car:std_logic_vector(7 downto 0);
SIGNAL B_cmp:std_logic_vector(7 downto 0);
SIGNAL B_neg:std_logic_vector(7 downto 0);
SIGNAL diff:std_logic_vector(7 downto 0);
SIGNAL overflow:std_logic;
SIGNAL check: std_logic;
BEGIN

B_cmp <= N xor "11111111";
comp0: adder_8bit PORT MAP
		(A=>M, B=>B_cmp, Co=>'1',
        sums=>diff, carries=>Car);
overflow<= '1' when ((Car(7) xor Car(6)) = '1') else '0';

check<= '1' when (diff(7) = '0' and overflow = '0') else
		  '1' when (overflow ='1' and M(7) = '0') else
		  '0';
     
	  
repr <="1110110" when M = N else
	  "1110000" when check = '1' else
     "1000110";
     
END ARCHITECTURE;


--- main circuit 
-- The main circuit
library IEEE;
use IEEE.std_logic_1164.all;

entity lab5 is
	port (
	sw: in std_logic_vector(17 downto 0);
	ledr: out std_logic_vector (7 downto 0);
	hex0,hex1,hex2, hex3, hex4, hex5, hex6, hex7: out std_logic_vector (6 downto 0));
end entity;

architecture sample of lab5 is
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
component adder_8bit is
port (
A, B: in std_logic_vector(7 downto 0);
Co: in std_logic;
sums: out std_logic_vector (7 downto 0);
carries: out std_logic_vector (7 downto 0)
);
end component;


component compare is
port (
M, N: in std_logic_vector(7 downto 0);
repr: out std_logic_vector (6 downto 0)
);
end component;
----------------------------------------


-- signals

SIGNAL summs: std_logic_vector(7 downto 0);
SIGNAL carrs: std_logic_vector(7 downto 0);
SIGNAL cmp_rep: std_logic_vector(6 downto 0);


SIGNAL new_A: std_logic_vector(7 downto 0);
SIGNAL new_B: std_logic_vector(7 downto 0);


SIGNAL check1: std_logic;
SIGNAL check2: std_logic;
SIGNAL check3: std_logic;

-----------------------------------------

BEGIN


check1 <= '1' when (sw(16) = '0' and sw(17) = '0') else '0';
check2 <= '1' when (sw(16) = '0' and sw(17) = '1') else '0';
check3 <= '1' when (sw(16) = '1' and sw(17) = '0') else '0';


 new_A <= sw(15 downto 8)  when check1 = '1' else
		  sw(15 downto 8)  when check2 = '1' else
		  sw(15 downto 8)  when check3 = '1' else
		  (sw(15 downto 8) xor "11111111");
          
new_B <= sw(7 downto 0)  when check1 = '1' else 
		 (sw(7 downto 0) xor "11111111") when check2 = '1' else 
		 sw(7 downto 0) when check3 = '1' else
		 sw(7 downto 0); 



comp0: adder_8bit PORT MAP
		(A=>new_A, B=>new_B, Co=>sw(17),
        sums=>summs, carries=>carrs);
        
comp1: compare PORT MAP
		(M=>sw(15 downto 8), N=>sw(7 downto 0),
        repr=>cmp_rep);
        
 --- start with ledr (7 down_to 0)
ledr(7 downto 0)<=summs(7 downto 0);

--- then hex7-6
hex6 <= To_7seg(sw(11 downto 8));
hex7 <= To_7seg(sw(15 downto 12));

--- Then hex5-4
hex4 <= To_7seg(sw(3 downto 0));
hex5 <= To_7seg(sw(7 downto 4));

--- then hex3
hex3 <= cmp_rep;

--- then hex1-0
hex0 <= To_7seg(summs(3 downto 0));
hex1 <= To_7seg(summs(7 downto 4));

end architecture;


