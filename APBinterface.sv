// Import the APB package to access the required types
import apb_pkg::*;

// APB Interface definition
interface apb_if (
    input logic pclk,           // Clock signal
    input logic presetn,        // Reset signal
    input logic [3:0] paddr,    // Address bus
    input logic psel,           // Select signal
    input logic penable,        // Enable signal
    input logic [7:0] pwdata,   // Write data
    input logic pwrite,         // Write control signal
    output logic [7:0] prdata,  // Read data
    output logic pready,        // Ready signal
    output logic pslverr        // Slave error signal
);

    // Declare APB slave interface signals using the imported type
    apb_slave_if_t slave_if;

    // Declare APB master interface signals using the imported type
    apb_master_if_t master_if;

endinterface
