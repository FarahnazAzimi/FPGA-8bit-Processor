library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_file is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        load_acc : in  std_logic;
        load_b   : in  std_logic;
        load_pc  : in  std_logic;
        load_ir  : in  std_logic;
        load_mar : in  std_logic;
        load_mdr : in  std_logic;
        data_in  : in  std_logic_vector(7 downto 0);
        acc_out  : out std_logic_vector(7 downto 0);
        b_out    : out std_logic_vector(7 downto 0);
        pc_out   : out std_logic_vector(7 downto 0);
        ir_out   : out std_logic_vector(7 downto 0);
        mar_out  : out std_logic_vector(7 downto 0);
        mdr_out  : out std_logic_vector(7 downto 0);
        pc_inc   : in  std_logic
    );
end entity reg_file;

architecture behavioral of reg_file is

    signal ACC : std_logic_vector(7 downto 0) := (others => '0');
    signal B   : std_logic_vector(7 downto 0) := (others => '0');
    signal PC  : std_logic_vector(7 downto 0) := (others => '0');
    signal IR  : std_logic_vector(7 downto 0) := (others => '0');
    signal MAR : std_logic_vector(7 downto 0) := (others => '0');
    signal MDR : std_logic_vector(7 downto 0) := (others => '0');

begin

    process(clk, rst)
    begin
        if rst = '1' then
            ACC <= (others => '0');
            B   <= (others => '0');
            PC  <= (others => '0');
            IR  <= (others => '0');
            MAR <= (others => '0');
            MDR <= (others => '0');
        elsif rising_edge(clk) then
            if load_ir  = '1' then IR  <= data_in; end if;
            if load_mar = '1' then MAR <= data_in; end if;
            if load_mdr = '1' then MDR <= data_in; end if;
            if load_b   = '1' then B   <= data_in; end if;
            if load_acc = '1' then ACC <= data_in; end if;
            if load_pc  = '1' then
                PC <= data_in;
            elsif pc_inc = '1' then
                PC <= std_logic_vector(unsigned(PC) + 1);
            end if;
        end if;
    end process;
    acc_out <= ACC;
    b_out   <= B;
    pc_out  <= PC;
    ir_out  <= IR;
    mar_out <= MAR;
    mdr_out <= MDR;

end architecture behavioral;