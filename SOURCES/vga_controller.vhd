-----------------------------------------------------------------------------
-- HAVVA BİLLOR--
--VGA Controller
-----------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.TermProjectLibrary.ALL;



entity VGA_Driver is
	port(
		CLK: in std_logic;
		VGA_HS, VGA_VS : out std_logic;
		VGA_B : out std_logic_vector (4 downto 0);
		VGA_G: out std_logic_vector (5 downto 0);
		VGA_R: out std_logic_vector (4 downto 0)
		);
end VGA_Driver;



architecture Behavioral of VGA_Driver is


---------------------------------------------------

-------------------Components----------------------

component VGA_Sync is
    Port ( 

        CLK : in std_logic;
	bg_blue : in std_logic_vector (4 downto 0);
	bg_green: in std_logic_vector (5 downto 0);
	bg_red: in std_logic_vector (4 downto 0);
        H_PosOut, V_PosOut : out std_logic_vector(11 downto 0);
        VGA_HS, VGA_VS : out std_logic;
        VGA_B : out std_logic_vector (4 downto 0);
	VGA_G: out std_logic_vector (5 downto 0);
	VGA_R: out std_logic_vector (4 downto 0)
	);
end component;


---------------------------------------------------

-------------------signals-------------------------

signal H_Pos, V_Pos : std_logic_vector(11 downto 0);
signal bg_red  :  std_logic_vector(4 downto 0);
signal bg_green :  std_logic_vector(5 downto 0);
signal bg_blue :  std_logic_vector(4 downto 0);

signal rom_addr     : std_logic_vector(14 downto 0);
signal rom_data     : std_logic_vector(15 downto 0);


---------------------------------------------------
-------------------constant------------------------

constant FRAME_WIDTH : natural := 1024;
constant FRAME_HEIGHT : natural := 768;

-- Frame Constants

constant xFrameLeft : natural := 10; 
constant xFrameRight : natural := 10;
constant yFrameTop : natural := 92;
constant yFrameBottom : natural := 46;
constant xFrameWidth : natural := 910;
constant xFrameCenter : natural := 505;
constant yFrameHeight : natural := 600;
constant yFrameCenter : natural := 392;
-- image constants
constant IMAGE_WIDTH     : natural := 384;
constant IMAGE_HEIGHT    : natural := 384;
constant Xstart          : natural := xFrameLeft;
constant Ystart          : natural := yFrameTop;

----------------------------------------------------------------
----------------------------- R0M ------------------------------

COMPONENT image_rom
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

---------------------------------------------------------------


begin


--VGA INST

VGA_Sync_Module: VGA_Sync

        port map(

            CLK       => CLK,
	    bg_blue   => bg_blue,
            bg_red    => bg_red,
            bg_green  => bg_green,
            H_PosOut  => H_Pos,
            V_PosOut  => V_Pos,
            VGA_HS    => VGA_HS,
            VGA_VS    => VGA_VS,
            VGA_R     => VGA_R,
            VGA_G     => VGA_G,
            VGA_B     => VGA_B
        ); 

-- ROM INST

ROM : image_rom
  PORT MAP (
    clka => CLK,
    addra => rom_addr,
    douta => rom_data
  );


process(CLK)

variable x_pos_int, y_pos_int : integer;
variable addr_int : integer;
variable local_x, local_y : integer;

begin 


	if rising_edge(CLK) then 

		bg_red <= "00000";
		bg_green <= "000000";
		bg_blue <= "10101";


		if (V_Pos < yFrameTop - 20) then -- Top

			if (draw_string(conv_integer(H_Pos), conv_integer(V_Pos), 300 - 32 , 32, " GENCLIGE HITABE", false, 3)) then
						  
				bg_red <= (others => '1');
				bg_green <= (others => '1');
				bg_blue <= (others => '1');

			end if;

		elsif (V_Pos >= yFrameTop and V_Pos <= yFrameTop + yFrameHeight) then -- Middle

				x_pos_int := to_integer(unsigned(H_Pos));
				y_pos_int := to_integer(unsigned(V_Pos));
				
				if (x_pos_int >= 300) and (x_pos_int < 300 + 384) and(y_pos_int >= Ystart) and (y_pos_int < Ystart + 384) then
				
					-- Ölçekleme: Her 3x3 VGA pikseli için 1 ROM pikseli
					local_x := (x_pos_int - Xstart + 90) / 3;  -- yatayda kayma tespit edildi
					local_y := (y_pos_int - Ystart) / 3;
				
					addr_int := local_y * 128 + local_x;
					rom_addr <= std_logic_vector(to_unsigned(addr_int, 15));
				
					bg_red   <= rom_data(15 downto 11);
					bg_green <= rom_data(10 downto 5);
					bg_blue  <= rom_data(4 downto 0);
				else
					bg_red <= "00000";
					bg_green <= "000000";
					bg_blue <= "10101";
				end if;
				
				if (draw_string(conv_integer(H_Pos), conv_integer(V_Pos), 100 , 500, "Ey Turk Gencligi! Birinci vazifen Turk", false, 2)) then

						bg_red <= (others => '1');
						bg_green <= (others => '1');
						bg_blue <= (others => '1');
				elsif (draw_string(conv_integer(H_Pos), conv_integer(V_Pos), 100 , 550, "istiklalini, Turk Cumhuriyeti'ni ilelebet,", false, 2)) then

						bg_red <= (others => '1');
						bg_green <= (others => '1');
						bg_blue <= (others => '1');
				elsif (draw_string(conv_integer(H_Pos), conv_integer(V_Pos), 100 , 600, "muhafaza ve mudafaa etmektir.", false, 2)) then

						bg_red <= (others => '1');
						bg_green <= (others => '1');
						bg_blue <= (others => '1');
				elsif (draw_string(conv_integer(H_Pos), conv_integer(V_Pos), 400 , 650, "Gazi Mustafa Kemal Ataturk", false, 2)) then

						bg_red <= (others => '1');
						bg_green <= (others => '1');
						bg_blue <= (others => '1');

				end if;  
		end if;
	end if;


end process;

end Behavioral;





















