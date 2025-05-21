library ieee;
use ieee.std_logic_1164.all;
use work.fulladder_package.all;

entity adder4 is
    port (
    a, b    : in std_logic_vector(3 downto 0);
    cin     : in std_logic;
    sum     : out std_logic_vector(3 downto 0);
    cout    : out std_logic
    );
end adder4;

architecture structural of adder4 is

    signal c : std_logic_vector(3 downto 0);

	begin

        

    stage0: fulladder
    port map (
    a(0),b(0), cin,sum(0),c(0)
    );

    stage1: fulladder
    port map (
    a(1),b(1),c(0),sum(1),c(1)
    );

    stage2: fulladder
    port map (
    a(2),b(2),c(1),sum(2),c(2)
    );

    stage3: fulladder
    port map (
    a(3),b(3),c(2),sum(3),cout
    );



end structural;