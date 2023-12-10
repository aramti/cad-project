# cad-project
A pipelined 32-bit signed integer multiplier.
# Contributers
Lohitha Reddy (EE20B015), 
Yerra Shobha Pavitra (EE20B154)
# Multiplier Algorithm

We have used a 32-bit ripple carry adder. It adds two 32-bit inputs x, y & 1-bit cin to produce a 33-bit output. 
We then Implemented the mkFoldedMultiplier module using 3 rules. The first rule implements the multiplication of the 32-bit number x with lsb 16-bits of y, in the pipeline rule these outputs are passed to the next stage. the second stage rule implements the multiplication of the 32-bit number x with msb 16-bits of y. Using Action start method inputs are given to the variables when the condition index is equal to 33 and the output is taken for the same when the index becomes 32.


