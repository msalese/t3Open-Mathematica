package com.t3;

import java.io.IOException;
import java.lang.Thread;

import com.t3.t3OpenT;

public class runTestT {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
	
		t3OpenT jobBid = new t3OpenT("192.168.0.78",5333,500000,200);
		jobBid.openConnection();
		jobBid.setRequest("function=subscribe|item=MI.EQCON.1|schema=best_bid1");
		jobBid.subscribeData();
		
		t3OpenT jobBidSiz = new t3OpenT("192.168.0.78",5333,500000,200);
		jobBidSiz.openConnection();
		jobBidSiz.setRequest("function=subscribe|item=MI.EQCON.1|schema=best_bsiz1");
		jobBidSiz.subscribeData();
		
				
		System.out.println("now start the new thread");
		Thread ntJobBid = new Thread(jobBid);
		ntJobBid.setDaemon(true);
		ntJobBid.setName("BID");
		ntJobBid.start();
		
		System.out.println("now start the new thread");
		Thread ntjobBidSiz = new Thread(jobBidSiz);
		ntjobBidSiz.setDaemon(true);
		ntjobBidSiz.setName("BIDSIZE");
		ntjobBidSiz.start();
		
		Integer counter = 0;
		while(true){
			try{
				Thread.sleep(5000);
				if(jobBid.gotData==true || jobBidSiz.gotData==true){
					System.out.println("read pooled data");
					System.out.println(jobBid.getPushedData());
					System.out.println(jobBidSiz.getPushedData());
					jobBid.gotData = false;	
					jobBidSiz.gotData = false;
					counter = counter + 1;
					System.out.println(Integer.toString(counter));
				}
				else{
					System.out.println("no data ");
				}
				
				if (counter == 5){
					jobBid.unsubscribe();
					jobBidSiz.unsubscribe();
					
					try{
 						ntJobBid.sleep(10000);
						ntjobBidSiz.sleep(10000);
						ntJobBid.interrupt();
						ntjobBidSiz.interrupt();
					}
					catch(InterruptedException ex){}
					
				}
					
					
			}
			catch(InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
		}
		
		
		
		
	}

		


	}

