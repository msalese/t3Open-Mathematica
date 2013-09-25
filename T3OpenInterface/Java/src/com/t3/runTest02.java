package com.t3;


import java.io.IOException;

import com.t3.t3Open;

public class runTest02 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		t3Open my = new t3Open("192.168.0.78",5333,1000,1000);
		System.out.println("created t3Open object");
		System.out.println(my.getIpAddress());
		System.out.println(my.getPortNumber());
		System.out.println(my.getSocketTimeOut());
		
		
		System.out.println("Now change socket time out");
		my.setSocketTimeOut(250);
		System.out.println("New socket time out:");
		System.out.println(my.getSocketTimeOut());
		
		System.out.println("now open connection");
		my.openConnection();
		
		System.out.println("send command ");
		my.setRequest("function=subscribe|item=MI.DER.808916|schema=last_price");
		System.out.println(my.getRequest());
		my.subscribeData();
		System.out.println(my.getResponse());
		System.out.println(my.getPushedData());
				
		System.out.println("send command ");
		my.setRequest("function=subscribe|item=MI.DER.808916|schema=best_bid1");
		System.out.println(my.getRequest());
		my.subscribeData();
		System.out.println(my.getResponse());
		System.out.println(my.getPushedData());
		
		System.out.println(my.getConenctionStatus());
		System.out.println(my.getCloseStatus());	
		
		my.closeConnection();
		
		System.out.println(my.getConenctionStatus());
		System.out.println(my.getCloseStatus());	
		
		
	}

		


	}

