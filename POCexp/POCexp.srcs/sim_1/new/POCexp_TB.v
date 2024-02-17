`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/18 17:12:16
// Design Name: 
// Module Name: POCexp_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module POCexp_TB();

reg	clk;  
reg modset;
reg reset;
reg [7:0]data;
wire [7:0]print;


localparam PERIOD = 100;	//10MHz
localparam JUMP = PERIOD/10;

initial	
begin
	clk = 0;
	forever	#(PERIOD/2)	
	clk = ~clk;
end



POCexp u_POCexp(
    .clk(clk),
    .reset(reset),
    .modset(modset),
    .data(data),
    .print(print)
   
);


initial
begin
    data=8'b10100101;//��һ��data
    reset=1;//���ؿ�
    modset=1;//���ж�
    #(JUMP);
    reset=0;//���ش���
    #(JUMP);
    reset=1;
   
    #(PERIOD*20);
    data=8'b11110000;//��2��data
    #(PERIOD*20);
    data=8'b00001111;//��3��data
    #(PERIOD*20);

    reset=0;
    modset=0;
    #(JUMP);
    reset=1;
    //#(PERIOD*20);
   // data=8'b00110011;//��4��data
    #(PERIOD*40);
    data=8'b11000011;//��4data

    reset=0;//�л�
    modset=1;
    #(JUMP);
    reset=1;//��Ե����
    #(PERIOD*40);
    $stop;
end

endmodule
