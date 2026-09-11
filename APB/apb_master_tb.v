`timescale 1ns/1ps

module apb_master_tb ;
    reg         clk;
    reg         reset;
    reg         transfer;
    reg         write;
    reg  [31:0] addr;
    reg  [31:0] wdata;

    reg  [31:0] prdata;
    reg         pready;
    reg         pslaverr;

    wire [31:0] paddr;
    wire        psel;
    wire        penable;
    wire        pwrite;
    wire [31:0] pwdata;

    wire [31:0] rdata;
    wire        error;

    //-----------------------------------------
    // DUT
    //-----------------------------------------
    apb_master dut (
        .clk      (clk),
        .reset    (reset),
        .transfer (transfer),
        .write    (write),
        .addr     (addr),
        .wdata    (wdata),
        .prdata   (prdata),
        .pready   (pready),
        .pslaverr (pslaverr),
        .paddr    (paddr),
        .psel     (psel),
        .penable  (penable),
        .pwrite   (pwrite),
        .pwdata   (pwdata),
        .rdata    (rdata),
        .error    (error)
    );

  
    // Clock: 10 ns period

    initial clk = 0;
    always #5 clk = ~clk;

    
    initial begin
        prdata   = 32'hABCD_1234;   // data returned on reads
        pready   = 0;
        pslaverr = 0;
    end

    always @(*) begin
        // Slave responds only when PSEL & PENABLE are high
        if (psel && penable) begin
            pready = 1'b1;
        end else begin
            pready = 1'b0;
        end
    end
  
    initial begin
        $dumpfile("apb_master.vcd");
        $dumpvars(0, apb_master_tb);
    end
    // Test sequence
  
    initial begin
        // ---- Initialize ----
        reset    = 0;
        transfer = 0;
        write    = 0;
        addr     = 0;
        wdata    = 0;

        // ---- Apply reset ----
        #20;
        reset = 1;
        #20;

        // ---- WRITE transaction ----
        $display("[%0t] WRITE: addr=%h data=%h", $time, 32'h1000, 32'hDEAD_BEEF);
        @(posedge clk);
        addr     = 32'h1000;
        wdata    = 32'hDEAD_BEEF;
        write    = 1;
        transfer = 1;

        // Wait for slave to finish (PREADY = 1)
        @(posedge clk);
        while (!pready) @(posedge clk);

        @(posedge clk);
        transfer = 0;
        write    = 0;

        #20;

        // ---- READ transaction ----
        $display("[%0t] READ : addr=%h", $time, 32'h2000);
        @(posedge clk);
        addr     = 32'h2000;
        write    = 0;
        transfer = 1;

        @(posedge clk);
        while (!pready) @(posedge clk);

        @(posedge clk);
        transfer = 0;

        #20;
        $display("[%0t] Read data = %h", $time, rdata);

        #40;
        $display("[%0t] DONE", $time);
        $finish;
    end

endmodule
