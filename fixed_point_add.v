`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2024 16:38:13
// Design Name: 
// Module Name: fixed_point_add
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
// Code your testbench here
// or browse Examples
// Code your design here
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2024 16:38:13
// Design Name: 
// Module Name: fixed_point_add
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
module tb;

    
  reg [7:0] a;
        
  reg [5:0] b;
        
        reg sign;
        
  wire [6:0] result;
        
        wire overflow;
        
        wire underflow;
        
        fixed_point_add #(4,4,3,3,3,4) uut(a,sign,b,result,overflow,underflow);
        
      /*  initial begin
            clk=0;
            
            forever #5 clk=~clk;
        
        end */
        
        initial begin
        
        repeat(30)
                begin
            
            #5;
                begin
                    a<=$random;
                    b<=$random;
                    sign<=0;
                 end
                end
            #5 
                a<=16'b1;
                b<=16'b1;
                sign<=0;    
                
            #5 
                a<=16'hfffa;
                b<=16'hfffa;
                sign<=0;     
                
              #100;
                $finish;  
         end   
  
  
  /*initial begin
    
    $dumpfile("a.vcd");
    $dumpvars;
    
  end */
        
        




endmodule









module fixed_point_add#(parameter i_p1=2,f_p1=12,i_p2=2,f_p2=12,res_i_p=2,res_f_p=12)(
    input [i_p1+f_p1-1:0] a,
    input sign,
    input [i_p2+f_p2-1:0] b,
    output reg [res_i_p+res_f_p-1:0] result, 
    output reg overflow,
    output  reg  underflow
    );
    
//storing signed values for signed artithemic additon    
    reg signed  [i_p1+f_p1-1:0] temp_a;
    
    reg signed [i_p1+f_p1-1:0] temp_b; 
    
    //storing unsigned values for unsigned arithemetic
    
       reg   [i_p1+f_p1-1:0] temp_a_us;
    
    reg  [i_p1+f_p1-1:0] temp_b_us; 
    
//result of signed operation
    
    reg signed [i_p1+f_p1:0] res;

//result of unsigned operation
        reg  [i_p1+f_p1:0] res_unsigned;
        
        //temporary register for storing acutal result'
       
       reg [res_i_p+res_f_p-1:0] resultt;
       



    always@(*)
        begin
            temp_a=a;
            temp_a_us=a;
            
            case(sign)
                1'b0:begin
                    temp_b_us=0;
                    temp_b_us=b<<(f_p1-f_p2);
                    end
                1'b1:begin
                    if(f_p1!=f_p2)
                        begin
                      temp_b[f_p1-(f_p2+1):0]={(f_p1-f_p2){1'b0}};
                      temp_b[f_p1-1:(f_p1-f_p2)]=b[f_p2-1:0];
                      temp_b[(f_p1+i_p2-1):f_p1]=b[i_p2+f_p2-1:f_p2];
                      temp_b[f_p1+i_p1-1:(f_p1+i_p1-1)-(i_p1-i_p2-1)]={(i_p1-i_p2){b[i_p2+f_p2-1]}};
                      end
                   else
                       begin
                       temp_b=b;
                       
                       end
                        
                     end   
            endcase               
        end 
        
   always@(*)
    begin
        if(sign)
                res = temp_a+temp_b;
        else
                res_unsigned=temp_a_us+temp_b_us;        
    end 


    always@(*)
        begin
        
        
        case(sign)
           1'b0:begin
        
             resultt[res_i_p+res_f_p-1:res_f_p]=res_unsigned[i_p1+f_p1:f_p1];
             if(res_f_p > f_p1)
                begin
                    resultt[res_f_p-1:0]={res_unsigned[f_p1-1:0],{res_f_p-f_p1-1{1'b0}}};
                   
                end
             else if(res_f_p < f_p1)
                begin
                    resultt[res_f_p-1:0]=res_unsigned[f_p1-1:res_f_p];
                    
                end
            else
                begin
                    resultt[res_f_p-1:0]=res_unsigned[f_p1-1:0];
                
                end    
                
             end
             
         1'b1:begin
         
                if(res_i_p>i_p1)
                    begin
                        resultt[res_f_p+i_p1-1:res_f_p]= res[i_p1+f_p1-1:f_p1];
                        
                        resultt[res_f_p+res_i_p-1:res_f_p+i_p1]={(res_i_p-i_p1){res[i_p1+f_p1]}};
                    
                    end
                else
                    begin
                     resultt[res_i_p+res_f_p-1:res_f_p]=res[i_p1+f_p1:f_p1];
                     
                    end    
         
                 if(res_f_p>f_p1)
                begin
                    resultt[res_f_p-1:0]={res[f_p1-1:0],{res_f_p-f_p1-1{1'b0}}};
                   
                end
            else if(res_f_p<f_p1)
                begin
                    resultt[res_f_p-1:0]=res[f_p1-1:(f_p1-res_f_p)];
                    
                end
            else
                begin
                    resultt[res_f_p-1:0]=res[f_p1-1:0];
                
                end    
                
             end
                
                
              
       endcase                
                
        end
        
        
        
        
        
        
        always@(*)
            begin
            
                case(sign)
                    1'b0:begin
                            if(res_i_p > i_p1)
                                   overflow=0;
                            else if(res_i_p<i_p1)
                                begin   
                                     overflow = |(res_unsigned[(i_p1+f_p1):(i_p1+f_p1)-(i_p1-res_i_p)]);
                                 end
                            else if(res_i_p == i_p1)
                                begin
                                    overflow=res_unsigned[(i_p1+f_p1)];
                                end
                            else
                                overflow=0;
                          end
                    1'b1:begin
                            if(res_i_p > i_p1)
                                   overflow=0;
                            else if((res[f_p1+i_p1-1] && ~temp_a[i_p1+f_p1-1] && ~temp_b[i_p1+f_p1-1]) |(~res[f_p1+i_p1-1] && temp_a[i_p1+f_p1-1] && temp_b[i_p1+f_p1-1]))
                                    overflow=1;
                            else
                                    overflow=0;         
                         end
                endcase
           end
    
    
    
        always@(*)
            begin
                case(sign)
                    1'b0:begin
                            if(res_f_p<f_p1)
                                begin
                                    underflow=(~|(res_unsigned[(f_p1+i_p1):(f_p1-res_f_p)])) &&(|res_unsigned[f_p1-res_f_p-1:0]);
                                end
                            else
                                begin
                                    underflow=0;
                                end        
                        end
                    1'b1:begin
                            if(res_f_p<f_p1)
                                begin
                                    if(res[f_p1+i_p1]==1'b1)
                                        begin
                                           underflow=(&(res[(f_p1+i_p1-1):(f_p1-res_f_p)])) && (~&res[f_p1-res_f_p-1:0]);
                                        end
                                    else if((res[f_p1+i_p1]==1'b0))
                                        begin
                                           underflow=(~|(res[(f_p1+i_p1-1):(f_p1-res_f_p)])) && (|res[f_p1-res_f_p-1:0]);
                                        end  
                                    else
                                        begin
                                            underflow=0;
                                        end              
                                
                                end
                            else
                                underflow=0;    
                         end
                    
                endcase
            
            
            end
            
            
            always@(*)
                begin
                    case(sign)
                        1'b0:begin
                                if(overflow==1'b1)
                                    result={(res_i_p+res_f_p){1'b1}};
                                else if(underflow==1)
                                     result={{(res_i_p+res_f_p-1){1'b0}},1'b1};
                                else
                                    result=resultt;    
                                    
                               end
                        1'b1:begin
                                if((overflow==1'b1) && (res[f_p1+i_p1-1] && ~temp_a[i_p1+f_p1-1] && ~temp_b[i_p1+f_p1-1]))
                                        result={1'b0,{(res_i_p+res_f_p-1){1'b1}}};
                               else if((overflow==1'b1) && (~res[f_p1+i_p1-1] && temp_a[i_p1+f_p1-1] && temp_b[i_p1+f_p1-1]))
                                        result={1'b1,{(res_i_p+res_f_p-1){1'b0}}};
                               else if(underflow==1'b1 &&  res[f_p1+i_p1]==1'b1)
                                        result={(res_i_p+res_f_p){1'b1}};
                               else if(underflow==1'b1 &&  res[f_p1+i_p1]==1'b0)
                                        result={{(res_i_p+res_f_p-1){1'b0}},1'b1};
                              else
                                        result=resultt;         
                                        
                             end 
                   endcase                   
                               
                
                end
                
            
            

    
    
endmodule





