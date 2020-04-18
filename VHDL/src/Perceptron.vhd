library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils.all;

entity Perceptron is 
	port (
	    clk     : in std_logic ;
    	reset   : in std_logic ;
		x		: in inputs	;
		w 		: in weights ;
		bias 	: in std_logic_vector(bw - 1 downto 0) ;
		y		: out std_logic_vector(bout - 1 downto 0) 
	);
end Perceptron;

architecture rtl of Perceptron is 

	component InputRegisters is
  		port (
    		clk     : in std_logic ;
    		reset   : in std_logic ;
    		x       : in inputs    ;
    		x_out   : out inputs    
  		) ;
	end component ;

	component WeightRegisters is
  		port (
    		clk     : in std_logic ;
    		reset   : in std_logic ;
    		w       : in weights   ;
    		w_out   : out weights  ;
			bias 	: in std_logic_vector(bw - 1 downto 0);  
			bias_out 	: out std_logic_vector(bw - 1 downto 0) 
  		) ;
	end component ;

	component SOPunit is 
		port (
			x		: in inputs	;
			w 		: in weights ;
			bias 	: in std_logic_vector(bw - 1 downto 0) ;
			SOPout	: out std_logic_vector(bsum - 1 downto 0)
		);	
	end component;

	component AFunit is 
		port (
			sop : in std_logic_vector(bsum - 1 downto 0);
			y : out std_logic_vector(bout - 1 downto 0) 
		);
	end component; 

	component DFFregister is
		generic( Nbit : positive); 
		port (
			reset	: in std_logic ;
			clk		: in std_logic ;
			en		: in std_logic ;
			di		: in std_logic_vector(Nbit-1 downto 0) ;
			do		: out std_logic_vector(Nbit-1 downto 0)
		);
	end component;
 
	signal x_internal : inputs;
	signal w_internal : weights;
	signal bias_internal : std_logic_vector(bw - 1 downto 0);
	signal sop_internal : std_logic_vector(bsum - 1 downto 0);
	signal y_toRegister : std_logic_vector(bout - 1 downto 0); 
	signal y_internal : std_logic_vector(bout - 1 downto 0);
	signal sop_toRegister : std_logic_vector(bsum - 1 downto 0);
	signal register_toAf : std_logic_vector(bsum - 1 downto 0);

	begin

	-- =============================================
	-- 					REGISTERS
	-- =============================================

	inputRegs : InputRegisters
	port map (
		clk => clk,
		reset => reset, 
		x => x, 
		x_out => x_internal
	);

	weightRegs : WeightRegisters
	port map (
		clk => clk,
		reset => reset,
		w => w, 
		w_out => w_internal,
		bias => bias, 
		bias_out => bias_internal
	);

	-- =============================================



	-- =============================================
	-- 						ALU
	-- =============================================

	sop : SOPunit			-- SUM OF PRODUCTS UNIT
	port map (
		x => x_internal, 
		w => w_internal, 
		bias => bias_internal,
		SOPout => sop_toRegister
	);

	pipeReg :DFFregister	-- PIPE REGISTER
	generic map (Nbit => bsum) 
	port map (
		reset   => reset, 
        clk     => clk, 
        en      => '1', 
        di      => sop_toRegister, 
        do      => register_toAf
    );

	af : AFunit				-- ACTIVATION FUNCTION UNIT
	port map (
		sop => register_toAf,
		y => y_toRegister
	);

	-- =============================================



	-- =============================================
	-- 				OUTPUT REGISTER
	-- =============================================

	outReg :DFFregister
	generic map (Nbit => bout) 
	port map (
		reset   => reset, 
        clk     => clk, 
        en      => '1', 
        di      => y_toRegister, 
        do      => y_internal
    );

	-- =============================================

	y <= y_internal;

end architecture; -- rtl 