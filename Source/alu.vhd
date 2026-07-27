library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    port (
        A      : in  std_logic_vector(7 downto 0);
        B      : in  std_logic_vector(7 downto 0);
        op     : in  std_logic_vector(2 downto 0);
        result : out std_logic_vector(7 downto 0);
        flag_z : out std_logic;
        flag_n : out std_logic;
        flag_c : out std_logic;
        flag_v : out std_logic
    );
end entity alu;

architecture behavioral of alu is

    signal res_9bit  : std_logic_vector(8 downto 0);
    signal result_i  : std_logic_vector(7 downto 0);

begin

    process(A, B, op)
    begin
        case op is
            when "000" =>
                res_9bit <= std_logic_vector(
                    ('0' & unsigned(A)) + ('0' & unsigned(B)));
            when "001" =>
                res_9bit <= std_logic_vector(
                    ('0' & unsigned(A)) - ('0' & unsigned(B)));
            when "010" =>
                res_9bit <= '0' & (A and B);
            when "011" =>
                res_9bit <= '0' & (A or B);
            when "100" =>
                res_9bit <= '0' & (not A);
            when "101" =>
                res_9bit <= std_logic_vector(
                    ('0' & unsigned(A)) + 1);
            when others =>
                res_9bit <= '0' & A;
        end case;
    end process;

    result_i <= res_9bit(7 downto 0);
    result   <= result_i;
    flag_z   <= '1' when result_i = "00000000" else '0';
    flag_n   <= result_i(7);
    flag_c   <= res_9bit(8);
    flag_v   <= (A(7) and B(7) and not result_i(7)) or
                (not A(7) and not B(7) and result_i(7));

end architecture behavioral;