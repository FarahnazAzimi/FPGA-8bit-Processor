library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpu_top is
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
end entity cpu_top;

architecture behavioral of cpu_top is

    component prog_mem is
        port (
            address  : in  std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;

    component data_mem is
        port (
            clk      : in  std_logic;
            we       : in  std_logic;
            address  : in  std_logic_vector(7 downto 0);
            data_in  : in  std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;

    component reg_file is
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
    end component;

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

    component control_unit is
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
    end component;

    component counter is
        port (
            clk     : in  std_logic;
            rst     : in  std_logic;
            enable  : in  std_logic;
            dir     : in  std_logic;
            load    : in  std_logic;
            data_in : in  std_logic_vector(7 downto 0);
            count   : out std_logic_vector(7 downto 0);
            carry   : out std_logic
        );
    end component;

    component timer is
        port (
            clk     : in  std_logic;
            rst     : in  std_logic;
            enable  : in  std_logic;
            load    : in  std_logic;
            data_in : in  std_logic_vector(7 downto 0);
            count   : out std_logic_vector(7 downto 0);
            done    : out std_logic
        );
    end component;

    component io_ports is
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
    end component;

    -- -- ?????????? ?????? --
    signal acc_out    : std_logic_vector(7 downto 0);
    signal b_out      : std_logic_vector(7 downto 0);
    signal pc_out     : std_logic_vector(7 downto 0);
    signal ir_out     : std_logic_vector(7 downto 0);
    signal mar_out    : std_logic_vector(7 downto 0);
    signal mdr_out    : std_logic_vector(7 downto 0);

    -- -- ?????????? ALU --
    signal alu_result : std_logic_vector(7 downto 0);
    signal flag_z_sig : std_logic;
    signal flag_n_sig : std_logic;
    signal flag_c_sig : std_logic;
    signal flag_v_sig : std_logic;

    -- -- ?????????? ????? --
    signal prog_data  : std_logic_vector(7 downto 0);
    signal dmem_data  : std_logic_vector(7 downto 0);

    -- -- ?????????? ?????? --
    signal load_acc   : std_logic;
    signal load_b     : std_logic;
    signal load_ir    : std_logic;
    signal load_mar   : std_logic;
    signal load_mdr   : std_logic;
    signal load_pc    : std_logic;
    signal pc_inc     : std_logic;
    signal we         : std_logic;
    signal alu_op     : std_logic_vector(2 downto 0);
    signal hlt_sig    : std_logic;
    signal state_sig  : std_logic_vector(4 downto 0);

    -- -- ?????????? IO --
    signal io_we_sig    : std_logic;
    signal io_re_sig    : std_logic;
    signal io_dout      : std_logic_vector(7 downto 0);
    signal io_addr_latch: std_logic_vector(3 downto 0) := "0000";

    -- -- ?????????? Counter ? Timer --
    signal cnt_out_sig  : std_logic_vector(7 downto 0);
    signal cnt_car_sig  : std_logic;
    signal tmr_out_sig  : std_logic_vector(7 downto 0);
    signal tmr_don_sig  : std_logic;

    -- -- ?????? ???? ? ??????? --
    signal data_bus   : std_logic_vector(7 downto 0);
    signal reg_z      : std_logic := '0';
    signal reg_n      : std_logic := '0';

    -- -- ???????? ???? FSM --
    constant S_FETCH_1 : std_logic_vector(4 downto 0) := "00000";
    constant S_FETCH_2 : std_logic_vector(4 downto 0) := "00001";
    constant S_FETCH_3 : std_logic_vector(4 downto 0) := "00010";
    constant S_DECODE  : std_logic_vector(4 downto 0) := "00011";
    constant S_LDI     : std_logic_vector(4 downto 0) := "00100";
    constant S_LDA_1   : std_logic_vector(4 downto 0) := "00101";
    constant S_LDA_2   : std_logic_vector(4 downto 0) := "00110";
    constant S_LDA_3   : std_logic_vector(4 downto 0) := "00111";
    constant S_STA_1   : std_logic_vector(4 downto 0) := "01000";
    constant S_STA_2   : std_logic_vector(4 downto 0) := "01001";
    constant S_ADD_1   : std_logic_vector(4 downto 0) := "01010";
    constant S_ADD_2   : std_logic_vector(4 downto 0) := "01011";
    constant S_ADD_3   : std_logic_vector(4 downto 0) := "01100";
    constant S_SUB_1   : std_logic_vector(4 downto 0) := "01101";
    constant S_SUB_2   : std_logic_vector(4 downto 0) := "01110";
    constant S_SUB_3   : std_logic_vector(4 downto 0) := "01111";
    constant S_AND_1   : std_logic_vector(4 downto 0) := "10000";
    constant S_AND_2   : std_logic_vector(4 downto 0) := "10001";
    constant S_AND_3   : std_logic_vector(4 downto 0) := "10010";
    constant S_OR_1    : std_logic_vector(4 downto 0) := "10011";
    constant S_OR_2    : std_logic_vector(4 downto 0) := "10100";
    constant S_OR_3    : std_logic_vector(4 downto 0) := "10101";
    constant S_NOT     : std_logic_vector(4 downto 0) := "10110";
    constant S_INC     : std_logic_vector(4 downto 0) := "10111";
    constant S_JMP     : std_logic_vector(4 downto 0) := "11000";
    constant S_JZ      : std_logic_vector(4 downto 0) := "11001";
    constant S_JN      : std_logic_vector(4 downto 0) := "11010";
    constant S_IN      : std_logic_vector(4 downto 0) := "11011";
    constant S_OUT     : std_logic_vector(4 downto 0) := "11100";
    constant S_HLT     : std_logic_vector(4 downto 0) := "11101";

begin

    -- -- Instantiate --

    PM: prog_mem
        port map(
            address  => pc_out,
            data_out => prog_data
        );

    DM: data_mem
        port map(
            clk      => clk,
            we       => we,
            address  => mar_out,
            data_in  => acc_out,
            data_out => dmem_data
        );

    RF: reg_file
        port map(
            clk      => clk,
            rst      => rst,
            load_acc => load_acc,
            load_b   => load_b,
            load_pc  => load_pc,
            load_ir  => load_ir,
            load_mar => load_mar,
            load_mdr => load_mdr,
            data_in  => data_bus,
            acc_out  => acc_out,
            b_out    => b_out,
            pc_out   => pc_out,
            ir_out   => ir_out,
            mar_out  => mar_out,
            mdr_out  => mdr_out,
            pc_inc   => pc_inc
        );

    AU: alu
        port map(
            A      => acc_out,
            B      => b_out,
            op     => alu_op,
            result => alu_result,
            flag_z => flag_z_sig,
            flag_n => flag_n_sig,
            flag_c => flag_c_sig,
            flag_v => flag_v_sig
        );

    CU: control_unit
        port map(
            clk       => clk,
            rst       => rst,
            opcode    => ir_out(7 downto 4),
            flag_z    => reg_z,
            flag_n    => reg_n,
            load_acc  => load_acc,
            load_b    => load_b,
            load_ir   => load_ir,
            load_mar  => load_mar,
            load_mdr  => load_mdr,
            load_pc   => load_pc,
            pc_inc    => pc_inc,
            we        => we,
            alu_op    => alu_op,
            hlt       => hlt_sig,
            state_out => state_sig,
            io_we     => io_we_sig,
            io_re     => io_re_sig
        );

    CTR: counter
        port map(
            clk     => clk,
            rst     => rst,
            enable  => cnt_enable,
            dir     => cnt_dir,
            load    => cnt_load,
            data_in => acc_out,
            count   => cnt_out_sig,
            carry   => cnt_car_sig
        );

    TMR: timer
        port map(
            clk     => clk,
            rst     => rst,
            enable  => tmr_enable,
            load    => tmr_load,
            data_in => acc_out,
            count   => tmr_out_sig,
            done    => tmr_don_sig
        );

    IOP: io_ports
        port map(
            clk        => clk,
            rst        => rst,
            io_we      => io_we_sig,
            io_re      => io_re_sig,
            io_addr    => io_addr_latch,
            data_in    => acc_out,
            data_out   => io_dout,
            port_in_0  => port_in_0,
            port_in_1  => port_in_1,
            port_out_0 => port_out_0,
            port_out_1 => port_out_1,
            cnt_data   => cnt_out_sig,
            cnt_carry  => cnt_car_sig,
            tmr_data   => tmr_out_sig,
            tmr_done   => tmr_don_sig
        );

    -- -- ??? ???? IO ?? ???? DECODE --
    -- ??? process ???? timing ???? ???? ?? ?? ??????
    process(clk, rst)
    begin
        if rst = '1' then
            io_addr_latch <= "0000";
        elsif rising_edge(clk) then
            if state_sig = S_DECODE then
                io_addr_latch <= ir_out(3 downto 0);
            end if;
        end if;
    end process;

    -- -- ???? data_bus --
    process(state_sig,
            prog_data, dmem_data, alu_result,
            mdr_out, ir_out, io_dout)
    begin
        data_bus <= (others => '0');

        if state_sig = S_FETCH_2 then
            data_bus <= prog_data;

        elsif state_sig = S_FETCH_3 then
            data_bus <= mdr_out;

        elsif state_sig = S_LDI then
            data_bus <= "0000" & ir_out(3 downto 0);

        elsif state_sig = S_LDA_1 or
              state_sig = S_STA_1 or
              state_sig = S_ADD_1 or
              state_sig = S_SUB_1 or
              state_sig = S_AND_1 or
              state_sig = S_OR_1  then
            data_bus <= "0000" & ir_out(3 downto 0);

        elsif state_sig = S_LDA_2 then
            data_bus <= dmem_data;

        elsif state_sig = S_LDA_3 then
            data_bus <= mdr_out;

        elsif state_sig = S_ADD_2 or
              state_sig = S_SUB_2 or
              state_sig = S_AND_2 or
              state_sig = S_OR_2  then
            data_bus <= dmem_data;

        elsif state_sig = S_ADD_3 or
              state_sig = S_SUB_3 or
              state_sig = S_AND_3 or
              state_sig = S_OR_3  or
              state_sig = S_NOT   or
              state_sig = S_INC   then
            data_bus <= alu_result;

        elsif state_sig = S_JMP or
              state_sig = S_JZ  or
              state_sig = S_JN  then
            data_bus <= "0000" & ir_out(3 downto 0);

        elsif state_sig = S_IN then
            data_bus <= io_dout;

        end if;
    end process;

    -- -- ??? ????? ??????? --
    process(clk, rst)
    begin
        if rst = '1' then
            reg_z <= '0';
            reg_n <= '0';
        elsif rising_edge(clk) then
            if load_acc = '1' then
                reg_z <= flag_z_sig;
                reg_n <= flag_n_sig;
            end if;
        end if;
    end process;

    -- -- ????????? ????? --
    hlt       <= hlt_sig;
    cnt_carry <= cnt_car_sig;
    tmr_done  <= tmr_don_sig;

end architecture behavioral;