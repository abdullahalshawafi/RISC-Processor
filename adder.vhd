Library ieee;
use ieee.std_logic_1164.all;

-- single bit adder

ENTITY my_adder IS 
PORT( a,b,cin : IN std_logic;
s,cout : OUT std_logic); 
END my_adder;

ARCHITECTURE a_my_adder OF my_adder IS
BEGIN

s <= a XOR b XOR cin;
cout <= (a AND b) or (cin AND (a XOR b));

END a_my_adder;

--_________________________________________________________________
-- ALU_ADDER

Library ieee;
use ieee.std_logic_1164.all;

entity ALU_ADDER is 
GENERIC (n : integer := 16);
port(
A,B : in std_logic_vector (n-1 downto 0); 
cin : in std_logic;
C,Z,Ne: out std_logic ; 
F : out std_logic_vector (n-1 downto 0)
);

end ALU_ADDER;

Architecture ALU_ADDER_arch of ALU_ADDER is

COMPONENT my_adder IS
PORT( a,b,cin : IN std_logic; s,cout : OUT std_logic);
END COMPONENT;

SIGNAL carry: std_logic_vector(n DOWNTO 0);
SIGNAL F1, zeroResult: std_logic_vector (n-1 DOWNTO 0);

begin
 
zeroResult <= (Others => '0');
carry(0) <= '0';

loop1: FOR i IN 0 TO n-1 GENERATE
	fx: my_adder PORT MAP(A(i),B(i),carry(i),F1(i),carry(i+1));
END GENERATE;
F <= F1;
C <= carry(n);
Ne <= F1(n-1);
Z <= '1' when F1 = zeroResult 
else
	'0';
end ALU_ADDER_arch;

