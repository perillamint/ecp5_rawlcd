module framebuffer(input clk,
                   input [31:0] addr,
                   output [7:0] data);
`include "lcd_params.vh"

   reg [7:0]                    data;

   reg [7:0]                    ram [0:fbsize - 1];
   initial $readmemh("fb.hex", ram);

   always @ (posedge clk)
     begin
        data <= ram[addr];
     end
endmodule // framebuffer
