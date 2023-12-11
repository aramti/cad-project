package mult;

function Bit#(TAdd#(32,1)) ripple(Bit#(32) x, Bit#(32) y, Bit#(1) c0); 
    Bit#(32) s; 
    Bit#(TAdd#(32,1)) c=0; c[0]=c0;
    Integer i;
    for(i=0; i<valueOf(32); i=i+1) begin
        let prop = x[i]^y[i];
        s[i] = prop ^ c[i];
        c[i+1] = (x[i] & y[i]) | (c[i] & prop);
    end
    return {c[valueOf(32)],s}; 
endfunction

interface Multiplier;
    method Bool start_mul();
    method Action start(Bit#(32) a, Bit#(32) b);
    method Bool result_outmul();
    method ActionValue#(Bit#(TAdd#(32,32))) result();
endinterface
(*synthesize*)
module mkFoldedMultiplier(Multiplier);

    Reg#(Bit#(32)) a <- mkRegU();
    Reg#(Bit#(32)) b <- mkRegU();
    Reg#(Bit#(32)) p <- mkRegU();
    Reg#(Bit#(32)) tp <- mkRegU();
    Reg#(Bit#(TAdd#(TLog#(32),1))) i <- mkReg(fromInteger(valueOf(32)+1));

    Reg#(Bit#(32)) p_stage1 <- mkRegU();
    Reg#(Bit#(32)) tp_stage1 <- mkRegU();
    Reg#(Bit#(TAdd#(TLog#(32), 1))) i_stage1 <- mkReg(fromInteger(valueOf(32)+1));

    Reg#(Bool) advance_to_stage2 <- mkReg(False);
    
    rule mulStep_stage1 if(i_stage1 < (fromInteger(valueOf(32)/2)));
        Bit#(32) m = (a[i_stage1] == 0) ? 0 : b;
        let s = ripple(m, tp_stage1, 0);
        p_stage1[i_stage1] <= s[0];
        tp_stage1 <= s[valueOf(32):1];
        i_stage1 <= i_stage1 + 1;
        advance_to_stage2 <= (i_stage1 == fromInteger(valueOf(32)/2));
    endrule

    rule pipelineAdvance if(advance_to_stage2);
            i <= fromInteger(valueOf(32)/2);           
            p <= p_stage1;
            tp <= tp_stage1;
            advance_to_stage2 <= False; 
    endrule

    rule mulStep_stage2 if(i >= fromInteger(valueOf(32)/2) && i < fromInteger(valueOf(32)));
        Bit#(32) m = (a[i] == 0) ? 0 : b;
        let s = ripple(m, tp, 0);
        p[i] <= s[0];
        tp <= s[valueOf(32):1];
        i <= i + 1;
    endrule

    method Bool start_mul();
        return i == fromInteger(valueOf(32)+1);
    endmethod

    method Action start(Bit#(32) a_input, Bit#(32) b_input);
        if (i == fromInteger(valueOf(32)+1)) begin
            a <= a_input;
            b <= b_input;
            p_stage1 <= 0;
            tp_stage1 <= 0;
            i_stage1 <= 0;
            advance_to_stage2 <= False; 
        end
    endmethod

    method Bool result_outmul();
        return i == fromInteger(valueOf(32));
    endmethod

    method ActionValue#(Bit#(TAdd#(32,32))) result();
        if (i == fromInteger(valueOf(32))) begin
            i <= i + 1;
            return {tp, p};
        end
        else begin
            return 0;
        end
    endmethod
endmodule
endpackage
