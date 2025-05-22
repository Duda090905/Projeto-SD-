library ieee;
use ieee.std_logic_1164.all;


entity fulladder is
    port (
    a    : in  std_logic; -- Bit de entrada a
    b    : in  std_logic; -- Bit de entrada b
    cin  : in  std_logic; -- Carry-in 
    sum  : out std_logic; -- Bit de soma
    cout : out std_logic  -- Carry-out 
    );
end entity;

architecture behavior of fulladder is
begin
    -- Soma: a XOR b XOR cin
        sum <= a xor b xor cin;

    -- Carry-out: (a AND b) OR (cin AND (a XOR b))
    cout <= (a and b) or (cin and (a xor b));
end architecture;