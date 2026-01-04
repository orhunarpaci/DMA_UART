library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AXI4_Lite_Slave is
    generic (
        -- Users to add parameters here

        -- User parameters ends
        -- Do not modify the parameters beyond this line
        -- Parameters of Axi Slave Bus Interface S_AXI
        C_S_AXI_DATA_WIDTH : integer := 32;
        C_S_AXI_ADDR_WIDTH : integer := 6
    );
    port (
        -- Users to add ports here
        -- Uart-0 User ports
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
        -- Uart-1 User ports
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
        -- UART-0-1 common user signals --
        o_uart_0_1_sync : out std_logic;

        -- User ports ends
        -- Do not modify the ports beyond this line
        -- Ports of Axi Slave Bus Interface S_AXI
        s_axi_aclk    : in std_logic;
        s_axi_aresetn : in std_logic;
        s_axi_awaddr  : in std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
        s_axi_awprot  : in std_logic_vector(2 downto 0);
        s_axi_awvalid : in std_logic;
        s_axi_awready : out std_logic;
        s_axi_wdata   : in std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
        s_axi_wstrb   : in std_logic_vector((C_S_AXI_DATA_WIDTH/8) - 1 downto 0);
        s_axi_wvalid  : in std_logic;
        s_axi_wready  : out std_logic;
        s_axi_bresp   : out std_logic_vector(1 downto 0);
        s_axi_bvalid  : out std_logic;
        s_axi_bready  : in std_logic;
        s_axi_araddr  : in std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
        s_axi_arprot  : in std_logic_vector(2 downto 0);
        s_axi_arvalid : in std_logic;
        s_axi_arready : out std_logic;
        s_axi_rdata   : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
        s_axi_rresp   : out std_logic_vector(1 downto 0);
        s_axi_rvalid  : out std_logic;
        s_axi_rready  : in std_logic
    );
end AXI4_Lite_Slave;

architecture arch_imp of AXI4_Lite_Slave is

    -- component declaration
    component AXI4_Lite_Slave_Driver
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
            S_AXI_ACLK              : in std_logic;
            S_AXI_ARESETN           : in std_logic;
            S_AXI_AWADDR            : in std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
            S_AXI_AWPROT            : in std_logic_vector(2 downto 0);
            S_AXI_AWVALID           : in std_logic;
            S_AXI_AWREADY           : out std_logic;
            S_AXI_WDATA             : in std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
            S_AXI_WSTRB             : in std_logic_vector((C_S_AXI_DATA_WIDTH/8) - 1 downto 0);
            S_AXI_WVALID            : in std_logic;
            S_AXI_WREADY            : out std_logic;
            S_AXI_BRESP             : out std_logic_vector(1 downto 0);
            S_AXI_BVALID            : out std_logic;
            S_AXI_BREADY            : in std_logic;
            S_AXI_ARADDR            : in std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
            S_AXI_ARPROT            : in std_logic_vector(2 downto 0);
            S_AXI_ARVALID           : in std_logic;
            S_AXI_ARREADY           : out std_logic;
            S_AXI_RDATA             : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
            S_AXI_RRESP             : out std_logic_vector(1 downto 0);
            S_AXI_RVALID            : out std_logic;
            S_AXI_RREADY            : in std_logic
        );
    end component;
begin

    -- Instantiation of Axi Bus Interface S_AXI
    AXI4_Lite_Slave_Driver_inst : AXI4_Lite_Slave_Driver
        generic map(
            C_S_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
            C_S_AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH
        )
        port map(
            o_uart_0_rst            => o_uart_0_rst,
            o_uart_0_clk_per_bit    => o_uart_0_clk_per_bit,
            o_uart_0_rx_idle_timer  => o_uart_0_rx_idle_timer,
            o_uart_0_data_width     => o_uart_0_data_width,
            o_uart_0_parity_en      => o_uart_0_parity_en,
            o_uart_0_parity         => o_uart_0_parity,
            o_uart_0_stop_bit       => o_uart_0_stop_bit,
            o_uart_0_tx_buffer_addr => o_uart_0_tx_buffer_addr,
            o_uart_0_tx_data_len    => o_uart_0_tx_data_len,
            o_uart_0_tx_start       => o_uart_0_tx_start,
            i_uart_0_tx_done        => i_uart_0_tx_done,
            i_uart_0_tx_busy        => i_uart_0_tx_busy,
            o_uart_0_tx_clr         => o_uart_0_tx_clr,
            o_uart_0_rx_en          => o_uart_0_rx_en,
            o_uart_0_rx_buffer_addr => o_uart_0_rx_buffer_addr,
            o_uart_0_rx_buffer_len  => o_uart_0_rx_buffer_len,
            i_uart_0_rx_data_len    => i_uart_0_rx_data_len,
            i_uart_0_rx_done        => i_uart_0_rx_done,
            i_uart_0_rx_half_done   => i_uart_0_rx_half_done,
            o_uart_0_rx_clr         => o_uart_0_rx_clr,
            o_uart_1_rst            => o_uart_1_rst,
            o_uart_1_clk_per_bit    => o_uart_1_clk_per_bit,
            o_uart_1_rx_idle_timer  => o_uart_1_rx_idle_timer,
            o_uart_1_data_width     => o_uart_1_data_width,
            o_uart_1_parity_en      => o_uart_1_parity_en,
            o_uart_1_parity         => o_uart_1_parity,
            o_uart_1_stop_bit       => o_uart_1_stop_bit,
            o_uart_1_tx_buffer_addr => o_uart_1_tx_buffer_addr,
            o_uart_1_tx_data_len    => o_uart_1_tx_data_len,
            o_uart_1_tx_start       => o_uart_1_tx_start,
            i_uart_1_tx_done        => i_uart_1_tx_done,
            i_uart_1_tx_busy        => i_uart_1_tx_busy,
            o_uart_1_tx_clr         => o_uart_1_tx_clr,
            o_uart_1_rx_en          => o_uart_1_rx_en,
            o_uart_1_rx_buffer_addr => o_uart_1_rx_buffer_addr,
            o_uart_1_rx_buffer_len  => o_uart_1_rx_buffer_len,
            i_uart_1_rx_data_len    => i_uart_1_rx_data_len,
            i_uart_1_rx_done        => i_uart_1_rx_done,
            i_uart_1_rx_half_done   => i_uart_1_rx_half_done,
            o_uart_1_rx_clr         => o_uart_1_rx_clr,
            o_uart_0_1_sync         => o_uart_0_1_sync,
            S_AXI_ACLK              => S_AXI_ACLK,
            S_AXI_ARESETN           => S_AXI_ARESETN,
            S_AXI_AWADDR            => S_AXI_AWADDR,
            S_AXI_AWPROT            => S_AXI_AWPROT,
            S_AXI_AWVALID           => S_AXI_AWVALID,
            S_AXI_AWREADY           => S_AXI_AWREADY,
            S_AXI_WDATA             => S_AXI_WDATA,
            S_AXI_WSTRB             => S_AXI_WSTRB,
            S_AXI_WVALID            => S_AXI_WVALID,
            S_AXI_WREADY            => S_AXI_WREADY,
            S_AXI_BRESP             => S_AXI_BRESP,
            S_AXI_BVALID            => S_AXI_BVALID,
            S_AXI_BREADY            => S_AXI_BREADY,
            S_AXI_ARADDR            => S_AXI_ARADDR,
            S_AXI_ARPROT            => S_AXI_ARPROT,
            S_AXI_ARVALID           => S_AXI_ARVALID,
            S_AXI_ARREADY           => S_AXI_ARREADY,
            S_AXI_RDATA             => S_AXI_RDATA,
            S_AXI_RRESP             => S_AXI_RRESP,
            S_AXI_RVALID            => S_AXI_RVALID,
            S_AXI_RREADY            => S_AXI_RREADY
        );
    -- Add user logic here

    -- User logic ends

end arch_imp;
