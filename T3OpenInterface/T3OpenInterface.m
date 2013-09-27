(* ::Package:: *)

BeginPackage["T3OpenInterface`",{"JLink`"}];


(* usage messages *)


t3OpenGetStatus::usage = "t3OpenGetStatus[] function 
returns OK if t3Open is running and tcp/http communications are activese.
Options[t3OpenGetStatus]";


t3OpenGetTickerByName::usage = "t3OpenGetTickerByName[exchange,market,patternName] function 
returns list as result of pattern-name query.
Options[t3OpenGetTickerByName]";


t3OpenGetTickerBySymbol::usage = "t3OpenGetTickerBySymbol[exchange,market,patternSymbol] function 
returns list as result of pattern-symbol query.
Options[t3OpenGetTickerBySymbol]";


t3OpenFormatSearchList::usage = "t3OpenFormatSearchList[searchList] function
format data from t3OpenGetTickerByName";


t3OpenGetMarketList::usage = "t3OpenGetMarketList[] function
returns T3Open market list.
Options[t3OpenGetMarketList]";


borsaItalianaGetLottiMinimi::usage = "borsaItalianaGetLottiMinimi[] a non T3Open function
returns isoalpha (american options) minimum number of stocks, download data from borsaitaliana.it
Options[borsaItalianaGetLottiMinimi]";


t3OpenObject::usage = "t3OpenObject[objList] function
returns a java object (or a list of java object) from class com.t3.T3Open and execute openConnection() method
which open a tcp socket to T3Open platform, objList must be a list of couples {{code,symbol}}.
Options[t3OpenObject]";


t3OpenObject::badarg = "The argument `1` is not a list of list.";


t3OpenObjectT::usage = "t3OpenObjectT[codeList] function with multi threads
returns a java object (or a list of java object) from class com.t3.T3OpenT and execute openConnection() method
which open a tcp socket to T3OpenT platform, objList must be a list of couples {{code,symbol}}.
Options[t3OpenObjectT]";


t3OpenSubscribe::usage = "t3OpenSubscribe[T3OpenJavaObj,exchange,market,code,schema] function
subscribe tcp data to T3Open code and schema, if subscription action is fine return OK";


t3OpenSubscribeLastPrice::usage = "t3OpenSubscribeLastPrice[t3OpenJavaObj,exchange,market,code] function
subscribe last_price tcp schema, returns OK if subscription action is fine otherwise KO.
When T3OpenJavaObj has a subscription running it can't be used for other subscription schema";


t3OpenSubscribeBestBid1::usage = "t3OpenSubscribeBestBid1[t3OpenJavaObj,exchange,market,code] function
subscribe best_bid1 tcp schema, returns OK if subscription action is fine otherwise KO.
When T3OpenJavaObj has a subscription running it can't be used for other subscription schema";


t3OpenSubscribeBestAsk1::usage = "t3OpenSubscribeBestAsk1[t3OpenJavaObj,exchange,market,code] function
subscribe best_ask1 tcp schema, returns OK if subscription action is fine otherwise KO.
When T3OpenJavaObj has a subscription running it can't be used for other subscription schema";


t3OpenRefresh::usage = "t3OpenRefresh[myT3OpenObj] function ";


t3OpenGetSubscribedData::usage = "t3OpenGetSubscribedData[T3OpenJavaObj] function;
returns refreshed subscripted data";


t3OpenUnsubscribe::usage = "t3OpenUnsubscribe[t3OpenJavaObj] function
remove subscription and close the tcp socket removing T3OpenJava object";


t3OpenGetHDailyClosePrice::usage = "t3OpenGetHDailyClosePrice[market,exchange,code,fromDate] function
get historical daily close price.
Options[t3OpenGetHDailyClosePrice]";


t3OpenGetHClosePrice1M::usage = "t3OpenGetHClosePrice1M[market,exchange,code,fromDate] function
get historical intraday 1 minute close price.
Options[t3OpenGetHClosePrice1M]";


t3OpenGetHClosePrice5M::usage = "t3OpenGetHClosePrice5M[market,exchange,code,fromDate] function
get historical intraday 5 minute close price.
Options[t3OpenGetHClosePrice5M]";


t3OpenGetDepositList::usage = "t3OpenGetDepositList[] function
returns the bond/security/stock deposit list (italian lista depositi).
Options[t3OpenGetDepositList]";


t3OpenGetFinanceSection::usage = "t3OpenGetFinanceSection[depositNumber] function;
returns the finance section (italian lista delle rubriche) bounded with deposit list.
Options[t3OpenGetFinanceSection]";


t3OpenSubscribePortfolio::usage = "t3OpenSubscribePortfolio[t3OpenJavaObj,depositNumber] function
subscribe a T3Open java object to deposit";


t3OpenSubscribePortfolioBalance::usage = "t3OpenSubscribePortfolioBalance[T3OpenJavaObj,depositNumber] function
subscribe a T3Open java object to deposit";


t3OpenSubscribeOrderBook::usage = "t3OpenSubscribeOrderBook[t3OpenJavaObj] function
subscribe a T3Open java object to order book";


t3GetIndexWatchList::usage = "t3GetIndexWatchList[idxList] function
return a whach list for index.
idxList is a list of index that you want follow: {{'MI','EQCON','I_SPMIB','FTSEMIB'}}";


t3GetUnderWatchList::usage = "t3GetUnderWatchList[underList] function
return a T3Open whatch list for stocks/bonds all instruments with lastPrice, BestBid and BestAsk.
underList is a list that you want follow : {{'MI','EQCON','1','G'},{'MI','EQCON','81658','TRN'},{'MI','DER','720541','FIB3I'}}";


t3SetUpPutChain::usage = "t3SetUpPutChain[exchange,market,name,expMonth,lowStrike,highStrike,stripChar] function
return a put chain. Parameters:
exchange es 'MI'
market es 'DER'
name es 'FTSE*MIB', you must check it using t3OpneGetTickerByName
expMonth es '20/09/2013'
lowStrike es 17500
highStrike es 16500
stripChar es 6, the number of char to strip from symbol to exstract strike price (MIBO3U17600)";


t3SetUpCallChain::usage = "t3SetUpCallChain[exchange,market,name,expMonth,lowStrike,highStrike,stripChar] function
return a call chain. Parameters:
exchange es 'MI'
market es 'DER'
name es 'FTSE*MIB', you must check it using t3OpneGetTickerByName
expMonth es '20/09/2013'
lowStrike es 17500
highStrike es 16500
stripChar es 6, the number of char to strip from symbol to exstract strike price (MIBO3U17600)";


t3WatchOptionChain::usage = "t3WatchOptionChain[optionChain] function
return the T3Open option chain (put/call).
optionCahin is a list created by t3SetUpCallChain or t3SetUpPutChain.";


t3EPutGreeksChain::usage = "t3EPutGreeksChain[putChain,interestRate,currentPrice,dividend] function
use internal Mathematica function to compute European put implied volatility and greeks from the put chain.
putChain is build using t3GetPutChain function.
Implied Vol is computed using middle price between ask and bid";


t3ECallGreeksChain::usage = "t3ECallGreeksChain[callChain,interestRate,currentPrice,dividend] function
use internal Mathematica function to compute European call implied volatility and greeks form the call chain.
callChain is build using t3GetCallChain function.
Implied Vol is computed using middle price between ask and bid";


(*public options*)


Options[t3OpenGetStatus]={IpAddress->"127.0.0.1",HttpPort->8333};


Options[t3OpenGetMarketList]={IpAddress->"127.0.0.1",HttpPort->8333};


Options[t3OpenGetTickerByName]={IpAddress->"127.0.0.1",HttpPort->8333,Type->"N"};


Options[t3OpenGetTickerBySymbol]={IpAddress->"127.0.0.1",HttpPort->8333,Type->"S"};


Options[t3OpenObject]={IpAddress->"127.0.0.1",TcpPort->5333,SoTimeOut->300,WaitBeforeRead->1000};


Options[t3OpenObjectT]={IpAddress->"127.0.0.1",TcpPort->5333,SoTimeOut->300,WaitBeforeRead->300};


Options[t3OpenGetHDailyClosePrice]={IpAddress->"127.0.0.1",HttpPort->8333,Frequency->"1D"};


Options[t3OpenGetHClosePrice1M]={IpAddress->"127.0.0.1",HttpPort->8333,Frequency->"1M"};


Options[t3OpenGetHClosePrice5M]={IpAddress->"127.0.0.1",HttpPort->8333,Frequency->"5M"};


Options[t3OpenGetDepositList]={IpAddress->"127.0.0.1",HttpPort->8333};


Options[t3OpenGetFinanceSection]={IpAddress->"127.0.0.1",HttpPort->8333};


(* start private context *)


Begin["Private`"];


InstallJava[];


If[$SystemID=="Windows-x86-64",
	t3OpenInterfaceJavaClassPath=StringJoin[$BaseDirectory,"\\Applications\\T3OpenInterface\\Java\\64"],
If[$SystemID=="Windows-x86",
	t3OpenInterfaceJavaClassPath=StringJoin[$BaseDirectory,"\\Applications\\T3OpenInterface\\Java\\32"],
	t3OpenInterfaceJavaClassPath=StringJoin[$BaseDirectory,"/Applications/T3OpenInterface/Java/64"]
]
];


(*add t3OpenIterface class to the java path*)
AddToClassPath[t3OpenInterfaceJavaClassPath];


t3OpenGetStatus[OptionsPattern[]]:=Module[{ipAddress,httpPort,command,sendCommand,status},
{ipAddress,httpPort}=OptionValue[{IpAddress,HttpPort}];
command = "http_server_status";
sendCommand = StringJoin[{"http://",ToString[ipAddress],":",ToString[httpPort],"/T3OPEN/",command}];
status = Import[sendCommand];
Return[status];
]; 


t3OpenGetMarketList[OptionsPattern[]]:=Module[
{ipAddress,httpPort,command,sendCommand,marketList},
{ipAddress,httpPort}=OptionValue[{IpAddress,HttpPort}];
command = "get_market_list";
sendCommand = StringJoin[{"http://",ToString[ipAddress],":",ToString[httpPort],"/T3OPEN/",command}];
marketList= Import[sendCommand];
(*isola outcom*)
Return[marketList];
];


t3OpenGetTickerByName[exchange_String,market_String,pattern_String,OptionsPattern[]]:=Module[
{ipAddress,httpPort,type,command,command01,sendCommand,searchList},
{ipAddress,httpPort,type}=OptionValue[{IpAddress,HttpPort,Type}];
command = "search";
command01 = StringJoin[command,"?borsa=",exchange,"&mercato=",market,"&tipoRicerca=",ToString[type],"&pattern=",pattern];
sendCommand = StringJoin[{"http://",ToString[ipAddress],":",ToString[httpPort],"/T3OPEN/",command01}];
searchList= Import[sendCommand];
Return[searchList];
];


t3OpenGetTickerBySymbol[exchange_String,market_String,pattern_String,OptionsPattern[]]:=Module[
{ipAddress,httpPort,type,command,command01,sendCommand,searchList},
{ipAddress,httpPort,type}=OptionValue[{IpAddress,HttpPort,Type}];
command = "search";
command01 = StringJoin[command,"?borsa=",exchange,"&mercato=",market,"&tipoRicerca=",ToString[type],"&pattern=",pattern];
sendCommand = StringJoin[{"http://",ToString[ipAddress],":",ToString[httpPort],"/T3OPEN/",command01}];
searchList= Import[sendCommand];
Return[searchList];
];


t3OpenFormatSearchList[searchList_]:=Module[{searchList02,stringSearch03,stringSearch04},
searchList02 = StringSplit[searchList,{"outcome=","numElements=",{"element="}}];
stringSearch03 = Drop[searchList02,2];
stringSearch04 = Table[StringTrim[stringSearch03[[i]]],{i,1,Length[stringSearch03]}];
Return[stringSearch04];
];


borsaItalianaGetLottiMinimi[]:=Module[{sendCommand,lottiMinimi,lottiMinimi02},
sendCommand = "http://www.borsaitaliana.it/derivati/specifichecontrattuali/lottiminimiopzionisuazioni.htm";
lottiMinimi= Import[sendCommand,"Data"];
lottiMinimi02 =lottiMinimi[[2]];
Return[lottiMinimi02];
];


t3OpenObject[codeList_,OptionsPattern[]]:=Module[{ipAddress,tcpPort,soTimeOut,waitBeforeRead,objList,codeList02},
{ipAddress,tcpPort,soTimeOut,waitBeforeRead}=OptionValue[{IpAddress,TcpPort,SoTimeOut,WaitBeforeRead}];
(*check argument*)
If[MatrixQ[codeList]==False,Message[t3OpenObject::badarg, codeList];Return[1]];
objList=Table[JavaNew["com.t3.t3Open",MakeJavaObject[ipAddress],MakeJavaObject[tcpPort],MakeJavaObject[soTimeOut],MakeJavaObject[waitBeforeRead]],{i,1,Dimensions[codeList][[1]]}];
Table[objList[[i]]@openConnection[],{i,1,Dimensions[objList][[1]]}];
codeList02 = Table[Append[codeList[[i]],objList[[i]]],{i,1,Dimensions[objList][[1]]}];
Return[codeList02];
];


t3OpenObjectT[codeList_,OptionsPattern[]]:=Module[{ipAddress,tcpPort,soTimeOut,waitBeforeRead,objList,codeList02},
{ipAddress,tcpPort,soTimeOut,waitBeforeRead}=OptionValue[{IpAddress,TcpPort,SoTimeOut,WaitBeforeRead}];
(*check argument*)
If[MatrixQ[codeList]==False,Message[t3OpenObject::badarg, codeList];Return[1]];
objList=Table[JavaNew["com.t3.t3OpenT",MakeJavaObject[ipAddress],MakeJavaObject[tcpPort],MakeJavaObject[soTimeOut],MakeJavaObject[waitBeforeRead]],{i,1,Dimensions[codeList][[1]]}];
Table[objList[[i]]@openConnection[],{i,1,Dimensions[objList][[1]]}];
codeList02 = Table[Append[codeList[[i]],objList[[i]]],{i,1,Dimensions[objList][[1]]}];
Return[codeList02];
];


t3OpenSubscribeLastPrice[myT3OpenObj_,exchange_,market_,code_]:= Module[
{funSub,request,response},
response={};
funSub= "function=subscribe|item=";
(*build the string request to send*)
request =StringJoin[{funSub,exchange,".",market,".",code,"|schema=","last_price"}];
(*set the request inside t3open object field*)
myT3OpenObj@setRequest[request];
(* call subsribeData method *)
myT3OpenObj@subscribeData[];
(* read the pushedData field *)
response = myT3OpenObj@getResponse[];
Return[response];
];


t3OpenSubscribeBestBid1[myT3OpenObj_,exchange_,market_,code_]:= Module[
{funSub,request,response},
response={};
funSub= "function=subscribe|item=";
(*build the string request to send*)
request =StringJoin[{funSub,exchange,".",market,".",code,"|schema=","best_bid1"}];
(*set the request inside t3open object field*)
myT3OpenObj@setRequest[request];
(* call subsribeData method *)
myT3OpenObj@subscribeData[];
(* read the pushedData field *)
response = myT3OpenObj@getResponse[];
Return[response];
];


t3OpenSubscribeBestAsk1[myT3OpenObj_,exchange_,market_,code_]:= Module[
{funSub,request,response},
response={};
funSub= "function=subscribe|item=";
(*build the string request to send*)
request =StringJoin[{funSub,exchange,".",market,".",code,"|schema=","best_ask1"}];
(*set the request inside t3open object field*)
myT3OpenObj@setRequest[request];
(* call subsribeData method *)
myT3OpenObj@subscribeData[];
(* read the pushedData field *)
response = myT3OpenObj@getResponse[];
Return[response];
];


t3OpenRefresh[myT3OpenObj_]:=Module[{pushedData,pushedDataNew},
(* conserva ultimo refresh *)
pushedData = myT3OpenObj@getPushedData[];
myT3OpenObj@refresh[];
pushedDataNew = myT3OpenObj@getPushedData[];
If[pushedDataNew == 0,Return[pushedData],Return[pushedDataNew]];
(*Return[response];*)
];


t3OpenGetSubscribedData[myT3OpenObj_]:= Module[
{request,response},
response={};
(*read the second response, here are the data that I need*)
myT3OpenObj@getSubscribedData[];
response = Append[response ,myT3OpenObj@getPooledData[]];
(*response = Take[Flatten[StringSplit[response,"|"]],-1]*)
(*new code*)
While[myT3OpenObj@getRefBufReader[]@ready[],
	response = myT3OpenObj@getRefBufReader[]@readLine[];
]
Return[response];
];


t3OpenUnsubscribe[myT3OpenObj_]:=Module[{i},
(*send unsubscribe comand*)
(*myT3OpenObj@getRefOutStream[]@println["function=unsubscribe"];*)
(*close java socket connection*)
myT3OpenObj@unsubscribe[];
myT3OpenObj@getRefSocket[]@close[];
(*release java object*)
ReleaseJavaObject[myT3OpenObj];
(*TODO Unsubscribe : must be corrected*)
Return[myT3OpenObj];
];
SetAttributes[t3OpenUnsubscribe,Listable];


t3OpenGetHDailyClosePrice[market_String,exchange_String,code_String,fromDate_String,OptionsPattern[]]:=Module[
{ipAddress,httpPort,frequency,command,data01,data02,data03,counter,close,closeDate,dataToPlot,toDay,fromDateF,fromDateF1,ohlc},
{ipAddress,httpPort,frequency}=OptionValue[{IpAddress,HttpPort,Frequency}];
(*check fromDate value*)
toDay = DateList[DateString[DateList[],{"Year","Month","Day"}]];
fromDateF = DateList[{fromDate,{"Year","","Month","","Day"}}];
fromDateF1 = If[DateDifference[fromDateF,toDay,"Year"][[1]]<=10,fromDate,DateString[DatePlus[toDay,{-10,"Year" }],{"Year","","Month","","Day"}]];
(*send http command*)
command = StringJoin["http://",ToString[ipAddress],":",ToString[httpPort],"/T3OPEN/get_history?item=",market,".",exchange,".",ToString[code],"&frequency=",frequency,"&dataDa=",fromDateF1];
data01 =Import[command];
data01 =Drop[data01,1];
data02 = Table[StringSplit[data01[[i]],"element="],{i,1,Dimensions[data01][[1]]}];
data02 =Flatten[data02];
data03 =StringSplit[data02,"|"];
(*take out date and put in math date format*) 
closeDate = Table[DateList[{data03[[i,1]],{"Year","","Month","","Day"}}],{i,1,Length[data03[[All,1]]]}];
(*take out Open,High, Low, Close and Volume-*)
ohlc = ToExpression[data03[[All,{4,2,3,5,6}]]];
(*create the time series*)
dataToPlot = Transpose[{closeDate,ohlc}];
Return[dataToPlot];
];


t3OpenGetHClosePrice1M[market_String,exchange_String,code_String,fromDate_String,OptionsPattern[]]:=Module[
{ipAddress,httpPort,frequency,command,data01,data02,data03,counter,close,closeDate,dataToPlot,toDay,fromDateF,fromDateF1,ohlc},
{ipAddress,httpPort,frequency}=OptionValue[{IpAddress,HttpPort,Frequency}];
(*check fromDate value*)
toDay = DateList[DateString[DateList[],{"Year","Month","Day"}]];
fromDateF = DateList[{fromDate,{"Year","","Month","","Day"}}];
fromDateF1 = If[DateDifference[fromDateF,toDay,"Day"][[1]]<=3,fromDate,DateString[DatePlus[toDay,{-3,"Day" }],{"Year","","Month","","Day"}]];
(*send http command*)
command = StringJoin["http://",ToString[ipAddress],":",ToString[httpPort],"/T3OPEN/get_history?item=",market,".",exchange,".",ToString[code],"&frequency=",frequency,"&dataDa=",fromDateF1];
data01 =Import[command];
data01 =Drop[data01,1];
data02 = Table[StringSplit[data01[[i]],"element="],{i,1,Dimensions[data01][[1]]}];
data02 =Flatten[data02];
data03 =StringSplit[data02,"|"];
(*take out date and put in math date format*) 
closeDate = Table[DateList[{data03[[i,1]],{"Year","","Month","","Day","","Hour","","Minute","","Second"}}],{i,1,Length[data03[[All,1]]]}];
(*take out Open,High, Low, Close and Volume-*)
ohlc = ToExpression[data03[[All,{4,2,3,5,6}]]];
(*create the time series*)
dataToPlot = Transpose[{closeDate,ohlc}];
Return[dataToPlot];
];


t3OpenGetHClosePrice5M[market_String,exchange_String,code_String,fromDate_String,OptionsPattern[]]:=Module[
{ipAddress,httpPort,frequency,command,data01,data02,data03,counter,close,closeDate,dataToPlot,toDay,fromDateF,fromDateF1,ohlc},
{ipAddress,httpPort,frequency}=OptionValue[{IpAddress,HttpPort,Frequency}];
(*check fromDate value*)
toDay = DateList[DateString[DateList[],{"Year","Month","Day"}]];
fromDateF = DateList[{fromDate,{"Year","","Month","","Day"}}];
fromDateF1 = If[DateDifference[fromDateF,toDay,"Day"][[1]]<=30,fromDate,DateString[DatePlus[toDay,{-30,"Day" }],{"Year","","Month","","Day"}]];
(*send http command*)
command = StringJoin["http://",ToString[ipAddress],":",ToString[httpPort],"/T3OPEN/get_history?item=",market,".",exchange,".",ToString[code],"&frequency=",frequency,"&dataDa=",fromDateF1];
data01 =Import[command];
data01 =Drop[data01,1];
data02 = Table[StringSplit[data01[[i]],"element="],{i,1,Dimensions[data01][[1]]}];
data02 =Flatten[data02];
data03 =StringSplit[data02,"|"];
(*take out date and put in math date format*) 
closeDate = Table[DateList[{data03[[i,1]],{"Year","","Month","","Day","","Hour","","Minute","","Second"}}],{i,1,Length[data03[[All,1]]]}];
(*take out Open,High, Low, Close and Volume-*)
ohlc = ToExpression[data03[[All,{4,2,3,5,6}]]];
(*create the time series*)
dataToPlot = Transpose[{closeDate,ohlc}];
Return[dataToPlot];
];


t3OpenGetDepositList[OptionsPattern[]]:=Module[{ipAddress,httpPort,command,sendCommand,depositList},
{ipAddress,httpPort}=OptionValue[{IpAddress,HttpPort}];
command = "get_conti";
sendCommand = StringJoin[{"http://",ToString[ipAddress],":",ToString[httpPort],"/T3OPEN/",command}];
depositList = Import[sendCommand];
Return[depositList];
]; 


t3OpenGetFinanceSection[deposit_String,OptionsPattern[]]:=Module[{ipAddress,httpPort,command,sendCommand,financeSection},
{ipAddress,httpPort}=OptionValue[{IpAddress,HttpPort}];
command = "get_rubriche";
sendCommand = StringJoin[{"http://",ToString[ipAddress],":",ToString[httpPort],"/T3OPEN/",command,"?conto=",deposit}];
financeSection = Import[sendCommand];
Return[financeSection];
]; 


t3OpenSubscribePortfolio[myT3OpenObj_,deposit_]:= Module[
{funSub,request,response},
response={};
funSub= "function=subscribe_portfolio|item=";
(*build the string request to send*)
request =StringJoin[{funSub,deposit}];
(*set poolingWhat attribute*)
myT3OpenObj@setPoolingWhat["subscribe_portafolio"];
(*send the request*)
myT3OpenObj@getRefOutStream[]@println[request];
(*read the first response*)
response = myT3OpenObj@getRefBufReader[]@readLine[];
(*read others using while on BufferedReader ready() method*)
(*TO DO*)
(*response = Take[Flatten[StringSplit[response,"|"]],-1];*)
Return[response];
];


t3OpenSubscribePortfolioBalance[myT3OpenObj_,deposit_]:= Module[
{funSub,request,response},
response={};
funSub= "function=subscribe_portfolio_balance|item=";
(*build the string request to send*)
request =StringJoin[{funSub,deposit}];
(*set poolingWhat attribute*)
myT3OpenObj@setPoolingWhat["subscribe_portafolio"];
(*send the request*)
myT3OpenObj@getRefOutStream[]@println[request];
(*read the first response*)
response = myT3OpenObj@getRefBufReader[]@readLine[];
(*response = Take[Flatten[StringSplit[response,"|"]],-1];*)
Return[response];
];


t3OpenSubscribeOrderBook[myT3OpenObj_,deposit_]:= Module[
{funSub,request,response},
response={};
funSub= "function=subscribe_orderbook|item=";
(*build the string request to send*)
request =StringJoin[{funSub,deposit}];
(*set poolingWhat attribute*)
myT3OpenObj@setPoolingWhat["subscribe_portafolio"];
(*send the request*)
myT3OpenObj@getRefOutStream[]@println[request];
(*read the first response*)
response = myT3OpenObj@getRefBufReader[]@readLine[];
(*response = Take[Flatten[StringSplit[response,"|"]],-1];*)
Return[response];
];


t3GetIndexWatchList[idxList_]:=Module[{data,data02Lastprice,subData,lastPrice,lastPrice01,lastPrice02,lastUpdate,finalPutChain,finalPutChain01 },
data = idxList;
data02Lastprice = Table[t3OpenObject[{data[[i]]}],{i,1,Length[data]}];
subData =Table[Append[data[[i]],data02Lastprice[[i,1]][[5]]],{i,1,Length[data]}];
(*first call to subscribed data*)
Table[t3OpenSubscribeLastPrice[subData[[i,5]],subData[[i,1]],subData[[i,2]],subData[[i,3]]],{i,1,Length[data]}];
(*get subscribed data*)
(*lastPrice =Table[t3OpenGetSubscribedData[subData[[i,5]]],{i,1,Length[data]}];*)
lastPrice =Table[t3OpenRefresh[subData[[i,5]]],{i,1,Length[data]}];
(*format for better output*)
lastPrice01 = Table[StringSplit[lastPrice[[i]],"|"],{i,1,Length[data]}];
lastPrice02=lastPrice01[[All,1]];
lastUpdate = Table[DateString[],{Length[data]}];
finalPutChain={lastUpdate,data[[All,3]],lastPrice02};
finalPutChain01 = Prepend[Transpose[finalPutChain],{"LastUpdateTime","Symbol","LastPrice"}];
(*destroy java objects*)
Table[t3OpenUnsubscribe[subData[[i,5]]],{i,1,Length[data]}];
Return[finalPutChain01];
];


t3GetUnderWatchList[underList_]:=Module[{data,data02Lastprice,data02BestBid1 ,data02BestAsk1,subData,lastPrice,bestBid1,bestAsk1,lastPrice01,bestBid101,bestAsk101,lastPrice02,bestBid102,bestAsk102,lastUpdate,finalPutChain,finalPutChain01 },
data = underList;
data02Lastprice = Table[t3OpenObject[{data[[i]]}],{i,1,Length[data]}];
data02BestBid1 =Table[t3OpenObject[{data[[i]]}],{i,1,Length[data]}];
data02BestAsk1 =Table[t3OpenObject[{data[[i]]}],{i,1,Length[data]}];
subData =Table[Append[Append[Append[data[[i]],data02Lastprice[[i,1]][[5]]],data02BestBid1[[i,1]][[5]]],data02BestAsk1[[i,1]][[5]]],{i,1,Length[data]}];
(*first call to subscribed data*)
Table[t3OpenSubscribeLastPrice[subData[[i,5]],subData[[i,1]],subData[[i,2]],subData[[i,3]]],{i,1,Length[data]}];
Table[t3OpenSubscribeBestBid1[subData[[i,6]],subData[[i,1]],subData[[i,2]],subData[[i,3]]],{i,1,Length[data]}];
Table[t3OpenSubscribeBestAsk1[subData[[i,7]],subData[[i,1]],subData[[i,2]],subData[[i,3]]],{i,1,Length[data]}];
(*get subscribed data*)
lastPrice =Table[t3OpenRefresh[subData[[i,5]]],{i,1,Length[data]}];
bestBid1 =Table[t3OpenRefresh[subData[[i,6]]],{i,1,Length[data]}];
bestAsk1=Table[t3OpenRefresh[subData[[i,7]]],{i,1,Length[data]}];
(*here we should check if lastPrice is null, if null you have to request again*)
If[MemberQ[lastPrice,{Null}],Return[1];Abort[]];
If[MemberQ[bestBid1,{Null}],Return[1];Abort[]];
If[MemberQ[bestAsk1,{Null}],Return[1];Abort[]];
(*format for better output*)
lastPrice01 = Table[StringSplit[lastPrice[[i]],"|"],{i,1,Length[data]}];
bestBid101 = Table[StringSplit[bestBid1[[i]],"|"],{i,1,Length[data]}];
bestAsk101 = Table[StringSplit[bestAsk1[[i]],"|"],{i,1,Length[data]}];
lastPrice02=lastPrice01[[All,2]];
bestBid102= bestBid101[[All,2]];
bestAsk102 = bestAsk101[[All,2]];
lastUpdate = Table[DateString[],{Length[data]}];
finalPutChain={lastUpdate,data[[All,4]],lastPrice02,bestBid102,bestAsk102};
finalPutChain01 = Prepend[Transpose[finalPutChain],{"LastUpdateTime","Symbol","LastPrice","BestBid1","BestAsk1"}];
(*destroy java objects*)
Table[t3OpenUnsubscribe[subData[[i,5]]],{i,1,Length[data]}];
Table[t3OpenUnsubscribe[subData[[i,6]]],{i,1,Length[data]}];
Table[t3OpenUnsubscribe[subData[[i,7]]],{i,1,Length[data]}];
Return[finalPutChain01];
];


t3SetUpPutChain[exchange_String,market_String,name_String,expMonth_String,lowStrike_,highStrike_,stripChar_]:=Module[
{pattern,searchList,searchList02,outcome,searchList03,searchList04,code,symbol,strike,data,exch,mrkt,expDate },
pattern = StringJoin["OPTION*",name,"*",expMonth,"*","PUT"];
searchList = t3OpenGetTickerByName[exchange,market,pattern];
searchList02 = StringSplit[searchList,{"outcome=","numElements=",{"element="}}];
outcome =StringDrop[searchList02[[1]],-1];
searchList03 = Drop[searchList02,2];
searchList04 =StringSplit[searchList03,"|"];
code = searchList04 [[All,3]];
symbol = StringTrim[searchList04 [[All,5]]];
strike = ToExpression[Flatten[StringSplit[symbol,Take[StringTake[symbol,stripChar],1]]]];
expDate = Table[expMonth,{Length[code]}];
exch = searchList04[[All,1]];
mrkt = searchList04[[All,2]];
data = Transpose[{code,symbol,strike,expDate,exch,mrkt}];
data = Sort[data,data[[All,3]]];
data =Select[data,(#[[3]] <= highStrike && #[[3]]>=lowStrike )&];
data = Prepend[data,{"Code","Symbol","Strike","ExpDate","Exchange","Market"}];
Return[data];
]


t3SetUpCallChain[exchange_String,market_String,name_String,expMonth_String,lowStrike_,highStrike_,stripChar_]:=Module[
{pattern,searchList,searchList02,outcome,searchList03,searchList04,code,symbol,strike,data,exch,mrkt,expDate },
pattern = StringJoin["OPTION*",name,"*",expMonth,"*","CALL"];
searchList = t3OpenGetTickerByName[exchange,market,pattern];
searchList02 = StringSplit[searchList,{"outcome=","numElements=",{"element="}}];
outcome =StringDrop[searchList02[[1]],-1];
searchList03 = Drop[searchList02,2];
searchList04 =StringSplit[searchList03,"|"];
code = searchList04 [[All,3]];
symbol = StringTrim[searchList04 [[All,5]]];
strike = ToExpression[Flatten[StringSplit[symbol,Take[StringTake[symbol,stripChar],1]]]];
expDate = Table[expMonth,{Length[code]}];
exch = searchList04[[All,1]];
mrkt = searchList04[[All,2]];
data = Transpose[{code,symbol,strike,expDate,exch,mrkt}];
data = Sort[data,data[[All,3]]];
data =Select[data,(#[[3]] <= highStrike && #[[3]]>=lowStrike )&];
data = Prepend[data,{"Code","Symbol","Strike","ExpDate","Exchange","Market"}];
Return[data];
]


t3WatchOptionChain[optionChain_List]:=Module[
{data,data02Lastprice,data02BestBid1 ,data02BestAsk1,subData,lastPrice,bestBid1,bestAsk1,lastPrice01,bestBid101,
bestAsk101,lastPrice02,bestBid102,bestAsk102,lastUpdate,finalPutChain,finalPutChain01,daysToExp,daysToExpY},
data = Drop[optionChain,1];
(*now we build java object for last_price, best_bid1 and best_ask1*)
data02Lastprice = Table[t3OpenObject[{data[[i]]}],{i,1,Length[data]}];
data02BestBid1 =Table[t3OpenObject[{data[[i]]}],{i,1,Length[data]}];
data02BestAsk1 =Table[t3OpenObject[{data[[i]]}],{i,1,Length[data]}];
subData =Table[Append[Append[Append[data[[i]],data02Lastprice[[i,1]][[7]]],data02BestBid1[[i,1]][[7]]],data02BestAsk1[[i,1]][[7]]],{i,1,Length[data]}];
(*first call to subscribed data*)
Table[t3OpenSubscribeLastPrice[subData[[i,7]],data[[i,5]],data[[i,6]],subData[[i,1]]],{i,1,Length[data]}];
Table[t3OpenSubscribeBestBid1[subData[[i,8]],data[[i,5]],data[[i,6]],subData[[i,1]]],{i,1,Length[data]}];
Table[t3OpenSubscribeBestAsk1[subData[[i,9]],data[[i,5]],data[[i,6]],subData[[i,1]]],{i,1,Length[data]}];
(*get subscribed data*)
lastPrice = Table[t3OpenRefresh[subData[[i,7]]],{i,1,Length[data]}];
bestBid1 = Table[t3OpenRefresh[subData[[i,8]]],{i,1,Length[data]}];
bestAsk1 = Table[t3OpenRefresh[subData[[i,9]]],{i,1,Length[data]}];

(*format for better output*)
lastPrice01 = Table[StringSplit[lastPrice[[i]],"|"],{i,1,Length[data]}];
bestBid101 = Table[StringSplit[bestBid1[[i]],"|"],{i,1,Length[data]}];
bestAsk101 = Table[StringSplit[bestAsk1[[i]],"|"],{i,1,Length[data]}];
lastPrice02 = lastPrice01[[All,1]];
bestBid102 = bestBid101[[All,1]];
bestAsk102 = bestAsk101[[All,1]];
lastUpdate = Table[DateString[{"Day","/","Month","/","Year"," ","Hour24",":","Minute",":","Second"}],{Length[data]}];
(*prepare for output*)
daysToExp =Table[ DateDifference[Take[DateList[],3],Take[DateList[data[[1,4]]],3]],{Length[data]}];
daysToExpY = N[daysToExp/365];
finalPutChain={lastUpdate,data[[All,2]],lastPrice02,bestBid102,bestAsk102,data[[All,3]],daysToExp,daysToExpY};
finalPutChain01 = Prepend[Transpose[finalPutChain],{"LastUpdateTime","Symbol","LastPrice","BestBid1","BestAsk1","Strike","DToExp","DToExpY"}];
(*destroy java objects*)
Table[t3OpenUnsubscribe[subData[[i,7]]],{i,1,Length[data]}];
Table[t3OpenUnsubscribe[subData[[i,8]]],{i,1,Length[data]}];
Table[t3OpenUnsubscribe[subData[[i,9]]],{i,1,Length[data]}];
(*Return[finalPutChain01];*)
Return[lastPrice];
];


t3EPutGreeksChain[chain_,interestRate_,currentPrice_,dividend_]:=Module[
{chain01,chain02,chain03,chain04,chain05,chain06,chain07,chain08,chainIvf},
(*remove column name*)
chain01=Drop[chain,1];
(*compute middle price*)
middlePrice=(ToExpression[chain01[[All,4]]]+ToExpression[chain01[[All,5]]])/2;
(*compute implied volatility*)
ivf =Table[FinancialDerivative[{"European","Put"}, {"StrikePrice"-> chain01[[i,6]], "Expiration"->chain01[[i,8]],"Value"->middlePrice[[i]]},  {"InterestRate"-> interestRate,"CurrentPrice"-> currentPrice, "Dividend"->dividend}, "ImpliedVolatility"],{i,1,Length[middlePrice]}];
(*use teo implid vol to compute greeks*)
greeks =Table[ FinancialDerivative[{"European","Put"}, {"StrikePrice"-> chain01[[i,6]], "Expiration"->chain01[[i,8]]},  {"InterestRate"-> interestRate, "Volatility" -> ivf[[i]], "CurrentPrice"-> currentPrice, "Dividend"->dividend}, {"Value", "Greeks"}],{i,1,Length[ivf]}];
(*extract greeks values*)
teoPrice = Table[greeks[[i,1]],{i,1,Length[ivf]}];
teoDelta = Table[greeks[[i,2]][[1]][[2]],{i,1,Length[ivf]}];
teoGamma = Table[greeks[[i,2]][[2]][[2]],{i,1,Length[ivf]}];
teoRho = Table[greeks[[i,2]][[3]][[2]],{i,1,Length[ivf]}];
teoTheta = Table[greeks[[i,2]][[4]][[2]],{i,1,Length[ivf]}];
teoVega =Table[greeks[[i,2]][[5]][[2]],{i,1,Length[ivf]}];
(*build output *)
chain02=Table[Append[chain01[[i]],ivf[[i]]],{i,1,Length[ivf]}];
chain03=Table[Append[chain02[[i]],teoPrice[[i]]],{i,1,Length[ivf]}];
chain04= Table[Append[chain03[[i]],teoDelta[[i]]],{i,1,Length[ivf]}];
chain05= Table[Append[chain04[[i]],teoGamma[[i]]],{i,1,Length[ivf]}];
chain06= Table[Append[chain05[[i]],teoRho[[i]]],{i,1,Length[ivf]}];
chain07= Table[Append[chain06[[i]],teoTheta[[i]]],{i,1,Length[ivf]}];
chain08= Table[Append[chain07[[i]],teoVega[[i]]],{i,1,Length[ivf]}];
chainIvf = Prepend[chain08,
{"LastUpdateTime","Symbol","LastPrice","BestBid1","BestAsk1","Strike","DToExp","DToExpY","ImpVol","TeoValue","Delta","Gamma","Rho","Theta","Vega"}
];
Return[chainIvf];
];


t3ECallGreeksChain[chain_,interestRate_,currentPrice_,dividend_]:=Module[
{chain01,chain02,chain03,chain04,chain05,chain06,chain07,chain08,chainIvf},
(*remove column name*)
chain01=Drop[chain,1];
(*compute middle price*)
middlePrice=(ToExpression[chain01[[All,4]]]+ToExpression[chain01[[All,5]]])/2;
(*compute implied volatility*)
ivf =Table[FinancialDerivative[{"European","Call"}, {"StrikePrice"-> chain01[[i,6]], "Expiration"->chain01[[i,8]],"Value"->middlePrice[[i]]},  {"InterestRate"-> interestRate,"CurrentPrice"-> currentPrice, "Dividend"->dividend}, "ImpliedVolatility"],{i,1,Length[middlePrice]}];
(*use teo implid vol to compute greeks*)
greeks =Table[ FinancialDerivative[{"European","Call"}, {"StrikePrice"-> chain01[[i,6]], "Expiration"->chain01[[i,8]]},  {"InterestRate"-> interestRate, "Volatility" -> ivf[[i]], "CurrentPrice"-> currentPrice, "Dividend"->dividend}, {"Value", "Greeks"}],{i,1,Length[ivf]}];
(*extract greeks values*)
teoPrice = Table[greeks[[i,1]],{i,1,Length[ivf]}];
teoDelta = Table[greeks[[i,2]][[1]][[2]],{i,1,Length[ivf]}];
teoGamma = Table[greeks[[i,2]][[2]][[2]],{i,1,Length[ivf]}];
teoRho = Table[greeks[[i,2]][[3]][[2]],{i,1,Length[ivf]}];
teoTheta = Table[greeks[[i,2]][[4]][[2]],{i,1,Length[ivf]}];
teoVega =Table[greeks[[i,2]][[5]][[2]],{i,1,Length[ivf]}];
(*build output *)
chain02=Table[Append[chain01[[i]],ivf[[i]]],{i,1,Length[ivf]}];
chain03=Table[Append[chain02[[i]],teoPrice[[i]]],{i,1,Length[ivf]}];
chain04= Table[Append[chain03[[i]],teoDelta[[i]]],{i,1,Length[ivf]}];
chain05= Table[Append[chain04[[i]],teoGamma[[i]]],{i,1,Length[ivf]}];
chain06= Table[Append[chain05[[i]],teoRho[[i]]],{i,1,Length[ivf]}];
chain07= Table[Append[chain06[[i]],teoTheta[[i]]],{i,1,Length[ivf]}];
chain08= Table[Append[chain07[[i]],teoVega[[i]]],{i,1,Length[ivf]}];
chainIvf = Prepend[chain08,
{"LastUpdateTime","Symbol","LastPrice","BestBid1","BestAsk1","Strike","DToExp","DToExpY","ImpVol","TeoValue","Delta","Gamma","Rho","Theta","Vega"}
];
Return[chainIvf];
];


(* end private context *)


End[];


EndPackage[];
