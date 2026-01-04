----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.12.2025 10:42:14
-- Design Name: 
-- Module Name: DMA_ENGINE - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DMA_ENGINE is
    generic (
        g_fifo_depth : integer := 8
    );
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        ---- AXI4-Master User Port-----
        go               : out std_logic;
        error            : in std_logic;
        RNW              : out std_logic;
        busy             : in std_logic;
        done             : in std_logic;
        address          : out std_logic_vector(31 downto 0);
        write_data       : out std_logic_vector(31 downto 0);
        read_data        : in std_logic_vector(31 downto 0);
        burst_length     : out std_logic_vector(7 downto 0);
        burst_size       : out std_logic_vector(6 downto 0);
        increment_burst  : out std_logic;
        clear_data_fifos : out std_logic;
        write_fifo_en    : out std_logic;
        write_fifo_empty : in std_logic;
        write_fifo_full  : in std_logic;
        read_fifo_en     : out std_logic;
        read_fifo_empty  : in std_logic;
        read_fifo_full   : in std_logic;
        --- AXI4-Lite Slave User Port ---
        i_uart_0_tx_buffer_addr : in std_logic_vector(31 downto 0);
        i_uart_0_tx_data_len    : in std_logic_vector(11 downto 0);
        i_uart_0_tx_start       : in std_logic;
        o_uart_0_tx_done        : out std_logic;
        i_uart_0_tx_clr         : in std_logic;
        ---
        i_uart_0_rx_en          : in std_logic;
        i_uart_0_rx_buffer_addr : in std_logic_vector(31 downto 0);
        i_uart_0_rx_buffer_len  : in std_logic_vector(11 downto 0);
        o_uart_0_rx_data_len    : out std_logic_vector(11 downto 0);
        o_uart_0_rx_done        : out std_logic;
        o_uart_0_rx_half_done   : out std_logic;
        i_uart_0_rx_clr         : in std_logic;
        ----
        i_uart_1_tx_buffer_addr : in std_logic_vector(31 downto 0);
        i_uart_1_tx_data_len    : in std_logic_vector(11 downto 0);
        i_uart_1_tx_start       : in std_logic;
        o_uart_1_tx_done        : out std_logic;
        i_uart_1_tx_clr         : in std_logic;
        ---
        i_uart_1_rx_en          : in std_logic;
        i_uart_1_rx_buffer_addr : in std_logic_vector(31 downto 0);
        i_uart_1_rx_buffer_len  : in std_logic_vector(11 downto 0);
        o_uart_1_rx_data_len    : out std_logic_vector(11 downto 0);
        o_uart_1_rx_done        : out std_logic;
        o_uart_1_rx_half_done   : out std_logic;
        i_uart_1_rx_clr         : in std_logic;

        ---- UART-0 User Port---
        o_uart_0_tx_fifo_wr_en    : out std_logic;
        o_uart_0_tx_fifo_data_in  : out std_logic_vector(7 downto 0);
        i_uart_0_tx_fifo_full     : in std_logic;
        i_uart_0_tx_fifo_empty    : in std_logic;
        i_uart_0_tx_fifo_data_cnt : in std_logic_vector(g_fifo_depth - 1 downto 0);
        i_uart_0_tx_fifo_ack      : in std_logic;
        i_uart_0_tx_fifo_wr_err   : in std_logic;
        o_uart_0_rx_fifo_rd_en    : out std_logic;
        i_uart_0_rx_fifo_data_out : in std_logic_vector(7 downto 0);
        i_uart_0_rx_fifo_valid    : in std_logic;
        i_uart_0_rx_fifo_full     : in std_logic;
        i_uart_0_rx_fifo_empty    : in std_logic;
        i_uart_0_rx_fifo_data_cnt : in std_logic_vector(g_fifo_depth - 1 downto 0);
        i_uart_0_rx_fifo_rd_err   : in std_logic;
        i_uart_0_rx_idle_flag     : in std_logic;
        i_uart_0_tx_done_flag     : in std_logic;

        ---- UART-1 User Port---
        o_uart_1_tx_fifo_wr_en    : out std_logic;
        o_uart_1_tx_fifo_data_in  : out std_logic_vector(7 downto 0);
        i_uart_1_tx_fifo_full     : in std_logic;
        i_uart_1_tx_fifo_empty    : in std_logic;
        i_uart_1_tx_fifo_data_cnt : in std_logic_vector(g_fifo_depth - 1 downto 0);
        i_uart_1_tx_fifo_ack      : in std_logic;
        i_uart_1_tx_fifo_wr_err   : in std_logic;
        o_uart_1_rx_fifo_rd_en    : out std_logic;
        i_uart_1_rx_fifo_data_out : in std_logic_vector(7 downto 0);
        i_uart_1_rx_fifo_valid    : in std_logic;
        i_uart_1_rx_fifo_full     : in std_logic;
        i_uart_1_rx_fifo_empty    : in std_logic;
        i_uart_1_rx_fifo_data_cnt : in std_logic_vector(g_fifo_depth - 1 downto 0);
        i_uart_1_rx_fifo_rd_err   : in std_logic;
        i_uart_1_rx_idle_flag     : in std_logic;
        i_uart_1_tx_done_flag     : in std_logic;
        --- UART_0_1 Sync 
        i_uart_0_1_sync : in std_logic;
        ---UART-0-1 interrupts
        o_uart_0_rx_int : out std_logic;
        o_uart_0_tx_int : out std_logic;
        o_uart_1_rx_int : out std_logic;
        o_uart_1_tx_int : out std_logic

    );
end DMA_ENGINE;

architecture Behavioral of DMA_ENGINE is

    type t_state is (ST_IDLE_TX_1, ST_RD_TX_1, ST_WR_TX_1, ST_IDLE_TX_2, ST_RD_TX_2, ST_WR_TX_3);
    signal state : t_state;
    ---
    signal s_uart_0_tx_start_reg       : std_logic;
    signal s_uart_0_tx_buffer_addr_reg : std_logic_vector(31 downto 0);
    signal s_uart_0_tx_data_len_reg    : std_logic_vector(11 downto 0);
    signal s_uart_0_tx_busy            : std_logic;
    signal s_uart_0_byte_sel           : unsigned(1 downto 0);
    ---
    signal s_uart_1_tx_start_reg       : std_logic;
    signal s_uart_1_tx_buffer_addr_reg : std_logic_vector(31 downto 0);
    signal s_uart_1_tx_data_len_reg    : std_logic_vector(11 downto 0);
    signal s_uart_1_tx_busy            : std_logic;
    signal s_uart_1_byte_sel           : unsigned(1 downto 0);
    ---
    signal s_uart_0_1_sync_reg : std_logic;
    --- AXI4 Fifo enables 
    signal s_write_fifo_en : std_logic;
    signal s_read_fifo_en  : std_logic;
    --- UART-0 Fifo 
    signal s_uart_0_tx_fifo_wr_en : std_logic;
    signal s_uart_0_rx_fifo_rd_en : std_logic;
    --- UART-1 Fifo 
    signal s_uart_1_tx_fifo_wr_en : std_logic;
    signal s_uart_1_rx_fifo_rd_en : std_logic;
    -- Internal Signals --
    signal s_uart_0_tx_data_cnt  : unsigned(11 downto 0);
    signal s_uart_0_wait_tx_done : std_logic;
    signal s_uart_1_tx_data_cnt  : unsigned(11 downto 0);
    signal s_uart_1_wait_tx_done : std_logic;

begin

    write_fifo_en          <= s_write_fifo_en;
    read_fifo_en           <= s_read_fifo_en;
    o_uart_0_tx_fifo_wr_en <= s_uart_0_tx_fifo_wr_en;
    o_uart_0_rx_fifo_rd_en <= s_uart_0_rx_fifo_rd_en;
    o_uart_1_tx_fifo_wr_en <= s_uart_1_tx_fifo_wr_en;
    o_uart_1_rx_fifo_rd_en <= s_uart_1_rx_fifo_rd_en;

    process (i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_rst = '1') then
                state                       <= ST_IDLE;
                s_uart_0_tx_start_reg       <= '0';
                s_uart_1_tx_start_reg       <= '0';
                s_uart_0_1_sync_reg         <= '0';
                s_uart_0_tx_buffer_addr_reg <= (others => '0');
                s_uart_0_tx_data_len_reg    <= (others => '0');
                s_uart_1_tx_buffer_addr_reg <= (others => '0');
                s_uart_1_tx_data_len_reg    <= (others => '0');
                s_uart_0_tx_busy            <= '0';
                s_uart_1_tx_busy            <= '0';
                s_uart_0_byte_sel           <= (others => '0');
                s_uart_1_byte_sel           <= (others => '0');
                --- AXI4 Master Control
                go               <= '0';
                RNW              <= '0';
                address          <= (others => '0');
                write_data       <= (others => '0');
                burst_length     <= (others => '0');
                burst_size       <= (others => '0');
                clear_data_fifos <= '0';
                s_write_fifo_en  <= '0';
                s_read_fifo_en   <= '0';
                --- UART-0 Fifo ports ---
                s_uart_0_tx_fifo_wr_en   <= '0';
                o_uart_0_tx_fifo_data_in <= (others => '0');
                s_uart_0_rx_fifo_rd_en   <= '0';
                --- UART-1 Fifo ports ---
                s_uart_1_tx_fifo_wr_en   <= '0';
                o_uart_1_tx_fifo_data_in <= (others => '0');
                s_uart_1_rx_fifo_rd_en   <= '0';
                ---
                s_uart_0_tx_data_cnt  <= (others => '0');
                s_uart_1_tx_data_cnt  <= (others => '0');
                s_uart_0_wait_tx_done <= '0';
                s_uart_1_wait_tx_done <= '0';
            else
                case state is
                    when ST_IDLE_TX_1 =>
                        go <= '0';
                        if s_uart_0_tx_start_reg = '1' then
                            s_uart_0_tx_busy <= '1';
                            state            <= ST_RD_TX_1;
                        else
                            state            <= ST_IDLE_TX_2;
                        end if;

                    when ST_RD_TX_1 =>

                        if busy = '0' and go = '0' then
                            address    <= s_uart_0_tx_buffer_addr_reg;
                            RNW        <= '1';
                            go         <= '1';
                            burst_size <= "0000100"; --4 
                        else
                            go <= '0';
                        end if;

                        if done = '1' then
                            if error = '0' then
                                if read_fifo_empty = '0' then
                                    s_read_fifo_en <= '1';
                                end if;
                            else
                                -- impelemet error condition
                            end if;
                        end if;

                        if s_read_fifo_en = '1' then
                            state          <= ST_WR_TX_1;
                            s_read_fifo_en <= '0';
                        end if;

                    when ST_WR_TX_1 =>

                        if i_uart_0_tx_fifo_full = '0' and s_uart_0_tx_fifo_wr_en = '0' then
                            s_uart_0_tx_fifo_wr_en <= '1';
                            s_uart_0_tx_data_cnt   <= s_uart_0_tx_data_cnt + 1;

                            case s_uart_0_byte_sel is
                                when "00" =>
                                    o_uart_0_tx_fifo_data_in <= read_data(7 downto 0);
                                when "01" =>
                                    o_uart_0_tx_fifo_data_in <= read_data(15 downto 8);
                                when "10" =>
                                    o_uart_0_tx_fifo_data_in <= read_data(23 downto 16);
                                when "11" =>
                                    o_uart_0_tx_fifo_data_in <= read_data(31 downto 24);
                                when others => null;
                            end case;
                        else
                            s_uart_0_tx_fifo_wr_en <= '0';
                        end if;

                        if s_uart_0_tx_fifo_wr_en = '1' then
                            s_uart_0_byte_sel <= s_uart_0_byte_sel + 1;
                            if s_uart_0_byte_sel = "11" then
                                state <= ST_IDLE_TX_2;
                            end if;
                        end if;

                        if s_uart_0_tx_data_cnt = s_uart_0_tx_data_len_reg then
                            s_uart_0_wait_tx_done <= '1';
                        end if;

                    when ST_IDLE_TX_2 =>
                    
                    when ST_RD_TX_2   =>
                    when others       => state <= ST_IDLE;
                end case;
            end if;

            if i_uart_0_tx_start = '1' then
                s_uart_0_tx_start_reg       <= '1';
                s_uart_0_1_sync_reg         <= '1';
                s_uart_0_tx_buffer_addr_reg <= i_uart_0_tx_buffer_addr;
                s_uart_0_tx_data_len_reg    <= i_uart_0_tx_data_len;
            end if;

            if i_uart_1_tx_start = '1' then
                s_uart_1_tx_start_reg       <= '1';
                s_uart_1_tx_buffer_addr_reg <= i_uart_1_tx_buffer_addr;
                s_uart_1_tx_data_len_reg    <= i_uart_1_tx_data_len;
            end if;

        end if;
    end process;

end Behavioral;
