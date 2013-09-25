/**
 * 
 */
package com.t3;

/**
 * @author msalese
 *
 */

import java.net.*;
import java.io.*;

public class t3Open {
	
	private String ipAddress;
	private Integer	portNumber;
	private Socket refSocket;
	private Integer socketTimeOut;
	private PrintWriter refOutStream;
	private InputStreamReader refImputStreamReader;
	private BufferedReader refBufReader;
	private Boolean closeStatus;
	private Boolean connectionStatus;
	private Integer waitBeforeRead;
	private String pushedData;
	private String response;
	private String request;
	
	


	/**
	 * @param ipAddress
	 * @param portNumber
	 * @param socketTimeOut
	 */
	public t3Open(String ipAddress,Integer portNumber,Integer socketTimeOut, Integer waitBeforeRead) {
		super();
		this.ipAddress = ipAddress;
		this.portNumber = portNumber;
		this.socketTimeOut = socketTimeOut;
		this.refBufReader = null;
		this.refOutStream = null;
		this.refImputStreamReader = null;
		this.refSocket = null;
		this.closeStatus = null;
		this.connectionStatus = null;
		this.waitBeforeRead =  waitBeforeRead;
		this.pushedData = null;
		this.response = null;
		this.request = null;
	}
	
	
	
	/**
	 * @return the closeStatus
	 */
	public Boolean getCloseStatus() {
		return closeStatus;
	}



	/**
	 * @return the conenctionStatus
	 */
	public Boolean getConenctionStatus() {
		return connectionStatus;
	}
	
	/**
	 * @return the request
	 */
	public String getRequest() {
		return request;
	}

	/**
	 * @param request the request to set
	 */
	public void setRequest(String request) {
		this.request = request;
	}

	/**
	 * @return the response
	 */
	public String getResponse() {
		return response;
	}
	
	/**
	 * @param ipAddress the ipAddress to set
	 */
	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}

	/**
	 * @param portNumber the portNumber to set
	 */
	public void setPortNumber(Integer portNumber) {
		this.portNumber = portNumber;
	}

	/**
	 * @param socketTimeOut the socketTimeOut to set
	 */
	public void setSocketTimeOut(Integer socketTimeOut) {
		this.socketTimeOut = socketTimeOut;
	}

	
	/**
	 * @return the refBufReader
	 */
	public BufferedReader getRefBufReader() {
		return refBufReader;
	}

	
	/**
	 * @return the pooledData
	 */
	public String getPushedData() {
		return pushedData;
	}

	
	public String getIpAddress(){
		 return this.ipAddress;
	}
	
	public Integer getPortNumber(){
		return this.portNumber;
	}
	
	public Socket getRefSocket(){
		return this.refSocket;
	}
	
	public Integer getSocketTimeOut(){
		return this.socketTimeOut;
	}
	

	public PrintWriter getRefOutStream(){
		return this.refOutStream;
	}
	
	
	
	public void subscribeData(){
	
	//send request	
	refOutStream.println(this.request);	
	
	//read response
	try{
		this.response = this.refBufReader.readLine();
		try { 
			Thread.sleep(this.waitBeforeRead); 
			} catch(InterruptedException e) { 
			} 
		while (this.refBufReader.ready()){
			this.pushedData = this.refBufReader.readLine();
			}
		
		if(this.pushedData == null){
			this.pushedData = Integer.toString(0);
		}
		
	//after response unsubscribe	
	this.unsubscribe();	
	
	}	
	catch(SocketTimeoutException e){
		this.response = "timeOut";
	}
	catch (IOException e) {
		this.pushedData = "error";

    }
		
	}
	
	public void unsubscribe(){
		this.refOutStream.println("function=unsubscribe");
	}
	
	
	public void openConnection(){
		
	try{
		
		this.refSocket = new Socket(this.ipAddress,this.portNumber);
		//Socket mySocket = new Socket(this.ipAddress,this.portNumber);
				
		this.refSocket.setSoTimeout(this.socketTimeOut);  
		this.closeStatus = this.refSocket.isClosed();
		this.connectionStatus = this.refSocket.isConnected();
	
		this.refOutStream = new PrintWriter(this.refSocket.getOutputStream(),true);
		//PrintWriter myOutStream = new PrintWriter(mySocket.getOutputStream(),true);
		//this.setRefOutStream(myOutStream);
		
		this.refImputStreamReader = new InputStreamReader(this.refSocket.getInputStream());
		//InputStreamReader myInputStreamReader = new InputStreamReader(mySocket.getInputStream());
		
		this.refBufReader = new  BufferedReader(this.refImputStreamReader);
		//BufferedReader myBufferedInputStreamReader = new BufferedReader(myInputStreamReader);
		//this.setRefBufReader(myBufferedInputStreamReader);
		
				
		
	}
	catch(UnknownHostException e) {
        System.err.println("Don't know about host.");
    }
	catch (IOException e) {
        System.err.println("Couldn't get I/O for the connection.");
    }

	}
	
	public void closeConnection(){
	try{
		this.connectionStatus = this.refSocket.isConnected();
		this.closeStatus = this.refSocket.isClosed();
		this.refSocket.close();
		this.connectionStatus = this.refSocket.isConnected();
		this.closeStatus = this.refSocket.isClosed();
	}
	catch(IOException e){
		 System.err.println("Couldn't get I/O for the connection.");
	}
	
	}
	
		

}
