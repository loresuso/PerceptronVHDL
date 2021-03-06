library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils.all;

entity SOPunit is 
	
	port (
		x		: in inputs	;
		w 		: in weights ;
		bias 	: in std_logic_vector(bw - 1 downto 0) ;
		SOPout	: out std_logic_vector(bsum - 1 downto 0)
	);

end SOPunit;

architecture rtl of SOPunit is 

	signal a	: std_logic_vector(bsum - 1 downto 0);

	signal a1	: std_logic_vector(bproduct-1 downto 0);
	signal a2	: std_logic_vector(bproduct-1 downto 0);
	signal a3	: std_logic_vector(bproduct-1 downto 0);
	signal a4	: std_logic_vector(bproduct-1 downto 0);
	signal a5	: std_logic_vector(bproduct-1 downto 0);
	signal a6	: std_logic_vector(bproduct-1 downto 0);
	signal a7	: std_logic_vector(bproduct-1 downto 0);
	signal a8	: std_logic_vector(bproduct-1 downto 0);
	signal a9	: std_logic_vector(bproduct-1 downto 0);
	signal a10	: std_logic_vector(bproduct-1 downto 0);

	begin 
		
		-- products 
		a1 <= std_logic_vector(signed(x(0))*signed(w(0)));	
		a2 <= std_logic_vector(signed(x(1))*signed(w(1)));
		a3 <= std_logic_vector(signed(x(2))*signed(w(2)));
		a4 <= std_logic_vector(signed(x(3))*signed(w(3)));
		a5 <= std_logic_vector(signed(x(4))*signed(w(4)));
		a6 <= std_logic_vector(signed(x(5))*signed(w(5)));
		a7 <= std_logic_vector(signed(x(6))*signed(w(6)));
		a8 <= std_logic_vector(signed(x(7))*signed(w(7)));
		a9 <= std_logic_vector(signed(x(8))*signed(w(8)));
		a10 <= std_logic_vector(signed(x(9))*signed(w(9)));

		process_SOP: process(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,bias)	-- process used to compute the sum of the products (SOP)
		variable a_v : std_logic_vector(bsum - 1 downto 0);
		variable biase : std_logic_vector(bsum - 1 downto 0);	-- variable containing the extendend and aligned version fo the bias

		-- variables containing the extended version of ai for each i
		variable a1e	: std_logic_vector(bsum-1 downto 0);
		variable a2e	: std_logic_vector(bsum-1 downto 0);
		variable a3e	: std_logic_vector(bsum-1 downto 0);
		variable a4e	: std_logic_vector(bsum-1 downto 0);
		variable a5e	: std_logic_vector(bsum-1 downto 0);
		variable a6e	: std_logic_vector(bsum-1 downto 0);
		variable a7e	: std_logic_vector(bsum-1 downto 0);
		variable a8e	: std_logic_vector(bsum-1 downto 0);
		variable a9e	: std_logic_vector(bsum-1 downto 0);
		variable a10e	: std_logic_vector(bsum-1 downto 0);
	
		begin 
			-- extending
			a1e := (bsum - 1 downto bproduct => a1(bproduct - 1)) & a1;
			a2e := (bsum - 1 downto bproduct => a2(bproduct - 1)) & a2;
			a3e := (bsum - 1 downto bproduct => a3(bproduct - 1)) & a3;
			a4e := (bsum - 1 downto bproduct => a4(bproduct - 1)) & a4;
			a5e := (bsum - 1 downto bproduct => a5(bproduct - 1)) & a5;
			a6e := (bsum - 1 downto bproduct => a6(bproduct - 1)) & a6;
			a7e := (bsum - 1 downto bproduct => a7(bproduct - 1)) & a7;
			a8e := (bsum - 1 downto bproduct => a8(bproduct - 1)) & a8;
			a9e := (bsum - 1 downto bproduct => a9(bproduct - 1)) & a9;
			a10e := (bsum - 1 downto bproduct => a10(bproduct - 1)) & a10;
		
			-- summing up all together
			biase := bias(bw - 1) & bias(bw - 1) & bias(bw - 1) & bias(bw - 1) & bias(bw - 1) & bias & (6 downto 0 => '0'); -- extension and alignment of the bias
			a_v := std_logic_vector(signed(a1e) + signed(a2e) + signed(a3e) + signed(a4e) + signed(a5e) + signed(a6e) + signed(a7e) + signed(a8e) + signed(a9e) + signed(a10e) + signed(biase));
			a <= a_v;
		end process;
		
		SOPout <= a;
	
end architecture; -- rtl 