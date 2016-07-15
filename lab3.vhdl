Lab3 source code


Library IEEE;
Use IEEE.std_logic_1164.all;

entity lab3 is
	port (
	sw: in std_logic_vector(17 downto 0);
	ledr: out std_logic_vector (17 downto 0);
	ledg: out std_logic_vector (17 downto 0);
	hex0,hex1,hex2, hex3, hex4, hex5, hex6, hex7: out std_logic_vector (6 downto 0));
end entity;

architecture sample of lab3 is
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
	signal output_val: std_logic;

	

begin
	-- switch inputs
	hex7 <= To_7seg(sw(17 downto 14));
	hex6 <= To_7seg(sw(13 downto 10));
	
	-- birthday
	hex5 <= To_7seg("0000");
	hex4 <= To_7seg("0100");
	hex3 <= To_7seg("0010");
	hex2 <= To_7seg("0100");
	
	-- 3-bit multiplexer controller
	hex1 <= To_7seg('0'&sw(2 downto 0));
	
	-- output value; multiplexer
	output_val <= sw(10) when sw(2 downto 0) = "000" else
					  sw(11) when sw(2 downto 0) = "001" else
					  sw(12) when sw(2 downto 0) = "010" else
					  sw(13) when sw(2 downto 0) = "011" else
					  sw(14) when sw(2 downto 0) = "100" else
					  sw(15) when sw(2 downto 0) = "101" else
					  sw(16) when sw(2 downto 0) = "110" else
					  sw(17) ;
	
	
	hex0 <=To_7seg("000"&output_val);
	
	ledg(0) <= '1' when sw(2 downto 0) = "000" else '0';
	ledg(1) <= '1' when sw(2 downto 0) = "001" else '0';
	ledg(2) <= '1' when sw(2 downto 0) = "010" else '0';
	ledg(3) <= '1' when sw(2 downto 0) = "011" else '0';
	ledg(4) <= '1' when sw(2 downto 0) = "100" else '0';
	ledg(5) <= '1' when sw(2 downto 0) = "101" else '0';
	ledg(6) <= '1' when sw(2 downto 0) = "110" else '0';
	ledg(7) <= '1' when sw(2 downto 0) = "111" else '0';
	
	ledr <= sw;
	
	
	
end architecture;
	
