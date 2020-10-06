library ieee;
use ieee.std_logic_1164.all;

entity vhdl_tb is
end vhdl_tb;

architecture test of vhdl_tb is
    component vhdl
        port
        (
            a: in std_ulogic;
            b: in std_ulogic;
            c: out std_ulogic;
            d: out std_ulogic
        );
    end component;

    signal a, b, c, d: std_ulogic;
begin
    half_adder: vhdl port map (a => a, b => b, c => c, d => d);

    process begin

        a <= 'X';
        b <= 'X';
        wait for 1 ns;

        a <= '0';
        b <= '0';
        wait for 1 ns;

        a <= '0';
        b <= '1';
        wait for 1 ns;

        a <= '1';
        b <= '0';
        wait for 1 ns;

        a <= '1';
        b <= '1';
        wait for 1 ns;

        assert false report "Reached end of test";
        wait;

    end process;

end test;