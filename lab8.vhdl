Project#1 main circuit

library IEEE;
use IEEE.std_logic_1164.all;
entity lab8 is
	port (
	sw: in std_logic_vector(17 downto 0);
	ledr: out std_logic_vector (7 downto 0);
	ledg: out std_logic_vector (7 downto 0);
	hex0,hex1,hex2, hex3, hex4, hex5, hex6, hex7: out std_logic_vector (6 downto 0));
end entity;

architecture sample of lab8 is
-- components
component D_latch IS
  PORT ( 
    D, Ck: IN STD_LOGIC;
    Q: OUT STD_LOGIC);
END component;

component Dflip_flop IS
  PORT ( 
    Df, Ckf: IN STD_LOGIC;
    Qf: OUT STD_LOGIC);
END component;

component Tflip_flop IS
  PORT ( 
    T, Ckt: IN STD_LOGIC;
    Qt: OUT STD_LOGIC);
END component;

signal outputQ: std_logic;
signal outputf_f: std_logic;
signal outputT: std_logic;

begin

comp0: D_latch PORT MAP
		(D=> sw(0), Ck =>sw(1), Q=>outputQ);
		
comp1: Dflip_flop PORT MAP
		(Df=> sw(0), Ckf =>sw(1), Qf=>outputf_f);	
	
comp2: Tflip_flop PORT MAP
		(T=> sw(0), Ckt =>sw(1), Qt=>outputT);		
		
ledr(0) <= outputQ;	
ledg(0) <= not outputQ;	

ledr(1) <= outputf_f;	
ledg(1) <= not outputf_f;	

ledr(2) <= outputT;	
ledg(2) <= not outputT;


end architecture;



Project #2 main circuit
library IEEE;
use IEEE.std_logic_1164.all;
entity lab8 is
	port (
	sw: in std_logic_vector(17 downto 0);
	KEY: in std_logic_vector(3 downto 0);
	ledr: out std_logic_vector (7 downto 0);
	ledg: out std_logic_vector (7 downto 0);
	hex0,hex1,hex2, hex3, hex4, hex5, hex6, hex7: out std_logic_vector (6 downto 0));
end entity;

architecture sample of lab8 is
-- components
component up_counter IS
  PORT ( 
    En, Clk, Reset: IN STD_LOGIC;
    up_count: OUT std_logic_vector(3 downto 0));
END component;

component down_counter IS
  PORT ( 
    En, Clk, Reset: IN STD_LOGIC;
    up_count: OUT std_logic_vector(3 downto 0));
END component;

begin

comp0: up_counter PORT MAP
		(En => sw(0), Clk => KEY(0), Reset =>  sw(1), up_count => ledr(3 downto 0));
		
comp1: down_counter PORT MAP
		(En => sw(0), Clk => KEY(0), Reset =>  sw(1), up_count => ledg(3 downto 0));

end architecture;



# components
-- D latch
Library IEEE;
Use IEEE.std_logic_1164.all;
ENTITY D_latch IS
  PORT ( 
    D, Ck: IN STD_LOGIC;
    Q: OUT STD_LOGIC);
END D_latch;

ARCHITECTURE Behavior1 OF D_latch IS
Signal Rg, Sg, Qa, Qb : std_logic;
Attribute Keep : boolean;
Attribute Keep of Rg, Sg, Qa, Qb : Signal is True;
BEGIN
Rg <= not(Ck and D);
Sg <= not((not D) and Ck);
Qa <= not(Rg and Qb);
Qb <= not(Sg and Qa);

Q<= Qa; 
END Behavior1;

-- D flip-flop
Library IEEE;
Use IEEE.std_logic_1164.all;
ENTITY Dflip_flop IS
  PORT ( 
    Df, Ckf: IN STD_LOGIC;
    Qf: OUT STD_LOGIC);
END Dflip_flop;

ARCHITECTURE Behavior2 OF Dflip_flop IS
component D_latch IS
  PORT ( 
    D, Ck: IN STD_LOGIC;
    Q: OUT STD_LOGIC);
END component;

Signal Qm : std_logic;
Signal outputQ : std_logic;

BEGIN
comp0: D_latch PORT MAP
		(D=> Df, Ck =>not Ckf, Q=>Qm);
comp1: D_latch PORT MAP
		(D=> Qm, Ck =>Ckf, Q=>outputQ);

Qf <= outputQ; 
END Behavior2;


-- T flip-flop
Library IEEE;
Use IEEE.std_logic_1164.all;
ENTITY Tflip_flop IS
  PORT ( 
    T, Ckt, reset: IN STD_LOGIC;
    Qt: OUT STD_LOGIC);
END Tflip_flop;

ARCHITECTURE Behavior3 OF Tflip_flop IS

component Dflip_flop IS
  PORT ( 
    Df, Ckf: IN STD_LOGIC;
    Qf: OUT STD_LOGIC);
END component;
signal Qs: std_logic;

signal s1: std_logic;
signal s2: std_logic;
signal s3: std_logic;

BEGIN

s1 <= (not T) and Qs;
s2 <= T and (not Qs);
s3 <= s1 or s2;

comp0:Dflip_flop PORT MAP
		(Df=> s3, Ckf =>Ckt, Qf=>Qs);
		
process(reset)
variable v :std_logic := '0';
begin
	v := '0'; 
	if reset = '0' then
		v := Qs;
	elsif reset = '1' then
		v := '0';
	end if;
	Qt <= v;
end process;

END Behavior3;


-- Up counter
Library IEEE;
Use IEEE.std_logic_1164.all;
ENTITY up_counter IS
  PORT ( 
    En, Clk, Reset: IN STD_LOGIC;
    up_count: OUT std_logic_vector(3 downto 0));
END up_counter;

ARCHITECTURE Behavior4 OF up_counter IS
component Tflip_flop IS
  PORT ( 
    T, Ckt, reset: IN STD_LOGIC;
    Qt: OUT STD_LOGIC);
END component;

signal Q0: std_logic;
signal Q1: std_logic;
signal Q2: std_logic;
signal Q3: std_logic;

signal t1: std_logic;
signal t2: std_logic;
signal t3: std_logic;

signal Q_v: std_logic_vector(3 downto 0);

BEGIN

comp0: Tflip_flop PORT MAP
		(T=> En, Ckt =>Clk, reset =>Reset, Qt=>Q0);
t1 <= Q0 and En;
		
comp1: Tflip_flop PORT MAP
		(T=> t1, Ckt =>Clk, reset =>Reset, Qt=>Q1);
t2 <= Q1 and t1;
		
comp2: Tflip_flop PORT MAP
		(T=> t2, Ckt =>Clk, reset =>Reset, Qt=>Q2);	
t3 <= Q2 and t2;
		
comp3: Tflip_flop PORT MAP
		(T=> t3, Ckt =>Clk, reset =>Reset, Qt=>Q3);		

Q_v(0) <= Q0;
Q_v(1) <= Q1;
Q_v(2) <= Q2;
Q_v(3) <= Q3;

up_count <= Q_v;
				
END Behavior4;


-- Down counter
Library IEEE;
Use IEEE.std_logic_1164.all;
ENTITY down_counter IS
  PORT ( 
    En, Clk, Reset: IN STD_LOGIC;
    up_count: OUT std_logic_vector(3 downto 0));
END down_counter;

ARCHITECTURE Behavior5 OF down_counter IS
component Tflip_flop IS
  PORT ( 
    T, Ckt, reset: IN STD_LOGIC;
    Qt: OUT STD_LOGIC);
END component;

signal Q0: std_logic;
signal Q1: std_logic;
signal Q2: std_logic;
signal Q3: std_logic;

signal t1: std_logic;
signal t2: std_logic;
signal t3: std_logic;

signal r: std_logic;

signal Q_v: std_logic_vector(3 downto 0);

BEGIN

comp0: Tflip_flop PORT MAP
		(T=> En, Ckt =>Clk,reset =>Reset, Qt=>Q0);
t1 <= (not Q0) and En;
		
comp1: Tflip_flop PORT MAP
		(T=> t1, Ckt =>Clk,reset =>Reset, Qt=>Q1);
t2 <= (not Q1) and t1;
		
comp2: Tflip_flop PORT MAP
		(T=> t2, Ckt =>Clk, reset =>Reset,Qt=>Q2);	
t3 <= (not Q2) and t2;
		
comp3: Tflip_flop PORT MAP
		(T=> t3, Ckt =>Clk,reset =>Reset, Qt=>Q3);		

Q_v(0) <= Q0;
Q_v(1) <= Q1;
Q_v(2) <= Q2;
Q_v(3) <= Q3;

up_count <= Q_v;

END Behavior5;