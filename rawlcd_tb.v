`timescale 1ns/10ps

module rawlcd_tb;
   reg clk;
   reg rst_n;
   wire [3:0] data;
   wire flm;
   wire lp;
   wire dclk;
   wire m;

   lcd lcd1(.clk(clk),
            .rst_n(rst_n),
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
