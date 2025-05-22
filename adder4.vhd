library ieee;
use ieee.std_logic_1164.all;
use work.componentes_ula_package.all;

entity adder4 is

  port (
  
    a, b    : in std_logic_vector(3 downto 0); -- entrada de 4 bits (operandos A e B)
    cin     : in std_logic; -- Carry-in
    sum     : out std_logic_vector(3 downto 0); -- saída que representa a soma final de 4 bits
    cout, overflow   : out std_logic -- Carry-out final e overflow 
	   );
		
end adder4;

architecture structural of adder4 is

  signal c : std_logic_vector(3 downto 0);


	begin
	
	-- somador completo do bit menos significativo
	
  stage0: fulladder
    port map (
    a(0),b(0), cin,sum(0),c(0) -- gera sum(0) e carry interno c(0)
              );
	 
	-- somador completo do segundo bit menos significativo
	
  stage1: fulladder
    port map (
    a(1),b(1),c(0),sum(1),c(1) -- gera sum(1) e carry interno c(1)
             );
	 
  -- somador completo do segundo bit mais significativo 
  
  stage2: fulladder
    port map (
    a(2),b(2),c(1),sum(2),c(2) -- gera sum(2) e carry interno c(2)
             );
  -- somador completo do bit mais significativo 
  
  stage3: fulladder
    port map (
  a(3),b(3),c(2),sum(3),cout   -- gera sum(3) e carry interno c(3)
             );
	 
	 -- Detecta overflow para números sinalizados (soma de dois números positivos dando negativo e soma de negativos que dão positivo)
	 
	 overflow <= (a(3) AND b(3) AND NOT sum(3)) OR (NOT a(3) AND NOT b(3) AND sum(3));
	 
	 
	 
 

end structural;