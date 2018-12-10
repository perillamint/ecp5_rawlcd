module framebuffer(input clk,
                   input [31:0] addr,
                   output [7:0] data);
   reg [7:0]                    data;

   reg [7:0]                    ram [0:7999];
   initial $readmemh("fb.hex", ram);

   always @ (posedge clk)
     begin
        data <= ram[addr];
     end
endmodule // framebuffer
