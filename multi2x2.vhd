library ieee;
use ieee.std_logic_1164.all;
use work.componentes_ula_package.all;

entity multi2x2 is
    port (
        a, b   : in  std_logic_vector(1 downto 0); -- Entradas a e b (2 bits cada)
        result : out std_logic_vector(3 downto 0)  -- Resultado da multiplicação (4 bits)
    );
end entity;

architecture behaviour of multi2x2 is

    signal p0, p1, p2, p3 : std_logic;
    signal sum0, sum1 : std_logic;
    signal cout0, cout1 : std_logic;

begin

    -- Produto parcial
	 
	 
    p0 <= a(0) and b(0); -- bit 0
    p1 <= (a(1) and b(0)) ;
    p2 <= (a(0) and b(1)) ;
    p3 <= a(1) and b(1); -- bit 3 (será somado com p2 como carry)

	 -- Soma dos produtos parciais p1 e p2
	
    stage1: fulladder
        port map (
            p1, p2,'0', sum0, cout0
	);
	
	-- Soma de p3 com o carry gerado anteriormente
	
stage2: fulladder
    port map(
	p3, cout0, '0', sum1, cout1
	);
    
    
    
    -- Montagem do resultado
	 
    result(0) <= p0;
    result(1) <= sum0;
    result(2) <= sum1 ;
    result(3) <= cout1;     -- carry final (msb)
end architecture;