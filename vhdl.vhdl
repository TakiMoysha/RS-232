library ieee;
use ieee.std_logic_1164.all;

entity vhdl is
    port
    (
        a: in std_ulogic;
        b: in std_ulogic;
        c: out std_ulogic;
        d: out std_ulogic
    );
end vhdl;

architecture behave of vhdl is
begin
    c <= a xor b;
    d <= a and b;
end behave;