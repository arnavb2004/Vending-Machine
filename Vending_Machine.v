`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2024 17:02:18
// Design Name: 
// Module Name: Vending_Machine
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


module Vending_Machine(
    input clk,
    input reset,
    input quarter,
    input dollar,
    input [3:0] select, //to slect item from the stock, 4 different item trays
                        //one tray for each product,having 15 units 
    input buy,          //to buy product
    input [3:0] load,       //to load out of stock product
    output reg [11:0] money = 0,    //money that will be withdrawn from the machine(change)
    output reg[3:0] products = 0,  //product being dispensed: ([1] 25 Cents for gum, [2] 75 cents for chocolates,
                            //[3] 150 ($1.5) for bag of chips, [4] 200 cents ($2) for a drink)
    output reg [3:0] out_of_stock = 0   //initially vending machine is full
    );
    
    reg quarter_prev, dollar_prev; //to remember the money inserted 
    reg buy_prev;   
    
    //Full stock initailly, 15 items each
    reg [3:0] stock0 = 4'b1111; //Gum(0),   25 cents
    reg [3:0] stock1 = 4'b1111; //Chocolate(1), 75 cents
    reg [3:0] stock2 = 4'b1111; //Chips(2), $1.5
    reg [3:0] stock3 = 4'b1111; //Drink(3), $2
    
    
    
    always@(posedge clk)
    begin
    quarter_prev<=quarter;
    dollar_prev<=dollar;
    buy_prev<=buy; //product is dispensed only when buy button is pressed
    
    if(reset==1)    //to display set to zero, money is reseted
        money<=1'b0;
    
    else if(quarter_prev==1'b0 && quarter==1'b1) //If quartr is inserted(nothing inserted before)
        money<=money+12'd25;    //25 cents inserted
    
    else if(dollar_prev==1'b0 && dollar==1'b1) //If dollar is inserted
        money<=money+12'd100;    //100 cents inserted
    
    else if( buy_prev==1'b0 && buy==1'b1) //after adding money, buying of product, then it occurs as follows
    
    //product to be dispensed, money change to be reurned, and changing the stock
    
    case(select)
    
    //buying a gum
    4'b0001:
    if (money>=12'd25 && stock0>0) //enough money inseted and stock available
    begin
        products[0] <=1'b1; //product getting dispensed
        stock0 <=stock0-1'b1; //reduce the stock
        money<=money-12'd25;  //machine withdraws price of the product from total money
    end
       
    //buying a chocolate
    4'b0010:
    if (money>=12'd75 && stock1>0) //enough money inseted and stock available
    begin
        products[1] <=1'b1; //product getting dispensed
        stock1 <=stock1-1'b1; //reduce the stock
        money<=money-12'd75;  //machine withdraws price of the product from total money
    end
    
    //buying chips
    4'b0100:
    if (money>=12'd150 && stock2>0) //enough money inseted and stock available
    begin
        products[2] <= 1'b1; //product getting dispensed
        stock2 <= stock2-1'b1; //reduce the stock
        money <= money-12'd150;  //machine withdraws price of the product from total money
    end
         
    //buying a drink
    4'b1000:
    if (money>=12'd200 && stock3>0) //enough money inseted and stock available
    begin
        products[3] <=1'b1; //product getting dispensed
        stock3 <=stock3-1'b1; //reduce the stock
        money<=money-12'd200;  //machine withdraws price of the product from total money
    end
    
    endcase
    
    else if (buy_prev==1'b1 && buy==1'b0) //if buy button not pressed, no product dispensed
    begin
    products [0] <= 1'b0;
    products [1] <= 1'b0;
    products [2] <= 1'b0;
    products [3] <= 1'b0;
    end
    
    //items in [3:0] stock run out, [3:0] out of stock led goes high
    else begin
    if (stock0==4'b0000)
    out_of_stock[0] <= 1'b1;
    else out_of_stock[0] <= 1'b0;
    
    if (stock1==4'b0000)
    out_of_stock[1] <= 1'b1;
    else out_of_stock[1] <= 1'b0;
    
    if (stock2==4'b0000)
    out_of_stock[2] <= 1'b1;
    else out_of_stock[2] <= 1'b0;
    
    if (stock3==4'b0000)
    out_of_stock[3] <= 1'b1;
    else out_of_stock[3] <= 1'b0;
    
    //if product 0 is being stocked, refilling the items, its stoc changes to 15
    
    case(load)
    4'b0001: stock0 <=4'b1111;
    4'b0010: stock1 <=4'b1111;
    4'b0100: stock2 <=4'b1111;
    4'b1000: stock3 <=4'b1111;
    endcase
    end
    end
      
endmodule
