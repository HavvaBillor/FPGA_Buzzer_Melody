library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity istiklal_marsi is

    Port (
        clk     : in  std_logic;  -- 50 MHz clock
        speaker : out std_logic
    );
end istiklal_marsi;



architecture Behavioral of istiklal_marsi is


    type note_array is array (natural range <>) of integer;
    type dur_array  is array (natural range <>) of integer;
    constant melody_length : integer := 122;

   constant clkdivs : note_array := (

    47801,
    35816,
    31887,
    30120,
    37936,
    31887,
    35816,
    0,
    35816,
    26824,
    23900,
    22563,
    28409,
    23900,
    26824,
    23900,
    26824,
    23900,
    31887,
    0,
    31887,
    28409,
    37936,
    31887,
    35816,
    31887,
    30120,
    28409,
    26824,
    21294,
    20096,
    18968,
    20096,
    17908,
    18968,
    17908,
    23900,
    28409,
    37936,
    47801,
    50607,
    47801,
    31887,
    47801,
    23900,
    28409,
    37936,
    31887,
    37936,
    35816,
    18968,
    21294,
    22563,
    23900,
    28409,
    37936,
    31887,
    35816,
    23900,
    47801,
    35816,
    47801,
    35816,
    31887,
    30120,
    37936,
    31887,
    35816,
    0,
    35816,
    26824,
    23900,
    22563,
    26824,
    28409,
    23900,
    26824,
    23900,
    26824,
    23900,
    31887,
    0,
    31887,
    28409,
    37936,
    31887,
    35816,
    31887,
    30120,
    28409,
    26824,
    21294,
    20096,
    18968,
    20096,
    17908,
    18968,
    17908,
    23900,
    28409,
    37936,
    47801,
    50607,
    47801,
    31887,
    47801,
    23900,
    28409,
    37936,
    31887,
    37936,
    35816,
    18968,
    21294,
    22563,
    23900,
    28409,
    37936,
    31887,
    35816
);

constant durations : dur_array := (

    40000000,
    40000000,
    40000000,
    40000000,
    20000000,
    10000000,
    80000000,
    15000000,
    40000000,
    40000000,
    40000000,
    40000000,
    20000000,
    10000000,
    80000000,
    10000000,
    10000000,
    10000000,
    20000000,
    5000000,
    20000000,
    10000000,
    20000000,
    10000000,
    20000000,
    10000000,
    20000000,
    10000000,
    20000000,
    10000000,
    20000000,
    10000000,
    20000000,
    10000000,
    10000000,
    10000000,
    40000000,
    40000000,
    80000000,
    10000000,
    10000000,
    10000000,
    40000000,
    40000000,
    40000000,
    10000000,
    10000000,
    20000000,
    10000000,
    40000000,
    40000000,
    10000000,
    20000000,
    10000000,
    20000000,
    10000000,
    20000000,
    40000000,
    80000000,
    40000000,
    40000000,
    40000000,
    40000000,
    20000000,
    10000000,
    80000000,
    15000000,
    40000000,
    40000000,
    40000000,
    20000000,
    20000000,
    20000000,
    20000000,
    40000000,
    10000000,
    10000000,
    10000000,
    20000000,
    5000000,
    20000000,
    10000000,
    20000000,
    10000000,
    20000000,
    10000000,
    20000000,
    10000000,
    20000000,
    10000000,
    20000000,
    10000000,
    20000000,
    10000000,
    10000000,
    10000000,
    40000000,
    40000000,
    80000000,
    10000000,
    10000000,
    10000000,
    40000000,
    40000000,
    40000000,
    10000000,
    10000000,
    20000000,
    10000000,
    40000000,
    40000000,
    10000000,
    20000000,
    10000000,
    20000000,
    10000000,
    20000000,
    40000000,
    80000000,
    100000000

);





signal note_idx       : integer range 0 to melody_length := 0;
signal clk_cnt        : integer := 0;
signal half_period    : integer := 0;
signal tone_duration  : integer := 0;
signal speaker_reg    : std_logic := '0';



begin

process(clk)
    begin
        if rising_edge(clk) then
            if note_idx < melody_length then
                if tone_duration = 0 then
                    half_period   <= clkdivs(note_idx);
                    tone_duration <= durations(note_idx);
                    clk_cnt       <= 0;
                    speaker_reg   <= '0';
                    note_idx      <= note_idx + 1;
                else
                    if clkdivs(note_idx - 1) /= 0 then
                        if clk_cnt >= half_period then
                            clk_cnt <= 0;
                            speaker_reg <= not speaker_reg;
                        else
                            clk_cnt <= clk_cnt + 1;
                        end if;
                    else
                        speaker_reg <= '0'; -- REST (sessizlik)
                    end if;
                    tone_duration <= tone_duration - 1;
                end if;
            else
                speaker_reg <= '0'; -- bittiğinde sessiz kalsın
            end if;
        end if;
    end process;

    speaker <= speaker_reg;

end Behavioral;

