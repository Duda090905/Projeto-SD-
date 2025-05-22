library ieee;
use ieee.std_logic_1164.all;
use work.componentes_ula_package.all;



ENTITY TopLevel IS -- -- Definição da entidade com entradas dos switches e saídas para displays e LEDs.

	PORT ( 		SW : IN STD_LOGIC_VECTOR (10 DOWNTO 0); --Switches
					HEX0,HEX2,HEX4,HEX6 : OUT STD_LOGIC_VECTOR (0 TO 6); --displays
					LEDR : OUT STD_LOGIC_VECTOR (5 DOWNTO 0) --LEDs 
			);
END TopLevel;


ARCHITECTURE Behaviour OF TopLevel IS


	SIGNAL AluOp:STD_LOGIC_VECTOR (2 DOWNTO 0); -- Operação da ULA
	SIGNAL a:STD_LOGIC_VECTOR (3 DOWNTO 0); -- A
	SIGNAL b:STD_LOGIC_VECTOR (3 DOWNTO 0); -- B
	SIGNAL Equ:STD_LOGIC; -- Igualdade entre A e B
	SIGNAL Lst:STD_LOGIC; -- Se A < B
	SIGNAL Grt:STD_LOGIC; -- Se A > B
	
	-- Resultados para operações do ULA
	
	SIGNAL and_result, or_result, not_result, add_result, sub_result, mul_result : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL selected_result : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	-- Carry e Overflow para ADD e SUB
   SIGNAL carry_out_add, carry_out_sub : STD_LOGIC;
   SIGNAL overflow_add, overflow_sub,overflow : STD_LOGIC;
	
   SIGNAL carry_out : STD_LOGIC; -- Carry selecionado entre soma e subtração, mostrado no LEDR(0)
   SIGNAL zero : STD_LOGIC; -- Flag Zero

	

BEGIN

--Mapeamento dos switches

-- Definição de quais bits SW (vetor) controlam a,b e AluOp

	a(0) <= SW(7);
	a(1) <= SW(8);
	a(2) <= SW(9);
	a(3) <= SW(10);
	
	b(0) <= SW(3);
	b(1) <= SW(4);
	b(2) <= SW(5);
	b(3) <= SW(6);
	
	AluOp(0)<= SW(0);
	AluOp(1)<= SW(1);
	AluOp(2)<= SW(2);
	
	
	-- Instancia o comparador e conecta as saídas de comparaçaõ (igual, maior, menor
	
comparacao: comparator4 PORT MAP (
    a, b, Equ, Grt, Lst
											);

	
	-- Instancia o Somador de 4 bits, fazendo A+B com o cin (carry in) valendo 0

soma: Adder4 PORT MAP (
    a, b, '0', add_result, carry_out_add, overflow_add	
	 
	 -- cin `0` baseado no circuito somador/subtrator
							
							);
							

-- Subtrator de 4 bits utilizando o Adder 4 com complemento de 2

sub: Adder4 PORT MAP (
    a, not_result, '1', sub_result, carry_out_sub, overflow_sub
	 
	 -- not_result -> valor de b invertido para a realização do complemento de 2
	 -- cin `1`baseado no circuito somador/subtrator
	 
	 
							);

 

-- Multiplicador de 2 bits (multiplica os 2 bits menos significativos)
 
	mult: multi2x2 PORT MAP (
    a(1 downto 0), b(1 downto 0), mul_result
									);


-- Operações lógicas diretas
and_result <= a AND b;
or_result  <= a OR b;
not_result <= NOT b;


-- Seleção do resultado principal

with AluOp select
    selected_result <=
        "0000"      when "000",  -- NOP
        and_result  when "001",  -- AND
        or_result   when "010",  -- OR
        not_result  when "011",  -- NOT
        add_result  when "100",  -- ADD
        sub_result  when "101",  -- SUB
        mul_result  when "110",  -- MUL
        "0000"      when others; -- COMP não tem saída no resultado

-- Seleção do carry_out (só ADD e SUB usam)
with AluOp select
    carry_out <=
        carry_out_add when "100",
        carry_out_sub when "101",
        '0'           when others;


-- Seleção do overflow (só ADD e SUB usam)
with AluOp select
    overflow <=
        overflow_add   when "100",
        overflow_sub   when "101",
        '0'            when others;


		  
-- Verificador de zero
zero <= '1' when selected_result = "0000" else '0';




-- LEDs
LEDR(0) <= carry_out; 
LEDR(1) <= zero;
LEDR(2) <= overflow;
LEDR(3) <= Equ;
LEDR(4) <= Grt;
LEDR(5) <= Lst;

	
	
	WITH AluOp SELECT
    HEX0 <=  "0000001" WHEN "000",  -- 0
             "1001111" WHEN "001",  -- 1
             "0010010" WHEN "010",  -- 2
             "0000110" WHEN "011",  -- 3
             "1001100" WHEN "100",  -- 4
             "0100100" WHEN "101",  -- 5
             "0100000" WHEN "110",  -- 6
             "0001111" WHEN "111",  -- 7
             "1111111" WHEN others;

	
	WITH b SELECT
		HEX2 <= "0000001" WHEN "0000",
				    "1001111" WHEN "0001",
				    "0010010" WHEN "0010",
				    "0000110" WHEN "0011",
				    "1001100" WHEN "0100",
				    "0100100" WHEN "0101",
				    "0100000" WHEN "0110",
				    "0001111" WHEN "0111",
				    "0000000" WHEN "1000",
				    "0001100" WHEN "1001",
				    "0001000" WHEN "1010",
				    "1100000" WHEN "1011",
				    "0110001" WHEN "1100",
				    "1000010" WHEN "1101",
				    "0110000" WHEN "1110",
				    "0111000" WHEN "1111",
				    "1111111" WHEN others;
	WITH a SELECT
		HEX4 <= "0000001" WHEN "0000",
				    "1001111" WHEN "0001",
				    "0010010" WHEN "0010",
				    "0000110" WHEN "0011",
				    "1001100" WHEN "0100",
				    "0100100" WHEN "0101",
				    "0100000" WHEN "0110",
				    "0001111" WHEN "0111",
				    "0000000" WHEN "1000",
				    "0001100" WHEN "1001",
				    "0001000" WHEN "1010",
				    "1100000" WHEN "1011",
				    "0110001" WHEN "1100",
				    "1000010" WHEN "1101",
				    "0110000" WHEN "1110",
				    "0111000" WHEN "1111",
				    "1111111" WHEN others;
					 
					 
	WITH selected_result SELECT
	
	---- Convertem os valores binários em números
	
    HEX6 <= "0000001" WHEN "0000",
             "1001111" WHEN "0001",
             "0010010" WHEN "0010",
             "0000110" WHEN "0011",
             "1001100" WHEN "0100",
             "0100100" WHEN "0101",
             "0100000" WHEN "0110",
             "0001111" WHEN "0111",
             "0000000" WHEN "1000",
             "0001100" WHEN "1001",
             "0001000" WHEN "1010",
             "1100000" WHEN "1011",
             "0110001" WHEN "1100",
             "1000010" WHEN "1101",
             "0110000" WHEN "1110",
             "0111000" WHEN "1111",
             "1111111" WHEN others;
END Behaviour;