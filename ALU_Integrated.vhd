
--________________________________________________________________
--ALU code

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ALU IS
      GENERIC (n : INTEGER := 16);
      PORT (
            Rs, Rt : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            AluOP : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            Rd : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            C, Ne, Z : OUT STD_LOGIC
      );

END ALU;
ARCHITECTURE struct OF ALU IS

      COMPONENT ALU_ADDER IS

            PORT (
                  A, B : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
                  cin : IN STD_LOGIC;
                  C, Z, Ne : OUT STD_LOGIC;
                  F : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
            );
      END COMPONENT;
      -- ################ OPERATIONS #########################
      -- 1=>NOT  2=> INC  3=>mov/push/pop/CALL/RETURN/INT/RETURN INT  4=> add/Iadd/ldd/sdd  5=> sub  6=> and  7=>ldm/sdm like add exactly ???NO

      SIGNAL oneVector, zeroVector, one_comp_Rt : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
      SIGNAL F1, F2, F3, F4, F5, F6 : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
      SIGNAL C1, C2, C3, C4, C5, C6 : STD_LOGIC;
      SIGNAL Z1, Z2, Z3, Z4, Z5, Z6 : STD_LOGIC;
      SIGNAL N1, N2, N3, N4, N5, N6 : STD_LOGIC;

BEGIN

      oneVector <= (0 => '1', OTHERS => '0');
      zeroVector <= (OTHERS => '0');
      one_comp_Rt <= NOT Rs;

      OP2 : ALU_ADDER PORT MAP(oneVector, Rs, '0', C2, Z2, N2, F2);
      OP4 : ALU_ADDER PORT MAP(Rs, Rt, '0', C4, Z4, N4, F4);
      --OP5 : ALU_ADDER PORT MAP(Rs, one_comp_Rt, '1', C5, Z5, N5, F5);
      F5 <= signed(Rs)- signed(Rt)
      -- #1 NOT OPERATION
      F1 <= NOT Rs;
      Z1 <= '1' WHEN F1 = zeroVector
            ELSE
            '0';
      N1 <= '1' WHEN F1(n - 1) = '1'
            ELSE
            '0';

      -- #3 MOV OPERATION
      F3 <= Rs;

      -- #6 AND OPERATION
      F6 <= Rs AND Rt;
      Z6 <= '1' WHEN F6 = zeroVector
            ELSE
            '0';
      N6 <= '1' WHEN F6(n - 1) = '1'
            ELSE
            '0';
      -- set Rd value

      Rd <= F1 WHEN AluOP = "001"
            ELSE
            F2 WHEN AluOP = "010"
            ELSE
            F3 WHEN AluOP = "011"
            ELSE
            F3 WHEN AluOP = "011"
            ELSE
            F4 WHEN AluOP = "100"
            ELSE
            F5 WHEN AluOP = "101"
	    ELSE
            F6 WHEN AluOP = "110"
            ELSE
            zeroVector;
      -- set carry bit 

      C <= C1 WHEN AluOP = "001"
            ELSE
            C2 WHEN AluOP = "010"
            ELSE
            C3 WHEN AluOP = "011"
            ELSE
            C4 WHEN AluOP = "100"
            ELSE
            C5 WHEN AluOP = "101"
 	   ELSE
            C6 WHEN AluOP = "110"
            ELSE
            '0';

      -- set  zero flag bit 

      Z <= Z1 WHEN AluOP = "001"
            ELSE
            Z2 WHEN AluOP = "010"
            ELSE
            Z3 WHEN AluOP = "011"
            ELSE
            Z4 WHEN AluOP = "100"
            ELSE
            Z5 WHEN AluOP = "101"
 	   ELSE
            Z6 WHEN AluOP = "110"
            ELSE
            '0';
      -- set  negative flag bit 

      Ne <= N1 WHEN AluOP = "001"
            ELSE
            N2 WHEN AluOP = "010"
            ELSE
            N3 WHEN AluOP = "011"
            ELSE
            N4 WHEN AluOP = "100"
            ELSE
            N5 WHEN AluOP = "101"
 	   ELSE
            N6 WHEN AluOP = "110"
            ELSE
            '0';
END struct;