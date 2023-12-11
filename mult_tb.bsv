module mktb (Empty);
    Multiplier  dut <- mkFoldedMultiplier;
    rule input;
        dut.start(32'd5,32'd3);
    ebdrule
    rule output;
        $display ("\n Result = %b", dut.result);
        $finish ();
    endrule
endmodule
