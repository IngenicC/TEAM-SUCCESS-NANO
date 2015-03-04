

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



entity cm0_wrapper is
  port (
      rst     : in  std_logic;
      clk     : in  std_logic;
      --AMBA bus signals
      ahbi   : in  ahb_mst_in_type;
      ahbo   : out ahb_mst_out_type
);
end;


architecture cm0_wrapper of cm0_wrapper is

component ahblite_bridge is
generic (
    hindex  : integer := 0 );
  port (
      rst     : in  std_logic;
      clk     : in  std_logic;
      --AMBA bus signals
      ahbi   : in  ahb_mst_in_type;
      ahbo   : out ahb_mst_out_type;
      -- CORTEX M0      
      haddr : in std_logic_vector (31 downto 0);
      hburst : in std_logic_vector(2 downto 0);
      hsize : in std_logic_vector (2 downto 0);
      htrans : in std_logic_vector (1 downto 0);
      hwdata : in std_logic_vector (31 downto 0);
      hwrite : in std_logic;
      hrdata : out std_logic_vector (31 downto 0);
      hready : out std_logic );
end component;


COMPONENT CORTEXM0DS 
	PORT(
  -- CLOCK AND RESETS ------------------
  --input  wire        HCLK,              -- Clock
  --input  wire        HRESETn,           -- Asynchronous reset
  HCLK : IN std_logic;              -- Clock
  HRESETn : IN std_logic;           -- Asynchronous reset

  -- AHB-LITE MASTER PORT --------------
  --output wire [31:0] HADDR,             -- AHB transaction address
  --output wire [ 2:0] HBURST,            -- AHB burst: tied to single
  --output wire        HMASTLOCK,         -- AHB locked transfer (always zero)
  --output wire [ 3:0] HPROT,             -- AHB protection: priv; data or inst
  --output wire [ 2:0] HSIZE,             -- AHB size: byte, half-word or word
  --output wire [ 1:0] HTRANS,            -- AHB transfer: non-sequential only
  --output wire [31:0] HWDATA,            -- AHB write-data
  --output wire        HWRITE,            -- AHB write control
  --input  wire [31:0] HRDATA,            -- AHB read-data
  --input  wire        HREADY,            -- AHB stall signal
  --input  wire        HRESP,             -- AHB error response
  HADDR : OUT std_logic_vector (31 downto 0);             -- AHB transaction address
  HBURST : OUT std_logic_vector (2 downto 0);            -- AHB burst: tied to single
  HMASTLOCK : OUT std_logic;         -- AHB locked transfer (always zero)
  HPROT : OUT std_logic_vector (3 downto 0);              -- AHB protection: priv; data or inst
  HSIZE : OUT std_logic_vector (2 downto 0);             -- AHB size: byte, half-word or word
  HTRANS : OUT std_logic_vector (1 downto 0);            -- AHB transfer: non-sequential only
  HWDATA : OUT std_logic_vector (31 downto 0);             -- AHB write-data
  HWRITE : OUT std_logic;            -- AHB write control
  HRDATA : IN std_logic_vector (31 downto 0);            -- AHB read-data
  HREADY : IN std_logic;            -- AHB stall signal
  HRESP : IN std_logic;             -- AHB error response

  -- MISCELLANEOUS ---------------------
  --input  wire        NMI,               -- Non-maskable interrupt input
  --input  wire [15:0] IRQ,               -- Interrupt request inputs
  --output wire        TXEV,              -- Event output (SEV executed)
  --input  wire        RXEV,              -- Event input
  --output wire        LOCKUP,            -- Core is locked-up
  --output wire        SYSRESETREQ,       -- System reset request
  NMI : IN std_logic;               -- Non-maskable interrupt input
  IRQ : IN std_logic_vector (15 downto 0);               -- Interrupt request inputs
  TXEV : OUT std_logic;              -- Event output (SEV executed)
  RXEV : IN std_logic;              -- Event input
  LOCKUP : OUT std_logic;            -- Core is locked-up
  SYSRESETREQ : OUT std_logic;       -- System reset request

  -- POWER MANAGEMENT ------------------
  --output wire        SLEEPING           -- Core and NVIC sleeping
  SLEEPING : OUT std_logic          -- Core and NVIC sleeping
);
END COMPONENT;



signal haddr : std_logic_vector (31 downto 0);
signal hburst : std_logic_vector(2 downto 0);
signal hsize : std_logic_vector (2 downto 0);
signal htrans : std_logic_vector (1 downto 0);
signal hwdata : std_logic_vector (31 downto 0);
signal hwrite : std_logic;
signal hrdata : std_logic_vector (31 downto 0);
signal hready : std_logic;
signal dummy : std_logic_vector (7 downto 0);

begin


ahblite_bridge0 : ahblite_bridge
	port map(rst, clk, ahbi, ahbo, haddr, hburst, hsize, htrans, hwdata, hwrite, hrdata, hready);

CORTEXM0DS0 : CORTEXM0DS
	port map(clk, rst, haddr, hburst, dummy(0), dummy(4 downto 1), hsize, htrans, hwdata, hwrite, hrdata, hready, '0', '0' , "0000000000000000", dummy(5), '0', dummy(6), dummy(7));


end cm0_wrapper;


