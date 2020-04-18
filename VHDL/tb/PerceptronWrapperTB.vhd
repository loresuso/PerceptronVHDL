library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils.all;

entity PerceptronWrapperTB is
end PerceptronWrapperTB;

architecture test of PerceptronWrapperTB is

	constant T_CLK : time := 20 ns;

	signal clk_tb : std_logic := '0';
	signal reset_tb : std_logic := '1';
	signal end_sim : std_logic := '0';
	signal x_tb : inputs := (others => "00000000");
    signal y_tb : std_logic_vector(bout - 1 downto 0);

	component PerceptronWrapper is 
		port (
	    	clk     : in std_logic ;
    		reset   : in std_logic ;
			x		: in inputs	;
			y		: out std_logic_vector(bout - 1 downto 0) 
		);
	end component;  

	begin 

		clk_tb <= not(clk_tb) or end_sim after T_CLK/2;
		end_sim <= '1' after 100*T_CLK;

		p: PerceptronWrapper 
		port map (
			clk => clk_tb,
			reset => reset_tb,
			x => x_tb,
			y => y_tb
		);

		test_proc: process(clk_tb)
			variable i : integer := 0;
			begin 
				if (rising_edge(clk_tb)) then	
					case(i) is
						-- testing the perceptron (the objective is to show that it works in all the three parts of the activation function)
						when 0 => reset_tb <= '0';
						when 1 => x_tb <= (others => "01111111"); 
						when 10 => x_tb <= (others => "10000000"); 
						when 20 => x_tb <= (others => "01000000"); 		
						when others => null;
					end case;
				i := i + 1; 
				end if;
			end process;			

end architecture;
