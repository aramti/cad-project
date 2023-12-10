package mult_tb
import mult::*;

module mkFoldedMultiplierTB;

    Multiplier#(32, TAdd#(32, 32)) dut <- mkFoldedMultiplier;
    Bit#(32) a_init = 5;
    Bit#(32) b_init = 3;

    Reg#(Bit#(32)) cycleCount <- mkReg(0);
    Reg#(Bool) testDone <- mkReg(False);

    rule applyStimuli;
        dut.start(a_init, b_init);
    endrule

    rule observeResults;
        if (dut.result_outmul() && !testDone) begin
            $display("Test Passed: Result = %0d", dut.result());
            testDone <= True;
        end
    endrule

    rule advanceCycles;
        if (!testDone) begin
            cycleCount <= cycleCount + 1;
        end
    endrule

    rule stopSimulation;
        if (cycleCount == 1000) begin
            $finish;
        end
    endrule

    always @(posedge dut.start_mul());
        $display("Cycle %0d", cycleCount);
    endrule

endmodule
endpackage
