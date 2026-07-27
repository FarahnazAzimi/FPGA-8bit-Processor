library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        opcode    : in  std_logic_vector(3 downto 0);
        flag_z    : in  std_logic;
        flag_n    : in  std_logic;
        load_acc  : out std_logic;
        load_b    : out std_logic;
        load_ir   : out std_logic;
        load_mar  : out std_logic;
        load_mdr  : out std_logic;
        load_pc   : out std_logic;
        pc_inc    : out std_logic;
        we        : out std_logic;
        alu_op    : out std_logic_vector(2 downto 0);
        hlt       : out std_logic;
        state_out : out std_logic_vector(4 downto 0);
        io_we     : out std_logic;
        io_re     : out std_logic
    );
end entity control_unit;

architecture behavioral of control_unit is

    type state_type is (
        FETCH_1, FETCH_2, FETCH_3, DECODE,
        EX_LDA_1, EX_LDA_2, EX_LDA_3,
        EX_STA_1, EX_STA_2,
        EX_LDI,
        EX_ADD_1, EX_ADD_2, EX_ADD_3,
        EX_SUB_1, EX_SUB_2, EX_SUB_3,
        EX_AND_1, EX_AND_2, EX_AND_3,
        EX_OR_1,  EX_OR_2,  EX_OR_3,
        EX_NOT,   EX_INC,
        EX_JMP,   EX_JZ,    EX_JN,
        EX_IN,    EX_OUT,   EX_HLT
    );

    signal state : state_type := FETCH_1;

begin

    -- -- process ???: ?????? ??? ??????? --
    process(clk, rst)
    begin
        if rst = '1' then
            state <= FETCH_1;
        elsif rising_edge(clk) then
            case state is

                when FETCH_1  => state <= FETCH_2;
                when FETCH_2  => state <= FETCH_3;
                when FETCH_3  => state <= DECODE;

                when DECODE =>
                    case opcode is
                        when "0000" => state <= EX_LDA_1;
                        when "0001" => state <= EX_STA_1;
                        when "0010" => state <= EX_LDI;
                        when "0011" => state <= EX_ADD_1;
                        when "0100" => state <= EX_SUB_1;
                        when "0101" => state <= EX_INC;
                        when "0110" => state <= EX_AND_1;
                        when "0111" => state <= EX_OR_1;
                        when "1000" => state <= EX_NOT;
                        when "1001" => state <= EX_JMP;
                        when "1010" => state <= EX_JZ;
                        when "1011" => state <= EX_JN;
                        when "1100" => state <= EX_IN;
                        when "1101" => state <= EX_OUT;
                        when "1111" => state <= EX_HLT;
                        when others => state <= FETCH_1;
                    end case;

                when EX_LDA_1 => state <= EX_LDA_2;
                when EX_LDA_2 => state <= EX_LDA_3;
                when EX_LDA_3 => state <= FETCH_1;

                when EX_STA_1 => state <= EX_STA_2;
                when EX_STA_2 => state <= FETCH_1;

                when EX_LDI   => state <= FETCH_1;

                when EX_ADD_1 => state <= EX_ADD_2;
                when EX_ADD_2 => state <= EX_ADD_3;
                when EX_ADD_3 => state <= FETCH_1;

                when EX_SUB_1 => state <= EX_SUB_2;
                when EX_SUB_2 => state <= EX_SUB_3;
                when EX_SUB_3 => state <= FETCH_1;

                when EX_AND_1 => state <= EX_AND_2;
                when EX_AND_2 => state <= EX_AND_3;
                when EX_AND_3 => state <= FETCH_1;

                when EX_OR_1  => state <= EX_OR_2;
                when EX_OR_2  => state <= EX_OR_3;
                when EX_OR_3  => state <= FETCH_1;

                when EX_NOT   => state <= FETCH_1;
                when EX_INC   => state <= FETCH_1;
                when EX_JMP   => state <= FETCH_1;
                when EX_JZ    => state <= FETCH_1;
                when EX_JN    => state <= FETCH_1;
                when EX_IN    => state <= FETCH_1;
                when EX_OUT   => state <= FETCH_1;
                when EX_HLT   => state <= EX_HLT;

            end case;
        end if;
    end process;

    -- -- process ???: ????? ?????????? ?????? --
    process(state, flag_z, flag_n)
    begin
        -- ????? ??????? ??? ?????????
        load_acc <= '0'; load_b   <= '0';
        load_ir  <= '0'; load_mar <= '0';
        load_mdr <= '0'; load_pc  <= '0';
        pc_inc   <= '0'; we       <= '0';
        alu_op   <= "000"; hlt    <= '0';
        io_we    <= '0'; io_re    <= '0';

        case state is

            when FETCH_1  => load_mar <= '1';
            when FETCH_2  => load_mdr <= '1'; pc_inc <= '1';
            when FETCH_3  => load_ir  <= '1';
            when DECODE   => null;

            when EX_LDA_1 => load_mar <= '1';
            when EX_LDA_2 => load_mdr <= '1';
            when EX_LDA_3 => load_acc <= '1';

            when EX_STA_1 => load_mar <= '1';
            when EX_STA_2 => we <= '1';

            when EX_LDI   => load_acc <= '1';

            when EX_ADD_1 => load_mar <= '1';
            when EX_ADD_2 => load_mdr <= '1'; load_b <= '1';
            when EX_ADD_3 => alu_op <= "000"; load_acc <= '1';

            when EX_SUB_1 => load_mar <= '1';
            when EX_SUB_2 => load_mdr <= '1'; load_b <= '1';
            when EX_SUB_3 => alu_op <= "001"; load_acc <= '1';

            when EX_AND_1 => load_mar <= '1';
            when EX_AND_2 => load_mdr <= '1'; load_b <= '1';
            when EX_AND_3 => alu_op <= "010"; load_acc <= '1';

            when EX_OR_1  => load_mar <= '1';
            when EX_OR_2  => load_mdr <= '1'; load_b <= '1';
            when EX_OR_3  => alu_op <= "011"; load_acc <= '1';

            when EX_NOT   => alu_op <= "100"; load_acc <= '1';
            when EX_INC   => alu_op <= "101"; load_acc <= '1';

            when EX_JMP   => load_pc <= '1';

            when EX_JZ    =>
                if flag_z = '1' then load_pc <= '1'; end if;

            when EX_JN    =>
                if flag_n = '1' then load_pc <= '1'; end if;

            -- -- IN: ?????? io_re ???? ?????? --
            -- ???? ???? ?? ir_out[3:0] ?????? (?? cpu_top)
            when EX_IN    =>
                io_re    <= '1';
                load_acc <= '1';
					-- load_mar <= '1';  -- ? ??? ?? ?? ????? ??

            -- -- OUT: ?????? io_we ???? ?????? --
            -- ???? ?? ACC ??????? ???? ?? ir_out[3:0]
            when EX_OUT   =>
                io_we    <= '1';
				--	 load_mar <= '1';  -- ? ??? ?? ?? ????? ??

            when EX_HLT   => hlt <= '1';
            when others   => null;

        end case;
    end process;

    -- -- process ???: ????? state --
    process(state)
    begin
        case state is
            when FETCH_1  => state_out <= "00000";
            when FETCH_2  => state_out <= "00001";
            when FETCH_3  => state_out <= "00010";
            when DECODE   => state_out <= "00011";
            when EX_LDI   => state_out <= "00100";
            when EX_LDA_1 => state_out <= "00101";
            when EX_LDA_2 => state_out <= "00110";
            when EX_LDA_3 => state_out <= "00111";
            when EX_STA_1 => state_out <= "01000";
            when EX_STA_2 => state_out <= "01001";
            when EX_ADD_1 => state_out <= "01010";
            when EX_ADD_2 => state_out <= "01011";
            when EX_ADD_3 => state_out <= "01100";
            when EX_SUB_1 => state_out <= "01101";
            when EX_SUB_2 => state_out <= "01110";
            when EX_SUB_3 => state_out <= "01111";
            when EX_AND_1 => state_out <= "10000";
            when EX_AND_2 => state_out <= "10001";
            when EX_AND_3 => state_out <= "10010";
            when EX_OR_1  => state_out <= "10011";
            when EX_OR_2  => state_out <= "10100";
            when EX_OR_3  => state_out <= "10101";
            when EX_NOT   => state_out <= "10110";
            when EX_INC   => state_out <= "10111";
            when EX_JMP   => state_out <= "11000";
            when EX_JZ    => state_out <= "11001";
            when EX_JN    => state_out <= "11010";
            when EX_IN    => state_out <= "11011";
            when EX_OUT   => state_out <= "11100";
            when EX_HLT   => state_out <= "11101";
            when others   => state_out <= "11111";
        end case;
    end process;

end architecture behavioral;