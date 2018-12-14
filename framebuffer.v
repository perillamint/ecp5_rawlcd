module framebuffer(input        rst_n,
                   input        rclk,
                   input        wclk,
                   input [31:0] rad,
                   input [31:0] wad,
                   input        switch,
                   input [7:0]  din,
                   output [7:0] dout);

   reg                          fbsel;
   wire                         clk1;
   wire                         clk2;
   wire [31:0]                  dout1;
   wire [31:0]                  dout2;

   fbram fbram1(.clk(clk1),
                .wre(fbsel),
                .rad(rad),
                .wad(wad),
                .dout(dout1),
                .din(din));

   fbram fbram2(.clk(clk2),
                .wre(!fbsel),
                .rad(rad),
                .wad(wad),
                .dout(dout2),
                .din(din));

   assign dout = fbsel ? dout1 : dout2;
   assign clk1 = fbsel ? rclk : wclk;
   assign clk2 = !fbsel ? rclk : wclk;

   always @ (posedge switch, negedge rst_n)
     begin
        if (!rst_n)
          begin
             fbsel <= 0;
          end
        else
          begin
             fbsel <= ~fbsel;
          end
     end
endmodule // framebuffer
