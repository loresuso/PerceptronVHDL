library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;

entity InputRegisters is
  port (
    clk     : in std_logic ;
    reset   : in std_logic ;
    x       : in inputs    ;
    x_out   : out inputs    
  ) ;
end InputRegisters ;

architecture rtl of InputRegisters is

    component DFFregister is
        generic( Nbit : positive ) ; 
        port (
            reset	: in std_logic ;
            clk	    : in std_logic ;
            en	    : in std_logic ;
            di	    : in std_logic_vector(Nbit-1 downto 0);
            do	    : out std_logic_vector(Nbit-1 downto 0)
        );
    end component;

begin

    GEN_INPUT:
    for i in 0 to N_in - 1 generate
        INPUT_DFF : DFFregister
        generic map (Nbit => bx)
        port map (
            reset   => reset, 
            clk     => clk, 
            en      => '1', 
            di      => x(i), 
            do      => x_out(i)
        );
    end generate GEN_INPUT;

end architecture ; -- rtl
