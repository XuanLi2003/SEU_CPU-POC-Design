`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/08 20:17:45
// Design Name: 
// Module Name: POC
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


module POC(
    input clk,
    output IRQ,
    input RW,
    input [7:0]Din,
    output [7:0]Dout,
    input ADDR,
    input RDY,
    input reset,
   // input mod,//1�ж�0��ѯ
    output TR,
    output [7:0]PD

    );
    
//reg mod_reg;
reg IRQ_reg;
reg TR_reg;  
reg[7:0] PD_reg;
reg[7:0] Dout_reg;
reg[2:0] state_reg;
reg[2:0] next_state=3'b000;
reg[7:0] BR;
reg[7:0] SR;
//reg select;//reset����1��0ѡ��ģʽ

parameter state1= 3'b000;
parameter state2= 3'b001;
parameter state3= 3'b010;
parameter state4= 3'b011;
parameter state5= 3'b100;
parameter state6= 3'b101;//�ؿ�ģʽ
    
    
    
always@(negedge reset or posedge clk)
begin
   // mod_reg<=mod;//��������ģʽ
    if(!reset)
    begin
        next_state=state6;//�ȶ�ȡģʽ
    end
   // mod_reg<=0;//Ĭ�ϲ�ѯ
    else 
    begin
        state_reg=next_state;
    end
end
always@(posedge clk)
begin
    //state_reg=next_state;
    case(state_reg)
        state1:
        begin
            TR_reg<=0;//��ԭTR����
            if(SR==8'b10000001)
            begin
                IRQ_reg<=0;
                next_state<=state2;
            end
            else if(SR==8'b10000000)
            begin
                IRQ_reg<=1;
                next_state<=state3;
            end
            else if(SR==8'b00000000)
            begin
                IRQ_reg<=1;
                next_state<=state4;
            end
            else if(SR==8'b00000001)
            begin
                IRQ_reg<=0;
                next_state<=state5;
            end
            else//resetģʽ����
            begin
                next_state<=state6;
            end
        end
        state2://�ж�
        begin
            if(RW==1&&ADDR==1)
            begin
                BR<=Din;
                //SR<=8'b00000001;
               // next_state=state2;
                
            end
            else if(RW==1&&ADDR==0)
            begin
                SR<=Din;
                Dout_reg<=Din;
                next_state <=state5;
            end
        end
        state3://��ѯ
        begin
            if(RW==0&&ADDR==0)//��sr
            begin
                Dout_reg<=SR;
                //next_state=state3;
                //next_state <=state3;
            end
            else if(RW==1&&ADDR==1)//дbr
            begin
                BR<=Din;
                //next_state=state3;
                //next_state <=state3;
            end 
            else if(RW==1&&ADDR==0)//дsr
            begin
                SR<=Din;
                Dout_reg<=Din;
                next_state<=state4;
            end
        end
        state4://��ѯ������
        begin
            if(RDY)
            begin
                TR_reg<=1;
                PD_reg<=BR;
                SR<=8'b10000000;
                next_state<=state1;
            end
        end
        state5://�жϺ�����
        begin
            if(RDY)
            begin
                TR_reg<=1;
                PD_reg<=BR;
                SR<=8'b10000001;
                next_state<=state1;
            end
        end
        state6:
        begin
            SR<=Din;  
            next_state<=state1;            
        end
        default:
            next_state<=state6;
    endcase     
end

assign IRQ = IRQ_reg;
assign TR = TR_reg;
assign PD = PD_reg;
assign Dout = Dout_reg;


endmodule








