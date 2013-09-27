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

public class t3OpenT implements Runnable{
	
	private String ipAddress;
	private Integer	portNumber;
	private Socket refSocket;
	private Integer socketTimeOut;
	private PrintWriter refOutStream;
	private InputStreamReader refInputStreamReader;
	private BufferedReader refBufReader;
	private Boolean closeStatus;
	private Boolean connectionStatus;
	private Integer waitBeforeRead;
	private String pushedData;
	public Boolean gotData;
	private String response;
	private String request;
	
	


	/**
	 * @param ipAddress
	 * @param portNumber
	 * @param socketTimeOut
	 */
	public t3OpenT(String ipAddress,Integer portNumber,Integer socketTimeOut, Integer waitBeforeRead) {
		super();
		this.ipAddress = ipAddress;
		this.portNumber = portNumber;
		this.refSocket = null;
		this.refOutStream = null;
		this.refInputStreamReader = null;
		this.refBufReader = null;
		this.socketTimeOut = socketTimeOut;
		this.closeStatus = null;
		this.connectionStatus = null;
		this.waitBeforeRead =  waitBeforeRead;
		this.pushedData = null;
		this.gotData = false;
		this.response = null;
		this.request = null;
	}
	
	
	 
	/**
	 * @return the gotData
	 */
	public Boolean getGotData() {
		return gotData;
	}



	/**
	 * @return the waitBeforeRead
	 */
	public Integer getWaitBeforeRead() {
		return waitBeforeRead;
	}


	/**
	 * @param waitBeforeRead the waitBeforeRead to set
	 */
	public void setWaitBeforeRead(Integer waitBeforeRead) {
		this.waitBeforeRead = waitBeforeRead;
	}

	/**
	 * @return the closeStatus
	 */
	public Boolean getCloseStatus() {
		return closeStatus;
	}


	/**
	 * @return the connectionStatus
	 */
	public Boolean getConnectionStatus() {
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
	
	
	try{
		//read first response
		this.response = this.refBufReader.readLine();
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
				
		this.refInputStreamReader = new InputStreamReader(this.refSocket.getInputStream());
				
		this.refBufReader = new  BufferedReader(this.refInputStreamReader);
						
		
	}
	catch(UnknownHostException e) {
        //System.err.println("Don't know about host.");
    }
	catch (IOException e) {
        //System.err.println("Couldn't get I/O for the connection.");
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
		 //System.err.println("Couldn't get I/O for the connection.");
	}
	
	}
	
	@Override
	public void run(){
		
		Thread chisono = Thread.currentThread();
		
		
		try{
			//check if bufferedReader is ready
			while (true){
				//sleep otherwise is too fast
				try {
					//System.out.println(chisono.getName());
					//System.out.println("check new data");
					
					Thread.sleep(this.waitBeforeRead);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} 
				//if ready red the second response and put it in pushedData field
				this.pushedData = this.refBufReader.readLine();
				gotData = true;
				//if second response is null set it to zero
				if(pushedData == null){
					pushedData = Integer.toString(0);
				}

				try{
					//System.out.println(chisono.getName());
					Thread.sleep(100);
				}
				catch(InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} 
			}
		}	
		catch(SocketTimeoutException e){
			response = "timeOut";
			//System.out.println("timeOut");
			unsubscribe();
		}
		catch (IOException e) {
			pushedData = "error";

	    }
			
		}
		

}
