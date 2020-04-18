library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils.all;

entity PerceptronWrapper is 
	port (
	    clk     : in std_logic ;
    	reset   : in std_logic ;
		x		: in inputs	;
		-- no weights here
		-- no bias here 
		y		: out std_logic_vector(bout - 1 downto 0) 
	);
end PerceptronWrapper;

architecture rtl of PerceptronWrapper is 

	component Perceptron is
  		port (
	    	clk     : in std_logic ;
    		reset   : in std_logic ;
			x		: in inputs	;
			w 		: in weights ;
			bias 	: in std_logic_vector(bw - 1 downto 0) ;
			y		: out std_logic_vector(bout - 1 downto 0)   
  		);
	end component ;

	signal y_wrapper : std_logic_vector(bout - 1 downto 0);

	begin 

		myPerceptron : Perceptron 
		port map (
			clk => clk,
			reset => reset, 
			x => x,
			w => const_weight, 
			bias => const_bias,
			y => y_wrapper
		);
		
		y <= y_wrapper;

end architecture; -- rtl 