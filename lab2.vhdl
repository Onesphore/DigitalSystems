-- component
LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY comp IS
PORT(
x1, x2, x3 : IN std_logic;
comp_out : OUT std_logic);
END comp;

ARCHITECTURE comp_arc OF comp IS
BEGIN
comp_out <= (x1 OR x2) AND (NOT x1 AND x3);
END ARCHITECTURE;



-- main circuit
LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY lab2 IS
PORT(
sw: IN std_logic_vector (3 DOWNTO 0);
ledr: OUT std_logic_vector (0 DOWNTO 0));
END lab2;

ARCHITECTURE lab2_arc OF lab2 IS
COMPONENT comp IS
PORT (
x1, x2, x3 : IN std_logic;
comp_out : OUT std_logic);
END COMPONENT;
SIGNAL c_out: std_logic;
BEGIN
compon: comp PORT MAP
		(x1=>sw(0), x2=>sw(1), x3=>sw(2), comp_out=>c_out);
ledr(0) <= (c_out XOR sw(3));
END ARCHITECTURE;

