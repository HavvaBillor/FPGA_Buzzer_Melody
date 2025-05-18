library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;



entity TOP_MODULE is 
port(
		CLK: in std_logic;
		RST_N: in std_logic;
		BUZZER :out std_logic;
		VGA_HS, VGA_VS : out std_logic;
		VGA_B : out std_logic_vector (4 downto 0);
		VGA_G: out std_logic_vector (5 downto 0);
		VGA_R: out std_logic_vector (4 downto 0)
		);
end TOP_MODULE;

architecture Behavioral of TOP_MODULE is


------------------------------------------------------
------------------COMPONENTS--------------------------
component istiklal_marsi is
    Port (
        clk     : in  std_logic;  -- 50 MHz clock
        speaker : out std_logic
    );

end component;


component VGA_Driver is
	port(
		CLK: in std_logic;
		VGA_HS, VGA_VS : out std_logic;
		VGA_B : out std_logic_vector (4 downto 0);
		VGA_G: out std_logic_vector (5 downto 0);
		VGA_R: out std_logic_vector (4 downto 0)
		);
end component;

component clock_wizard
port
 (-- Clock in ports
  CLK_IN1           : in     std_logic;
  -- Clock out ports
  CLK_OUT1          : out    std_logic;
  CLK_OUT2          : out    std_logic
 );
end component;

---------------------------------------------------------
---------------------SIGNALS-----------------------------
signal pixel_clk :std_logic;
signal CLK_1 :std_logic;
---------------------------------------------------------

begin

	 
PLL: clock_wizard
  port map
   (-- Clock in ports
    CLK_IN1 => CLK,
    -- Clock out ports
    CLK_OUT1 => pixel_clk,
    CLK_OUT2 => CLK_1);	 
	 
	 
Buzzer_inst:  istiklal_marsi 
    Port map (
        clk     => CLK_1,
        speaker => BUZZER
);
 

VGA: VGA_Driver 
	port map(
		CLK	 => pixel_clk,	
		VGA_HS => VGA_HS,
		VGA_VS => VGA_VS,
		VGA_R  => VGA_R,
		VGA_G  => VGA_G,
		VGA_B  => VGA_B
		);

end Behavioral;
