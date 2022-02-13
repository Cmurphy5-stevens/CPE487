library ieee;
use ieee.std_logic_1164.ALL;

entity half_adder_tb IS
end half_adder_tb;

architecture tb_arch of half_adder_tb is

    signal i_bit1, i_bit2 : std_logic;
    signal o_sum, o_carry : std_logic;

begin 

    UUT : entity work.half_adder port map (i_bit1 => i_bit1, i_bit2 => i_bit2, o_sum => o_sum, o_carry => o_carry);

    process 
        constant delay: time := 10 ns;
        begin
        i_bit1 <= '0';
        i_bit2 <= '0';
        wait for delay;
        i_bit1 <= '1';
        i_bit2 <= '0';
        wait for delay;
        i_bit1 <= '0';
        i_bit2 <= '1';
        wait for delay;
        i_bit1 <= '1';
        i_bit2 <= '1';
        wait for delay;
    end process;
end tb_arch;
    
