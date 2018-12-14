`timescale 1ns/10ps

module testram(input        clk,
               input [31:0] addr,
               output [7:0] data);

`include "lcd_params.vh"

   reg [7:0]                data;
   reg [7:0]                ram [0:fbsize - 1];

   initial $readmemh("fb.hex", ram);

   always @ (posedge clk)
     begin
        data <= ram[addr];
     end
endmodule // testram

module rawlcd_tb;
   reg clk;
   reg rst_n;
   wire [3:0] data;
   wire flm;
   wire lp;
   wire dclk;
   wire m;
   wire fb_clk;
   wire [31:0] fb_addr;
   wire [7:0]  fb_data;

   testram tram1(.clk(fb_clk),
                 .addr(fb_addr),
                 .data(fb_data));

   lcd lcd1(.clk(clk),
            .rst_n(rst_n),
            .fb_clk(fb_clk),
            .fb_data(fb_data),
            .fb_addr(fb_addr),
            .data(data),
            .flm(flm),
            .lp(lp),
            .dclk(dclk),
            .m(m));

   initial begin
      $dumpfile("rawlcd_wave.vcd");
      $dumpvars(0, lcd1);

      clk <= 0;
      rst_n <= 1;
      #1;
      rst_n <= 0;
      #1;
      rst_n <= 1;
      #1;
      #10000000;
      $finish;
   end // initial begin

   always #10 clk <= ~clk;
endmodule // rawlcd_tb
