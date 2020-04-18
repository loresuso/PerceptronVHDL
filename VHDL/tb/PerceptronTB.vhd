library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils.all;

entity PerceptronTB is
end PerceptronTB;

architecture test of PerceptronTB is

	constant T_CLK : time := 20 ns;

	signal clk_tb : std_logic := '0';
	signal reset_tb : std_logic := '1';
	signal end_sim : std_logic := '0';
	signal x_tb : inputs := (others => "00000000");
	signal w_tb : weights := (others => "000000000");
	signal bias_tb : std_logic_vector(bw - 1 downto 0) := "000000000";
    signal y_tb : std_logic_vector(bout - 1 downto 0);

	component Perceptron is 
		port (
	    	clk     : in std_logic ;
    		reset   : in std_logic ;
			x		: in inputs	;
			w 		: in weights ;
			bias 	: in std_logic_vector(bw - 1 downto 0) ;
			y		: out std_logic_vector(bout - 1 downto 0) 
		);
	end component;  

	begin 

		clk_tb <= not(clk_tb) or end_sim after T_CLK/2;
		end_sim <= '1' after 100*T_CLK;

		p: Perceptron 
		port map (
			clk => clk_tb,
			reset => reset_tb,
			x => x_tb,
			w => w_tb,
			bias => bias_tb,
			y => y_tb
		);

		test_proc: process(clk_tb)
			variable i : integer := 0;
			begin 
				if (rising_edge(clk_tb)) then	
					case(i) is
						-- testing the perceptron (the objective is to show that it works in all the three parts of the activation function)
						when 0 => reset_tb <= '0';
						when 1 => x_tb <= (others => "01111111"); w_tb <= (others => "011111111"); bias_tb <= "000000000";  -- 0.9922 * 0.9961 * 10 > 2 -> correct output: 1 (h0400)
						when 10 => x_tb <= (others => "00000000"); w_tb <= (others => "000000000"); bias_tb <= "000000000"; -- all is zero, so correct output 0.5 (h0200)
						when 20 => x_tb <= (others => "01000000"); w_tb <= (others => "000000001"); bias_tb <= "001000000"; -- f(0.5 * 0.0039*10 + 0.25) = 0.5673 -> actual output 0.5674 (h0245)
						when 30 => x_tb <= (others => "10000000"); w_tb <= (others => "010000000"); bias_tb <= "110000000"; -- sop is < -2 so correct output 0 (h0000)
						when 40 => x_tb <= (0 => "01000000", others => "00000000"); w_tb <= (0 => "010000000", others => "000000000"); bias_tb <= "010000000"; -- expected 0.6875, actual output 0.6875 (h02c0)
						when 50 => x_tb <= (2 downto 0 => "01000000", others => "00000000"); w_tb <= (2 downto 0 => "010000000", others => "000000000"); bias_tb <= "110000000"; -- expected 0.5625, actual output 0.5625 (h0240)
						when 60 => x_tb <= (2 downto 0 => "01000000", others => "00000000"); w_tb <= (2 downto 0 => "010000000", others => "000000000"); bias_tb <= "100000000"; -- expected 0.4375, actual output 0.4375 (h01c0)
						when others => null;
					end case;
				i := i + 1; 
				end if;
			end process;			

end architecture;

	 