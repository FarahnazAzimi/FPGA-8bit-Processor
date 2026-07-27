library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        enable   : in  std_logic;
        dir      : in  std_logic;
        -- dir=1 ????????  dir=0 ??????????
        load     : in  std_logic;
        data_in  : in  std_logic_vector(7 downto 0);
        count    : out std_logic_vector(7 downto 0);
        carry    : out std_logic
    );
end entity counter;

architecture behavioral of counter is

    signal cnt : unsigned(7 downto 0) := (others => '0');

begin

    process(clk, rst)
    begin
        if rst = '1' then
            cnt <= (others => '0');

        elsif rising_edge(clk) then

            -- ??? load ???? ???? ????? ????? ????
            if load = '1' then
                cnt <= unsigned(data_in);

            -- ??? enable ???? ???? ?????
            elsif enable = '1' then
                if dir = '1' then
                    cnt <= cnt + 1;  -- ????????
                else
                    cnt <= cnt - 1;  -- ??????????
                end if;
            end if;

        end if;
    end process;

    -- ????? count
    count <= std_logic_vector(cnt);

    -- carry:
    -- ????????: ???? ?? FF ?? 00 ??? ? carry=1
    -- ??????????: ???? ?? 00 ?? FF ??? ? carry=1
    carry <= '1' when (dir = '1' and cnt = "11111111") else
             '1' when (dir = '0' and cnt = "00000000") else
             '0';

end architecture behavioral;