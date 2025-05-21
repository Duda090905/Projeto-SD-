library ieee;
use ieee.std_logic_1164.all;

ENTITY Comparator IS
	PORT ( x,y : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		AltB,AgtB,AeqB: OUT STD_LOGIC );
END Comparator;

ARCHITECTURE LogicFunc OF Comparator IS
	SIGNAL i1,i2,i3,i0:STD_LOGIC;
	SIGNAL AUX1,AUX2:STD_LOGIC;
	
BEGIN

	i0 <= x(0) XNOR y(0);
	i1 <= x(1) XNOR y(1);
	i2 <= x(2) XNOR y(2);
	i3 <= x(3) XNOR y(3);
	AUX1 <= i0 AND i1 AND i2 AND i3;
	AeqB <= AUX1;
	
	Aux2 <= (x(3) AND (NOT y(3))) OR (i3 AND (NOT y(2)) AND x(2)) OR (i3 AND i2 AND (NOT y(1)) AND x(1)) OR (i3 AND i2 AND i1 AND (NOT y(0)) AND x(0));
	AgtB <= AUX2;
	
	Altb <= AUX1 NOR AUX2;
	
END LogicFunc;