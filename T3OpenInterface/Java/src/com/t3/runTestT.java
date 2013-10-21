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
		//questo codice verra eseguito da mathematica
		//
		
		//prepariamo oggetto che monitorizza generali
		t3OpenT job01 = new t3OpenT("192.168.0.78",5333,500000,200);
		job01.openConnection();
		job01.setRequest("function=subscribe|item=MI.EQCON.1|schema=best_bsiz1;best_bid1;best_ask1;best_asiz1;symbol");
		job01.subscribeData();
		System.out.println(job01.getResponse());
		
		//prepariamo oggetto che monitorizza terna
		t3OpenT job02 = new t3OpenT("192.168.0.78",5333,500000,200);
		job02.openConnection();
		job02.setRequest("function=subscribe|item=MI.EQCON.81658|schema=best_bsiz1;best_bid1;best_ask1;best_asiz1;symbol");
		job02.subscribeData();
		System.out.println(job02.getResponse());
		
		//start del Thread che segue generali		
		System.out.println("now start the thread 01");
		Thread ntJob01 = new Thread(job01);
		ntJob01.setDaemon(true);
		ntJob01.setName("GENERALI");
		ntJob01.start();
		
		//start del Thread che segue terna
		System.out.println("now start the thread 02");
		Thread ntJob02 = new Thread(job02);
		ntJob02.setDaemon(true);
		ntJob02.setName("TERNA");
		ntJob02.start();
		
		Integer counter = 0;
		while(true){
			try{
				
				Thread.sleep(1000);
				System.out.println(Integer.toString(counter)+ " " +"reading pooled data");
				//System.out.println(job01.getPushedData());
				//System.out.println(job02.getPushedData());
				System.out.print("Time"+"                   "+"Code"+"        "+"QtBid"+" "+"Bid"+"   "+"Ask"+ "   "+"QtAsk"+" "+"Symbol");
				System.out.println();
				System.out.print(job01.getDateTimeSample()+"    "+ job01.getInfo()[0]+"  "+job01.getInfo()[1]+" "+job01.getInfo()[2]+" "+job01.getInfo()[3]+" "+job01.getInfo()[4]+"   "+job01.getInfo()[5]);
				System.out.println();
				System.out.println();
				
				System.out.print("Time"+"                   "+"Code"+"        "+"QtBid"+" "+"Bid"+"   "+"Ask"+ "   "+"QtAsk"+" "+"Symbol");
				System.out.println();
				System.out.print(job02.getDateTimeSample()+"    "+job02.getInfo()[0]+"  "+job02.getInfo()[1]+" "+job02.getInfo()[2]+" "+job02.getInfo()[3]+" "+job02.getInfo()[4]+"   "+job02.getInfo()[5]);
				System.out.println();
				System.out.println();
				
				counter = counter + 1;
						
				if (counter == 100){
					//set variabile che notifica interruzione dei thread di streaming data				
					job01.setThExtSignal(true);
				}
				
				if (counter == 110){
					job02.setThExtSignal(true);
				}
				
				System.out.println(job01.getRefThread().getName() + " " + job01.getRefThread().getState());
				System.out.println(job02.getRefThread().getName() + " " + job02.getRefThread().getState());
				System.out.println();

				if(job01.getRefThread().getState().toString()== "TERMINATED" && job02.getRefThread().getState().toString()== "TERMINATED"){
					System.exit(0);
					
				}
				
				//temporizzatore per il main thread
				Thread.sleep(60*1000);
				
			}	
			catch(InterruptedException e) {
				// TODO Auto-generated catch block
				System.out.println("Interrupted MAIN ");
				return;
				
			} 
		}
		
		
		
		
	}

		


	}

