library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity io_ports is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        io_we      : in  std_logic;
        io_re      : in  std_logic;
        io_addr    : in  std_logic_vector(3 downto 0);
        data_in    : in  std_logic_vector(7 downto 0);
        data_out   : out std_logic_vector(7 downto 0);
        port_in_0  : in  std_logic_vector(7 downto 0);
        port_in_1  : in  std_logic_vector(7 downto 0);
        port_out_0 : out std_logic_vector(7 downto 0);
        port_out_1 : out std_logic_vector(7 downto 0);
        cnt_data   : in  std_logic_vector(7 downto 0);
        cnt_carry  : in  std_logic;
        tmr_data   : in  std_logic_vector(7 downto 0);
        tmr_done   : in  std_logic
    );
end entity io_ports;

architecture behavioral of io_ports is

    signal reg_out_0 : std_logic_vector(7 downto 0) := (others => '0');
    signal reg_out_1 : std_logic_vector(7 downto 0) := (others => '0');

begin

    process(clk, rst)
    begin
        if rst = '1' then
            reg_out_0 <= (others => '0');
            reg_out_1 <= (others => '0');
        elsif rising_edge(clk) then
            if io_we = '1' then
                case io_addr is
                    when "0000" => reg_out_0 <= data_in;
                    when "0001" => reg_out_1 <= data_in;
                    when others => null;
                end case;
            end if;
        end if;
    end process;

    process(io_re, io_addr,
            port_in_0, port_in_1,
            cnt_data, cnt_carry,
            tmr_data, tmr_done)
    begin
        data_out <= (others => '0');
        if io_re = '1' then
            case io_addr is
                when "0000" => data_out <= port_in_0;
                when "0001" => data_out <= port_in_1;
                when "0010" => data_out <= cnt_data;
                when "0011" => data_out <= "0000000" & cnt_carry;
                when "0100" => data_out <= tmr_data;
                when "0101" => data_out <= "0000000" & tmr_done;
                when others => data_out <= (others => '0');
            end case;
        end if;
    end process;

    port_out_0 <= reg_out_0;
    port_out_1 <= reg_out_1;

end architecture behavioral;