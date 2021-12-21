LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- single bit adder

ENTITY my_adder IS
	PORT (
		a, b, cin : IN STD_LOGIC;
		s, cout : OUT STD_LOGIC);
END my_adder;

ARCHITECTURE a_my_adder OF my_adder IS
BEGIN

	s <= a XOR b XOR cin;
	cout <= (a AND b) OR (cin AND (a XOR b));

END a_my_adder;

--_________________________________________________________________
-- ALU_ADDER

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ALU_ADDER IS
	GENERIC (n : INTEGER := 16);
	PORT (
		A, B : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
		cin : IN STD_LOGIC;
		C, Z, Ne : OUT STD_LOGIC;
		F : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
	);

END ALU_ADDER;

ARCHITECTURE ALU_ADDER_arch OF ALU_ADDER IS

	COMPONENT my_adder IS
		PORT (
			a, b, cin : IN STD_LOGIC;
			s, cout : OUT STD_LOGIC);
	END COMPONENT;

	SIGNAL carry : STD_LOGIC_VECTOR(n DOWNTO 0);
	SIGNAL F1, zeroResult : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);

BEGIN

	zeroResult <= (OTHERS => '0');
	carry(0) <= '0';

	loop1 : FOR i IN 0 TO n - 1 GENERATE
		fx : my_adder PORT MAP(A(i), B(i), carry(i), F1(i), carry(i + 1));
	END GENERATE;

	F <= F1;
	C <= carry(n);
	Ne <= F1(n - 1);
	Z <= '1' WHEN F1 = zeroResult
		ELSE
		'0';
END ALU_ADDER_arch;