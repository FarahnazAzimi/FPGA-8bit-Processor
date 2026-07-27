library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_alu is
end entity tb_alu;

architecture behavioral of tb_alu is

    component alu is
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
    end component;

    signal A, B    : std_logic_vector(7 downto 0) := (others => '0');
    signal op      : std_logic_vector(2 downto 0) := "000";
    signal result  : std_logic_vector(7 downto 0);
    signal flag_z, flag_n, flag_c, flag_v : std_logic;

begin

    UUT: alu port map(A, B, op, result, flag_z, flag_n, flag_c, flag_v);

    process
    begin

        -- ??? ADD:  5 + 3 = 8
        A <= "00000101";  B <= "00000011";  op <= "000";
        wait for 20 ns;
        -- ??????: result=00001000, Z=0, N=0, C=0

        -- ??? ADD ?? carry:  200 + 100 = 300 (?????)
        A <= "11001000";  B <= "01100100";  op <= "000";
        wait for 20 ns;
        -- ??????: C=1

        -- ??? SUB:  8 - 3 = 5
        A <= "00001000";  B <= "00000011";  op <= "001";
        wait for 20 ns;

        -- ??? AND
        A <= "11110000";  B <= "10101010";  op <= "010";
        wait for 20 ns;
        -- ??????: result=10100000

        -- ??? OR
        A <= "11110000";  B <= "00001111";  op <= "011";
        wait for 20 ns;
        -- ??????: result=11111111

        -- ??? NOT
        A <= "11110000";  B <= "00000000";  op <= "100";
        wait for 20 ns;
        -- ??????: result=00001111

        -- ??? Zero flag:  5 - 5 = 0
        A <= "00000101";  B <= "00000101";  op <= "001";
        wait for 20 ns;
        -- ??????: Z=1

        wait;
    end process;

end architecture behavioral;