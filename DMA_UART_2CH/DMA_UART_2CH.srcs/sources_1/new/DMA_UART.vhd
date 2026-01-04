----------------------------------------------------------------------------------
--  Design      : DMA_UART
--  File        : DMA_UART.vhd
--  Description :

--
--  Features:
--    * 

--
--  Dependencies:
--    * None
--
--  Author      : Orhun Arpaci
--  Created     : 27.12.2025
--  Standard    : VHDL-2002
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity DMA_UART is
    generic (
        g_fifo_depth : integer := 11
    );
    port (
        --- AXI4 Master ports for DMA operations ---
        m_axi_aclk     : in std_logic; -- this clock used in entire IP so multiple clocks are not suppoerted
        m_axi_aresetn  : in std_logic;
        m_axi_arready  : in std_logic;
        m_axi_arvalid  : out std_logic;
        m_axi_araddr   : out std_logic_vector(31 downto 0);
        m_axi_arid     : out std_logic_vector (3 downto 0);
        m_axi_arlen    : out std_logic_vector (7 downto 0);
        m_axi_arsize   : out std_logic_vector (2 downto 0);
        m_axi_arburst  : out std_logic_vector (1 downto 0);
        m_axi_arlock   : out std_logic;
        m_axi_arcache  : out std_logic_vector (3 downto 0);
        m_axi_arprot   : out std_logic_vector (2 downto 0);
        m_axi_arqos    : out std_logic_vector (3 downto 0);
        m_axi_arregion : out std_logic_vector (3 downto 0);
        m_axi_rready   : out std_logic;
        m_axi_rvalid   : in std_logic;
        m_axi_rdata    : in std_logic_vector(31 downto 0);
        m_axi_rresp    : in std_logic_vector(1 downto 0);
        m_axi_rid      : in std_logic_vector (3 downto 0);
        m_axi_rlast    : in std_logic;
        m_axi_awready  : in std_logic;
        m_axi_awvalid  : out std_logic;
        m_axi_awaddr   : out std_logic_vector(31 downto 0);
        m_axi_awid     : out std_logic_vector (3 downto 0);
        m_axi_awlen    : out std_logic_vector (7 downto 0);
        m_axi_awsize   : out std_logic_vector (2 downto 0);
        m_axi_awburst  : out std_logic_vector (1 downto 0);
        m_axi_awlock   : out std_logic;
        m_axi_awcache  : out std_logic_vector (3 downto 0);
        m_axi_awprot   : out std_logic_vector (2 downto 0);
        m_axi_awqos    : out std_logic_vector (3 downto 0);
        m_axi_awregion : out std_logic_vector (3 downto 0);
        m_axi_wready   : in std_logic;
        m_axi_wvalid   : out std_logic;
        m_axi_wid      : out std_logic_vector(3 downto 0);
        m_axi_wdata    : out std_logic_vector(31 downto 0);
        m_axi_wstrb    : out std_logic_vector(3 downto 0);
        m_axi_wlast    : out std_logic;
        m_axi_bready   : out std_logic;
        m_axi_bvalid   : in std_logic;
        m_axi_bresp    : in std_logic_vector(1 downto 0);
        m_axi_bid      : in std_logic_vector(3 downto 0);
        --- AXI4 Lite Slave Ports
        s_axi_awaddr  : in std_logic_vector(5 downto 0);
        s_axi_awprot  : in std_logic_vector(2 downto 0);
        s_axi_awvalid : in std_logic;
        s_axi_awready : out std_logic;
        s_axi_wdata   : in std_logic_vector(31 downto 0);
        s_axi_wstrb   : in std_logic_vector(3 downto 0);
        s_axi_wvalid  : in std_logic;
        s_axi_wready  : out std_logic;
        s_axi_bresp   : out std_logic_vector(1 downto 0);
        s_axi_bvalid  : out std_logic;
        s_axi_bready  : in std_logic;
        s_axi_araddr  : in std_logic_vector(5 downto 0);
        s_axi_arprot  : in std_logic_vector(2 downto 0);
        s_axi_arvalid : in std_logic;
        s_axi_arready : out std_logic;
        s_axi_rdata   : out std_logic_vector(31 downto 0);
        s_axi_rresp   : out std_logic_vector(1 downto 0);
        s_axi_rvalid  : out std_logic;
        s_axi_rready  : in std_logic;

        --- UART-0 signals ---
        i_rx_0 : in std_logic;
        o_tx_0 : out std_logic;
        --- UART-1 signals ---
        i_rx_1 : in std_logic;
        o_tx_1 : out std_logic;
        ---UART-0-1 Interrupt pins
        o_uart_0_1_rx_int : out std_logic;
        o_uart_0_1_tx_int : out std_logic
    );
end DMA_UART;

architecture Behavioral of DMA_UART is

    component AXI_master
        generic (
            data_width : integer range 32 to 64
        );
        port (
            go               : in std_logic;
            error            : out std_logic;
            RNW              : in std_logic;
            busy             : out std_logic;
            done             : out std_logic;
            address          : in std_logic_vector(31 downto 0);
            write_data       : in std_logic_vector(data_width - 1 downto 0);
            read_data        : out std_logic_vector(data_width - 1 downto 0);
            burst_length     : in std_logic_vector(7 downto 0);
            burst_size       : in std_logic_vector(6 downto 0);
            increment_burst  : in std_logic;
            clear_data_fifos : in std_logic;
            write_fifo_en    : in std_logic;
            write_fifo_empty : out std_logic;
            write_fifo_full  : out std_logic;
            read_fifo_en     : in std_logic;
            read_fifo_empty  : out std_logic;
            read_fifo_full   : out std_logic;
            m_axi_aclk       : in std_logic;
            m_axi_aresetn    : in std_logic;
            m_axi_arready    : in std_logic;
            m_axi_arvalid    : out std_logic;
            m_axi_araddr     : out std_logic_vector(31 downto 0);
            m_axi_arid       : out std_logic_vector (3 downto 0);
            m_axi_arlen      : out std_logic_vector (7 downto 0);
            m_axi_arsize     : out std_logic_vector (2 downto 0);
            m_axi_arburst    : out std_logic_vector (1 downto 0);
            m_axi_arlock     : out std_logic;
            m_axi_arcache    : out std_logic_vector (3 downto 0);
            m_axi_arprot     : out std_logic_vector (2 downto 0);
            m_axi_arqos      : out std_logic_vector (3 downto 0);
            m_axi_arregion   : out std_logic_vector (3 downto 0);
            m_axi_rready     : out std_logic;
            m_axi_rvalid     : in std_logic;
            m_axi_rdata      : in std_logic_vector(data_width - 1 downto 0);
            m_axi_rresp      : in std_logic_vector(1 downto 0);
            m_axi_rid        : in std_logic_vector (3 downto 0);
            m_axi_rlast      : in std_logic;
            m_axi_awready    : in std_logic;
            m_axi_awvalid    : out std_logic;
            m_axi_awaddr     : out std_logic_vector(31 downto 0);
            m_axi_awid       : out std_logic_vector (3 downto 0);
            m_axi_awlen      : out std_logic_vector (7 downto 0);
            m_axi_awsize     : out std_logic_vector (2 downto 0);
            m_axi_awburst    : out std_logic_vector (1 downto 0);
            m_axi_awlock     : out std_logic;
            m_axi_awcache    : out std_logic_vector (3 downto 0);
            m_axi_awprot     : out std_logic_vector (2 downto 0);
            m_axi_awqos      : out std_logic_vector (3 downto 0);
            m_axi_awregion   : out std_logic_vector (3 downto 0);
            m_axi_wready     : in std_logic;
            m_axi_wvalid     : out std_logic;
            m_axi_wid        : out std_logic_vector(3 downto 0);
            m_axi_wdata      : out std_logic_vector(data_width - 1 downto 0);
            m_axi_wstrb      : out std_logic_vector((data_width/8) - 1 downto 0);
            m_axi_wlast      : out std_logic;
            m_axi_bready     : out std_logic;
            m_axi_bvalid     : in std_logic;
            m_axi_bresp      : in std_logic_vector(1 downto 0);
            m_axi_bid        : in std_logic_vector(3 downto 0)
        );
    end component;

    component AXI4_Lite_Slave
        generic (
            C_S_AXI_DATA_WIDTH : integer;
            C_S_AXI_ADDR_WIDTH : integer
        );
        port (
            o_uart_0_rst            : out std_logic;
            o_uart_0_clk_per_bit    : out std_logic_vector(23 downto 0);
            o_uart_0_rx_idle_timer  : out std_logic_vector(15 downto 0);
            o_uart_0_data_width     : out std_logic_vector(1 downto 0);
            o_uart_0_parity_en      : out std_logic;
            o_uart_0_parity         : out std_logic;
            o_uart_0_stop_bit       : out std_logic;
            o_uart_0_tx_buffer_addr : out std_logic_vector(31 downto 0);
            o_uart_0_tx_data_len    : out std_logic_vector(11 downto 0);
            o_uart_0_tx_start       : out std_logic;
            i_uart_0_tx_done        : in std_logic;
            i_uart_0_tx_busy        : in std_logic;
            o_uart_0_tx_clr         : out std_logic;
            o_uart_0_rx_en          : out std_logic;
            o_uart_0_rx_buffer_addr : out std_logic_vector(31 downto 0);
            o_uart_0_rx_buffer_len  : out std_logic_vector(11 downto 0);
            i_uart_0_rx_data_len    : in std_logic_vector(11 downto 0);
            i_uart_0_rx_done        : in std_logic;
            i_uart_0_rx_half_done   : in std_logic;
            o_uart_0_rx_clr         : out std_logic;
            o_uart_1_rst            : out std_logic;
            o_uart_1_clk_per_bit    : out std_logic_vector(23 downto 0);
            o_uart_1_rx_idle_timer  : out std_logic_vector(15 downto 0);
            o_uart_1_data_width     : out std_logic_vector(1 downto 0);
            o_uart_1_parity_en      : out std_logic;
            o_uart_1_parity         : out std_logic;
            o_uart_1_stop_bit       : out std_logic;
            o_uart_1_tx_buffer_addr : out std_logic_vector(31 downto 0);
            o_uart_1_tx_data_len    : out std_logic_vector(11 downto 0);
            o_uart_1_tx_start       : out std_logic;
            i_uart_1_tx_done        : in std_logic;
            i_uart_1_tx_busy        : in std_logic;
            o_uart_1_tx_clr         : out std_logic;
            o_uart_1_rx_en          : out std_logic;
            o_uart_1_rx_buffer_addr : out std_logic_vector(31 downto 0);
            o_uart_1_rx_buffer_len  : out std_logic_vector(11 downto 0);
            i_uart_1_rx_data_len    : in std_logic_vector(11 downto 0);
            i_uart_1_rx_done        : in std_logic;
            i_uart_1_rx_half_done   : in std_logic;
            o_uart_1_rx_clr         : out std_logic;
            o_uart_0_1_sync         : out std_logic;
            s_axi_aclk              : in std_logic;
            s_axi_aresetn           : in std_logic;
            s_axi_awaddr            : in std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
            s_axi_awprot            : in std_logic_vector(2 downto 0);
            s_axi_awvalid           : in std_logic;
            s_axi_awready           : out std_logic;
            s_axi_wdata             : in std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
            s_axi_wstrb             : in std_logic_vector((C_S_AXI_DATA_WIDTH/8) - 1 downto 0);
            s_axi_wvalid            : in std_logic;
            s_axi_wready            : out std_logic;
            s_axi_bresp             : out std_logic_vector(1 downto 0);
            s_axi_bvalid            : out std_logic;
            s_axi_bready            : in std_logic;
            s_axi_araddr            : in std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
            s_axi_arprot            : in std_logic_vector(2 downto 0);
            s_axi_arvalid           : in std_logic;
            s_axi_arready           : out std_logic;
            s_axi_rdata             : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
            s_axi_rresp             : out std_logic_vector(1 downto 0);
            s_axi_rvalid            : out std_logic;
            s_axi_rready            : in std_logic
        );
    end component;

    component UART_INTERFACE
        generic (
            g_fifo_depth : integer
        );
        port (
            i_clk              : in std_logic;
            i_rst              : in std_logic;
            i_clk_per_bit      : in std_logic_vector(23 downto 0);
            i_rx_idle_timer    : in std_logic_vector(15 downto 0);
            i_data_width       : in std_logic_vector(1 downto 0);
            i_parity_en        : in std_logic;
            i_parity           : in std_logic;
            i_stop_bit         : in std_logic;
            i_tx_fifo_wr_en    : in std_logic;
            i_tx_fifo_data_in  : in std_logic_vector(7 downto 0);
            o_tx_fifo_full     : out std_logic;
            o_tx_fifo_empty    : out std_logic;
            o_tx_fifo_data_cnt : out std_logic_vector(g_fifo_depth - 1 downto 0);
            o_tx_fifo_ack      : out std_logic;
            o_tx_fifo_wr_err   : out std_logic;
            i_rx_fifo_rd_en    : in std_logic;
            o_rx_fifo_data_out : out std_logic_vector(7 downto 0);
            o_rx_fifo_valid    : out std_logic;
            o_rx_fifo_full     : out std_logic;
            o_rx_fifo_empty    : out std_logic;
            o_rx_fifo_data_cnt : out std_logic_vector(g_fifo_depth - 1 downto 0);
            o_rx_fifo_rd_err   : out std_logic;
            o_rx_idle          : out std_logic;
            o_tx_done          : out std_logic;
            i_rx               : in std_logic;
            o_tx               : out std_logic
        );
    end component;

    component DMA_ENGINE
        generic (
            g_fifo_depth : integer
        );
        port (
            i_clk                     : in std_logic;
            i_rst                     : in std_logic;
            go                        : out std_logic;
            error                     : in std_logic;
            RNW                       : out std_logic;
            busy                      : in std_logic;
            done                      : in std_logic;
            address                   : out std_logic_vector(31 downto 0);
            write_data                : out std_logic_vector(31 downto 0);
            read_data                 : in std_logic_vector(31 downto 0);
            burst_length              : out std_logic_vector(7 downto 0);
            burst_size                : out std_logic_vector(6 downto 0);
            increment_burst           : out std_logic;
            clear_data_fifos          : out std_logic;
            write_fifo_en             : out std_logic;
            write_fifo_empty          : in std_logic;
            write_fifo_full           : in std_logic;
            read_fifo_en              : out std_logic;
            read_fifo_empty           : in std_logic;
            read_fifo_full            : in std_logic;
            i_uart_0_tx_buffer_addr   : in std_logic_vector(31 downto 0);
            i_uart_0_tx_data_len      : in std_logic_vector(11 downto 0);
            i_uart_0_tx_start         : in std_logic;
            o_uart_0_tx_done          : out std_logic;
            i_uart_0_tx_clr           : in std_logic;
            i_uart_0_rx_en            : in std_logic;
            i_uart_0_rx_buffer_addr   : in std_logic_vector(31 downto 0);
            i_uart_0_rx_buffer_len    : in std_logic_vector(11 downto 0);
            o_uart_0_rx_data_len      : out std_logic_vector(11 downto 0);
            o_uart_0_rx_done          : out std_logic;
            o_uart_0_rx_half_done     : out std_logic;
            i_uart_0_rx_clr           : in std_logic;
            i_uart_1_tx_buffer_addr   : in std_logic_vector(31 downto 0);
            i_uart_1_tx_data_len      : in std_logic_vector(11 downto 0);
            i_uart_1_tx_start         : in std_logic;
            o_uart_1_tx_done          : out std_logic;
            i_uart_1_tx_clr           : in std_logic;
            i_uart_1_rx_en            : in std_logic;
            i_uart_1_rx_buffer_addr   : in std_logic_vector(31 downto 0);
            i_uart_1_rx_buffer_len    : in std_logic_vector(11 downto 0);
            o_uart_1_rx_data_len      : out std_logic_vector(11 downto 0);
            o_uart_1_rx_done          : out std_logic;
            o_uart_1_rx_half_done     : out std_logic;
            i_uart_1_rx_clr           : in std_logic;
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
            i_uart_0_1_sync           : in std_logic;
            o_uart_0_rx_int           : out std_logic;
            o_uart_0_tx_int           : out std_logic;
            o_uart_1_rx_int           : out std_logic;
            o_uart_1_tx_int           : out std_logic
        );
    end component;

    --- Constants ----
    constant c_m_axi_data_width : integer range 32 to 64 := 32; -- Do not change this value the code is not verified when axi data with is 64
    constant c_s_axi_data_width : integer range 32 to 64 := 32; -- Do not change this value he code is not verified when axi data with is 64
    --- AXI4 Full Master User Signals ---
    signal s_go               : std_logic;
    signal s_error            : std_logic;
    signal s_RNW              : std_logic;
    signal s_busy             : std_logic;
    signal s_done             : std_logic;
    signal s_address          : std_logic_vector(31 downto 0);
    signal s_write_data       : std_logic_vector(c_m_axi_data_width - 1 downto 0);
    signal s_read_data        : std_logic_vector(c_m_axi_data_width - 1 downto 0);
    signal s_burst_length     : std_logic_vector(7 downto 0);
    signal s_burst_size       : std_logic_vector(6 downto 0);
    signal s_increment_burst  : std_logic;
    signal s_clear_data_fifos : std_logic;
    signal s_write_fifo_en    : std_logic;
    signal s_write_fifo_empty : std_logic;
    signal s_write_fifo_full  : std_logic;
    signal s_read_fifo_en     : std_logic;
    signal s_read_fifo_empty  : std_logic;
    signal s_read_fifo_full   : std_logic;
    --- Active High Sync Reset
    signal i_rst : std_logic;
    --- UART_0 Signals ---
    signal s_uart_0_rst              : std_logic;
    signal s_uart_0_clk_per_bit      : std_logic_vector(23 downto 0);
    signal s_uart_0_rx_idle_timer    : std_logic_vector(15 downto 0);
    signal s_uart_0_data_width       : std_logic_vector(1 downto 0);
    signal s_uart_0_parity_en        : std_logic;
    signal s_uart_0_parity           : std_logic;
    signal s_uart_0_stop_bit         : std_logic;
    signal s_uart_0_tx_fifo_wr_en    : std_logic;
    signal s_uart_0_tx_fifo_data_in  : std_logic_vector(7 downto 0);
    signal s_uart_0_tx_fifo_full     : std_logic;
    signal s_uart_0_tx_fifo_empty    : std_logic;
    signal s_uart_0_tx_fifo_data_cnt : std_logic_vector(g_fifo_depth - 1 downto 0);
    signal s_uart_0_tx_fifo_ack      : std_logic;
    signal s_uart_0_tx_fifo_wr_err   : std_logic;
    signal s_uart_0_rx_fifo_rd_en    : std_logic;
    signal s_uart_0_rx_fifo_data_out : std_logic_vector(7 downto 0);
    signal s_uart_0_rx_fifo_valid    : std_logic;
    signal s_uart_0_rx_fifo_full     : std_logic;
    signal s_uart_0_rx_fifo_empty    : std_logic;
    signal s_uart_0_rx_fifo_data_cnt : std_logic_vector(g_fifo_depth - 1 downto 0);
    signal s_uart_0_rx_fifo_rd_err   : std_logic;
    signal s_uart_0_rx_idle_flag     : std_logic;
    signal s_uart_0_tx_done_flag     : std_logic;
    --- UART_1 Signals ---
    signal s_uart_1_rst              : std_logic;
    signal s_uart_1_clk_per_bit      : std_logic_vector(23 downto 0);
    signal s_uart_1_rx_idle_timer    : std_logic_vector(15 downto 0);
    signal s_uart_1_data_width       : std_logic_vector(1 downto 0);
    signal s_uart_1_parity_en        : std_logic;
    signal s_uart_1_parity           : std_logic;
    signal s_uart_1_stop_bit         : std_logic;
    signal s_uart_1_tx_fifo_wr_en    : std_logic;
    signal s_uart_1_tx_fifo_data_in  : std_logic_vector(7 downto 0);
    signal s_uart_1_tx_fifo_full     : std_logic;
    signal s_uart_1_tx_fifo_empty    : std_logic;
    signal s_uart_1_tx_fifo_data_cnt : std_logic_vector(g_fifo_depth - 1 downto 0);
    signal s_uart_1_tx_fifo_ack      : std_logic;
    signal s_uart_1_tx_fifo_wr_err   : std_logic;
    signal s_uart_1_rx_fifo_rd_en    : std_logic;
    signal s_uart_1_rx_fifo_data_out : std_logic_vector(7 downto 0);
    signal s_uart_1_rx_fifo_valid    : std_logic;
    signal s_uart_1_rx_fifo_full     : std_logic;
    signal s_uart_1_rx_fifo_empty    : std_logic;
    signal s_uart_1_rx_fifo_data_cnt : std_logic_vector(g_fifo_depth - 1 downto 0);
    signal s_uart_1_rx_fifo_rd_err   : std_logic;
    signal s_uart_1_rx_idle_flag     : std_logic;
    signal s_uart_1_tx_done_flag     : std_logic;
    --- UART_0 DMA CTRL Signals ---
    signal s_uart_0_tx_buffer_addr : std_logic_vector(31 downto 0);
    signal s_uart_0_tx_data_len    : std_logic_vector(11 downto 0);
    signal s_uart_0_tx_start       : std_logic;
    signal s_uart_0_tx_done        : std_logic;
    signal s_uart_0_tx_busy        : std_logic;
    signal s_uart_0_tx_clr         : std_logic;
    signal s_uart_0_rx_en          : std_logic;
    signal s_uart_0_rx_buffer_addr : std_logic_vector(31 downto 0);
    signal s_uart_0_rx_buffer_len  : std_logic_vector(11 downto 0);
    signal s_uart_0_rx_data_len    : std_logic_vector(11 downto 0);
    signal s_uart_0_rx_done        : std_logic;
    signal s_uart_0_rx_half_done   : std_logic;
    signal s_uart_0_rx_clr         : std_logic;
    --- UART_1 DMA CTRL Signals ---
    signal s_uart_1_tx_buffer_addr : std_logic_vector(31 downto 0);
    signal s_uart_1_tx_data_len    : std_logic_vector(11 downto 0);
    signal s_uart_1_tx_start       : std_logic;
    signal s_uart_1_tx_done        : std_logic;
    signal s_uart_1_tx_busy        : std_logic;
    signal s_uart_1_tx_clr         : std_logic;
    signal s_uart_1_rx_en          : std_logic;
    signal s_uart_1_rx_buffer_addr : std_logic_vector(31 downto 0);
    signal s_uart_1_rx_buffer_len  : std_logic_vector(11 downto 0);
    signal s_uart_1_rx_data_len    : std_logic_vector(11 downto 0);
    signal s_uart_1_rx_done        : std_logic;
    signal s_uart_1_rx_half_done   : std_logic;
    signal s_uart_1_rx_clr         : std_logic;
    ---
    signal s_uart_0_1_sync : std_logic;
    signal s_uart_0_rx_int : std_logic;
    signal s_uart_0_tx_int : std_logic;
    signal s_uart_1_rx_int : std_logic;
    signal s_uart_1_tx_int : std_logic;

begin

    i_rst             <= (not m_axi_aresetn);
    o_uart_0_1_rx_int <= s_uart_0_rx_int or s_uart_1_rx_int;
    o_uart_0_1_tx_int <= s_uart_0_tx_int or s_uart_1_tx_int;

    
    AXI_master_inst : AXI_master
    generic map(
        data_width => c_m_axi_data_width
    )
    port map(
        go               => s_go,
        error            => s_error,
        RNW              => s_RNW,
        busy             => s_busy,
        done             => s_done,
        address          => s_address,
        write_data       => s_write_data,
        read_data        => s_read_data,
        burst_length     => s_burst_length,
        burst_size       => s_burst_size,
        increment_burst  => s_increment_burst,
        clear_data_fifos => s_clear_data_fifos,
        write_fifo_en    => s_write_fifo_en,
        write_fifo_empty => s_write_fifo_empty,
        write_fifo_full  => s_write_fifo_full,
        read_fifo_en     => s_read_fifo_en,
        read_fifo_empty  => s_read_fifo_empty,
        read_fifo_full   => s_read_fifo_full,
        m_axi_aclk       => m_axi_aclk,
        m_axi_aresetn    => m_axi_aresetn,
        m_axi_arready    => m_axi_arready,
        m_axi_arvalid    => m_axi_arvalid,
        m_axi_araddr     => m_axi_araddr,
        m_axi_arid       => m_axi_arid,
        m_axi_arlen      => m_axi_arlen,
        m_axi_arsize     => m_axi_arsize,
        m_axi_arburst    => m_axi_arburst,
        m_axi_arlock     => m_axi_arlock,
        m_axi_arcache    => m_axi_arcache,
        m_axi_arprot     => m_axi_arprot,
        m_axi_arqos      => m_axi_arqos,
        m_axi_arregion   => m_axi_arregion,
        m_axi_rready     => m_axi_rready,
        m_axi_rvalid     => m_axi_rvalid,
        m_axi_rdata      => m_axi_rdata,
        m_axi_rresp      => m_axi_rresp,
        m_axi_rid        => m_axi_rid,
        m_axi_rlast      => m_axi_rlast,
        m_axi_awready    => m_axi_awready,
        m_axi_awvalid    => m_axi_awvalid,
        m_axi_awaddr     => m_axi_awaddr,
        m_axi_awid       => m_axi_awid,
        m_axi_awlen      => m_axi_awlen,
        m_axi_awsize     => m_axi_awsize,
        m_axi_awburst    => m_axi_awburst,
        m_axi_awlock     => m_axi_awlock,
        m_axi_awcache    => m_axi_awcache,
        m_axi_awprot     => m_axi_awprot,
        m_axi_awqos      => m_axi_awqos,
        m_axi_awregion   => m_axi_awregion,
        m_axi_wready     => m_axi_wready,
        m_axi_wvalid     => m_axi_wvalid,
        m_axi_wid        => m_axi_wid,
        m_axi_wdata      => m_axi_wdata,
        m_axi_wstrb      => m_axi_wstrb,
        m_axi_wlast      => m_axi_wlast,
        m_axi_bready     => m_axi_bready,
        m_axi_bvalid     => m_axi_bvalid,
        m_axi_bresp      => m_axi_bresp,
        m_axi_bid        => m_axi_bid
    );

    AXI4_Lite_Slave_inst : AXI4_Lite_Slave
    generic map(
        C_S_AXI_DATA_WIDTH => c_s_axi_data_width,
        C_S_AXI_ADDR_WIDTH => 6
    )
    port map(
        o_uart_0_rst           => s_uart_0_rst,
        o_uart_0_clk_per_bit   => s_uart_0_clk_per_bit,
        o_uart_0_rx_idle_timer => s_uart_0_rx_idle_timer,
        o_uart_0_data_width    => s_uart_0_data_width,
        o_uart_0_parity_en     => s_uart_0_parity_en,
        o_uart_0_parity        => s_uart_0_parity,
        o_uart_0_stop_bit      => s_uart_0_stop_bit,
        ---
        o_uart_0_tx_buffer_addr => s_uart_0_tx_buffer_addr,
        o_uart_0_tx_data_len    => s_uart_0_tx_data_len,
        o_uart_0_tx_start       => s_uart_0_tx_start,
        i_uart_0_tx_done        => s_uart_0_tx_done,
        i_uart_0_tx_busy        => s_uart_0_tx_busy,
        o_uart_0_tx_clr         => s_uart_0_tx_clr,
        o_uart_0_rx_en          => s_uart_0_rx_en,
        o_uart_0_rx_buffer_addr => s_uart_0_rx_buffer_addr,
        o_uart_0_rx_buffer_len  => s_uart_0_rx_buffer_len,
        i_uart_0_rx_data_len    => s_uart_0_rx_data_len,
        i_uart_0_rx_done        => s_uart_0_rx_done,
        i_uart_0_rx_half_done   => s_uart_0_rx_half_done,
        o_uart_0_rx_clr         => s_uart_0_rx_clr,
        ---
        o_uart_1_rst           => s_uart_1_rst,
        o_uart_1_clk_per_bit   => s_uart_1_clk_per_bit,
        o_uart_1_rx_idle_timer => s_uart_1_rx_idle_timer,
        o_uart_1_data_width    => s_uart_1_data_width,
        o_uart_1_parity_en     => s_uart_1_parity_en,
        o_uart_1_parity        => s_uart_1_parity,
        o_uart_1_stop_bit      => s_uart_1_stop_bit,
        ---
        o_uart_1_tx_buffer_addr => s_uart_1_tx_buffer_addr,
        o_uart_1_tx_data_len    => s_uart_1_tx_data_len,
        o_uart_1_tx_start       => s_uart_1_tx_start,
        i_uart_1_tx_done        => s_uart_1_tx_done,
        i_uart_1_tx_busy        => s_uart_1_tx_busy,
        o_uart_1_tx_clr         => s_uart_1_tx_clr,
        o_uart_1_rx_en          => s_uart_1_rx_en,
        o_uart_1_rx_buffer_addr => s_uart_1_rx_buffer_addr,
        o_uart_1_rx_buffer_len  => s_uart_1_rx_buffer_len,
        i_uart_1_rx_data_len    => s_uart_1_rx_data_len,
        i_uart_1_rx_done        => s_uart_1_rx_done,
        i_uart_1_rx_half_done   => s_uart_1_rx_half_done,
        o_uart_1_rx_clr         => s_uart_1_rx_clr,
        ---
        o_uart_0_1_sync => s_uart_0_1_sync,
        ---
        s_axi_aclk    => m_axi_aclk,
        s_axi_aresetn => m_axi_aresetn,
        s_axi_awaddr  => s_axi_awaddr,
        s_axi_awprot  => s_axi_awprot,
        s_axi_awvalid => s_axi_awvalid,
        s_axi_awready => s_axi_awready,
        s_axi_wdata   => s_axi_wdata,
        s_axi_wstrb   => s_axi_wstrb,
        s_axi_wvalid  => s_axi_wvalid,
        s_axi_wready  => s_axi_wready,
        s_axi_bresp   => s_axi_bresp,
        s_axi_bvalid  => s_axi_bvalid,
        s_axi_bready  => s_axi_bready,
        s_axi_araddr  => s_axi_araddr,
        s_axi_arprot  => s_axi_arprot,
        s_axi_arvalid => s_axi_arvalid,
        s_axi_arready => s_axi_arready,
        s_axi_rdata   => s_axi_rdata,
        s_axi_rresp   => s_axi_rresp,
        s_axi_rvalid  => s_axi_rvalid,
        s_axi_rready  => s_axi_rready
    );
    UART_INTERFACE_0_inst : UART_INTERFACE
    generic map(
        g_fifo_depth => g_fifo_depth
    )
    port map(
        i_clk              => m_axi_aclk,
        i_rst              => s_uart_0_rst,
        i_clk_per_bit      => s_uart_0_clk_per_bit,
        i_rx_idle_timer    => s_uart_0_rx_idle_timer,
        i_data_width       => s_uart_0_data_width,
        i_parity_en        => s_uart_0_parity_en,
        i_parity           => s_uart_0_parity,
        i_stop_bit         => s_uart_0_stop_bit,
        i_tx_fifo_wr_en    => s_uart_0_tx_fifo_wr_en,
        i_tx_fifo_data_in  => s_uart_0_tx_fifo_data_in,
        o_tx_fifo_full     => s_uart_0_tx_fifo_full,
        o_tx_fifo_empty    => s_uart_0_tx_fifo_empty,
        o_tx_fifo_data_cnt => s_uart_0_tx_fifo_data_cnt,
        o_tx_fifo_ack      => s_uart_0_tx_fifo_ack,
        o_tx_fifo_wr_err   => s_uart_0_tx_fifo_wr_err,
        i_rx_fifo_rd_en    => s_uart_0_rx_fifo_rd_en,
        o_rx_fifo_data_out => s_uart_0_rx_fifo_data_out,
        o_rx_fifo_valid    => s_uart_0_rx_fifo_valid,
        o_rx_fifo_full     => s_uart_0_rx_fifo_full,
        o_rx_fifo_empty    => s_uart_0_rx_fifo_empty,
        o_rx_fifo_data_cnt => s_uart_0_rx_fifo_data_cnt,
        o_rx_fifo_rd_err   => s_uart_0_rx_fifo_rd_err,
        o_rx_idle          => s_uart_0_rx_idle_flag,
        o_tx_done          => s_uart_0_tx_done_flag,
        i_rx               => i_rx_0,
        o_tx               => o_tx_0
    );

    UART_INTERFACE_1_inst : UART_INTERFACE
    generic map(
        g_fifo_depth => g_fifo_depth
    )
    port map(
        i_clk              => m_axi_aclk,
        i_rst              => s_uart_1_rst,
        i_clk_per_bit      => s_uart_1_clk_per_bit,
        i_rx_idle_timer    => s_uart_1_rx_idle_timer,
        i_data_width       => s_uart_1_data_width,
        i_parity_en        => s_uart_1_parity_en,
        i_parity           => s_uart_1_parity,
        i_stop_bit         => s_uart_1_stop_bit,
        i_tx_fifo_wr_en    => s_uart_1_tx_fifo_wr_en,
        i_tx_fifo_data_in  => s_uart_1_tx_fifo_data_in,
        o_tx_fifo_full     => s_uart_1_tx_fifo_full,
        o_tx_fifo_empty    => s_uart_1_tx_fifo_empty,
        o_tx_fifo_data_cnt => s_uart_1_tx_fifo_data_cnt,
        o_tx_fifo_ack      => s_uart_1_tx_fifo_ack,
        o_tx_fifo_wr_err   => s_uart_1_tx_fifo_wr_err,
        i_rx_fifo_rd_en    => s_uart_1_rx_fifo_rd_en,
        o_rx_fifo_data_out => s_uart_1_rx_fifo_data_out,
        o_rx_fifo_valid    => s_uart_1_rx_fifo_valid,
        o_rx_fifo_full     => s_uart_1_rx_fifo_full,
        o_rx_fifo_empty    => s_uart_1_rx_fifo_empty,
        o_rx_fifo_data_cnt => s_uart_1_rx_fifo_data_cnt,
        o_rx_fifo_rd_err   => s_uart_1_rx_fifo_rd_err,
        o_rx_idle          => s_uart_1_rx_idle_flag,
        o_tx_done          => s_uart_1_tx_done_flag,
        i_rx               => i_rx_1,
        o_tx               => o_tx_1
    );

    DMA_ENGINE_inst : DMA_ENGINE
    generic map(
        g_fifo_depth => g_fifo_depth
    )
    port map(
        i_clk            => m_axi_aclk,
        i_rst            => i_rst,
        go               => s_go,
        error            => s_error,
        RNW              => s_RNW,
        busy             => s_busy,
        done             => s_done,
        address          => s_address,
        write_data       => s_write_data,
        read_data        => s_read_data,
        burst_length     => s_burst_length,
        burst_size       => s_burst_size,
        increment_burst  => s_increment_burst,
        clear_data_fifos => s_clear_data_fifos,
        write_fifo_en    => s_write_fifo_en,
        write_fifo_empty => s_write_fifo_empty,
        write_fifo_full  => s_write_fifo_full,
        read_fifo_en     => s_read_fifo_en,
        read_fifo_empty  => s_read_fifo_empty,
        read_fifo_full   => s_read_fifo_full,
        ---
        i_uart_0_tx_buffer_addr => s_uart_0_tx_buffer_addr,
        i_uart_0_tx_data_len    => s_uart_0_tx_data_len,
        i_uart_0_tx_start       => s_uart_0_tx_start,
        o_uart_0_tx_done        => s_uart_0_tx_done,
        i_uart_0_tx_clr         => s_uart_0_tx_clr,
        i_uart_0_rx_en          => s_uart_0_rx_en,
        i_uart_0_rx_buffer_addr => s_uart_0_rx_buffer_addr,
        i_uart_0_rx_buffer_len  => s_uart_0_rx_buffer_len,
        o_uart_0_rx_data_len    => s_uart_0_rx_data_len,
        o_uart_0_rx_done        => s_uart_0_rx_done,
        o_uart_0_rx_half_done   => s_uart_0_rx_half_done,
        i_uart_0_rx_clr         => s_uart_0_rx_clr,
        ---
        i_uart_1_tx_buffer_addr => s_uart_1_tx_buffer_addr,
        i_uart_1_tx_data_len    => s_uart_1_tx_data_len,
        i_uart_1_tx_start       => s_uart_1_tx_start,
        o_uart_1_tx_done        => s_uart_1_tx_done,
        i_uart_1_tx_clr         => s_uart_1_tx_clr,
        i_uart_1_rx_en          => s_uart_1_rx_en,
        i_uart_1_rx_buffer_addr => s_uart_1_rx_buffer_addr,
        i_uart_1_rx_buffer_len  => s_uart_1_rx_buffer_len,
        o_uart_1_rx_data_len    => s_uart_1_rx_data_len,
        o_uart_1_rx_done        => s_uart_1_rx_done,
        o_uart_1_rx_half_done   => s_uart_1_rx_half_done,
        i_uart_1_rx_clr         => s_uart_1_rx_clr,
        ---
        o_uart_0_tx_fifo_wr_en    => s_uart_0_tx_fifo_wr_en,
        o_uart_0_tx_fifo_data_in  => s_uart_0_tx_fifo_data_in,
        i_uart_0_tx_fifo_full     => s_uart_0_tx_fifo_full,
        i_uart_0_tx_fifo_empty    => s_uart_0_tx_fifo_empty,
        i_uart_0_tx_fifo_data_cnt => s_uart_0_tx_fifo_data_cnt,
        i_uart_0_tx_fifo_ack      => s_uart_0_tx_fifo_ack,
        i_uart_0_tx_fifo_wr_err   => s_uart_0_tx_fifo_wr_err,
        o_uart_0_rx_fifo_rd_en    => s_uart_0_rx_fifo_rd_en,
        i_uart_0_rx_fifo_data_out => s_uart_0_rx_fifo_data_out,
        i_uart_0_rx_fifo_valid    => s_uart_0_rx_fifo_valid,
        i_uart_0_rx_fifo_full     => s_uart_0_rx_fifo_full,
        i_uart_0_rx_fifo_empty    => s_uart_0_rx_fifo_empty,
        i_uart_0_rx_fifo_data_cnt => s_uart_0_rx_fifo_data_cnt,
        i_uart_0_rx_fifo_rd_err   => s_uart_0_rx_fifo_rd_err,
        i_uart_0_rx_idle_flag     => s_uart_0_rx_idle_flag,
        i_uart_0_tx_done_flag     => s_uart_0_tx_done_flag,
        ---
        o_uart_1_tx_fifo_wr_en    => s_uart_1_tx_fifo_wr_en,
        o_uart_1_tx_fifo_data_in  => s_uart_1_tx_fifo_data_in,
        i_uart_1_tx_fifo_full     => s_uart_1_tx_fifo_full,
        i_uart_1_tx_fifo_empty    => s_uart_1_tx_fifo_empty,
        i_uart_1_tx_fifo_data_cnt => s_uart_1_tx_fifo_data_cnt,
        i_uart_1_tx_fifo_ack      => s_uart_1_tx_fifo_ack,
        i_uart_1_tx_fifo_wr_err   => s_uart_1_tx_fifo_wr_err,
        o_uart_1_rx_fifo_rd_en    => s_uart_1_rx_fifo_rd_en,
        i_uart_1_rx_fifo_data_out => s_uart_1_rx_fifo_data_out,
        i_uart_1_rx_fifo_valid    => s_uart_1_rx_fifo_valid,
        i_uart_1_rx_fifo_full     => s_uart_1_rx_fifo_full,
        i_uart_1_rx_fifo_empty    => s_uart_1_rx_fifo_empty,
        i_uart_1_rx_fifo_data_cnt => s_uart_1_rx_fifo_data_cnt,
        i_uart_1_rx_fifo_rd_err   => s_uart_1_rx_fifo_rd_err,
        i_uart_1_rx_idle_flag     => s_uart_1_rx_idle_flag,
        i_uart_1_tx_done_flag     => s_uart_1_tx_done_flag,
        ---
        i_uart_0_1_sync => s_uart_0_1_sync,
        ---
        o_uart_0_rx_int => s_uart_0_rx_int,
        o_uart_0_tx_int => s_uart_0_tx_int,
        o_uart_1_rx_int => s_uart_1_rx_int,
        o_uart_1_tx_int => s_uart_1_tx_int
    );

end Behavioral;
