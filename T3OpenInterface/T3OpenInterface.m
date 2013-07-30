(* ::Package:: *)

BeginPackage["T3OpenInterface`",{"JLink`"}];


getT3OpenStatus::usage = 
"getT3OpenStatus[hostAddress_,httpPort_];
restituisce OK se lo stato della piattaforma e' valido";


getT3OpenTickerSearch::usage =
"getT3OpenTickerSearch[exchange_,market_,type_,pattern_,OptionsPattern[]]
restituisce il risultato di una interrogazione con pattern.
{ipAddress->'127.0.0.1',httpPort\[Rule]8333}";


formatSearchList::usage =
"formatta il risultato proveniente da getT3OpenTickerSearch";


getT3OpenMarketList::usage =
"getT3OpenMarketList[] restituisce la lista dei mercati della T3Open.
Legge i dati di connessione dal foglio Status
Scarica i dati sul foglio MarketList B5:C5";


getLottiMinimi::usage =
"getLottiMinimi[] restituisce la tabella dei lotti minimi sulle opzioni isoalpha
preleva i dati dal sito di borsaitaliana.it
scarica i dati sul foglio LottiMinimi
aggiorna la data dell'ultima richiesta";


t3OpenObject::usage =
"t3OpenObject[objList_,OptionsPattern[]]
crea un oggetto o lista di oggetti delle classe com.t3.T3Open ed esegue il metodo openConnection[]
che apre per ogni oggetto un socket con l apiattaforma.
objList deve essere una lista di copie {{code,symbol}} precedentemente create usando getT3OpenTickerSearch.
{ipAddress->'192.168.0.78',tcpPort->5333,soTimeout\[Rule]250} sono le opzioni di default";


t3OpenSubscribe::usage =
"t3OpenSubscribe[myT3OpenObj_,exchange_,market_,code_,schema_];
Sottoscrive alla piattaforma un codice ed uno schema,
restituisce il messaggio di OK o KO";


t3OpenSubscribeLastprice::usage = 
"t3OpenSubscribeLastprice[myT3OpenObj_,exchange_,market_,code_];
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


Begin["Private`"];


ReinstallJava[CommandLine->"E:\\Java\\jre7\\bin\\javaw.exe"];


If[$SystemID=="Windows-x86-64",
	t3OpenInterfaceJavaClassPath=StringJoin[$BaseDirectory,"\T3OpenInterface\Java"],
	t3OpenInterfaceJavaClassPath=StringJoin[$BaseDirectory,"/T3OpenInterface/Java"]
];


(*add t3OpenIterface class to the java path*)
AddToClassPath[t3OpenInterfaceJavaClassPath];


Options[getT3OpenStatus]={ipAddress->"127.0.0.1",httpPort->8333};


getT3OpenStatus[OptionsPattern[]]:=Module[{command,sendCommand,status},
command = "http_server_status";
sendCommand = StringJoin[{"http://",ToString[OptionValue[ipAddress]],":",ToString[OptionValue[httpPort]],"/T3OPEN/",command}];
status = Import[sendCommand];
Return[status];
]; 


Options[getT3OpenMarketList]={ipAddress->"127.0.0.1",httpPort->8333};


getT3OpenMarketList[OptionsPattern[]]:=Module[
{command,sendCommand,marketList},
command = "get_market_list";
sendCommand = StringJoin[{"http://",ToString[OptionValue[ipAddress]],":",ToString[OptionValue[httpPort]],"/T3OPEN/",command}];
marketList= Import[sendCommand];
(*isola outcom*)
Return[marketList];
];


Options[getT3OpenTickerSearch]={ipAddress->"127.0.0.1",httpPort->8333};


getT3OpenTickerSearch[exchange_,market_,type_,pattern_,OptionsPattern[]]:=Module[
{command,command01,sendCommand,searchList},
command = "search";
command01 = StringJoin[command,"?borsa=",exchange,"&mercato=",market,"&tipoRicerca=",type,"&pattern=",pattern];
sendCommand = StringJoin[{"http://",ToString[OptionValue[ipAddress]],":",ToString[OptionValue[httpPort]],"/T3OPEN/",command01}];
searchList= Import[sendCommand];
Return[searchList];
];


formatSearchList[searchList_]:=Module[{searchList02,stringSearch03,stringSearch04},
searchList02 = StringSplit[searchList,{"outcome=","numElements=",{"element="}}];
stringSearch03 = Drop[searchList02,2];
stringSearch04 = Table[StringTrim[stringSearch03[[i]]],{i,1,Length[stringSearch03]}];
Return[stringSearch04];
];


getLottiMinimi[]:=Module[{sendCommand,lottiMinimi,lottiMinimi02},
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
Return[codeList02];
];


t3OpenSubscribe[myT3OpenObj_,exchange_,market_,code_,schema_]:= Module[
{funSub,request,response},
response={};
funSub= "function=subscribe|item=";
(*build the string request to send*)
request =StringJoin[{funSub,exchange,".",market,".",code,"|schema=",schema}];
(*send the request*)
(*out@println[request];*)
myT3OpenObj@getRefOutStream[]@println[request];
(*read the first response*)
(*response = in@readLine[];*)
response = myT3OpenObj@getRefBufReader[]@readLine[];
(*response = Take[Flatten[StringSplit[response,"|"]],-1];*)
Return[response];
];


t3OpenSubscribeLastprice[myT3OpenObj_,exchange_,market_,code_]:= Module[
{funSub,request,response},
response={};
funSub= "function=subscribe|item=";
(*build the string request to send*)
request =StringJoin[{funSub,exchange,".",market,".",code,"|schema=","last_price"}];
(*send the request*)
(*out@println[request];*)
myT3OpenObj@getRefOutStream[]@println[request];
(*read the first response*)
(*response = in@readLine[];*)
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
(*send the request*)
(*out@println[request];*)
myT3OpenObj@getRefOutStream[]@println[request];
(*read the first response*)
(*response = in@readLine[];*)
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
(*send the request*)
(*out@println[request];*)
myT3OpenObj@getRefOutStream[]@println[request];
(*read the first response*)
(*response = in@readLine[];*)
response = myT3OpenObj@getRefBufReader[]@readLine[];
(*response = Take[Flatten[StringSplit[response,"|"]],-1];*)
Return[response];
];


t3OpenGetSubscribedData[myT3OpenObj_]:= Module[
{request,response},
response={};
(*read the second response, here are the data that I need*)
myT3OpenObj@getSubscribedData[];
response = Append[response ,myT3OpenObj@pooledData];
(*response = Take[Flatten[StringSplit[response,"|"]],-1]*)
Return[response];
];


t3OpenUnsubscribe[myT3OpenObj_]:=Module[{},
(*out@println["function=unsubscribe"];
socket@close[];*)
myT3OpenObj@getRefOutStream[]@println["function=unsubscribe"];
myT3OpenObj@getRefSocket[]@close[];
Clear[Evaluate[myT3OpenObj]];
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


End[];


EndPackage[];
