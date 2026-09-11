`timescale 1ns/1ps

module apb_slave_tb;

    //-----------------------------------------
    // Parameters
    //-----------------------------------------
    parameter NUM_REGS    = 8;
    parameter WAIT_CYCLES = 3;

    //-----------------------------------------
    // Signals
    //-----------------------------------------
    reg         PCLK;
    reg         PRESETn;

    reg  [31:0] PADDR;
    reg         PSEL;
    reg         PENABLE;
    reg         PWRITE;
    reg  [31:0] PWDATA;

    wire [31:0] PRDATA;
    wire        PREADY;
    wire        PSLVERR;

    //-----------------------------------------
    // DUT
    //-----------------------------------------
    apb_slave #(
        .NUM_REGS    (NUM_REGS),
        .WAIT_CYCLES (WAIT_CYCLES)
    ) dut (
        .PCLK    (PCLK),
        .PRESETn (PRESETn),
        .PADDR   (PADDR),
        .PSEL    (PSEL),
        .PENABLE (PENABLE),
        .PWRITE  (PWRITE),
        .PWDATA  (PWDATA),
        .PRDATA  (PRDATA),
        .PREADY  (PREADY),
        .PSLVERR (PSLVERR)
    );

    //-----------------------------------------
    // Clock: 10 ns period
    //-----------------------------------------
    initial PCLK = 0;
    always #5 PCLK = ~PCLK;

    //-----------------------------------------
    // Waveform dump
    //-----------------------------------------
    initial begin
        $dumpfile("apb_slave.vcd");
        $dumpvars(0, apb_slave_tb);
    end

    //-----------------------------------------
    // Task: APB WRITE
    //-----------------------------------------
    task apb_write(input [31:0] a, input [31:0] d);
        begin
            // SETUP phase
            @(posedge PCLK);
            PADDR   = a;
            PWDATA  = d;
            PWRITE  = 1;
            PSEL    = 1;
            PENABLE = 0;

            // ACCESS phase
            @(posedge PCLK);
            PENABLE = 1;

            // Wait for slave to be ready
            @(posedge PCLK);
            while (!PREADY) @(posedge PCLK);

            // End of transfer
            @(posedge PCLK);
            PSEL    = 0;
            PENABLE = 0;
            PWRITE  = 0;
        end
    endtask

    //-----------------------------------------
    // Task: APB READ
    //-----------------------------------------
    task apb_read(input [31:0] a);
        begin
            // SETUP phase
            @(posedge PCLK);
            PADDR   = a;
            PWRITE  = 0;
            PSEL    = 1;
            PENABLE = 0;

            // ACCESS phase
            @(posedge PCLK);
            PENABLE = 1;

            // Wait for slave to be ready
            @(posedge PCLK);
            while (!PREADY) @(posedge PCLK);

            // End of transfer
            @(posedge PCLK);
            PSEL    = 0;
            PENABLE = 0;
        end
    endtask

    //-----------------------------------------
    // Test sequence
    //-----------------------------------------
    initial begin
        // ---- Initialize ----
        PRESETn = 0;
        PADDR   = 0;
        PSEL    = 0;
        PENABLE = 0;
        PWRITE  = 0;
        PWDATA  = 0;

        // ---- Reset ----
        #20;
        PRESETn = 1;
        #20;

        // ---- TEST 1: Write to reg 0 ----
        $display("[%0t] TEST 1: Write 0xDEADBEEF to addr 0x00", $time);
        apb_write(32'h00, 32'hDEADBEEF);
        #20;

        // ---- TEST 2: Read back from reg 0 ----
        $display("[%0t] TEST 2: Read from addr 0x00", $time);
        apb_read(32'h00);
        #20;
        if (PRDATA === 32'hDEADBEEF)
            $display("   PASS: PRDATA = %h", PRDATA);
        else
            $display("   FAIL: PRDATA = %h (expected DEADBEEF)", PRDATA);

        // ---- TEST 3: Write to reg 4 (addr = 4*4 = 0x10) ----
        $display("[%0t] TEST 3: Write 0x12345678 to addr 0x10", $time);
        apb_write(32'h10, 32'h12345678);
        #20;

        // ---- TEST 4: Read from reg 4 ----
        $display("[%0t] TEST 4: Read from addr 0x10", $time);
        apb_read(32'h10);
        #20;
        if (PRDATA === 32'h12345678)
            $display("   PASS: PRDATA = %h", PRDATA);
        else
            $display("   FAIL: PRDATA = %h (expected 12345678)", PRDATA);

        // ---- TEST 5: Invalid address (reg 10, only 8 regs) ----
        $display("[%0t] TEST 5: Read from invalid addr 0x28", $time);
        apb_read(32'h28);
        #20;
        if (PSLVERR === 1)
            $display("   PASS: PSLVERR asserted for invalid addr");
        else
            $display("   FAIL: PSLVERR = %b (expected 1)", PSLVERR);

        #40;
        $display("[%0t] DONE", $time);
        $finish;
    end

endmodule
