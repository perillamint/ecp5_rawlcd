module top(
           input        clk,
           input        rst_n,
           output [7:0] led,
           output       lcd_flm,
           output       lcd_cl1,
           output       lcd_cl2,
           output       lcd_m,
           output [3:0] lcd_data
           );

   reg [15:0]    clkdiv;
   reg           clk_1mhz;
   reg           clk_lcd;

   always @ (negedge clk)
     begin
        if (clkdiv >= 16'd2)
          begin
             clkdiv <= 0;
             clk_lcd <= ~clk_lcd;
          end
        else
          begin
             clkdiv <= clkdiv + 1;
          end
     end // always @ (negedge clk, negedge rst_n)

   lcd lcd1 (.clk(clk_lcd),
             .rst_n(rst_n),
             .data(lcd_data),
             .flm(lcd_flm),
             .lp(lcd_cl1),
             .dclk(lcd_cl2),
             .m(lcd_m));

   assign led = ~{lcd_data, lcd_flm, lcd_cl1, lcd_cl2, lcd_m};
endmodule
