module top(
           input        clk,
           output       clk_en,
           input        rst_n,
           output [7:0] led,
           output       lcd_flm,
           output       lcd_cl1,
           output       lcd_cl2,
           output       lcd_m,
           output [3:0] lcd_data,
           input        cs_n,
           input        sclk,
           input        mosi,
           output       miso,
           input uart_rx,
           output uart_tx
           );

   assign clk_en = 1;

   reg [15:0]    clkdiv;
   reg           clk_1mhz;
   reg           clk_lcd;

   always @ (negedge clk)
     begin
        if (clkdiv >= 8'd10)
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

   wire        fb_wclk;
   reg [31:0]  fb_waddr;
   reg [7:0]   fb_wdata;
   wire        fb_switch;

   framebuffer fb (.rst_n(rst_n),
                   .rclk(fb_clk),
                   .wclk(fb_wclk),
                   .rad(fb_addr),
                   .wad(fb_waddr - 1),
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
                   .cs_n(cs_n),
                   .sclk(sclk),
                   .mosi(mosi),
                   .miso(miso),
                   .dr(dr),
                   .rxbuf(rxbuf));

   //simpleuart uart1 (.resetn(rst_n),
   //                  .clk(clk),
   //                  .ser_tx(uart_tx),
   //                  .ser_rx(uart_rx),
   //                  .reg_)

   reg         flag;

   reg [31:0]  clkdivcnt;

   //always @ (posedge dr, posedge cs_n)
   //  begin
   //     if (cs_n)
   //       begin
   //          fb_waddr <= 0;
   //          fb_wdata <= 0;
   //       end
   //     else
   //       begin
   //          fb_waddr <= fb_waddr + 1;
   //          fb_wdata <= rxbuf;
   //       end // else: !if(!rst_n)
   //  end // always @ (posedge dr, negedge rst_n)

   assign fb_switch = cs_n;
   assign fb_wclk = !dr;
endmodule
