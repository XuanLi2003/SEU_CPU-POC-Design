`timescale 1ns / 1ps

module POCexp(
    input clk,
    input reset,
    input modset,
    input [7:0]data,
    output [7:0]print
   
    );
 
  
wire ADDR;
wire TR;
wire RW;
wire IRQ;
wire RDY;

wire [7:0]Din;
wire [7:0]Dout;
wire [7:0]PD;
 
    
Processor u_Processor(
    .ADDR(ADDR),//����SR����BR��1��BR
    .Dout(Dout[7:0]),
    .Din(Din[7:0]),
    .RW(RW),//���ƶ�д��1��cpu����д
    .clk(clk),
    .IRQ(IRQ),//IRQΪ0�����ж�����
    .reset(reset),
    .modset(modset),
    .data(data[7:0])

    );
    
POC u_POC(
    .clk(clk),
    .IRQ(IRQ),
    .RW(RW),
    .Din(Din[7:0]),
    .Dout(Dout[7:0]),
    .ADDR(ADDR),
    .RDY(RDY),
    .TR(TR),
    .PD(PD[7:0]),
    .reset(reset)

    );   
    
Printer u_Printer(
    .clk(clk),
    .TR(TR),
    .PD(PD[7:0]),
    .RDY(RDY),
    .PRINT(print[7:0]),
    .reset(reset)

    ); 
    
    
    
endmodule
