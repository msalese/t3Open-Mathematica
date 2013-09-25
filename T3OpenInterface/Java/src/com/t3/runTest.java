package com.t3;

import java.io.IOException;

import com.t3.t3Open;

public class runTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		t3Open my = new t3Open("192.168.0.78",5333,200,200);
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
		
		System.out.println("set command ");
		my.setRequest("function=subscribe|item=MI.DER.808916|schema=last_price");
		//my.setRequest("function=subscribe|item=MI.EQCON.1|schema=last_price");
		System.out.println(my.getRequest());
		
		System.out.println("subscribe ");
		my.subscribeData();
		
		System.out.println("read response");
		System.out.println(my.getResponse());
		
		try{
			System.out.println(my.getRefBufReader().ready());
		}
		catch (IOException e) {
			System.out.println("error");

	    }
		
		System.out.println("read pooled data");
		System.out.println(my.getPushedData());
		
		System.out.println(my.getConenctionStatus());
		System.out.println(my.getCloseStatus());
		
		if(my.getPushedData()==null){
			my.subscribeData();
		}
		
		my.closeConnection();
		
		System.out.println(my.getConenctionStatus());
		System.out.println(my.getCloseStatus());	
		
		
	}

		


	}

