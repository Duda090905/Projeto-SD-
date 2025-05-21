library ieee;
use ieee.std_logic_1164.all;

package comparador_package is

	component comparador
		port (
				a, b : in std_logic_vector(3 downto 0);
				equ, grt, lst : out std_logic);
	end component;
end comparador_package;