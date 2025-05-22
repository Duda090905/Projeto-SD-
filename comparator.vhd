library ieee;
use ieee.std_logic_1164.all;


entity comparator4 is

	port (
		a, b : in std_logic_vector (3 downto 0); --entrada de 4 bits (operandos A e B)
		equ  : out std_logic; -- 1 se A = B
		grt  : out std_logic; -- 1 se A > B
		lst  : out std_logic  -- 1 se A < B
	);
end comparator4;

architecture LogicFunc of comparator4 is

	signal i0, i1, i2, i3 : std_logic; -- Sinais auxiliares para igualdade
	signal aux1, aux2 : std_logic;     -- aux1: igualdade total, aux2: A > B

	begin

-- Cada i(n) verifica se A(n) e B(n) são iguais
-- XNOR retorna 1 se os bits forem iguais

	i0 <= a(0) XNOR b(0);
	i1 <= a(1) XNOR b(1);
	i2 <= a(2) XNOR b(2);
	i3 <= a(3) XNOR b(3);
	
	
	

	aux1 <= i0 AND i1 AND i2 AND i3;
	equ <= aux1; -- equ = 1 apenas se todos os bits forem iguais 

	
	-- Compara os bits de maneira prioritária , do MSB (a(3)) para o LSB (a(0))
	
	aux2 <= (a(3) AND (NOT b(3))) OR
	        (i3 AND a(2) AND (NOT b(2))) OR
	        (i3 AND i2 AND a(1) AND (NOT b(1))) OR
	        (i3 AND i2 AND i1 AND a(0) AND (NOT b(0)));
	grt <= aux2;

	lst <= NOT (aux1 OR aux2); -- se A é diferente de B (aux=0) e também nao maior que B (aux=0), restando apenas que ele seja o menor
	
end LogicFunc;