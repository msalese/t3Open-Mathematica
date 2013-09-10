(* ::Package:: *)

BeginPackage["T3OpenInterface`",{"JLink`"}];


t3OpenGetStatus::usage = "t3OpenGetStatus[] function 
returns OK if t3Open is running and tcp/http communications are activese.
Options[t3OpenGetStatus]";


t3OpenGetTickerByName::usage = "t3OpenGetTickerByName[exchange,market,pattern] function 
returns list as result of pattern query.
Options[t3OpenGetTickerByName]";


t3OpenFormatSearchList::usage = "t3OpenFormatSearchList[searchList] function
format data from t3OpenGetTickerByName";


t3OpenGetMarketList::usage = "t3OpenGetMarketList[] function
returns T3Open market list.
Options[t3OpenGetMarketList]";


borsaItalianaGetLottiMinimi::usage = "borsaItalianaGetLottiMinimi[] a non T3Opne function
returns isoalpha (american options) minimum number of stocks, download data from borsaitaliana.it
Options[borsaItalianaGetLottiMinimi]";


t3OpenObject::usage = "t3OpenObject[objList] function
returns a java object (or a list of java object) from class com.t3.T3Open and execute openConnection() method
which open a tcp socket to T3Open platform, objList must be a list of couples {{code,symbol}}.
Options[t3OpenObject]";


t3OpenSubscribe::usage = "t3OpenSubscribe[T3OpenJavaObj,exchange,market,code,schema] function
subscribe tcp data to T3Open code and schema, if subscription action is fine return OK";


t3OpenSubscribeLastPrice::usage = "t3OpenSubscribeLastPrice[T3OpenJavaObj,exchange,market,code] function
subscribe last_price tcp schema, returns OK if subscription action is fine otherwise KO.
When T3OpenJavaObj has a subscription running it can't be used for other subscription schema";


t3OpenSubscribeBestBid1::usage = "t3OpenSubscribeBestBid1[T3OpenJavaObj,exchange,market,code] function
subscribe best_bid1 tcp schema, returns OK if subscription action is fine otherwise KO.
When T3OpenJavaObj has a subscription running it can't be used for other subscription schema";


t3OpenSubscribeBestAsk1::usage = "t3OpenSubscribeBestAsk1[T3OpenJavaObj,exchange,market,code] function
subscribe best_ask1 tcp schema, returns OK if subscription action is fine otherwise KO.
When T3OpenJavaObj has a subscription running it can't be used for other subscription schema";


t3OpenGetSubscribedData::usage = "t3OpenGetSubscribedData[T3OpenJavaObj] function;
returns refreshed subscripted data";


t3OpenUnsubscribe::usage = "t3OpenUnsubscribe[T3OpenJavaObj] function
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


t3OpenSubscribeOrderBook::usage = "t3OpenSubscribeOrderBook[T3OpenJavaObj] function
subscribe a T3Open java object to order book";


Begin["Private`"];


ReinstallJava[CommandLine->"E:\\Java\\jre7\\bin\\javaw.exe"];


If[$SystemID=="Windows-x86-64",
	t3OpenInterfaceJavaClassPath=StringJoin[$BaseDirectory,"\\T3OpenInterface\\Java"],
	t3OpenInterfaceJavaClassPath=StringJoin[$BaseDirectory,"/T3OpenInterface/Java"]
];


If[$SystemID=="Windows-x86-64",
	t3OpenInterfaceJavaClassPath=StringJoin[$BaseDirectory,"\\T3OpenInterface\\Java"],
	t3OpenInterfaceJavaClassPath=StringJoin[$BaseDirectory,"/T3OpenInterface/Java"]
];


(*add t3OpenIterface class to the java path*)
AddToClassPath[t3OpenInterfaceJavaClassPath];


Options[t3OpenGetStatus]={ipAddress->"127.0.0.1",httpPort->8333};


t3OpenGetStatus[OptionsPattern[]]:=Module[{command,sendCommand,status},
command = "http_server_status";
sendCommand = StringJoin[{"http://",ToString[OptionValue[ipAddress]],":",ToString[OptionValue[httpPort]],"/T3OPEN/",command}];
status = Import[sendCommand];
Return[status];
]; 


Options[t3OpenGetMarketList]={ipAddress->"127.0.0.1",httpPort->8333};


t3OpenGetMarketList[OptionsPattern[]]:=Module[
{command,sendCommand,marketList},
command = "get_market_list";
sendCommand = StringJoin[{"http://",ToString[OptionValue[ipAddress]],":",ToString[OptionValue[httpPort]],"/T3OPEN/",command}];
marketList= Import[sendCommand];
(*isola outcom*)
Return[marketList];
];


Options[t3OpenGetTickerByName]={ipAddress->"127.0.0.1",httpPort->8333,type->"N"};


t3OpenGetTickerByName[exchange_String,market_String,pattern_String,OptionsPattern[]]:=Module[
{command,command01,sendCommand,searchList},
command = "search";
command01 = StringJoin[command,"?borsa=",exchange,"&mercato=",market,"&tipoRicerca=",ToString[OptionValue[type]],"&pattern=",pattern];
sendCommand = StringJoin[{"http://",ToString[OptionValue[ipAddress]],":",ToString[OptionValue[httpPort]],"/T3OPEN/",command01}];
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


beforet3OpenObject[codeList_]:=Module[{ab,absym,ab2},
ab = Table[Append[codeList[[i]],Symbol[StringJoin["c",StringDrop[ToString[codeList[[i,1]]],-1],"LastPrice"]]],{i,1,Dimensions[codeList][[1]]}];
(*absym = Table[Symbol[ab[[i,3]]],{i,1,Dimensions[codeList][[1]]}];*)
(*ab2 = Table[Append[ab[[i]],absym[[i]]],{i,1,Dimensions[ab][[1]]}];*)
Return[ab];
];


Options[t3OpenObject]={ipAddress->"127.0.0.1",tcpPort->5333,soTimeout->250};


t3OpenObject[codeList_,OptionsPattern[]]:=Module[{objList,codeList02},
objList=Table[JavaNew["com.t3.t3Open",MakeJavaObject[OptionValue[ipAddress]],MakeJavaObject[OptionValue[tcpPort]],MakeJavaObject[OptionValue[soTimeout]]],{i,1,Dimensions[codeList][[1]]}];
Table[objList[[i]]@openConnection[],{i,1,Dimensions[objList][[1]]}];
codeList02 = Table[Append[codeList[[i]],objList[[i]]],{i,1,Dimensions[objList][[1]]}];
Table[codeList02[[All,3]][[i]]@setPoolingWhatSymbol[codeList[[All,2]][[i]]],{i,1,Dimensions[codeList02[[All,3]]][[1]]}];
Table[codeList02[[All,3]][[i]]@setPoolingWhatCode[codeList[[All,1]][[i]]],{i,1,Dimensions[codeList02[[All,3]]][[1]]}];
Return[codeList02];
];


t3OpenSubscribeLastPrice[myT3OpenObj_,exchange_,market_,code_]:= Module[
{funSub,request,response},
response={};
funSub= "function=subscribe|item=";
(*build the string request to send*)
request =StringJoin[{funSub,exchange,".",market,".",code,"|schema=","last_price"}];
(*set poolingWhat attribute*)
myT3OpenObj@setPoolingWhat["last_price"];
(*send the request*)
myT3OpenObj@getRefOutStream[]@println[request];
(*read the first response*)
response = myT3OpenObj@getRefBufReader[]@readLine[];
(*response = Take[Flatten[StringSplit[response,"|"]],-1];*)
Return[response];
];


t3OpenSubscribeBestBid1[myT3OpenObj_,exchange_,market_,code_]:= Module[
{funSub,request,response},
response={};
funSub= "function=subscribe|item=";
(*build the string request to send*)
request =StringJoin[{funSub,exchange,".",market,".",code,"|schema=","best_bid1"}];
(*set poolingWhat attribute*)
myT3OpenObj@setPoolingWhat["best_bid1"];
(*send the request*)
myT3OpenObj@getRefOutStream[]@println[request];
(*read the first response*)
response = myT3OpenObj@getRefBufReader[]@readLine[];
(*response = Take[Flatten[StringSplit[response,"|"]],-1];*)
Return[response];
];


t3OpenSubscribeBestAsk1[myT3OpenObj_,exchange_,market_,code_]:= Module[
{funSub,request,response},
response={};
funSub= "function=subscribe|item=";
(*build the string request to send*)
request =StringJoin[{funSub,exchange,".",market,".",code,"|schema=","best_ask1"}];
(*set poolingWhat attribute*)
myT3OpenObj@setPoolingWhat["best_ask1"];
(*send the request*)
myT3OpenObj@getRefOutStream[]@println[request];
(*read the first response*)
response = myT3OpenObj@getRefBufReader[]@readLine[];
(*response = Take[Flatten[StringSplit[response,"|"]],-1];*)
Return[response];
];


t3OpenGetSubscribedData[myT3OpenObj_]:= Module[
{request,response},
response={};
(*read the second response, here are the data that I need*)
myT3OpenObj@getSubscribedData[];
response = Append[response ,myT3OpenObj@getPooledData[]];
(*response = Take[Flatten[StringSplit[response,"|"]],-1]*)
Return[response];
];


t3OpenUnsubscribe[myT3OpenObj_]:=Module[{i},
(*send unsubscribe comand*)
myT3OpenObj@getRefOutStream[]@println["function=unsubscribe"];
(*close java socket connection*)
myT3OpenObj@getRefSocket[]@close[];
(*release java object*)
ReleaseJavaObject[myT3OpenObj];
(*TODO Unsubscribe : must be corrected*)
Return[myT3OpenObj];
];
SetAttributes[t3OpenUnsubscribe,Listable];


Options[t3OpenGetHDailyClosePrice]={ipAddress->"127.0.0.1",httpPort->8333,frequency->"1D"};


t3OpenGetHDailyClosePrice[market_String,exchange_String,code_String,fromDate_String,OptionsPattern[]]:=Module[
{command,data01,data02,data03,counter,close,closeDate,dataToPlot,toDay,fromDateF,fromDateF1,ohlc},
(*check fromDate value*)
toDay = DateList[DateString[DateList[],{"Year","Month","Day"}]];
fromDateF = DateList[{fromDate,{"Year","","Month","","Day"}}];
fromDateF1 = If[DateDifference[fromDateF,toDay,"Year"][[1]]<=10,fromDate,DateString[DatePlus[toDay,{-10,"Year" }],{"Year","","Month","","Day"}]];
(*send http command*)
command = StringJoin["http://",OptionValue[ipAddress],":",ToString[OptionValue[httpPort]],"/T3OPEN/get_history?item=",market,".",exchange,".",ToString[code],"&frequency=",OptionValue[frequency],"&dataDa=",fromDate];
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


Options[t3OpenGetHClosePrice1M]={ipAddress->"127.0.0.1",httpPort->8333,frequency->"1M"};


t3OpenGetHClosePrice1M[market_String,exchange_String,code_String,fromDate_String,OptionsPattern[]]:=Module[
{command,data01,data02,data03,counter,close,closeDate,dataToPlot,toDay,fromDateF,fromDateF1},
(*check fromDate value*)
toDay = DateList[DateString[DateList[],{"Year","Month","Day"}]];
fromDateF = DateList[{fromDate,{"Year","","Month","","Day"}}];
fromDateF1 = If[DateDifference[fromDateF,toDay,"Day"][[1]]<=3,fromDate,DateString[DatePlus[toDay,{-3,"Day" }],{"Year","","Month","","Day"}]];
(*send http command*)
command = StringJoin["http://",OptionValue[ipAddress],":",ToString[OptionValue[httpPort]],"/T3OPEN/get_history?item=",market,".",exchange,".",ToString[code],"&frequency=",OptionValue[frequency],"&dataDa=",fromDate];
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


Options[t3OpenGetHClosePrice5M]={ipAddress->"127.0.0.1",httpPort->8333,frequency->"5M"};


t3OpenGetHClosePrice5M[market_String,exchange_String,code_String,fromDate_String,OptionsPattern[]]:=Module[
{command,data01,data02,data03,counter,close,closeDate,dataToPlot,toDay,fromDateF,fromDateF1},
(*check fromDate value*)
toDay = DateList[DateString[DateList[],{"Year","Month","Day"}]];
fromDateF = DateList[{fromDate,{"Year","","Month","","Day"}}];
fromDateF1 = If[DateDifference[fromDateF,toDay,"Day"][[1]]<=3,fromDate,DateString[DatePlus[toDay,{-30,"Day" }],{"Year","","Month","","Day"}]];
(*send http command*)
command = StringJoin["http://",OptionValue[ipAddress],":",ToString[OptionValue[httpPort]],"/T3OPEN/get_history?item=",market,".",exchange,".",ToString[code],"&frequency=",OptionValue[frequency],"&dataDa=",fromDateF1];
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


Options[t3OpenGetDepositList]={ipAddress->"127.0.0.1",httpPort->8333};


t3OpenGetDepositList[OptionsPattern[]]:=Module[{command,sendCommand,depositList},
command = "get_conti";
sendCommand = StringJoin[{"http://",ToString[OptionValue[ipAddress]],":",ToString[OptionValue[httpPort]],"/T3OPEN/",command}];
depositList = Import[sendCommand];
Return[depositList];
]; 


Options[t3OpenGetFinanceSection]={ipAddress->"127.0.0.1",httpPort->8333};


t3OpenGetFinanceSection[deposit_String,OptionsPattern[]]:=Module[{command,sendCommand,financeSection},
command = "get_rubriche";
sendCommand = StringJoin[{"http://",ToString[OptionValue[ipAddress]],":",ToString[OptionValue[httpPort]],"/T3OPEN/",command,"?conto=",deposit}];
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


End[];


EndPackage[];
