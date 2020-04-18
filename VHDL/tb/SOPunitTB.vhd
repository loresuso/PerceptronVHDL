library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils.all;

entity SOPunitTB is
end SOPunitTB;


architecture test of SOPunitTB is 

	component SOPunit is 
	
	port (
		x		: in inputs	;
		w 		: in weights ;
		bias 	: in std_logic_vector(bw - 1 downto 0) ;
		SOPout	: out std_logic_vector(bsum - 1 downto 0)
	);

	end component;

	signal bias_tb : std_logic_vector(bw - 1 downto 0);
	signal x_tb : inputs;
	signal w_tb : weights;
	signal out_tb : std_logic_vector(bsum - 1 downto 0);
	begin
		sop: SOPunit
		port map (
			x => x_tb, 
			w => w_tb,
			bias => bias_tb, 
			SOPout => out_tb
		);

		x_tb <= (others => "00010001");
		w_tb <= (others => "000010001");
		bias_tb <= "000000000";
end architecture;