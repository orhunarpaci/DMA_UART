
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axi4lite_master_pkg.all;

entity DMA_UART_tb is
end;

architecture bench of DMA_UART_tb is
    -- Clock period
    constant clk_period : time := 10 ns;
    -- Generics
    constant g_fifo_depth : integer := 11;
    -- Ports
    signal m_axi_aclk        : std_logic := '0';
    signal m_axi_aresetn     : std_logic := '1';
    signal m_axi_arready     : std_logic;
    signal m_axi_arvalid     : std_logic;
    signal m_axi_araddr      : std_logic_vector(31 downto 0);
    signal m_axi_arid        : std_logic_vector (3 downto 0);
    signal m_axi_arlen       : std_logic_vector (7 downto 0);
    signal m_axi_arsize      : std_logic_vector (2 downto 0);
    signal m_axi_arburst     : std_logic_vector (1 downto 0);
    signal m_axi_arlock      : std_logic;
    signal m_axi_arcache     : std_logic_vector (3 downto 0);
    signal m_axi_arprot      : std_logic_vector (2 downto 0);
    signal m_axi_arqos       : std_logic_vector (3 downto 0);
    signal m_axi_arregion    : std_logic_vector (3 downto 0);
    signal m_axi_rready      : std_logic;
    signal m_axi_rvalid      : std_logic;
    signal m_axi_rdata       : std_logic_vector(31 downto 0);
    signal m_axi_rresp       : std_logic_vector(1 downto 0);
    signal m_axi_rid         : std_logic_vector (3 downto 0);
    signal m_axi_rlast       : std_logic;
    signal m_axi_awready     : std_logic;
    signal m_axi_awvalid     : std_logic;
    signal m_axi_awaddr      : std_logic_vector(31 downto 0);
    signal m_axi_awid        : std_logic_vector (3 downto 0);
    signal m_axi_awlen       : std_logic_vector (7 downto 0);
    signal m_axi_awsize      : std_logic_vector (2 downto 0);
    signal m_axi_awburst     : std_logic_vector (1 downto 0);
    signal m_axi_awlock      : std_logic;
    signal m_axi_awcache     : std_logic_vector (3 downto 0);
    signal m_axi_awprot      : std_logic_vector (2 downto 0);
    signal m_axi_awqos       : std_logic_vector (3 downto 0);
    signal m_axi_awregion    : std_logic_vector (3 downto 0);
    signal m_axi_wready      : std_logic;
    signal m_axi_wvalid      : std_logic;
    signal m_axi_wid         : std_logic_vector(3 downto 0);
    signal m_axi_wdata       : std_logic_vector(31 downto 0);
    signal m_axi_wstrb       : std_logic_vector(3 downto 0);
    signal m_axi_wlast       : std_logic;
    signal m_axi_bready      : std_logic;
    signal m_axi_bvalid      : std_logic;
    signal m_axi_bresp       : std_logic_vector(1 downto 0);
    signal m_axi_bid         : std_logic_vector(3 downto 0);
    signal s_axi_awaddr      : std_logic_vector(5 downto 0);
    signal s_axi_awprot      : std_logic_vector(2 downto 0);
    signal s_axi_awvalid     : std_logic;
    signal s_axi_awready     : std_logic;
    signal s_axi_wdata       : std_logic_vector(31 downto 0);
    signal s_axi_wstrb       : std_logic_vector(3 downto 0);
    signal s_axi_wvalid      : std_logic;
    signal s_axi_wready      : std_logic;
    signal s_axi_bresp       : std_logic_vector(1 downto 0);
    signal s_axi_bvalid      : std_logic;
    signal s_axi_bready      : std_logic;
    signal s_axi_araddr      : std_logic_vector(5 downto 0);
    signal s_axi_arprot      : std_logic_vector(2 downto 0);
    signal s_axi_arvalid     : std_logic;
    signal s_axi_arready     : std_logic;
    signal s_axi_rdata       : std_logic_vector(31 downto 0);
    signal s_axi_rresp       : std_logic_vector(1 downto 0);
    signal s_axi_rvalid      : std_logic;
    signal s_axi_rready      : std_logic;
    signal i_rx_0            : std_logic;
    signal o_tx_0            : std_logic;
    signal i_rx_1            : std_logic;
    signal o_tx_1            : std_logic;
    signal o_uart_0_1_rx_int : std_logic;
    signal o_uart_0_1_tx_int : std_logic;
    ---
    signal m_axi_awuser : std_logic_vector(-1 downto 0); -- not used but declared
    signal m_axi_wuser  : std_logic_vector(-1 downto 0); -- not used but declared
    signal m_axi_buser  : std_logic_vector(-1 downto 0); -- not used but declared
    signal m_axi_aruser : std_logic_vector(-1 downto 0); -- not used but declared
    signal m_axi_ruser  : std_logic_vector(-1 downto 0); -- not used but declared
    ---
    signal s_axi_if : t_axi4lite_slave_if;
begin
    -- Write address channel
    s_axi_awaddr     <= s_axi_if.awaddr(5 downto 0);
    s_axi_awprot     <= s_axi_if.awprot;
    s_axi_awvalid    <= s_axi_if.awvalid;
    s_axi_if.awready <= s_axi_awready;

    -- Write data channel
    s_axi_wdata     <= s_axi_if.wdata;
    s_axi_wstrb     <= s_axi_if.wstrb;
    s_axi_wvalid    <= s_axi_if.wvalid;
    s_axi_if.wready <= s_axi_wready;

    -- Write response channel
    s_axi_if.bresp  <= s_axi_bresp;
    s_axi_if.bvalid <= s_axi_bvalid;
    s_axi_bready    <= s_axi_if.bready;

    -- Read address channel
    s_axi_araddr     <= s_axi_if.araddr(5 downto 0);
    s_axi_arprot     <= s_axi_if.arprot;
    s_axi_arvalid    <= s_axi_if.arvalid;
    s_axi_if.arready <= s_axi_arready;

    -- Read data channel
    s_axi_if.rdata  <= s_axi_rdata;
    s_axi_if.rresp  <= s_axi_rresp;
    s_axi_if.rvalid <= s_axi_rvalid;
    s_axi_rready    <= s_axi_if.rready;

    m_axi_aclk <= not m_axi_aclk after clk_period/2;
    process
    begin
        wait for clk_period * 10;
        wait until rising_edge(m_axi_aclk);
        m_axi_aresetn <= '0';
        wait for clk_period * 10;
        m_axi_aresetn <= '1';
        wait for clk_period * 10;

        --Write UART_0_CFG_1 Register clk_per_bit = 0x364 (dec 868), data width = 0b11, stop bit = 1, no parity
        axi4lite_write(s_axi_if, m_axi_aclk, std_logic_vector(to_unsigned(0,32)), x"03000364");
        --Write UART_0_CFG_2 Register Rx_idle time = 0x3EB (dec 1000) 
        axi4lite_write(s_axi_if, m_axi_aclk, std_logic_vector(to_unsigned(0+4,32)), x"000003E8");
        --Write UART_0_DMA_TX_ADDR Register = 0x0 (TX Addr)
        axi4lite_write(s_axi_if, m_axi_aclk, std_logic_vector(to_unsigned(0+8,32)), x"00000000");
        --Write UART_0_DMA_RX_ADDR Register = 0x100 (RX Addr)
        axi4lite_write(s_axi_if, m_axi_aclk, std_logic_vector(to_unsigned(0+12,32)), x"00000100");
        --Write UART_0_DMA_RX_CFG Register = RX enable, buffer length = 256
        axi4lite_write(s_axi_if, m_axi_aclk, std_logic_vector(to_unsigned(0+16,32)), x"80000100");

        --Write UART_1_CFG_1 Register clk_per_bit = 0x364 (dec 868), data width = 0b11, stop bit = 1, no parity
        axi4lite_write(s_axi_if, m_axi_aclk, std_logic_vector(to_unsigned(20,32)), x"03000364");
        --Write UART_1_CFG_2 Register Rx_idle time = 0x3EB (dec 1000) 
        axi4lite_write(s_axi_if, m_axi_aclk, std_logic_vector(to_unsigned(20+4,32)), x"000003E8");
        --Write UART_1_DMA_TX_ADDR Register = 0x200 (TX Addr)
        axi4lite_write(s_axi_if, m_axi_aclk, std_logic_vector(to_unsigned(20+8,32)), x"00000200");
        --Write UART_1_DMA_RX_ADDR Register = 0x200 (RX Addr)
        axi4lite_write(s_axi_if, m_axi_aclk, std_logic_vector(to_unsigned(20+12,32)), x"00000300");
        --Write UART_1_DMA_RX_CFG Register = RX enable, buffer length = 256
        axi4lite_write(s_axi_if, m_axi_aclk, std_logic_vector(to_unsigned(20+16,32)), x"80000100");


        report "AXI4-Lite WRITE SUCCESSFUL" severity note;
        wait;
    end process;







    DMA_UART_inst : entity work.DMA_UART
        generic map(
            g_fifo_depth => g_fifo_depth
        )
        port map(
            m_axi_aclk        => m_axi_aclk,
            m_axi_aresetn     => m_axi_aresetn,
            m_axi_arready     => m_axi_arready,
            m_axi_arvalid     => m_axi_arvalid,
            m_axi_araddr      => m_axi_araddr,
            m_axi_arid        => m_axi_arid,
            m_axi_arlen       => m_axi_arlen,
            m_axi_arsize      => m_axi_arsize,
            m_axi_arburst     => m_axi_arburst,
            m_axi_arlock      => m_axi_arlock,
            m_axi_arcache     => m_axi_arcache,
            m_axi_arprot      => m_axi_arprot,
            m_axi_arqos       => m_axi_arqos,
            m_axi_arregion    => m_axi_arregion,
            m_axi_rready      => m_axi_rready,
            m_axi_rvalid      => m_axi_rvalid,
            m_axi_rdata       => m_axi_rdata,
            m_axi_rresp       => m_axi_rresp,
            m_axi_rid         => m_axi_rid,
            m_axi_rlast       => m_axi_rlast,
            m_axi_awready     => m_axi_awready,
            m_axi_awvalid     => m_axi_awvalid,
            m_axi_awaddr      => m_axi_awaddr,
            m_axi_awid        => m_axi_awid,
            m_axi_awlen       => m_axi_awlen,
            m_axi_awsize      => m_axi_awsize,
            m_axi_awburst     => m_axi_awburst,
            m_axi_awlock      => m_axi_awlock,
            m_axi_awcache     => m_axi_awcache,
            m_axi_awprot      => m_axi_awprot,
            m_axi_awqos       => m_axi_awqos,
            m_axi_awregion    => m_axi_awregion,
            m_axi_wready      => m_axi_wready,
            m_axi_wvalid      => m_axi_wvalid,
            m_axi_wid         => m_axi_wid,
            m_axi_wdata       => m_axi_wdata,
            m_axi_wstrb       => m_axi_wstrb,
            m_axi_wlast       => m_axi_wlast,
            m_axi_bready      => m_axi_bready,
            m_axi_bvalid      => m_axi_bvalid,
            m_axi_bresp       => m_axi_bresp,
            m_axi_bid         => m_axi_bid,
            s_axi_awaddr      => s_axi_awaddr,
            s_axi_awprot      => s_axi_awprot,
            s_axi_awvalid     => s_axi_awvalid,
            s_axi_awready     => s_axi_awready,
            s_axi_wdata       => s_axi_wdata,
            s_axi_wstrb       => s_axi_wstrb,
            s_axi_wvalid      => s_axi_wvalid,
            s_axi_wready      => s_axi_wready,
            s_axi_bresp       => s_axi_bresp,
            s_axi_bvalid      => s_axi_bvalid,
            s_axi_bready      => s_axi_bready,
            s_axi_araddr      => s_axi_araddr,
            s_axi_arprot      => s_axi_arprot,
            s_axi_arvalid     => s_axi_arvalid,
            s_axi_arready     => s_axi_arready,
            s_axi_rdata       => s_axi_rdata,
            s_axi_rresp       => s_axi_rresp,
            s_axi_rvalid      => s_axi_rvalid,
            s_axi_rready      => s_axi_rready,
            i_rx_0            => i_rx_0,
            o_tx_0            => o_tx_0,
            i_rx_1            => i_rx_1,
            o_tx_1            => o_tx_1,
            o_uart_0_1_rx_int => o_uart_0_1_rx_int,
            o_uart_0_1_tx_int => o_uart_0_1_tx_int
        );

    AXI4_Full_Slave_IP_inst : entity work.AXI4_Full_Slave_IP
        port map(
            s00_axi_aclk     => m_axi_aclk,
            s00_axi_aresetn  => m_axi_aresetn,
            s00_axi_awid     => m_axi_awid,
            s00_axi_awaddr   => m_axi_awaddr(9 downto 0),
            s00_axi_awlen    => m_axi_awlen,
            s00_axi_awsize   => m_axi_awsize,
            s00_axi_awburst  => m_axi_awburst,
            s00_axi_awlock   => m_axi_awlock,
            s00_axi_awcache  => m_axi_awcache,
            s00_axi_awprot   => m_axi_awprot,
            s00_axi_awqos    => m_axi_awqos,
            s00_axi_awregion => m_axi_awregion,
            s00_axi_awuser   => m_axi_awuser,
            s00_axi_awvalid  => m_axi_awvalid,
            s00_axi_awready  => m_axi_awready,
            s00_axi_wdata    => m_axi_wdata,
            s00_axi_wstrb    => m_axi_wstrb,
            s00_axi_wlast    => m_axi_wlast,
            s00_axi_wuser    => m_axi_wuser,
            s00_axi_wvalid   => m_axi_wvalid,
            s00_axi_wready   => m_axi_wready,
            s00_axi_bid      => m_axi_bid,
            s00_axi_bresp    => m_axi_bresp,
            s00_axi_buser    => m_axi_buser,
            s00_axi_bvalid   => m_axi_bvalid,
            s00_axi_bready   => m_axi_bready,
            s00_axi_arid     => m_axi_arid,
            s00_axi_araddr   => m_axi_araddr(9 downto 0),
            s00_axi_arlen    => m_axi_arlen,
            s00_axi_arsize   => m_axi_arsize,
            s00_axi_arburst  => m_axi_arburst,
            s00_axi_arlock   => m_axi_arlock,
            s00_axi_arcache  => m_axi_arcache,
            s00_axi_arprot   => m_axi_arprot,
            s00_axi_arqos    => m_axi_arqos,
            s00_axi_arregion => m_axi_arregion,
            s00_axi_aruser   => m_axi_aruser,
            s00_axi_arvalid  => m_axi_arvalid,
            s00_axi_arready  => m_axi_arready,
            s00_axi_rid      => m_axi_rid,
            s00_axi_rdata    => m_axi_rdata,
            s00_axi_rresp    => m_axi_rresp,
            s00_axi_rlast    => m_axi_rlast,
            s00_axi_ruser    => m_axi_ruser,
            s00_axi_rvalid   => m_axi_rvalid,
            s00_axi_rready   => m_axi_rready
        );
end;