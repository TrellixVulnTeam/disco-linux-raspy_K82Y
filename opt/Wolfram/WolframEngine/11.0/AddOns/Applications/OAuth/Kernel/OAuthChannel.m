
Begin["OAuthClient`"]

OAuthClient`oauthChannelVerify;
OAuthClient`loadChannelListen;

Begin["`Private`"]

(* NEED A NEW SAVE MECHANISM *)

$ChannelListenPacletName="ChannelFramework";
$WolframConnectorLandingBaseURL="https://www.wolfram.com/oauthlanding/connector/";
channellistenOpts={Permissions->"Public"};
$ServiceConnectChannel="https://channelbroker.wolframcloud.com:443/users/services-admin@wolfram.com/tokenchannel";
oauthChannelListenerCompleteQ[_]:=False
oauthChannelHandle[_]:=None;
(* have to choose the right parameter, is it usually "code"? *)
getVerifierValues[raw_Association,name_]:=getverifierValues[raw,name]
getVerifierValues[___]:=$Failed

getverifierValues[data_,name_]:=With[{code=getCode[name, data]},
	If[StringQ[code],code,Message[ServiceConnect::verif];Throw[$Failed]]
]


OAuthClient`oauthChannelVerify[{url0_String, redirectfun_,temptoken_}, {name_,uuid_}]:=Block[{loaded, listener,url, channel},
	PrintTemporary[oauthChannelListenerMessagePanel[name]];
    loaded=OAuthClient`loadChannelListen[];
    If[!TrueQ[loaded],Return[$Failed]];  
    channel=System`ChannelObject[$ServiceConnectChannel];
    listener=System`ChannelListen[channel,
    	With[{callback=verifierCallbackFunction[temptoken, redirectfun, {name,uuid}]},
	    	If[connectionIDmatchQ[#,uuid],
				callback[#["Message"]]
				,
				Identity
	    	]&
    	], "TrustedChannel" -> True
    	];
    oauthChannelHandle[uuid]=listener;
	SystemOpen[url0];
	Pause[1];
]


verifierCallbackFunction[temptoken_, redirectfun_, {name_,uuid_}]:=With[
	{dv=getBlockedDownValues[], headerQ=OAuthClient`Private`$useAuthHeader},
		setBlockedDownValues[
    		Block[{value,res},
	            (value=getVerifierValues[#,name];
	            res=redirectfun[value];
	            res=accessTokenParse[res,uuid,name];
                Set[OAuthSigning`Private`temporaryOAuthToken[temptoken],res];
	            ServiceConnections`Private`appendauthservicelist[uuid];
	            removeChannelListener[oauthChannelHandle[uuid]];
	            oauthChannelListenerCompleteQ[uuid]=True)]&
            ,dv,headerQ]
	]

removeChannelListener[ch_System`ChannelListener]:=System`RemoveChannelListener[ch]

connectionIDmatchQ[response_,uuid_]:=True/;!FreeQ[response,uuid]
connectionIDmatchQ[response_,__]:=False

removeOAuthlistener[listener_]:=System`RemoveChannelListener[listener];

(*
createOAuthChannel[]:=With[{uuid=CreateUUID[]},
	System`CreateChannel["wolframconnector/"<>uuid,channellistenOpts]
]
*)
getOAuthChannelURL[channel_]:=First[channel]

OAuthClient`loadChannelListen[]:=Block[{local,paclet=None,remote},
	local=PacletManager`PacletFind[$ChannelListenPacletName];
	If[Length[local]>0&&checkChannelFrameworkVersionNumber[local],
		paclet=First[local]
	];
	If[paclet===None,
		remote=PacletManager`PacletFindRemote[$ChannelListenPacletName];
		If[Length[remote]>0&&checkChannelFrameworkVersionNumber[remote],
	        paclet=First[remote];
	        PacletManager`PacletInstall[paclet]
	        ,
	        $AllowNonBlockingDialogsQ=False;
	        Return[$Failed]
	    ];
	    First[PacletManager`PacletFind[$ChannelListenPacletName]]
	];
	Needs[$ChannelListenPacletName<>"`"];
	True
]


checkChannelFrameworkVersionNumber[remote_]:=Quiet[With[{
	numbers=ToExpression[StringSplit[Lookup[PacletManager`PacletInformation[First[remote]], "Version"], "."]]},
	TrueQ[First[numbers]>0||numbers[[2]]>4]]]

createRedirect["WolframConnectorChannelListen",uuid_, name_]:= With[{loaded=OAuthClient`loadChannelListen[]},
    If[!TrueQ[loaded],Return[$Failed]];
    createredirect[$WolframConnectorLandingBaseURL, uuid, name]
    (* $WolframConnectorLandingBaseURL *)]

createRedirect["WolframConnectorChannel",uuid_, _]:=With[{loaded=OAuthClient`loadChannelListen[]},
    If[!TrueQ[loaded],Return[$Failed]];
    URLBuild[{System`$ChannelBase,"users",$OAuthChannelUser,uuid}]]
    
createRedirect[expr_,__]:=expr

createredirect[url_, id_, name_]:=
    createredirect0[Lookup[OAuthClient`Private`oauthservicedata[name],"RedirectURLFunction"],url, id]
     
createredirect0[_Missing,url_,uuid_]:=URLBuild[url,{"connectionid"->uuid}]
createredirect0[fun_Function,url_,uuid_]:=fun[url,uuid]
createredirect0[_,url_, uuid_]:=URLBuild[url,{"connectionid"->uuid}]

accessTokenParse[token_,id_, name_]:=accesstokenParse[Lookup[OAuthClient`Private`oauthservicedata[name],"AccessTokenExtractor"],token, id]
     
accesstokenParse["Refresh/2.0",token_,uuid_]:=Block[{
	rawtoken=Cases[OAuthClient`Private`updateTokenContext[token],OAuthSigning`Private`Token20[l_List]:>l,{0,Infinity}]},
        If[rawtoken==={},token,
            rawtoken=First[rawtoken];
            OAuthClient`Private`refreshtoken[uuid]=OAuthClient`Private`formatrefreshtoken[Rest[rawtoken]];
            Replace[token,rawtoken:>rawtoken[[1]],{0,Infinity}]
        ]
    ]
accesstokenParse[_,token_, uuid_]:=token


getCode[name_, data_]:=
    getcode[Lookup[OAuthClient`Private`oauthservicedata[name],"VerifierParsing"],data]

getcode[str_String,data_]:=Lookup[data,str,$Failed]
getcode[_Missing|$Failed,data_]:=Lookup[data,"code",$Failed]
getcode[fun_,data_]:=fun[data]

getBlockedDownValues[]:=DownValues /@ {OAuthSigning`Private`jsonAccessTokenExtractor, OAuthSigning`Private`jsonAccessTokenAndRefreshExtractor,
                OAuthSigning`Private`tokenSaneQ20, OAuthClient`Private`tokenobject, OAuthClient`Private`rawtoken,
                OAuthSigning`Private`HMACSha1SignatureService}

setBlockedDownValues[fun_,dv_, useheaderQ_]:=Block[{OAuthSigning`Private`jsonAccessTokenExtractor, OAuthSigning`Private`jsonAccessTokenAndRefreshExtractor,
        OAuthSigning`Private`tokenSaneQ20, OAuthClient`Private`tokenobject, OAuthClient`Private`rawtoken,
        OAuthSigning`Private`HMACSha1SignatureService,OAuthClient`Private`$useAuthHeader=useheaderQ},
    MapThread[(DownValues[#1] = #2) &, {{OAuthSigning`Private`jsonAccessTokenExtractor, OAuthSigning`Private`jsonAccessTokenAndRefreshExtractor,
        OAuthSigning`Private`tokenSaneQ20, OAuthClient`Private`tokenobject, OAuthClient`Private`rawtoken,
        OAuthSigning`Private`HMACSha1SignatureService},
        dv}]; 
    fun[##]]&
      
$OAuthChannelListenerMessageFunction=StringTemplate["Opening web browser to authorize `1`"];

oauthChannelListenerMessagePanel[name_]:=oauthChannelListenerMessagePanel[name, OAuthClient`OAuthServicesData[name,"icon"]]

oauthChannelListenerMessagePanel[name_, icon_]:=Block[{text},
	If[TrueQ[hasFrontEnd[]],
            text = $OAuthChannelListenerMessageFunction[name];
            If[ImageQ[icon],
                	Internal`LoadingPanel[Row[{icon,"  ",text}]]
                	,
                	Internal`LoadingPanel[text]
            	],
            Print[text]
        ]
]


hasFrontEnd[] :=(hasFrontEnd[]= ToString[Head[$FrontEnd]] === "FrontEndObject")

If[OAuthClient`Private`$AllowNonBlockingDialogsQ,
    OAuthClient`loadChannelListen[]
]

End[];
End[];