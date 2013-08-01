package com.t3;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.UnknownHostException;

import com.t3.t3Open;

public class runTest {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		t3Open my = new t3Open("192.168.0.78",5333,250);
		System.out.println(my.getIpAddress());
		my.setPortNumber(5333);
		my.setSocketTimeOut(1000);
		
		my.openConnection();
		System.out.println(my.getPortNumber());
		System.out.println(my.getSocketTimeOut());
		
		PrintWriter pippo = my.getRefOutStream();
		//pippo.println("function=subscribe_portfolio|item=0059900001034466");
		pippo.println("function=subscribe|item=MI.EQCON.2552|schema=last_price");
		
		BufferedReader pluto = my.getRefBufReader();
		
		try{
			
			System.out.println(pluto.readLine());
			while(pluto.ready()){
			
				System.out.println(pluto.readLine());
			}
			
			
		}
		catch(UnknownHostException e) {
	        System.err.println("Don't know about host: taranis.");
	        System.exit(1);
	    }
		catch (IOException e) {
	        System.err.println("Couldn't get I/O for the connection to: taranis.");
	        System.exit(1);
	    }
	}

		


	}

