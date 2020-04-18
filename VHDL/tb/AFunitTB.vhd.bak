library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils.all;

entity AFunitTB is
end AFunitTB;

architecture test of AFunitTB is 

	constant T_CLK : time 	:= 100 ns;

	component AFunit is 
	
	port (
		sop : in std_logic_vector(bsum - 1 downto 0);
		y : out std_logic_vector(bout - 1 downto 0) -- truncation is needed 'cause bsum > bout and the AF works on bsum bits
	);

	end component; 
	


	signal sop_tb : std_logic_vector(bsum - 1 downto 0);
	signal y_tb : std_logic_vector(bout - 1 downto 0); 

	begin

		af: AFunit
		port map(
			sop => sop_tb,
			y => y_tb
		);


		-- sop_tb <= "000000100000000000000"; -- 0.5
		-- sop_tb <= "000000110011001100110" after 2*T_CLK; -- 0.8
		-- sop_tb <= "111111100110011001100"; -- -0.4
		-- sop_tb <= "100000000000000000000";
		-- sop_tb <= "000010000000000000000";
		-- sop_tb <= "000001111111111111111";	
		   sop_tb <= "000000000000000000000";	
	
end architecture;