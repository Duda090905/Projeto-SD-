library ieee;
use ieee.std_logic_1164.all;
use work.comparador_package.all;
use work.fulladder_package.all;
use work.adder4_package.all;
use work.multiplicador_package.all;


ENTITY TopLevel IS
	PORT ( SW : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
			    HEX0,HEX2,HEX4,HEX7,HEX6 : OUT STD_LOGIC_VECTOR (0 TO 6);
			    LEDR : OUT STD_LOGIC_VECTOR (0 DOWNTO 5) );
END TopLevel;


ARCHITECTURE Behaviour OF TopLevel IS


	SIGNAL AluOp:STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL a:STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL b:STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL Equ:STD_LOGIC;
	SIGNAL Lst:STD_LOGIC;
	SIGNAL Grt:STD_LOGIC;
	SIGNAL and_result, or_result, not_result, add_result, sub_result, mul_result : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL selected_result : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL carry_out_add, carry_out_sub : STD_LOGIC;
    SIGNAL overflow_add, overflow_sub : STD_LOGIC;
    SIGNAL carry_out : STD_LOGIC;
    SIGNAL overflow : STD_LOGIC;
    SIGNAL zero : STD_LOGIC;

BEGIN
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
	
comparacao: comparador port map (
    a => a,
    b => b,
    equ => Equ,
    grt => Grt,
    lst => Lst
);

	
	-- Somador de 4 bits
soma: Adder4 PORT MAP (
    a => a,
    b => b,
    result => add_result,
    carry => carry_out_add,
    overflow => overflow_add
);

-- Subtrator de 4 bits
sub: Subtrator4 PORT MAP (
    a => a,
    b => b,
    result => sub_result,
    carry => carry_out_sub,
    overflow => overflow_sub
);

-- Multiplicador de 2 bits
mult: Mult2x2 PORT MAP (
    a => a(1 downto 0),
    b => b(1 downto 0),
    result => mul_result
);

-- Operações lógicas diretas
and_result <= a AND b;
or_result  <= a OR b;
not_result <= NOT b;


-- Seleção do resultado principal (Result)
with AluOp select
    selected_result <=
        "0000"      when "000",  -- NOP
        and_result  when "001",  -- AND
        or_result   when "010",  -- OR
        not_result  when "011",  -- NOT
        add_result  when "100",  -- ADD
        sub_result  when "101",  -- SUB
        mul_result  when "110",  -- MUL
        "0000"      when others; -- COMP não tem saída em Result

-- Seleção do carry_out (só ADD e SUB usam)
with AluOp select
    carry_out <=
        '0'             when "000" | "001" | "010" | "011" | "110" | "111",
        carry_out_add   when "100",
        carry_out_sub   when "101",
        '0'             when others;

-- Seleção do overflow (só ADD e SUB usam)
with AluOp select
    overflow <=
        '0'             when "000" | "001" | "010" | "011" | "110" | "111",
        overflow_add    when "100",
        overflow_sub    when "101",
        '0'             when others;

-- Verificador de zero
zero <= '1' when selected_result = "0000" else '0';


-- Resultado final
Result <= selected_result;

-- LEDs
LEDR(0) <= carry_out;
LEDR(1) <= zero;
LEDR(2) <= overflow;
LEDR(3) <= Equ;
LEDR(4) <= Grt;
LEDR(5) <= Lst;

	
	
	
	
	
	
	WITH b SELECT
		HEX1 <= "0000001" WHEN "0000",
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
END LogicFunc;
