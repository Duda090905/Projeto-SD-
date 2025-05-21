
library ieee;
use ieee.std_logic_1164.all;


    package fulladder_package is
        
    component fulladder is
    port (
        a, b, cin : in std_logic;
        sum, cout,overflow : out std_logic
    );
    end component;
    
    end fulladder_package;
