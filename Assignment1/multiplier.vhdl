library IEEE;
use IEEE.NUMERIC_BIT.all;
 

entity MULTIPLIER is 
 port (A0  : in  bit;
       A1  : in  bit;
       B0  : in  bit;
       B1  : in  bit;
       C0  : out bit;
       C1  : out bit;
       C2  : out bit;
       C3  : out bit);
end MULTIPLIER;

architecture RTL_INTEGER
of MULTIPLIER is 
  signal A_VEC : unsigned (1 downto 0 );
  signal B_VEC : unsigned (1 downto 0 );  
  signal A_INT : integer range 0 to 3;
  signal B_INT : integer range 0 to 3;
  signal C_VEC : unsigned (3 downto 0 );
  signal C_INT : integer range 0 to 9;
begin
 
  A_VEC <= A1 & A0;
  A_INT <= TO_INTEGER(A_VEC);
  B_VEC <= B1 & B0;
  B_INT <= TO_INTEGER(B_VEC);
 
  C_INT <= A_INT * B_INT;
 
  C_VEC <= TO_UNSIGNED(C_INT, 4);
 
  (C3, C2, C1, C0) <= C_VEC;
end RTL_INTEGER;
