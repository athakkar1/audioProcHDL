--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
--Date        : Sat Oct  5 17:12:50 2024
--Host        : somalia running 64-bit Ubuntu 22.04.4 LTS
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_wrapper is
    generic(
        data_len : integer := 24
    );
    port(
        mclk              : in    std_logic;
        user_mute         : in    std_logic;
        mute              : out   std_logic := '1';
        ac_mclk           : out   std_logic;
        bclk              : out   std_logic;
        pbdat             : out   std_logic;
        pblrc             : out   std_logic;
        recdat            : in    std_logic;
        reclrc            : out   std_logic;
        reset             : in    std_logic;
        led_out           : out   std_logic;
        DDR_addr          : inout STD_LOGIC_VECTOR(14 downto 0);
        DDR_ba            : inout STD_LOGIC_VECTOR(2 downto 0);
        DDR_cas_n         : inout STD_LOGIC;
        DDR_ck_n          : inout STD_LOGIC;
        DDR_ck_p          : inout STD_LOGIC;
        DDR_cke           : inout STD_LOGIC;
        DDR_cs_n          : inout STD_LOGIC;
        DDR_dm            : inout STD_LOGIC_VECTOR(3 downto 0);
        DDR_dq            : inout STD_LOGIC_VECTOR(31 downto 0);
        DDR_dqs_n         : inout STD_LOGIC_VECTOR(3 downto 0);
        DDR_dqs_p         : inout STD_LOGIC_VECTOR(3 downto 0);
        DDR_odt           : inout STD_LOGIC;
        DDR_ras_n         : inout STD_LOGIC;
        DDR_reset_n       : inout STD_LOGIC;
        DDR_we_n          : inout STD_LOGIC;
        FIXED_IO_ddr_vrn  : inout STD_LOGIC;
        FIXED_IO_ddr_vrp  : inout STD_LOGIC;
        FIXED_IO_mio      : inout STD_LOGIC_VECTOR(53 downto 0);
        FIXED_IO_ps_clk   : inout STD_LOGIC;
        FIXED_IO_ps_porb  : inout STD_LOGIC;
        FIXED_IO_ps_srstb : inout STD_LOGIC;
        IIC_0_0_scl_io    : inout STD_LOGIC;
        IIC_0_0_sda_io    : inout STD_LOGIC
    );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
    component design_1 is
        port(
            DDR_cas_n         : inout STD_LOGIC;
            DDR_cke           : inout STD_LOGIC;
            DDR_ck_n          : inout STD_LOGIC;
            DDR_ck_p          : inout STD_LOGIC;
            DDR_cs_n          : inout STD_LOGIC;
            DDR_reset_n       : inout STD_LOGIC;
            DDR_odt           : inout STD_LOGIC;
            DDR_ras_n         : inout STD_LOGIC;
            DDR_we_n          : inout STD_LOGIC;
            DDR_ba            : inout STD_LOGIC_VECTOR(2 downto 0);
            DDR_addr          : inout STD_LOGIC_VECTOR(14 downto 0);
            DDR_dm            : inout STD_LOGIC_VECTOR(3 downto 0);
            DDR_dq            : inout STD_LOGIC_VECTOR(31 downto 0);
            DDR_dqs_n         : inout STD_LOGIC_VECTOR(3 downto 0);
            DDR_dqs_p         : inout STD_LOGIC_VECTOR(3 downto 0);
            FIXED_IO_mio      : inout STD_LOGIC_VECTOR(53 downto 0);
            FIXED_IO_ddr_vrn  : inout STD_LOGIC;
            FIXED_IO_ddr_vrp  : inout STD_LOGIC;
            FIXED_IO_ps_srstb : inout STD_LOGIC;
            FIXED_IO_ps_clk   : inout STD_LOGIC;
            FIXED_IO_ps_porb  : inout STD_LOGIC;
            IIC_0_0_sda_i     : in    STD_LOGIC;
            IIC_0_0_sda_o     : out   STD_LOGIC;
            IIC_0_0_sda_t     : out   STD_LOGIC;
            IIC_0_0_scl_i     : in    STD_LOGIC;
            IIC_0_0_scl_o     : out   STD_LOGIC;
            IIC_0_0_scl_t     : out   STD_LOGIC
        );
    end component design_1;

    component IOBUF is
        port(
            I  : in    STD_LOGIC;
            O  : out   STD_LOGIC;
            T  : in    STD_LOGIC;
            IO : inout STD_LOGIC
        );
    end component IOBUF;

    component i2s_top
        port(
            mclk     : in  std_logic;
            reset    : in  std_logic;
            mclk_i2s : out std_logic;
            bclk     : out std_logic;
            pblrc    : out std_logic;
            pbdat    : out std_logic;
            recdat   : in std_logic
        );
    end component i2s_top;

    signal IIC_0_0_scl_i   : STD_LOGIC;
    signal IIC_0_0_scl_o   : STD_LOGIC;
    signal IIC_0_0_scl_t   : STD_LOGIC;
    signal IIC_0_0_sda_i   : STD_LOGIC;
    signal IIC_0_0_sda_o   : STD_LOGIC;
    signal IIC_0_0_sda_t   : STD_LOGIC;
    signal led_1           : std_logic := '0';
    signal bclk_i          : std_logic;
    signal pblrc_i         : std_logic;
    signal pbdat_i         : std_logic;
    signal mclk_i          : std_logic;
begin
    bclk        <= bclk_i;
    pbdat       <= pbdat_i;
    pblrc       <= pblrc_i;
    ac_mclk <= mclk_i;
    reclrc <= pblrc_i;
    i2s_top_inst : component i2s_top
        port map(
            mclk     => mclk,
            reset    => reset,
            mclk_i2s => mclk_i,
            bclk     => bclk_i,
            pblrc    => pblrc_i,
            pbdat    => pbdat_i,
            recdat => recdat
        );

    IIC_0_0_scl_iobuf : component IOBUF
        port map(
            I  => IIC_0_0_scl_o,
            IO => IIC_0_0_scl_io,
            O  => IIC_0_0_scl_i,
            T  => IIC_0_0_scl_t
        );
    IIC_0_0_sda_iobuf : component IOBUF
        port map(
            I  => IIC_0_0_sda_o,
            IO => IIC_0_0_sda_io,
            O  => IIC_0_0_sda_i,
            T  => IIC_0_0_sda_t
        );
    design_1_i : component design_1
        port map(
            DDR_addr(14 downto 0)     => DDR_addr(14 downto 0),
            DDR_ba(2 downto 0)        => DDR_ba(2 downto 0),
            DDR_cas_n                 => DDR_cas_n,
            DDR_ck_n                  => DDR_ck_n,
            DDR_ck_p                  => DDR_ck_p,
            DDR_cke                   => DDR_cke,
            DDR_cs_n                  => DDR_cs_n,
            DDR_dm(3 downto 0)        => DDR_dm(3 downto 0),
            DDR_dq(31 downto 0)       => DDR_dq(31 downto 0),
            DDR_dqs_n(3 downto 0)     => DDR_dqs_n(3 downto 0),
            DDR_dqs_p(3 downto 0)     => DDR_dqs_p(3 downto 0),
            DDR_odt                   => DDR_odt,
            DDR_ras_n                 => DDR_ras_n,
            DDR_reset_n               => DDR_reset_n,
            DDR_we_n                  => DDR_we_n,
            FIXED_IO_ddr_vrn          => FIXED_IO_ddr_vrn,
            FIXED_IO_ddr_vrp          => FIXED_IO_ddr_vrp,
            FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
            FIXED_IO_ps_clk           => FIXED_IO_ps_clk,
            FIXED_IO_ps_porb          => FIXED_IO_ps_porb,
            FIXED_IO_ps_srstb         => FIXED_IO_ps_srstb,
            IIC_0_0_scl_i             => IIC_0_0_scl_i,
            IIC_0_0_scl_o             => IIC_0_0_scl_o,
            IIC_0_0_scl_t             => IIC_0_0_scl_t,
            IIC_0_0_sda_i             => IIC_0_0_sda_i,
            IIC_0_0_sda_o             => IIC_0_0_sda_o,
            IIC_0_0_sda_t             => IIC_0_0_sda_t
        );
    
    process(mclk_i)
        variable divider : integer := 1000000;
        variable count   : integer := 0;
    begin
        if rising_edge(mclk_i) then
            if count /= divider then
                count := count + 1;
            else
                count := 0;
                led_1 <= not led_1;
            end if;
        end if;
    end process;
    led_out <= led_1;
    mute    <= user_mute;
end STRUCTURE;
