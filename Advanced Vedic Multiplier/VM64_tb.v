module tb_VM64;

    reg  [63:0] x, y;
    wire [127:0] prod;

    wire [127:0] expected;
    assign expected = x * y;

    VM64 dut(x, y, prod);

    integer errors = 0;
    integer tests  = 0;

    task check;
        input [63:0] a, b;
        begin
            x = a; y = b;
            #20;
            tests = tests + 1;
            if (prod !== expected) begin
                $display("ERROR: A=%0d B=%0d -> P=%0d Expected=%0d", a, b, prod, expected);
                errors = errors + 1;
            end
        end
    endtask

    integer i, j;

    initial begin
        $display("=== VM64 Testbench ===");
        errors = 0; tests = 0;
        x = 0; y = 0;
        #10;

        $display("-- Corner Cases --");
        check(0, 0);
        check(1, 0);
        check(0, 1);
        check(1, 1);
        check(64'hFFFFFFFFFFFFFFFF, 1);
        check(1, 64'hFFFFFFFFFFFFFFFF);
        check(64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF);
        check(64'hFFFFFFFF00000000, 64'hFFFFFFFF00000000);
        check(64'h00000000FFFFFFFF, 64'h00000000FFFFFFFF);
        check(64'hFFFFFFFF00000000, 64'h00000000FFFFFFFF);
        check(64'h00000000FFFFFFFF, 64'hFFFFFFFF00000000);
        check(64'hAAAAAAAAAAAAAAAA, 64'h5555555555555555);
        check(64'h5555555555555555, 64'hAAAAAAAAAAAAAAAA);
        check(64'hAAAAAAAAAAAAAAAA, 64'hAAAAAAAAAAAAAAAA);
        check(64'h5555555555555555, 64'h5555555555555555);

        $display("-- Powers of 2 --");
        for (i = 0; i < 64; i = i + 1) begin
            check(64'h1 << i, 1);
            check(1, 64'h1 << i);
            check(64'h1 << i, 64'h1 << i);
        end

        $display("-- Boundary: 32-bit split points --");
        check(64'h0000000100000000, 64'h0000000100000000);
        check(64'hFFFFFFFF00000000, 64'h0000000100000000);
        check(64'h00000000FFFFFFFF, 64'h0000000100000000);
        check(64'h0000000100000000, 64'hFFFFFFFF00000000);
        check(64'h0000000100000000, 64'h00000000FFFFFFFF);
        check(64'hFFFFFFFFFFFFFFFF, 64'h0000000100000000);
        check(64'h0000000100000000, 64'hFFFFFFFFFFFFFFFF);

        $display("-- Small exhaustive (0..255 x 0..255) --");
        for (i = 0; i < 256; i = i + 1)
            for (j = 0; j < 256; j = j + 1)
                check(i, j);

        $display("-- Random Tests (100000) --");
        repeat (100000)
            check({$random,$random}, {$random,$random});

        $display("==============================");
        $display("Total tests : %0d", tests);
        $display("Errors      : %0d", errors);
        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("FAILURES DETECTED");
        $display("==============================");

        $finish;
    end

endmodule
