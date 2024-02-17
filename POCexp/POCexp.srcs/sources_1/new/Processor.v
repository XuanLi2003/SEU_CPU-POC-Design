`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/08 20:17:05
// Design Name: 
// Module Name: Processor
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


module Processor(
    output ADDR,//����SR����BR��1��BR
    input [7:0]Dout,
    output [7:0]Din,
    output RW,//���ƶ�д��1��cpu����д
    input clk,
    input IRQ,//IRQΪ0�����ж�����
    input reset,
    input modset,
    input [7:0]data

    );


reg ADDR_reg;
reg RW_reg;
reg [7:0]Din_reg;
reg handle=0;//�����б�cpu�Ƿ�д��br
//reg check=0;//�б��ѯģʽ�Ƿ���
//reg [7:0]data=8'b10100101;
reg [1:0]change_flag=2'b00;//ģʽ�л�ʱ�չ�1slot


always @(negedge reset or posedge clk)
begin
    if(!reset)
    begin
        change_flag<=2'b01;
        if(modset)//����жϿ���
        begin
            ADDR_reg<=0;//дsr
            RW_reg<=1;
            Din_reg<=8'b10000001;
            handle<=0;
        end
        else
        begin//��ѯģʽ����
            ADDR_reg<=0;//дsr
            RW_reg<=1;
            Din_reg<=8'b10000000;
            handle<=0;
        end
    end
    else
//    begin
    
//    end
//end
//        //reset����mod����ΪĬ��
//always @(posedge clk)
    begin
        if(change_flag==2'b01)
        begin
        //����ʱ϶
            change_flag<=2'b00;
        end
        else if(change_flag==2'b00)
        begin
            if(!IRQ)//�ж�����
            begin
                if(handle==0)
                begin
                    ADDR_reg<=1;
                    RW_reg<=1;
                    Din_reg<=data;//д��data
                    handle<=1;
                end
                else
                begin
                    ADDR_reg<=0;
                    RW_reg<=1;
                    Din_reg<=8'b00000001;//SR0=1,SR7=0;
                    handle<=0;//sr�������
                end
            end
            /*
            else if(RW&&Dout==8'b00000001)//û׼����
            begin
                RW_reg=0;
            end
            */   
            else if(IRQ)//��ѯ
            begin
                if(Dout==8'b10000000)
                //��ѯsr7
                begin
                    if(handle==0)
                    begin
                        RW_reg <= 1;
                        ADDR_reg <= 1;
                        Din_reg<=data;
                        handle<=1;
                    end
                    else
                    begin//��sr7=0
                        RW_reg <=1;
                        ADDR_reg <=0;
                        Din_reg<=8'b00000000;
                        handle<=0;
                    end
                end
                else
                begin//���ֶ�ȡ̬��ѯ
                    RW_reg<=0;
                    ADDR_reg<=0;
                end
            end
            else
            begin
                //�չ�
            end
        end
    end
end
    
assign ADDR = ADDR_reg;
assign RW = RW_reg;
assign Din = Din_reg;


endmodule
