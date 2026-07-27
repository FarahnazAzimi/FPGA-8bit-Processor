library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity prog_mem is
    port (
        address  : in  std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end entity prog_mem;

architecture behavioral of prog_mem is
begin
    process(address)
    begin
        case address is
            when "00000000" => data_out <= "00100010"; -- LDI 2
            when "00000001" => data_out <= "00111010"; -- ADD addr=10
            when "00000010" => data_out <= "00010000"; -- STA addr=0
            when "00000011" => data_out <= "11000100"; -- IN  addr=4
            when "00000100" => data_out <= "00110000"; -- ADD addr=0
            when "00000101" => data_out <= "11010000"; -- OUT addr=0
            when "00000110" => data_out <= "11110000"; -- HLT
            when others     => data_out <= "00000000";
        end case;
    end process;
end architecture behavioral;