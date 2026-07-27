library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_cpu is
end entity tb_cpu;

architecture behavioral of tb_cpu is

    component cpu_top is
        port (
            clk        : in  std_logic;
            rst        : in  std_logic;
            port_in_0  : in  std_logic_vector(7 downto 0);
            port_in_1  : in  std_logic_vector(7 downto 0);
            port_out_0 : out std_logic_vector(7 downto 0);
            port_out_1 : out std_logic_vector(7 downto 0);
            hlt        : out std_logic;
            cnt_enable : in  std_logic;
            cnt_dir    : in  std_logic;
            cnt_load   : in  std_logic;
            cnt_carry  : out std_logic;
            tmr_enable : in  std_logic;
            tmr_load   : in  std_logic;
            tmr_done   : out std_logic
        );
    end component;

    signal clk        : std_logic := '0';
    signal rst        : std_logic := '1';
    signal port_in_0  : std_logic_vector(7 downto 0) := "00000000";
    signal port_in_1  : std_logic_vector(7 downto 0) := "00000000";
    signal port_out_0 : std_logic_vector(7 downto 0);
    signal port_out_1 : std_logic_vector(7 downto 0);
    signal hlt        : std_logic;
    signal cnt_enable : std_logic := '0';
    signal cnt_dir    : std_logic := '1';
    signal cnt_load   : std_logic := '0';
    signal cnt_carry  : std_logic;
    signal tmr_enable : std_logic := '1';
    signal tmr_load   : std_logic := '0';
    signal tmr_done   : std_logic;

    constant CLK_PERIOD : time := 20 ns;

begin

    UUT: cpu_top
        port map(
            clk        => clk,
            rst        => rst,
            port_in_0  => port_in_0,
            port_in_1  => port_in_1,
            port_out_0 => port_out_0,
            port_out_1 => port_out_1,
            hlt        => hlt,
            cnt_enable => cnt_enable,
            cnt_dir    => cnt_dir,
            cnt_load   => cnt_load,
            cnt_carry  => cnt_carry,
            tmr_enable => tmr_enable,
            tmr_load   => tmr_load,
            tmr_done   => tmr_done
        );

    clk <= not clk after CLK_PERIOD / 2;

    process
    begin
        -- ????? ?? ????? ???? ??? (tmr_enable=1 ?? ????? ??????)
        -- Reset ???? 3 ????
        rst <= '1';
        wait for 3 * CLK_PERIOD;

        -- ???? CPU
        rst <= '0';

        -- ??? ???? ????? ??????
        wait for 500 * CLK_PERIOD;

        wait;
    end process;

end architecture behavioral;