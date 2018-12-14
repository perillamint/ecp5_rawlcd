module top(
           input        clk,
           input        rst_n,
           output [7:0] led,
           output       lcd_flm,
           output       lcd_cl1,
           output       lcd_cl2,
           output       lcd_m,
           output [3:0] lcd_data,
           input        sclk,
           input        mosi,
           output       miso
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

   wire [7:0]  rxbuf;
   wire        dr;

   wire        fb_clk;
   wire [31:0] fb_addr;
   wire [7:0]  fb_data;

   reg         fb_wclk;
   reg [31:0]  fb_waddr;
   reg [7:0]   fb_wdata;
   reg         fb_switch;

   framebuffer fb (.rst_n(rst_n),
                   .rclk(fb_clk),
                   .wclk(fb_wclk),
                   .rad(fb_addr),
                   .wad(fb_waddr),
                   .switch(fb_switch),
                   .din(fb_wdata),
                   .dout(fb_data));

   lcd lcd1 (.clk(clk_lcd),
             .rst_n(rst_n),
             .fb_clk(fb_clk),
             .fb_data(fb_data),
             .fb_addr(fb_addr),
             .data(lcd_data),
             .flm(lcd_flm),
             .lp(lcd_cl1),
             .dclk(lcd_cl2),
             .m(lcd_m));

   //assign led = ~{lcd_data, lcd_flm, lcd_cl1, lcd_cl2, lcd_m};
   spi_slave spi1 (.rst_n(rst_n),
                   .sclk(sclk),
                   .mosi(mosi),
                   .miso(miso),
                   .dr(dr),
                   .rxbuf(rxbuf));

   reg         flag;

   always @ (negedge clk)
     begin
        if (dr && !flag)
          begin
             fb_wdata <= rxbuf;
             fb_wclk <= 0;
             flag <= 1;
          end
        else
          begin
             if (flag)
               begin
                  fb_waddr <= fb_waddr + 1;
                  fb_wclk <= 1;
                  flag <= 0;
                  fb_switch <= 0;
               end

             if (fb_waddr == 8000)
               begin
                  fb_switch <= 1;
                  fb_waddr <= 0;
               end
          end
     end
endmodule
