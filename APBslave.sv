module apb_slave_top (
    input  logic                      pclk,
    input  logic                      presetn,
    input  logic [apb_pkg::ADDR_WIDTH-1:0] paddr,
    input  logic                      psel,
    input  logic                      penable,
    input  logic [apb_pkg::DATA_WIDTH-1:0] pwdata,
    input  logic                      pwrite,
    output logic [apb_pkg::DATA_WIDTH-1:0] prdata,
    output logic                      pready,
    output logic                      pslverr
);
    // Import the package to access types and parameters
    import apb_pkg::*;

    // Internal state parameters
    localparam apb_slave_state_t IDLE  = SLAVE_IDLE;
    localparam apb_slave_state_t WRITE = SLAVE_WRITE;
    localparam apb_slave_state_t READ  = SLAVE_READ;

    // Internal signals
    logic [DATA_WIDTH-1:0] mem[0:15];       // Memory array
    apb_slave_state_t state, nstate;       // Current and next states

    // Error signals
    logic addr_err, addv_err, data_err;

    // State register with reset logic
    always_ff @(posedge pclk or negedge presetn) begin
        if (!presetn)
            state <= IDLE;
        else
            state <= nstate;
    end

    // Next-state logic and output logic
    always_comb begin
        // Default assignments
        prdata = '0;
        pready = 1'b0;
        nstate = state;

        // State machine
        case (state)
            IDLE: begin
                if (psel && pwrite)
                    nstate = WRITE;
                else if (psel && !pwrite)
                    nstate = READ;
            end

            WRITE: begin
                if (psel && penable) begin
                    if (!addr_err && !addv_err && !data_err) begin
                        pready = 1'b1;
                        mem[paddr] = pwdata; // Write data to memory
                    end
                    nstate = IDLE;
                end
            end

            READ: begin
                if (psel && penable) begin
                    if (!addr_err && !addv_err && !data_err) begin
                        pready = 1'b1;
                        prdata = mem[paddr]; // Read data from memory
                    end
                    nstate = IDLE;
                end
            end

            default: nstate = IDLE;
        endcase
    end

    // Error handling logic
    assign addr_err = (paddr >= 4'h10); // Address out of range
    assign addv_err = (paddr < 0);      // Invalid address (example logic)
    assign data_err = (pwdata == '0);   // Example data validation

    assign pslverr = (psel && penable) ? (addr_err || addv_err || data_err) : 1'b0;

endmodule
