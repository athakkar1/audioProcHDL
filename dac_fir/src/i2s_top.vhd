library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.sinewave.all;

entity i2s_top is
    port(
        mclk : in std_logic;
        reset : in std_logic;
        mclk_i2s : out std_logic;
        bclk : out std_logic;
        pblrc : out std_logic;
        pbdat : out std_logic;
        recdat : in std_logic
    );
end entity i2s_top;

architecture RTL of i2s_top is
    COMPONENT ila_0

        PORT (
            clk : IN STD_LOGIC;
            probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
            probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
            probe2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
            probe3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe5 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
            probe6 : IN STD_LOGIC_VECTOR(23 DOWNTO 0)
        );
        END COMPONENT  ;
    component clk_wiz_0
        port
         (-- Clock in ports
          -- Clock out ports
          clk_out1          : out    std_logic;
          clk_in1           : in     std_logic
         );
        end component;

    component i2s_pb
        generic(data_len : integer := 24);
        port(
            bclk         : in  std_logic;
            pbdat        : out std_logic;
            pblrc        : out std_logic;
            pbword_left  : in  std_logic_vector(data_len - 1 downto 0);
            pbword_right : in  std_logic_vector(data_len - 1 downto 0);
            reset        : in  std_logic
        );
    end component i2s_pb;

    component i2s_rec
        generic(data_len : integer := 24);
        port(
            bclk          : in  std_logic;
            recdat        : in  std_logic;
            reclrc        : in  std_logic;
            recword_left  : out std_logic_vector(data_len - 1 downto 0);
            recword_right : out std_logic_vector(data_len - 1 downto 0);
            reset         : in  std_logic
        );
    end component i2s_rec; 
    signal mclk_i : std_logic_vector(0 downto 0);
    signal bclk_i : std_logic_vector(0 downto 0) := (others => '1');
    signal fake_data_word : std_logic_vector(23 downto 0) := (others => '0');
    signal pbdat_i : std_logic_vector(0 downto 0);
    signal pblrc_i : std_logic_vector(0 downto 0);
    signal recdat_i : std_logic_vector(0 downto 0);
    signal recword_left : std_logic_vector(23 downto 0);
    signal recword_right : std_logic_vector(23 downto 0);
    
begin

    clk_wiz_0_i : clk_wiz_0
    port map ( 
   -- Clock out ports  
    clk_out1 => mclk_i(0), --12.288 MHz
    -- Clock in ports
    clk_in1 => mclk
  );

  i2s_pb_inst : component i2s_pb
    generic map(
        data_len => 24
    )
    port map(
        bclk         => bclk_i(0),
        pbdat        => pbdat_i(0),
        pblrc        => pblrc_i(0),
        pbword_left  => recword_left(23 downto 0),
        pbword_right => recword_left(23 downto 0),
        reset        => reset
    );

i2s_rec_inst : entity work.i2s_rec
    generic map(
        data_len => 24
    )
    port map(
        bclk          => bclk_i(0),
        recdat        => recdat,
        reclrc        => pblrc_i(0),
        recword_left  => recword_left,
        recword_right => recword_right,
        reset         => reset
    );


    logic_analyzer : ila_0
PORT MAP (
	clk => mclk,
	probe0 => mclk_i, 
	probe1 => bclk_i, 
	probe2 => pbdat_i, 
	probe3 => pblrc_i,
	probe4 => recdat_i,
    probe5 => recword_left,
    probe6 => recword_right
);
  

  bclk_gen : process(mclk_i)
    variable count : integer range 0 to 4 := 0;
begin
    if rising_edge(mclk_i(0)) then
        if count < 1 then
            count := count + 1;
        else
            bclk_i <= not bclk_i; -- ~3 MHz
            count  := 0;
        end if;
    end if;
end process bclk_gen;

fake_data : process(bclk_i)
variable count : integer range 0 to 10000 := 0;
variable i : integer range 0 to 4095 := 0;
begin
    if(rising_edge(bclk_i(0))) then
        if count /= 2 then
            count := count + 1;
        else
            if i /= 4095 then
                i := i + 1;
            else
                i := 0;
            end if;
            fake_data_word <= std_logic_vector(wave(i));
            --fake_data_word <= "100000000000000000000001";
            count := 0;
        end if;
    end if;
end process fake_data;


mclk_i2s <= mclk_i(0);
bclk <= bclk_i(0);
pbdat <= pbdat_i(0);
pblrc <= pblrc_i(0);
recdat_i(0) <= recdat;
end architecture RTL;
