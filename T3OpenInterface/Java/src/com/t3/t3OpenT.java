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
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class t3OpenT implements Runnable{
	
	private String ipAddress;
	private Integer	portNumber;
	private Socket refSocket;
	private Integer socketTimeOut;
	private PrintWriter refOutStream;
	private InputStreamReader refInputStreamReader;
	private BufferedReader refBufReader;
	private Boolean connectionStatus;
	private Integer waitBeforeRead;
	private String pushedData;
	private String response;
	private String request;
	private Thread refThread;
	private Boolean thExtSignal;
	private String info[];
	private DateFormat dateFormat;
    private Calendar cal ;
    private String dateTimeSample; 


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
		this.socketTimeOut = socketTimeOut;
		this.refOutStream = null;
		this.refInputStreamReader = null;
		this.refBufReader = null;
		this.connectionStatus = null;
		this.waitBeforeRead =  waitBeforeRead;
		this.pushedData = null;
		this.response = null;
		this.request = null;
		this.refThread = null;
		this.thExtSignal = null;
		this.info = new String[6];
		this.dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		this.cal = Calendar.getInstance();
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
	public Boolean getThExtSignal() {
		return thExtSignal;
	}
	
	
	/**
	 * @param closeStatus the closeStatus to set
	 */
	public void setThExtSignal(Boolean thExtSignal) {
		this.thExtSignal = thExtSignal;
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
		this.refSocket.close();
		this.connectionStatus = this.refSocket.isConnected();
	}
	catch(IOException e){
		 //System.err.println("Couldn't get I/O for the connection.");
	}
	
	}
	
	
	
	/**
	 * @return the refThread
	 */
	public Thread getRefThread() {
		return refThread;
	}



	/**
	 * @param refThread the refThread to set
	 */
	public void setRefThread(Thread refThread) {
		this.refThread = refThread;
	}

    

	/**
	 * @return the info
	 */
	public String[] getInfo() {
		return info;
	}



	/**
	 * @return the dateTime
	 */
	public String getDateTimeSample() {
		return dateTimeSample;
	}



	@Override
	public void run(){
		
		thExtSignal = false;
		refThread = Thread.currentThread();
		
		try{

			while (true){
				
				try{
					//controlla se il thread deve essere terminato
					if(thExtSignal == true){
						//interrompi
						Thread.currentThread().interrupt();
					}
					//se interrotto raise exception
					if(Thread.interrupted()){
						 throw new InterruptedException();
				
					}
								
					
					//if ready red the second response and put it in pushedData field
					this.pushedData = this.refBufReader.readLine();
					dateTimeSample = dateFormat.format(cal.getTime()).toString();
					String responseBidAsk[] = pushedData.split("\\|", 6);
					for(int i=0 ; i<=responseBidAsk.length-1;i++){
						if(responseBidAsk[i].length()>0){
							info[i]=responseBidAsk[i];
						}else{
							info[i]=info[i];
						}
					}
				
				}catch (InterruptedException e) {
			        // We've been interrupted: no more messages.
			        this.unsubscribe();
			        return;
			        
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
