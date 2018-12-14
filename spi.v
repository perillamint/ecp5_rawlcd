module spi_slave(
                 input        rst_n,
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

   always @ (posedge sclk)
     begin
        count <= count + 1;
        dr <= count == 3'd7;
        rxbuf <= {rxbuf[6:0], mosi};
        //miso <= txbuf[];
     end

   always @ (negedge txset)
     begin
        txbuf <= tx;
     end
endmodule // spi_slave
