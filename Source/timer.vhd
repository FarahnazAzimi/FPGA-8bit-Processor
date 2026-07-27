library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        enable   : in  std_logic;
        load     : in  std_logic;
        data_in  : in  std_logic_vector(7 downto 0);
        count    : out std_logic_vector(7 downto 0);
        done     : out std_logic
    );
end entity timer;

architecture behavioral of timer is
    signal cnt : unsigned(7 downto 0) := (others => '0');
begin

    process(clk, rst)
    begin
        if rst = '1' then
            cnt <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                cnt <= unsigned(data_in);
            elsif enable = '1' then
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    count <= std_logic_vector(cnt);
    done  <= '1' when cnt = "11111111" else '0';

end architecture behavioral;