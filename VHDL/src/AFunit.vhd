library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils.all;

entity AFunit is 
	
	port (
		sop : in std_logic_vector(bsum - 1 downto 0);
		y : out std_logic_vector(bout - 1 downto 0) -- truncation is needed 'cause bsum > bout and the AF works on bsum bits
	);

end AFunit; 

architecture rtl of AFunit is 
	
	signal internal_y : std_logic_vector(bsum - 1 downto 0);

	begin 
		process_af : process(sop)
		variable res : integer ;
		begin
			if(to_integer(signed(sop)) >= const_2) then 
				internal_y <= repr_1;
			elsif(to_integer(signed(sop)) <= const_min_2) then
				internal_y <= repr_0;
			else
				res := to_integer( ( signed(sop) / 4 ) + signed(repr_dot5) ) ; -- linear part f(x) = x/4 + 1/2
				internal_y <= std_logic_vector(to_signed(res, bsum)) ;
			end if;
			
		end process;

		y <= internal_y(bsum - 1 downto 5); -- truncation of 5 bits 'cause bsum is 21 and bout must be 16


end architecture;

