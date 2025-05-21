    
library ieee;
use ieee.std_logic_1164.all;


    package adder4_package is
        
    component adder4 is
    port (
        a, b : in std_logic_vector(3 downto 0);
        cin : in std_logic;
        sum : out std_logic_vector(3 downto 0);
        cout : out std_logic

    );
    
    end component;

    end adder4_package;
