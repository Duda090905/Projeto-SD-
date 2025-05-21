library ieee;
use ieee.std_logic_1164.all;


entity fulladder is
    port (
    a    : in  std_logic;
    b    : in  std_logic;
    cin  : in  std_logic;
    sum  : out std_logic;
    cout : out std_logic
    );
end entity;

architecture behavior of fulladder is
begin
    -- Soma: a XOR b XOR cin
        sum <= a xor b xor cin;

    -- Carry-out: (a AND b) OR (cin AND (a XOR b))
    cout <= (a and b) or (cin and (a xor b));
end architecture;