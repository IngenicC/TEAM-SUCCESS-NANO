library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library gaisler;
use gaisler.misc.all;
library UNISIM;
use UNISIM.VComponents.all;


entity state_machine is
 port (
    clk : in std_logic; -- Clock.
    reset : in std_logic; -- Synchronous reset.
    htrans : in std_logic_vector (1 downto 0);
    dmao : in ahb_dma_out_type;
    dmai : out ahb_dma_in_type;
    hready : out std_logic;
    haddr : in std_logic_vector (31 downto 0);
    hburst : in std_logic_vector(2 downto 0);
    hsize : in std_logic_vector (2 downto 0);
    hwdata : in std_logic_vector (31 downto 0);
    hwrite : in std_logic;
    out_state : out std_logic_vector (1 downto 0)
);
end state_machine;



architecture state_machine of state_machine is
begin
	process (clk,reset)
	variable state : std_logic_vector (1 downto 0) := "00";
	begin

	if (rising_edge(clk)) then
		out_state <= state;
		dmai.address <= haddr;
		dmai.wdata <= hwdata;
		dmai.size <= hsize;
		dmai.write <= hwrite;

		case state is

		  when "00" =>
		  	hready <= '1';
		  	dmai.start <= '0';
		    if htrans = "10" then
				state := "01";
		    end if;

		  when "01" =>
		  	hready <= '0';
		  	dmai.start <= '1';
		  	state := "10";
		  	if (reset = '1') then
		  		state := "00";
		  	end if;

		  when "10" =>
		  	dmai.start <= '0';
		  	hready <= '0';
		  	if (dmao.ready = '1') then
		  		state := "00";
		  	end if;
		  when others =>
		  	state := "00";
		end case;
	end if;
	end process;
end state_machine;