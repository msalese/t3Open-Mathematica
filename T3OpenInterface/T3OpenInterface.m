(* ::Package:: *)

BeginPackage["T3OpenInterface`",{"JLink`"}];


t3OpenGetStatus::usage = 
"t3OpenGetStatus[OptionsPattern[]];
restituisce OK se lo stato della piattaforma e' valido";


t3OpenGetTickerByName::usage =
"t3OpenGetTickerByName[exchange_,market_,pattern_,OptionsPattern[]]
restituisce il risultato di una interrogazione con pattern.
{ipAddress->'127.0.0.1',httpPort\[Rule]8333}";


t3OpenFormatSearchList::usage =
"formatta il risultato proveniente da t3OpenGetTickerByName";


t3OpenGetMarketList::usage =
"t3OpenGetMarketList[OptionsPattern[]]
restituisce la lista dei mercati su cui e' possibile operare dalla T3Open.";


borsaItalianaGetLottiMinimi::usage =
"borsaItalianaGetLottiMinimi[];
restituisce la tabella dei lotti minimi sulle opzioni isoalpha preleva i dati dal sito di borsaitaliana.it
I lotti minimi vengono prelevati da fonte esterna e non da T3Open";


t3OpenObject::usage =
"t3OpenObject[objList_,OptionsPattern[]]
crea un oggetto o lista di oggetti delle classe com.t3.T3Open ed esegue il metodo openConnection[]
che apre per ogni oggetto un socket con la piattaforma.
objList deve essere una lista di copie {{code,symbol}} precedentemente create usando t3OpneGetTickerByName.
{ipAddress->'192.168.0.78',tcpPort->5333,soTimeout\[Rule]250} sono le opzioni di default";


t3OpenSubscribe::usage =
"t3OpenSubscribe[myT3OpenObj_,exchange_,market_,code_,schema_];
Sottoscrive alla piattaforma un codice ed uno schema,
restituisce il messaggio di OK o KO";


t3OpenSubscribeLastPrice::usage = 
"t3OpenSubscribeLastPrice[myT3OpenObj_,exchange_,market_,code_];
Sottoscrive lo schema last_price alla piattaforma,
restituisce il messaggio di OK o KO.
A questo punto gli oggetti myT3OpenObj di com.t3.T3Open sono impegnati e non possono essere piu' usati
per altre sottoscrizioni";


t3OpenSubscribeBestBid1::usage =
"t3OpenSubscribeBestBid1[myT3OpenObj_,exchange_,market_,code_];
Sottoscrive lo schema best_bid1 alla piattaforma,
restituisce il messaggio di OK o KO.
A questo punto gli oggetti myT3OpenObj di com.t3.T3Open sono impegnati e non possono essere piu' usati
per altre sottoscrizioni";


t3OpenSubscribeBestAsk1::usage =
"t3OpenSubscribeBestAsk1[myT3OpenObj_,exchange_,market_,code_];
Sottoscrive lo schema best_ask1 alla piattaforma,
restituisce il messaggio di OK o KO.
A questo punto gli oggetti myT3OpenObj di com.t3.T3Open sono impegnati e non possono essere piu' usati
per altre sottoscrizioni";


t3OpenGetSubscribedData::usage =
"t3OpenGetSubscribedData[myT3OpenObj_];
effettua il refresh dei dati sottoscritti";


t3OpenUnsubscribe::usage = 
"t3OpenUnsubscribe[myT3OpenObj_];
desottoscrive l'informativa di myT3OpenObj, chiude il socket ed effetuua un Clear di myT3OpenObj";


t3OpenGetHDailyClosePrice::usage = 
"getHDailyClosePrice[market_String,exchange_String,code_String,fromDate_String,OptionsPattern[]];
get historical daily close price.";


t3OpenGetDepositList::usage =
"t3OpenGetDepositList[];
returns the bond/security/stock deposit list (italian lista depositi).
Options[t3OpenGetDepositList]={ipAddress->'127.0.0.1',httpPort->8333}";


t3OpenGetFinanceSection::usage =
"t3OpenGetFinanceSection[deposit_String,OptionsPattern[]];
returns the finance section (italian lista delle rubriche) bounded with deposit list.
Options[t3OpenGetFinanceSection]={ipAddress->'127.0.0.1',httpPort->8333}";


t3OpenSubscribePortfolio::usage =
"to completed";


t3OpenUnsubscribePortfolio::usage =
"to be completed";


t3OpenSubscribePortfolioBalance::usage =
"to be completed";


t3OpenUnsubscribePortfolioBalance::usage =
"to be completed";


t3OpenSubscribeOrderBook::usage =
"to be completed";


t3OpenUnsubscribeOrderBook::usage =
"to be completed";


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
{command,data01,data02,data03,counter,close,closeDate,dataToPlot},
command = StringJoin["http://",OptionValue[ipAddress],":",ToString[OptionValue[httpPort]],"/T3OPEN/get_history?item=",market,".",exchange,".",ToString[code],"&frequency=",OptionValue[frequency],"&dataDa=",fromDate];
data01 =Import[command];
data01 =Drop[data01,1];
data02 = Table[StringSplit[data01[[i]],"element="],{i,1,Dimensions[data01][[1]]}];
data02 =Flatten[data02];
data03 =StringSplit[data02,"|"];
closeDate = data03[[All,1]];
close = ToExpression[data03[[All,5]]];
counter=Range[1,Length[close],1];
dataToPlot = Transpose[{counter,closeDate,close}];
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


t3OpenUnsubscribePortfolio[myT3OpenObj_]:=Module[{i},
(*send unsubscribe comand*)
myT3OpenObj@getRefOutStream[]@println["function=unsubscribe_portfolio"];
(*close java socket connection*)
myT3OpenObj@getRefSocket[]@close[];
(*release java object*)
ReleaseJavaObject[myT3OpenObj];
(*TODO Unsubscribe : must be corrected*)
Return[myT3OpenObj];
];
SetAttributes[t3OpenUnsubscribePortfolio,Listable];


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


t3OpenUnsubscribePortfolioBalance[myT3OpenObj_]:=Module[{i},
(*send unsubscribe comand*)
myT3OpenObj@getRefOutStream[]@println["function=unsubscribe_portfolio_balance"];
(*close java socket connection*)
myT3OpenObj@getRefSocket[]@close[];
(*release java object*)
ReleaseJavaObject[myT3OpenObj];
(*TODO Unsubscribe : must be corrected*)
Return[myT3OpenObj];
];
SetAttributes[t3OpenUnsubscribePortfolioBalance,Listable];


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


t3OpenUnsubscribeOrderBook[myT3OpenObj_]:=Module[{i},
(*send unsubscribe comand*)
myT3OpenObj@getRefOutStream[]@println["function=unsubscribe_orderbook"];
(*close java socket connection*)
myT3OpenObj@getRefSocket[]@close[];
(*release java object*)
ReleaseJavaObject[myT3OpenObj];
(*TODO Unsubscribe : must be corrected*)
Return[myT3OpenObj];
];


SetAttributes[t3OpenUnsubscribeOrderBook,Listable];


End[];


EndPackage[];
