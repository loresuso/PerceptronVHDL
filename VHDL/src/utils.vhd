library IEEE;
use IEEE.std_logic_1164.all;

package utils is
		
        constant N_in   	: integer := 10 ;   -- number of in inputs
        constant bx     	: integer := 8 ;    -- number of bits of an input
        constant bw     	: integer := 9 ;    -- number of bits of a weight and bias 
		constant bsum		: integer := 21 ;	-- number of bits of the output of the SOPunit 
		constant bproduct 	: integer := 17 ;	-- number of bits of a product between input and weight
		constant bout 		: integer := 16 ; 	-- number of bits of the output perceptron 
		constant repr_dot5 	: std_logic_vector(bsum - 1 downto 0) := "000000100000000000000" ;	-- representation of 0.5
		constant repr_1		: std_logic_vector(bsum - 1 downto 0) := "000001000000000000000" ;	-- representation of 1.0
		constant repr_0		: std_logic_vector(bsum - 1 downto 0) := "000000000000000000000" ;  -- representation of 0.0
		constant const_2	: integer := 65536 ;	-- integer corresponding to 2
		constant const_min_2: integer := -65536 ;	-- integer corresponding to -2 	

        -- definition of useful types, one for weights and one for inputs 
        type weights is array(N_in - 1 downto 0) of std_logic_vector(bw - 1 downto 0);
		type inputs is array(N_in - 1 downto 0) of std_logic_vector(bx - 1 downto 0);

		-- constant weight to reduce nuber of inputs in the wrapper (otherwise 197 bits input
		-- are too much for the zybo board)
		constant const_weight : weights := (others => "010000000");
		constant const_bias : std_logic_vector(bw - 1 downto 0) := "010000000";

		-- I chose to let the weights be constant because I think that when realizing a network in HW it is 
		-- first of all tested and trained in SW, so the weights are already adjusted when realizing it in HW.
        
end package;


