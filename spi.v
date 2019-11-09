module spi_slave(
                 input        rst_n,
                 input        cs_n,
                 input        sclk,
                 input        mosi,
                 output       miso,
                 output [7:0] rxbuf,
                 input        txset,
                 input [7:0]  tx,
                 output       dr
                 );

   reg [7:0]                  rxbuf;
   reg                        dr;
   reg                        miso;

   reg [7:0]                  txbuf;
   reg [2:0]                  count;

   wire                       rst = rst_n && (!cs_n);

   always @ (posedge sclk, negedge rst)
     begin
        if (!rst)
          begin
             count <= 0;
             dr <= 0;
             rxbuf <= 0;
            end
        else
          begin
             count <= count + 1;
             dr <= count == 3'd7;
             rxbuf <= {rxbuf[6:0], mosi};
          end
        //miso <= txbuf[];
     end

   always @ (negedge txset)
     begin
        txbuf <= tx;
     end
endmodule // spi_slave
