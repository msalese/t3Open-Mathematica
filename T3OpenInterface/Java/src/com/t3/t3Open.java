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
	private Integer	 portNumber;
	private Socket refSocket;
	private Integer socketTimeOut;
	private PrintWriter refOutStream;
	private BufferedReader refBufReader;
	private String poolingWhat;
	private String poolingWhatCode;
	private String poolingWhatSymbol;
	private String pooledData;
	
		
	/**
	 * @param ipAddress
	 * @param portNumber
	 * @param socketTimeOut
	 */
	public t3Open(String ipAddress,Integer portNumber,Integer socketTimeOut) {
		super();
		this.ipAddress = ipAddress;
		this.portNumber = portNumber;
		this.socketTimeOut = socketTimeOut;
		this.refBufReader = null;
		this.refOutStream = null;
		this.refSocket = null;
		this.poolingWhat = null;
		this.poolingWhatCode = null;
		this.poolingWhatSymbol = null;
		this.pooledData = null;
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
	 * @param refBufReader the refBufReader to set
	 */
	public void setRefBufReader(BufferedReader refBufReader) {
		this.refBufReader = refBufReader;
	}

	
	public String getPoolingWhat() {
		return poolingWhat;
	}

	public void setPoolingWhat(String poolingWhat) {
		this.poolingWhat = poolingWhat;
	}

	public String getPoolingWhatCode() {
		return poolingWhatCode;
	}
	
	
	/**
	 * @return the pooledData
	 */
	public String getPooledData() {
		return pooledData;
	}

	/**
	 * @param pooledData the pooledData to set
	 */
	private void setPooledData(String pooledData) {
		this.pooledData = pooledData;
	}

	public void setPoolingWhatCode(String pooligWhatCode) {
		this.poolingWhatCode = pooligWhatCode;
	}

	public String getPoolingWhatSymbol() {
		return poolingWhatSymbol;
	}

	public void setPoolingWhatSymbol(String poolingWhatSymbol) {
		this.poolingWhatSymbol = poolingWhatSymbol;
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
	
	public void setRefSocket(Socket mySocket){
		this.refSocket = mySocket;
	}
	
	public PrintWriter getRefOutStream(){
		return this.refOutStream;
	}
	
	public void setRefOutStream(PrintWriter myOutStream){
		this.refOutStream = myOutStream;
	}
	
	
	public void getSubscribedData(){

	try{	
		this.pooledData = refBufReader.readLine();
	}
	catch(SocketTimeoutException e){
		this.pooledData = this.pooledData;	
	}
	catch (IOException e) {
		this.pooledData = "error";

    }
		
	}
	
	
	public void openConnection(){
		
	try{
		Socket mySocket = new Socket(this.getIpAddress(),this.getPortNumber());
		mySocket.setSoTimeout(this.getSocketTimeOut());
		this.setRefSocket(mySocket);
		PrintWriter myOutStream = new PrintWriter(mySocket.getOutputStream(),true);
		this.setRefOutStream(myOutStream);
		
		InputStreamReader myInputStreamReader = new InputStreamReader(mySocket.getInputStream());
		BufferedReader myBufferedInputStreamReader = new BufferedReader(myInputStreamReader);
		
		this.setRefBufReader(myBufferedInputStreamReader);
				
		
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
