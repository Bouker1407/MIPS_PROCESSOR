`timescale 1ns / 1ps


module Data_mem_tb();
reg clk;
reg rst_n;
reg MemWrite;
reg MemRead;
reg [31:0] dmem_address;
reg [31:0] write_data_mem;
wire [31:0] read_data;

Data_Mem dmem(.*);

typedef struct{
    bit[31:0] data;
    bit[31:0] addr;
} packet;

mailbox #(packet) sti2dr_mb = new();
mailbox #(packet) sti2com_mb = new();
mailbox #(packet) mon2com_mb = new();


initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial begin
    rst_n = 0;
    #100;
    rst_n = 1;
end

initial begin
    wait (rst_n === 1);
    fork
        stimulus();
        drive();
        monitor();
        compare();
    join_any
    
    #4000
    disable fork;
    $finish;
end

task stimulus();
    packet pkt_sti;
    for (int i = 0; i < 5; i++) begin
        std::randomize(pkt_sti.data, pkt_sti.addr) with {pkt_sti.addr inside {[0:2047]};};
        sti2dr_mb.put(pkt_sti);
        sti2com_mb.put(pkt_sti);
        $display("# %0t: [stimulus] Sent packet to driver and scoreboard", $time);
    end
endtask

task drive();
    packet pkt_drv;
//    MemWrite = 0;
//    MemRead = 0;
//    dmem_address = 0;
//    write_data_mem = 0;
    while(1) begin
        $display("# %0t: [drive] Get packet from stimulus", $time);
        sti2dr_mb.get(pkt_drv);
        @(posedge clk)
        $display("# %0t: [drive] Write transaction, drive write address 32'h%0h, write data 32'h%0h", $time, pkt_drv.addr, pkt_drv.data);
        //#1;
        dmem_address = pkt_drv.addr;
        write_data_mem = pkt_drv.data;
        MemWrite = 1;
        @(posedge clk)
        //#1;
        MemWrite = 0;
        write_data_mem = 0;
        @(posedge clk)
        $display("# %0t: [drive] Read transaction, Drive read address 32'h%0h", $time, pkt_drv.addr);
        //#1;
        MemRead = 1;
        @(posedge clk)
        //#1;
        MemRead = 0;
        dmem_address = 0;
    end

endtask

task monitor();
    packet pkt_mon;
    while(1) begin
        @(posedge MemRead);
        $display("# %0t: [monitor] Capture activity and send to mailbox", $time);
        #1
        pkt_mon.data = read_data;
        pkt_mon.addr = dmem_address;
        mon2com_mb.put(pkt_mon);
    end
endtask

task compare();
    packet exp_pkt, act_pkt;
    while (1) begin 
        @(negedge MemRead)
        $display("# %0t: [compare] Get actual packet", $time);     
        mon2com_mb.get(act_pkt);  
        $display("# %0t: [compare] Get expected packet", $time);
        sti2com_mb.get(exp_pkt);
        if(exp_pkt.data == act_pkt.data)
            $display("# %0t: [compare] Data write and read value matching 32'h%0h", $time, exp_pkt.data);
        else
            $display("# %0t: [compare] Data read and write mismatched, expected is 32'h%0h and actual is 32'h%0h", $time, exp_pkt.data, act_pkt.data);
    end
endtask



endmodule
