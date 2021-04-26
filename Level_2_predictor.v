module level_2_predictor(clk,PC,effective_address);

input clk;                      //Clock signal
input [4:0] PC;                 //PC given by the processor
input [4:0] effective_address;  //Calculated effective address to check whether the predicted outcome is correct or not

parameter SNT=0;                
parameter WNT=1;
parameter WT=2;
parameter ST=3;

reg History_bit;               //1 bit History table
reg [1:0] counter0;            //1st predictor--- a 2 bit counter
reg [1:0] counter1;            //2nd predictor--- a 2 bit counter
reg [2:0] BTB_tag [0:3];       //Tags stored in Branch History Buffer
reg [4:0] BTB_addr [0:3];      //Target Address stored in Branch History Buffer
//reg [1:0] Global_BHR;
 
reg [1:0] index;               //to index into the BTB and BHT--- some bits of PC provides the index
reg [2:0] tag;                 //Apart from the index, the rest of the bits of the PC is the tag
reg hit;                       //If tag matches with that of the BTB
reg [4:0] right;               //Counter to count the no. of times the predictions made are correct

reg [4:0] predicted_next_PC;   //next PC predicted by the Branch predictor
//reg [4:0] actual_next_PC;


initial
begin
    counter0=SNT; counter1=SNT; History_bit=0; right=0;
    BTB_addr[0]=5'b01001; BTB_tag[0]=3'b011;             //initially some values are stored in the BTB
end

always@(posedge clk && PC)
begin
    index=PC[1:0];                                  //get the index from the last 2 bits oF PC
    tag=PC[4:2];                                    //get the tag from the rest of the bits of the PC
    if(BTB_tag[index]==tag)                         
    begin
      hit=1;                                        //if tag is matched, the it's a BTB "hit"
      if(History_bit==0)                            //If Histor_bit=0, choose counter0; otherwise choose counter1
      begin
          if(counter0==SNT)                          //If the predictor is in the SNT state 
          begin
              predicted_next_PC=PC+4;                //prediction--- branch won't be taken
              if(predicted_next_PC==effective_address)   //if prediction is correct
              begin
                counter0<=SNT;                           //remain in SNT state
                right<=right+1;                          //it's a correct prediction
                History_bit<=0;                          //Since, the actual outcome is "Not Taken", History_bit=0
              end  
              else
              begin
                counter0<=WNT;                           //if preiction is wrong, then go to the WNT state
                History_bit<=1;                          //If the actual outcome is "Taken", History_bit=1
              end   
          end
          else if(counter0==WNT)                        //If the predictor is in the WNT state
          begin
              predicted_next_PC=PC+4;                   //prediction--- branch won't be taken
              if(predicted_next_PC==effective_address)  //if prediction is correct
              begin
                counter0<=SNT;                          //go back to the SNT state
                right<=right+1;                         //it's a correct prediction
                 History_bit<=0;                        //Since, the actual outcome is "Not Taken", History_bit=0
              end
              else
              begin
                counter0<=WT;                           //if preiction is wrong, then go to the WT state
                 History_bit<=1;                        //If the actual outcome is "Taken", History_bit=1
              end   
          end
          else if(counter0==WT)                         //If the predictor is in the WT state
          begin
              predicted_next_PC=BTB_addr[index];        //prediction----branch will be taken
              if(predicted_next_PC==effective_address)  //if prediction is correct
              begin
                counter0<=ST;                           //go to ST state
                right<=right+1;                         //it's a correct prediction
                History_bit<=1;                         //Since, the actual outcome is "Taken", History_bit=1
              end
              else
              begin
                counter0<=WNT;                          //if preiction is wrong, then go to the WNT state
                 History_bit<=0;                        //If the actual outcome is "Not Taken", History_bit=0
              end   
          end
          else if(counter0==ST)                         //If the predictor is in the ST state 
          begin
              predicted_next_PC=BTB_addr[index];        //prediction----branch will be taken
              if(predicted_next_PC==effective_address)  //if prediction is correct
              begin
                counter0<=ST;                           //remain in the ST state
                right<=right+1;                         //it's a correct prediction
                History_bit<=1;                         //Since, the actual outcome is "Taken", History_bit=1
              end  
              else
              begin
                counter0<=WT;                           //if preiction is wrong, then go to the WT state
                History_bit<=0;                         //If the actual outcome is "Not Taken", History_bit=0
              end   
          end
      end
      else                       //If History_bit=1, choose counter1 and follow the same logic as that of counter0
      begin
          if(counter1==SNT)
           begin
              predicted_next_PC=PC+4;
              if(predicted_next_PC==effective_address)
              begin
                counter1<=SNT;
                right<=right+1;
                History_bit<=0;
              end  
              else
              begin
                counter1<=WNT; 
                History_bit<=1;
              end   
          end
          else if(counter1==WNT)
          begin
              predicted_next_PC=PC+4;
              if(predicted_next_PC==effective_address)
              begin
                counter1<=SNT;
                right<=right+1;
                History_bit<=0;
              end  
              else
              begin
                counter1<=WT; 
                History_bit<=1;
              end   
          end
          else if(counter1==WT)
          begin
              predicted_next_PC=BTB_addr[index];
              if(predicted_next_PC==effective_address)
              begin
                counter1<=ST;
                right<=right+1;
                History_bit<=1;
              end  
              else
              begin
                counter1<=WNT; 
                History_bit<=0; 
              end  
          end
          else if(counter1==ST)
          begin
              predicted_next_PC=BTB_addr[index];
              if(predicted_next_PC==effective_address)
              begin
                counter1<=ST;
                right<=right+1;
                History_bit<=1;
              end  
              else
              begin
                counter1<=WT;  
                History_bit<=0;
              end  
          end
      end
    end
    else
    begin
      hit=0;                                       //If the tag doesn't match with those present in the BTB
      predicted_next_PC=PC+4;                      //predicted target address = PC+4
        if(predicted_next_PC==effective_address)   //If actual address matches with that of the predicted address
         right<=right+1;                           
      else
      begin                                        //If actual address doesn't match with that of the predicted address
          BTB_tag[index]<=tag;                     //Store the tag from the current PC in the BTB
          BTB_addr[index]<=effective_address;      //Store the actual target address corresponding to the tag 
      end 
    end  
end

endmodule