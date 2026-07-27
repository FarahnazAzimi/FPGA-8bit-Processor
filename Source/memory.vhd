library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_mem is
    port (
        clk      : in  std_logic;
        we       : in  std_logic;
        address  : in  std_logic_vector(7 downto 0);
        data_in  : in  std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end entity data_mem;

architecture behavioral of data_mem is

    type mem_array is array(0 to 255)
        of std_logic_vector(7 downto 0);

    signal RAM : mem_array := (
        0      => "00000000",
        10     => "00000101",
        others => "00000000"
    );

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                RAM(to_integer(unsigned(address))) <= data_in;
            end if;
        end if;
    end process;

    data_out <= RAM(to_integer(unsigned(address)));

end architecture behavioral;