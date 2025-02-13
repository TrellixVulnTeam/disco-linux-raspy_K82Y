
(* ::Package:: *)

(* $Id$ *)

(* :Summary:
	A framework for authenticating and exchanging data with OAuth services
*)

(* :Mathematica Version: Mathematica 11.0 *)

(* :Keywords:
OAuth
*)

(* :Examples:
*)
(* Exported symbols *)
OAuthClient`saveOAuthConnection;
OAuthClient`loadOAuthConnection;
OAuthClient`deleteOAuthConnection;
OAuthClient`findSavedOAuthConnections;
OAuthClient`checkpermissions;
OAuthClient`addpermissions;
OAuthClient`oauthdata;
OAuthClient`rawoauthdata;
OAuthClient`$CacheResults;
OAuthClient`$SaveConnection;
OAuthClient`$SaveConnectionDefault;
OAuthClient`oauthauthenticate;
OAuthClient`oauthdisconnect;

(Unprotect[#]; Clear[#])& /@ {
  OAuthClient`rawoauthdata, OAuthClient`oauthdata,
  OAuthClient`saveOAuthConnection,OAuthClient`loadOAuthConnection,OAuthClient`deleteOAuthConnection,OAuthClient`findSavedOAuthConnections,
  OAuthClient`checkpermissions,OAuthClient`addpermissions
}

Begin["OAuthClient`"];

Begin["`Private`"];

oauthservicesdata = OAuthClient`OAuthServicesData;

(* Use the cloud stored client credentials,
    For OAuth 1 this signs urls in the wolfram cloud,
    For OAuth 2 this gets the authorization url and access tokens in the wolfram cloud *)
$OAuthCloudCredentialsQ = True;
$AllowNonBlockingDialogsQ=ValueQ[OAuthSigning`Private`$BlockingDialog];

(* if multiple svaed connections are found, either the most recent is used, or an error is given *)
$UseLatestSavedConnection = True;

(* Because the many of the services update thier data frequently (i.e. Twitter) caching is false by default.
    In some places where calls are often repeated, this is set to true *)
OAuthClient`$CacheResults = False;

(* Store access tokens locally on in the cloud. Automatic uses the cloud only if the user is already connected *)
OAuthClient`$ServiceStorageLocation = Automatic;

(* default save condition *)
OAuthClient`$SaveConnectionDefault = False;
OAuthClient`$SaveConnection = False;

$useAuthHeader = False;
(* Import Functions *)
serviceName = ServiceConnections`Private`serviceName;
getServiceObject = ServiceConnections`Private`getServiceObject;
checkservicelist = ServiceConnections`Private`checkservicelist;
getServiceID = ServiceConnections`Private`getServiceID;
getServiceName = ServiceConnections`Private`getServiceName;
serviceRawRequests = ServiceConnections`Private`serviceRawRequests;
serviceRawPosts = ServiceConnections`Private`serviceRawPosts;
serviceRawDeletes = ServiceConnections`Private`serviceRawDeletes;
serviceRawPuts = ServiceConnections`Private`serviceRawPuts;
serviceRequests = ServiceConnections`Private`serviceRequests;
servicePosts = ServiceConnections`Private`servicePosts;
serviceDeletes = ServiceConnections`Private`serviceDeletes;
servicePuts = ServiceConnections`Private`servicePuts;
logout = ServiceConnections`Private`logout;
urlfetchFun = ServiceConnections`Private`urlfetchFun;
refreshFun = ServiceConnections`Private`refreshFun;
serviceInfo = ServiceConnections`Private`serviceInfo;
serviceAuthentication = ServiceConnections`Private`serviceAuthentication;
debugPrint = ServiceConnections`Private`debugPrint;

(************************************** OAuth Authentication **********************************)

OAuthClient`oauthauthenticate[name_, opts_: {}, conn___String] :=
    With[ {service = oauthauthenticate1[name,opts,conn],
    (* OAuthClient`$SaveConnection is set by the dialog window during authentication *)
    save = Lookup[opts, "SaveServiceConnection", OAuthClient`$SaveConnection]},
        If[ !$CloudEvaluation,
            Switch[save,
                False|None,Null, (* default *)
                True|Automatic,OAuthClient`saveOAuthConnection[service]
            ]
        ];
        OAuthClient`$SaveConnection = OAuthClient`$SaveConnectionDefault;
        service
    ]

oauthauthenticate1[name_, opts_, "New"] :=
    (Internal`DeleteCache[{"OAuthTokens", name}];
     newoauthauthenticate[name, opts])

oauthauthenticate1[name_, opts_, connection_String] :=
    If[ MemberQ[ServiceConnections`Private`$authenticatedservices,connection],
        If[ serviceName[connection]===name,
            getServiceObject[connection],
            Message[ServiceConnect::nameid,connection,name];
            $Failed
        ],
        cloudoauthauthenticate[name, opts, connection]
    ]

oauthauthenticate1[name_, opts_] :=
    With[ {authorized = checkservicelist[ServiceConnections`Private`$authenticatedservices, name, ServiceConnect]},
        If[ FailureQ[authorized],
            cloudoauthauthenticate[name, opts],
            authorized
        ]
    ]

cloudoauthauthenticate[name_,opts_] :=
    cloudoauthauthenticate[name, opts, Automatic]


tokenpattern = (_OAuthSigning`Private`Token20|_OAuthSigning`Private`Token10);

updateTokenContext[expr_]:=Replace[expr,{
	HTTPClient`OAuth`Private`Token20->OAuthSigning`Private`Token20,
	HTTPClient`OAuth`Private`Token10->OAuthSigning`Private`Token10},
	Infinity,
	Heads->True]
	
cloudoauthauthenticate[name_,opts_,id_] :=
    Block[ {savedconns = updateTokenContext[loadoauthConnection[name,id]],service},
        If[ savedconns==="Multiple",
            Throw[$Failed]
        ];
        If[ MatchQ[savedconns,{_,tokenpattern}],
            savedconns[[2]] = {savedconns[[2]],None}
        ];
        Switch[savedconns,
            {_,{tokenpattern,_}},
                importSavedOAuthConnection[name,savedconns,opts],
            {_,_ServiceObject},savedconns[[2]],
            $Failed,If[ id===Automatic,
                        newoauthauthenticate[name, opts],
                        $Failed
                    ],
            _,$Failed
        ]
    ]

importSavedOAuthConnection[name_, saved_, rest_]:=Block[
	{OAuthSigning`Private`OAuthFlow, ServiceConnections`Private`makeuuid,Internal`CheckCache,service},
    Internal`CheckCache[___] :=
        $Failed;
    ServiceConnections`Private`makeuuid[] = saved[[1]];
    OAuthSigning`Private`OAuthFlow[___] = saved[[2,1]];
    service = newoauthauthenticate[name, rest];
    refreshtoken[getServiceID[service]] = saved[[2,2]];
    ServiceConnections`Private`appendauthservicelist[saved[[1]]];
    ServiceConnections`Private`appendsavedservicelist[saved[[1]]];
    service
]

newoauthauthenticate[name_,opts_] :=
    Module[ {
        service,
        rawgets = oauthservicesdata[name, "RawGets"],
        gets = oauthservicesdata[name, "Gets"],
        rawposts = oauthservicesdata[name, "RawPosts"],
        posts = oauthservicesdata[name, "Posts"],
        rawdeletes = oauthservicesdata[name, "RawDeletes"],
        deletes = oauthservicesdata[name, "Deletes"],
        rawputs = oauthservicesdata[name, "RawPuts"],
        puts = oauthservicesdata[name, "Puts"],
        id,
        info},
        info = ToString/@OAuthClient`Private`getclientinfo[name];
        info = If[ !MatchQ[info,{_,__}],
                   Throw[$Failed],
                   {"ConsumerKey"->info[[1]],"ConsumerSecret"->info[[2]]}
               ];
        service = newunknownoauthauthenticate[name,Join[oauthservicesdata[name, "Authentication"],info]];
        id = getServiceID[service];

        serviceRawRequests[id] = sortrequests[serviceRawRequests[id],rawgets];
        serviceRawPosts[id] = sortrequests[serviceRawPosts[id],rawposts];
        serviceRawDeletes[id] = sortrequests[serviceRawDeletes[id],rawdeletes];
        serviceRawPuts[id] = sortrequests[serviceRawPuts[id],rawputs];
        serviceRequests[id] =sortrequests[serviceRequests[id],gets];
        servicePosts[id] = sortrequests[servicePosts[id],posts];
        serviceDeletes[id] = sortrequests[serviceDeletes[id],deletes];
        servicePuts[id] = sortrequests[servicePuts[id],puts];
        logout[id] = oauthservicesdata[name,"LogoutURL"];
        service
    ]/;MemberQ[OAuthClient`$predefinedOAuthservicelist,name]

newoauthauthenticate[name_,rest___] :=
    newunknownoauthauthenticate[name, rest]

sortrequests[l1_,l2_]:=Sort[Select[Flatten[{l1,l2}],StringQ]]

otheroauthoptions = {"AccessVerb", "CodeExtractor",
	"RequestTokenExtractor", "RequestVerb", "ScopeDomain",
	"ScopeParameter", "SignatureMethod", "URLSignService","VerifierLabel","ResponseType"};

extraoauth2opts = {"CodeExtractor", "AccessEndpoint", "AccessVerb", "ScopeDomain",
	"AuthorizationFunction","AccessTokenRequestor"};

extraoauth1opts = {"RequestVerb", "CodeExtractor", "AccessEndpoint", "AccessVerb",
	"URLSignService", "SignatureMethod","AccessTokenExtractor", "ScopeParameter"};

defaultOAuthOptions = {
    "ServiceName"				-> Null,
    "OAuthVersion"       	 	-> "1.0a",
    "RequestEndpoint"			-> "",
    "AccessEndpoint"			-> Null,
    "AuthorizeEndpoint"			-> Null,
    "ConsumerKey"				-> Null,
    "ConsumerSecret"			-> Null,
    "RedirectURI"				-> "oob",
    "AdditionalOAuthParameter"	-> None,
    "Scope"						-> None,
    "AuthenticationDialog"		-> "TokenDialog",
    "RequestFormat"				-> "URL",
    "LogoutURL"					-> Null,
    "Information"				-> "",
    "AccessTokenExtractor"		-> None,
    "Blocking"          		-> True,
    "tokenread"					-> Identity,
    "RefreshAccessTokenFunction"-> None
};

newunknownoauthauthenticate[name_,opts___] :=
    Module[ {version,authurl,requrl,accessurl,key,secret,redirect,dialogfun,token,urlfetchfun,service,id,dialog,requestformat,info,logouturl,
    extra,scope,atokenext,extraopts,params,temprefreshtoken = None,refreshfun,refreshatoken,uuid,blocking},
        params = {
            "OAuthVersion","AuthorizeEndpoint","RequestEndpoint","AccessEndpoint","ConsumerKey","ConsumerSecret",
            "RedirectURI","AuthenticationDialog","RequestFormat","Information",
            "LogoutURL","AdditionalOAuthParameter","Scope","AccessTokenExtractor","RefreshAccessTokenFunction","Blocking"};
        {version,authurl,requrl,accessurl,key,secret,redirect,dialog,
            requestformat,info,logouturl,extra,scope,atokenext,refreshatoken,blocking} = params/.Flatten[{opts}]/.defaultOAuthOptions;
        uuid = ServiceConnections`Private`makeuuid[];
        extraopts = Append[FilterRules[Flatten[{opts}],Except[params]],"ConnectionID"->uuid];
        If[ !MatchQ[version,"1.0"|"1.0a"|"2.0"|"1"|"2"|1|2|1.|2.],
            Message[ServiceConnect::oauthver,version];
            Throw[$Failed]
        ];
        If[ !StringQ[#],
            Message[ServiceConnect::url,#];
            Throw[$Failed]
        ]&/@{authurl, requrl, accessurl};
        If[ !StringQ[#],
            Message[ServiceConnect::skey,#];
            Throw[$Failed]
        ]&/@{key, secret};
        If[ !StringQ[redirect],
            Message[ServiceConnect::url,redirect];
            Throw[$Failed]
        ];
    	redirect=createRedirect[redirect,uuid, name];
    	If[!StringQ[redirect],Message[ServiceConnect::url,redirect];Throw[$Failed]];

    	dialogfun=getOAuthDialogFun[dialog,{name,uuid}];
        urlfetchfun = getOAuthFetchFun[requestformat, version];
        refreshfun = With[{Name = name, RefAToken = refreshatoken, AccessEndpoint = accessurl, ConsumerKey = key, ConsumerSecret = secret, VerifyOpt = Lookup[extraopts,"VerifyPeer",Automatic]},
        (*"VerifyPeer" set to Automatic by default to avoid SSL connection issues*)
			getOAuthRefreshFun[Name, RefAToken, AccessEndpoint, ConsumerKey, ConsumerSecret, VerifyOpt]
        ];
        token = Which[
            (* authenticate with parameters in request header *)
            MatchQ[requestformat,"Headers"|{"Headers",__}]&&version==="1.0a",
            Block[ {OAuthSigning`Private`HMACSha1SignatureService,$useAuthHeader = requestformat},
                OAuthSigning`Private`initializedQ;
                OAuthSigning`Private`HMACSha1SignatureService[args__] :=
                    With[ {res = OAuthSigning`Private`oAuth10SignURL[args]},
                        Sequence @@ OAuthClient`Private`fromURLtoAuthorizationHeaders[{res}, "1.0a",requestformat]
                    ];
                newAuthenticate[name,version,authurl,requrl,accessurl,key,secret,
                        redirect,{extra,scope},dialogfun,atokenext,blocking,extraopts]
				]
             ,

             (* Get a Refresh Token along with the access token *)
             atokenext === "Refresh/2.0",
             Block[{tokenobject, rawtoken},
                 tokenobject = newAuthenticate[name,version,authurl, requrl,accessurl,key,secret,
                     redirect,{extra,scope},dialogfun,atokenext,blocking,extraopts];
                 rawtoken = Cases[tokenobject,OAuthSigning`Private`Token20[l_List]:>l,Infinity];
                 If[ rawtoken==={},
                     tokenobject,
                     rawtoken = First[rawtoken];
                     temprefreshtoken = formatrefreshtoken[Rest[rawtoken]];
                     Replace[tokenobject,rawtoken:>rawtoken[[1]],Infinity]
                 ]
             ]

            ,
            True,
            (* default user query string *)
            newAuthenticate[name,version,authurl, requrl, accessurl,key,secret,
                redirect,{extra,scope},dialogfun,atokenext,blocking,extraopts]
        ];

		service=ServiceConnections`Private`createServiceObject["OAuth",name,token, uuid, blocking||(!$AllowNonBlockingDialogsQ)];

        id = getServiceID[service];
        urlfetchFun[id] = urlfetchfun;
        refreshFun[id] = refreshfun;
        refreshtoken[id] = temprefreshtoken;
        tokenread[id] = Identity;
        serviceInfo[id] = info;
        logout[id] = logouturl;
        service
    ]


newAuthenticate[name_,version_,authurl_, requrl_, accessurl_,key_,secret_,redirect_,
    {additionalparam_,scope_},dialogfun_, accesstokenext_,blocking_,extraopts_] :=
    Module[ {token, parameters,oauthflowdef,resetflowdef = False, uuid = Lookup[extraopts,"ConnectionID"]},
        parameters =
            If[ MatchQ[version,"1"|"1.0"|"1.0a"|1|1.],
                Join[
                {
                    "ServiceName"       -> name,
                    "OAuthVersion"		-> "1.0a",
                    "RequestEndpoint"   -> requrl,
                    "AccessEndpoint"    -> accessurl,
                    "AuthorizeEndpoint" -> authurl,
                	"RedirectURI"       -> redirect,
                    "ConsumerKey"		-> key,
                    "ConsumerSecret"    ->    secret,
                    "AuthenticationDialog" -> dialogfun,
		        	"Blocking"			-> blocking,
                    If[ accesstokenext=!=None,
                        "AccessTokenExtractor"->accesstokenext,
                        Sequence@@{}
                    ]
                },
                    FilterRules[extraopts,extraoauth1opts]
                ],
                Join[
                {

					"ServiceName"			-> name,
					"OAuthVersion"			-> "2.0",
					"AuthorizeEndpoint"		-> authurl,
					"AccessEndpoint"		-> accessurl,
					"RedirectURI"			-> redirect,
					"ConsumerKey"			-> key,
					"ConsumerSecret"		-> secret,
					"AuthenticationDialog"	-> dialogfun,
					"Blocking"			-> blocking,
					If[ accesstokenext=!=None,
						"AccessTokenExtractor"->accesstokenext,
						Sequence@@{}
					]

                },
                    FilterRules[extraopts,extraoauth2opts]
                ]
            ];

   	 	If[!$AllowNonBlockingDialogsQ,
    		parameters=FilterRules[parameters,Except["Blocking"]]];
        Switch[{additionalparam,scope},
            {_Rule,None|{}},
				(* Add additional parameter to request and access token calls *)
				If[ version==="2.0",
					Throw[$Failed]
				];
				resetflowdef = True;
				oauthflowdef = DownValues[OAuthSigning`Private`OAuthFlow];
				parameters = Join[parameters,{"ScopeParameter" -> additionalparam[[1]]}];
				DownValues[OAuthSigning`Private`OAuthFlow] =
					Join[{HoldPattern[OAuthSigning`Private`OAuthFlow][auth_] :> OAuthSigning`Private`OAuthFlow[auth, {additionalparam[[2]]}]},
					oauthflowdef],
			{None,{__}},
				If[ version=!="2.0",
					Throw[$Failed]
				];
				resetflowdef = True;
				oauthflowdef = DownValues[OAuthSigning`Private`OAuthFlow];
				DownValues[OAuthSigning`Private`OAuthFlow] =
					Join[{HoldPattern[OAuthSigning`Private`OAuthFlow][auth_] :> OAuthSigning`Private`OAuthFlow[auth, scope]},
					oauthflowdef],
			{None,None|{}},
				Null,
			_,
				Message[ServiceConnect::addparam,addparam];
				Throw[$Failed]
		];
        token = tokenread[name]@getauthtoken[parameters,uuid];
        If[ resetflowdef,
            DownValues[OAuthSigning`Private`OAuthFlow] = oauthflowdef
        ];
        If[ Head[token] =!= OAuthSigning`OAuthToken,
            Message[ServiceConnect::token, name];
            Throw[$Failed]
        ];
        token
    ]

authenticationfunction[] :=
    If[ $OAuthCloudCredentialsQ,
        oauthCloudCredentials,
        OAuthSigning`OAuthAuthentication[#1]&
    ]

getauthtoken[parameters_,uuid_] :=
    Block[ {name = "ServiceName"/.parameters, token},
        token = Internal`CheckCache[{"OAuthTokens", name}];
      (*    If[token === $Failed,
             token=checkCloudOAuth[name]; *)
        If[ Head[token] =!= OAuthSigning`OAuthToken,
            token = authenticationfunction[][parameters,uuid];
            If[ token === $Canceled,
                Return[$Canceled]
            ];
            If[ Head[token] =!= OAuthSigning`OAuthToken,
                Return[$Failed]
            ];
            Internal`SetCache[{"OAuthTokens", name}, token]
        (*;
                  Do automatically or require "save"? saveCloudOAuth[name, token]
             ] *)
         ];
        token
    ]

(*********** refresh access token *************)
refreshAccessToken[id_] :=
    Module[ {newtoken,oldtoken,oldtokenobj,oldcache,expdate},
        {newtoken, expdate} = Switch[$OAuthCloudCredentialsQ,True,First@refreshFun[id],False,Last@refreshFun[id]][refreshtoken[id]];
        oldtokenobj = serviceAuthentication[id];
        oldtoken = Cases[oldtokenobj,OAuthSigning`Private`Token20[x_]:>x,Infinity];
        If[ ListQ[oldtoken],
            oldtoken = First[oldtoken]
        ];
        serviceAuthentication[id] = Replace[oldtokenobj,oldtoken->newtoken,Infinity];
        oldcache = Internal`CheckCache[{"OAuthTokens", serviceName[id]}];
        If[ Head[oldcache] =!= OAuthSigning`OAuthToken,
            Internal`SetCache[{"OAuthTokens", serviceName[id]}, serviceAuthentication[id]],
            Internal`SetCache[{"OAuthTokens", serviceName[id]}, Replace[oldcache,oldtoken->newtoken,Infinity]]
        ];
        refreshtoken[id] = {First@refreshtoken[id],expdate};
    ]
$refreshTokenSafetyMargin = 30;(* seconds *)

formatrefreshtoken[{token_,time_?NumberQ}] :=
    {token,Floor[AbsoluteTime[]+time]-$refreshTokenSafetyMargin}/;time<2208988800 (* not an absolute time *)

formatrefreshtoken[expr_] := None

(*************************************************Automatic refresh function generator***********************************************)
cloudAutomaticRefreshfunURL = "https://www.wolframcloud.com/objects/user-00e58bd3-2dfd-45b3-b80b-d281d360703a/oauth20autrefresh";

automaticrefreshfun[AccessEndpoint_,ConsumerKey_,ConsumerSecret_,VerifyOpt_]:=(Block[{data,res,tok,time},
  If[# === None, Return[$Failed]]; (*Verifying that is a valid refreshtoken*)
	res = URLFetch[AccessEndpoint,
		"Method" -> "POST",
        "Parameters" -> {"client_id" -> ConsumerKey,"client_secret" -> ConsumerSecret, "grant_type" -> "refresh_token", "refresh_token"->#[[1]]},
        OAuthSigning`Private`verifyPeerOptions[VerifyOpt]];
	If[StringQ[res],
		data=ImportString[res,"JSON"];
		If[MatchQ[data, _?OptionQ],
			tok="access_token"/.data;
			If[StringQ[tok]&&tok=!="access_token",
				time=ToExpression["expires_in"/.data]+AbsoluteTime[];
				{tok,time},
				$Failed
			],
			$Failed
		],
	$Failed
	]
])&

automaticrefreshfun[Name_,AccessEndpoint_,ConsumerKey_,ConsumerSecret_,VerifyOpt_]:=
  (Block[{reftok},
	reftok = ToExpression@URLFetch[cloudAutomaticRefreshfunURL,"Parameters"->{"Name"->Name,"AccessEndpoint"->AccessEndpoint,"VerifyOpt"->ToString[VerifyOpt,InputForm],"refreshtoken" -> ToString[#[[1]],InputForm],
	Sequence@@If[OAuthClient`Private`$AllowNonBlockingDialogsQ,{"ChannelBrokerQ"->"True"},{}]},"VerifyPeer"->False];
	  Switch[reftok,{_String,_?NumberQ},reftok,_,$Failed]
    ])&

automaticrefreshfun[___] := $Failed
(*************************************************HTTPBasic refresh function generator***********************************************)
cloudHTTPBasicRefreshfunURL = "https://www.wolframcloud.com/objects/user-00e58bd3-2dfd-45b3-b80b-d281d360703a/oauth20httprefresh";

httpbasicrefreshfun[AccessEndpoint_,ConsumerKey_,ConsumerSecret_,VerifyOpt_]:=(Block[{data,res,tok,time},
  If[# === None, Return[$Failed]]; (*Verifying that is a valid refreshtoken*)
	res = URLFetch[AccessEndpoint,
		"Method" -> "POST",
    	"Headers"->{"Authorization"->("Basic "<>ExportString[ConsumerKey<>":"<>ConsumerSecret,"Base64"])},
        "Parameters" -> {"grant_type" -> "refresh_token", "refresh_token"->#[[1]]},
        OAuthSigning`Private`verifyPeerOptions[VerifyOpt]];
	If[StringQ[res],
		data=ImportString[res,"JSON"];
		If[MatchQ[data, _?OptionQ],
			tok="access_token"/.data;
			If[StringQ[tok]&&tok=!="access_token",
				time=ToExpression["expires_in"/.data]+AbsoluteTime[];
				{tok,time},
				$Failed
			],
			$Failed
		],
	$Failed
	]
])&

httpbasicrefreshfun[Name_,AccessEndpoint_,ConsumerKey_,ConsumerSecret_,VerifyOpt_]:=
(Block[{reftok},
	reftok = ToExpression@URLFetch[cloudHTTPBasicRefreshfunURL,"Parameters"->{"Name"->Name,"AccessEndpoint"->AccessEndpoint,"VerifyOpt"->ToString[VerifyOpt,InputForm],"refreshtoken" -> ToString[#[[1]],InputForm],
	Sequence@@If[OAuthClient`Private`$AllowNonBlockingDialogsQ,{"ChannelBrokerQ"->"True"},{}]},"VerifyPeer"->False];
	  Switch[reftok,{_String,_?NumberQ},reftok,_,$Failed]
  ])&

httpbasicrefreshfun[___] := $Failed

(************************************** ServiceDisconnect *****************************)
OAuthClient`oauthdisconnect[service_ServiceObject] := OAuthClient`oauthdisconnect[getServiceName[service],getServiceID[service]]

OAuthClient`oauthdisconnect[name_, id_]:=
    Module[ {link},
        Internal`DeleteCache[{"OAuthTokens", name}];
        serviceName[id] = None;
        serviceRawRequests[id] = {};
        serviceRequests[id] = {};
        serviceRawPosts[id] = {};
        servicePosts[id] = {};
        serviceRawDeletes[id] = {};
        serviceDeletes[id] = {};
        serviceRawPuts[id] = {};
        servicePuts[id] = {};
        serviceAuthentication[id] = {};
        urlfetchFun[id] = URLFetch;
        refreshFun[id] = None;
        serviceInfo[id] = "";
        refreshtoken[id] = None;
        link = hyperlink[logout[id]];
        logout[id] = Null;
        ServiceConnections`Private`$authenticatedservices = DeleteCases[ServiceConnections`Private`$authenticatedservices,id];
        link
    ]


OAuthClient`oauthdisconnect[___] :=
    $Failed

(************************************** ExternalService **********************************)
OAuthClient`oauthdata[service_ServiceObject,"Authentication"] :=
    With[ {auth = serviceAuthentication[getServiceID[service]]},
        parseToken[auth,getServiceName[service]]
    ]


parseToken[token_,name_] :=
    parseToken0[
    Cases[token,(p_OAuthSigning`Private`OAuth10Parameters|p_OAuthSigning`Private`OAuth20Parameters):>p,Infinity],
    name]

parseToken0[{params_OAuthSigning`Private`OAuth10Parameters},name_] :=
    {"OAuthVersion"        ->    "1.0",
    "RequestEndpoint"    ->    params[[9]],
    "AuthorizeEndpoint"    ->    params[[11]],
    "AccessEndpoint"    ->    params[[13]],
    Sequence@@If[ MemberQ[OAuthClient`$predefinedOAuthservicelist,name],
                  {},
                  {"ConsumerKey"->params[[7]],"ConsumerSecret"->params[[8]]}
              ]
    }

parseToken0[{params_OAuthSigning`Private`OAuth20Parameters},name_] :=
    {"OAuthVersion"        ->    "2.0",
    "AuthorizeEndpoint"    ->    params[[9]],
    "AccessEndpoint"    ->    params[[11]],
    Sequence@@If[ MemberQ[OAuthClient`$predefinedOAuthservicelist,name],
                  {},
                  {"ConsumerKey"->params[[7]],"ConsumerSecret"->params[[8]]}
              ]
    }

parseToken[___] :=
    Throw[$Failed]

OAuthClient`oauthdata[service_ServiceObject,property_,rest___] :=
    Module[ {raw, id = getServiceID[service]},
        (* refresh access token if appropriate *)
        If[ ListQ[refreshtoken[id]],
            If[ NumberQ[refreshtoken[id][[2]]],
                If[ AbsoluteTime[]>refreshtoken[id][[2]],
                    refreshAccessToken[id];
                ]
            ]
        ];
        If[ MemberQ[Join[serviceRequests[id],servicePosts[id],serviceDeletes[id],servicePuts[id]], property],
            OAuthClient`oauthcookeddata[getServiceName[service],property,id,rest],
            raw = OAuthClient`rawoauthdata[id,property,rest];
            parsedata[id,property]@raw
        ]
    ]

OAuthClient`oauthdata[args___] :=
    $Failed

OAuthClient`rawoauthdata[id_,parameter_,rest_] :=
    OAuthClient`rawoauthdata[id,parameter,{rest}]/;!ListQ[rest]

OAuthClient`rawoauthdata[id_,url0_String] :=
    Module[ {url, res},
    	If[!StringQ[Interpreter["URL"][url0]],
    		Message[ServiceExecute::invreq,url0, serviceName[id]];
    		Throw[$Failed]
    	];
        url = getsignedurl[url0,serviceAuthentication[id]];
        If[ url === $Failed,
            Throw[$Failed]
        ];
        If[ url === $Canceled,
            Return[$Canceled]
        ];
        (
             res = urlfetchFun[id]@@url;
             res /; (res =!= $Failed)
        ) /; (url =!= $Failed)
    ]/;!MemberQ[ServiceConnections`Private`availablequeries[id],url0]


OAuthClient`rawoauthdata[id_,property_,rest___] :=
    Module[ {url0,method,pathparams,params,bodyparams,mpdata,headers,reqparams,
    url, res, auth, tmp, pvpairs = Flatten[{rest}], params1, bodyparams1,mpdata1,headers1
    ,reqperms,returncontentdata, missingperms, oauth1Q,querydata},
        If[ OAuthClient`$CacheResults,
            res = Internal`CheckCache[{"OAuth", {id, property, rest}}];
            If[ res =!= $Failed,
                Return[res]
            ];
        ];
        querydata = ServiceConnections`Private`getQueryData[id, property];
        {url0,method,pathparams,params,bodyparams,mpdata,headers,reqparams, reqperms, returncontentdata} = Most[querydata];
        (* Check the required permissions *)
        If[ reqperms=!={},
            missingperms = If[ grantedpermissions[id]===All,
                               {},
                               With[ {updated = updatepermissions[id]},
                                   Cases[reqperms,_?(!MemberQ[updated,#]&),1]
                               ]
                           ];
            (* Try to add any missing permissions *)
            If[ missingperms=!={},
                If[ FailureQ[requestpermissions[id,missingperms]],
                    Throw[$Failed]
                ]
            ];
        ];

        (* check for required parameters *)
        If[ !MemberQ[First/@pvpairs,#],
            Message[ServiceExecute::nparam,#];
            Throw[$Failed]
        ]&/@reqparams;


        (* Path Parameters use a StringForm Function *)
        url = If[ Head[url0]===Function,
                  ServiceConnections`Private`insertpathparameters[url0,pathparams,pvpairs],
                  url0
              ];
        params1 = Cases[params,_?(!FreeQ[pvpairs,#]&)];
        params1 = Thread[params1->(params1/.pvpairs)];
        bodyparams1 = Cases[bodyparams,_?(!FreeQ[pvpairs,#]&)];
        bodyparams1 = Thread[bodyparams1->(bodyparams1/.pvpairs)];
        mpdata1=Append[List @@ #, Lookup[pvpairs, First[#]]] & /@ FilterRules[(Rule @@ #) & /@ mpdata, Keys[pvpairs]];
        auth = serviceAuthentication[id];
        If[ FreeQ[auth,OAuthSigning`Private`Token20|OAuthSigning`Private`Token10],
            Message[ServiceExecute::nolink,id];
            Throw[$Failed]
        ];
        oauth1Q = FreeQ[auth,OAuthSigning`Private`Token20|OAuthSigning`Private`OAuth20Parameters];
        If[ oauth1Q,
            url = getsignedurl[url,auth,"Parameters"->Join[params1, bodyparams1], "Method"->method],
            url = getsignedurl[url,auth,"Parameters"->params1,"BodyData"->bodyparams1, "Method"->method]
        ];
        If[ !MatchQ[url,_String|{_String,___}],
            Throw[$Failed]
        ];

        If[!MatchQ[("Parameters"/.Rest@url),"Parameters"],
        	pvpairs = Union[pvpairs,("Parameters"/.Rest@url)]
        ];

        If[ headers=!={},
            (* Headers should have default values, check for given values *)
            headers1 = If[ FreeQ[pvpairs,First[#]],
                           #,
                           First[#]->(First[#]/.pvpairs)
                       ]&/@headers;
            url = Join[url,{"Headers"->headers1}]
        ];
        If[ method==="POST",
            If[ oauth1Q,
                tmp = cutoutparameters1[url[[1]], bodyparams];
                url[[1]] = tmp[[1]];
                url = Join[url,{"BodyData"->tmp[[2]], "MultipartData"->mpdata1}],
                tmp = cutoutparameters2[Rest[url], bodyparams];
                tmp = tmp/.HoldPattern[Rule["BodyData",bd:(_Rule|{_Rule...})]]:>Rule["BodyData",URLQueryEncode[bd]];
                url = If[ mpdata1==={},
                          Join[{url[[1]]},tmp],
                          Join[{url[[1]]},tmp,{"MultipartData"->mpdata1}]
                      ];
                (* workaround for parameter issue *)
                url[[1]] = URLBuild[url[[1]],Normal[KeyDrop["access_token"][Lookup[Rest[url],"Parameters"]]]];
            	(*url=DeleteCases[url,Rule["Parameters",_]];*)
            ]
        ];
        If[ returncontentdata,
            url = Insert[url,"ContentData",2]
        ];
        url = Join[url,{"CredentialsProvider" -> None}];
        If[ url === $Canceled,
            Return[$Canceled]
        ];
        (
             res = urlfetchFun[id]@@url;
             (If[ OAuthClient`$CacheResults,
                  Internal`SetCache[{"OAuth", {id, property, rest}}, res]
              ];
              res) /; (res =!= $Failed)
        ) /; (url =!= $Failed)
    ]/;property=!="Authentication"&&MemberQ[Join[serviceRawRequests[id],serviceRawPosts[id],serviceRawDeletes[id],serviceRawPuts[id]], property]


OAuthClient`rawoauthdata[___] :=
    Throw[$Failed]

parsedata[id_,property_] :=
    (("ResultsFunction"/.oauthservicesdata[serviceName[id],property])/."ResultsFunction"->Identity
    )/;MemberQ[Join[serviceRawRequests[id],serviceRawPosts[id],serviceRawDeletes[id],serviceRawPuts[id]], property]

parsedata[__] :=
    Identity


(**************** Manage Permissions *************)
grantedpermissions[id_] :=
    {}/;!ServiceConnections`Private`authenticatedServiceQ[id]

grantedpermissions[id_] :=
    (grantedpermissions[id] = OAuthClient`checkpermissions[serviceName[id],id])

updatepermissions[id_] :=
    (grantedpermissions[id] = OAuthClient`checkpermissions[serviceName[id],id])/;ServiceConnections`Private`authenticatedServiceQ[id]

requestpermissions[id_,p_] :=
    (OAuthClient`addpermissions[serviceName[id],id,p])/;ServiceConnections`Private`authenticatedServiceQ[id]

updatepermissions[___] :=
    $Failed
requestpermissions[___] :=
    $Failed

(****************** Utilities *********************)
hyperlink[str_String] :=
    Hyperlink[str];
hyperlink[___] :=
    Null
tokenread[id_] :=
    Identity/;!ServiceConnections`Private`authenticatedServiceQ[id]
refreshtoken[id_] :=
    None/;!ServiceConnections`Private`authenticatedServiceQ[id]

fromURLtoAuthorizationHeaders[url_,"2.0"|"2", header0_] :=
    Module[ {params, token,headers,
    rest = Rest[url],header,addheaders,addcontentdata= !FreeQ[url,"ContentData"],method,partialResponse},
				If[addcontentdata,rest = Rest[rest]];
				If[ ListQ[header0],
            header = header0[[2]];
            addheaders = If[ Length[header0]>2,
                             header0[[3]],
                             {}
                         ],
            header = "Oauth";
            addheaders = {}
        ];
        method = "Method"/.rest;
        params = "Parameters"/.rest/."Parameters"->{};
        headers = ("Headers"/.rest)/."Headers"->{};
        token = "access_token"/.params;
        params = FilterRules[params,Except["access_token"]];
        partialResponse = {"Headers"->Join[headers,addheaders,
            {"Authorization"->(header<>" "<>token)}],"Parameters"->params,Sequence@@FilterRules[rest,Except["Parameters"|"Headers"]]};
		If[addcontentdata,PrependTo[partialResponse,"ContentData"]];
        If[ method==="POST",
            Join[{First[url]},partialResponse],
            Join[{URLParse[First[url],"AbsolutePath"]},partialResponse]
        ]
    ]

$oauthfields = {"oauth_consumer_key", "oauth_nonce", "realm","oauth_callback",
"oauth_signature_method", "oauth_timestamp", "oauth_token", "oauth_verifier",
"oauth_version", "oauth_signature"};
fromURLtoAuthorizationHeaders[url_,__,header0_] :=
    Module[ {split,addheaders,header,
    query,auth,headers},
        If[ ListQ[header0],
            header = header0[[2]];
            addheaders = If[ Length[header0]>2,
                             header0[[3]],
                             {}
                         ],
            header = "Oauth";
            addheaders = {}
        ];
        split = URLParse[First[url]];
        query = Lookup[split,"Query",{}];
        auth = FilterRules[query,$oauthfields];
        query = FilterRules[query,Except[$oauthfields]];
        auth = URLQueryEncode[auth];
        headers = ("Headers"/.Rest[url])/."Headers"->{};
        {URLBuild@Join[KeyDrop[split, "Query"], Association["Query" -> query]],
            "Headers"->Join[headers,addheaders,{
          "Authorization"->header<>" "<>StringReplace[auth, {"=" -> "=\"", "&" -> "\","}] <> "\""}],
          Sequence@@FilterRules[Rest[url],Except["Headers"]]
        }
    ]
            (*
fromURLtoAuthorizationHeaders[url_,__,header0_] := Module[{base, auth, headers,
    header,addheaders},
    If[ListQ[header0],header=header0[[2]];
        addheaders=If[Length[header0]>2,header0[[3]],{}],header="Oauth";addheaders={}];
      {base, auth} = StringSplit[First[url], "?"];
      headers=("Headers"/.Rest[url])/."Headers"->{};
    {base,"Headers"->Join[headers,addheaders,{
        "Authorization"->header<>" "<>StringReplace[auth, {"=" -> "=\"", "&" -> "\","}] <> "\""}],Rest[url]}
  ]
  *)


cutoutparameters1[str_, {}] :=
    {str,""}
cutoutparameters1[str_, params0_] :=
    Module[ {tmp, url, body, url0,params},
        params = Join[params0,URLEncode/@params0];
        tmp = StringSplit[str, {"?", "&"}];
        tmp =  GatherBy[tmp, (StringFreeQ[#, StringJoin[#, "="] & /@ params] &)];
        {url0,body} = If[ Length[tmp]===1,
                          {First[tmp],{}},
                          tmp
                      ];
        url = First[url0];
        If[ Length[url0] > 1,
            url = url <> "?" <> url0[[2]];
            If[ Length[url0] > 2,
                url = StringJoin[url,"&", ##] & @@ Riffle[Drop[url0, 2], "&"]
            ]
        ];
        StringReplace[body = StringJoin[Riffle[body, "&"]],"ParameterlessBodyData*="->""];
        {url, body}
    ]

cutoutparameters2[opts_, {}] :=
    opts
cutoutparameters2[opts_, params0_] :=
    Module[ {body,params, urlparams,body0},
        params = Join[params0,URLEncode/@params0];
        body0 = "BodyData"/.opts;
        urlparams = "Parameters"/.opts;
        body = DeleteCases[urlparams,_?(FreeQ[#,Alternatives@@params] &)];
        body = Join[body0,body]/.HoldPattern[Rule["ParameterlessBodyData",x_]]:>x;(*
        body=URLEncode[body/.({"ParameterlessBodyData"->x_}:>x)];*)
        If[ MatchQ[body,{_String}|{{_Integer..}}],
            body = First[body]
        ];
        urlparams = DeleteCases[urlparams, _?(!FreeQ[#,Alternatives@@params] &)];
        Join[{"Parameters"->urlparams, "BodyData"->body},DeleteCases[opts,Rule["Parameters"|"BodyData",_]]]
    ]

(****************************** Token Storage *************************************)
OAuthClient`saveOAuthConnection[service_ServiceObject, location_: Automatic] :=
    Module[ {rescloud, reslocal},
        rescloud = If[ MatchQ[location,All|"Cloud"]||(MatchQ[location,Automatic|True]&&$CloudConnected),
                       saveOAuthConnectionCloud[service],
                       $Failed
                   ];
        If[ MatchQ[location,All|"Local"]||(MatchQ[location,Automatic|True]&&FailureQ[rescloud]),
            reslocal = saveOAuthConnectionLocal[service]
        ];
        If[ FailureQ[rescloud]&&FailureQ[reslocal],
            Message[ServiceConnect::nsave];
            $Failed
        ]
    ]

$StoreFullOAuthConnections = False;
createConnectionData[service_] :=
    Module[ {id = getServiceID[service]},
        Join[Normal[ServiceConnections`Private`servicedata[id]],
                {"urlfetch"->urlfetchFun[id],"logout"->logout[id],
                "RawPropertyData"->((#->ServiceConnections`Private`getQueryData[id,#])&/@Join[serviceRawRequests[id],serviceRawPosts[id],serviceRawDeletes[id],serviceRawPuts[id]])
                }]
    ]

createConnectionTokenData[service_] :=
    Module[ {id = getServiceID[service]},
        {Last[serviceAuthentication[id]],refreshtoken[id]}
    ]

saveOAuthConnectionLocal[service_ServiceObject] :=
    Module[ {id = getServiceID[service], name = getServiceName[service],
    dir, file, temp = FileNameJoin[{$TemporaryDirectory,"m"<>ToString[RandomInteger[1000]]<>".txt"}], data},
        dir = FileNameJoin[{$UserBaseDirectory,"Connections","Services",name}];
        file = FileNameJoin[{dir,id<>".txt"}];
        If[ !DirectoryQ[dir],
            CreateDirectory[dir]
        ];
        If[ FileExistsQ[file],
            DeleteFile[file]
        ];
        data = If[ $StoreFullOAuthConnections,
                   createConnectionData,
                   createConnectionTokenData
               ][service];
        Put[data,temp];
        Encode[temp,file];
        DeleteFile[temp];
    ]

saveOAuthConnectionCloud[service_] :=
    Block[ {id = getServiceID[service], name = getServiceName[service], co, file, temp1, temp2, data,
    OAuthClient`Private`deobflag = True, res,current},
        If[ !$CloudConnected,
            CloudConnect[]
        ];
        If[ !$CloudConnected,
            Return[$Failed]
        ];
        co = CloudObject["connections/services/"<>name];
        current = Quiet[Import[co,"JSON"]];
        If[ FailureQ[current],
            current = {},
            current = DeleteCases[current,Rule[id,_]]
        ];
        data = If[ $StoreFullOAuthConnections,
                   createConnectionData,
                   createConnectionTokenData
               ][service];
        data = OAuthClient`Private`ob[data];
        res = Export[co,Append[current,id->data],"JSON"];
        res/;!FailureQ[res]
    ]

saveOAuthConnectionCloud[___] :=
    $Failed

OAuthClient`loadOAuthConnection[name_,rest___]:=Block[{token=updateTokenContext[loadoauthConnection[name,rest]]},
	If[ MatchQ[token,{_,tokenpattern}],
        token[[2]] = {token[[2]],None}
	];
	If[MatchQ[token,{_,{tokenpattern,_}}],
		importSavedOAuthConnection[name, token, rest]
	]
]

loadoauthConnection[name_,id_:Automatic] :=
    Module[ {res},
        Switch[OAuthClient`$ServiceStorageLocation,
            Automatic|All (* default *),
            If[ $CloudConnected,
                res = loadoauthConnectionCloud[name, id];
                If[ FailureQ[res],
                    loadoauthConnectionLocal[name, id],
                    res
                ],
                res = loadoauthConnectionLocal[name, id];
                If[ FailureQ[res]&&(id=!=Automatic||OAuthClient`$ServiceStorageLocation===All),
                    Message[ServiceConnect::ncloud];
                    res,
                    res
                ]
            ],
            "Cloud",loadoauthConnectionCloud[name, id],
            "Local",loadoauthConnectionLocal[name, id]
        ]
    ]

loadoauthConnectionLocal[name_, fileid_] :=
    Module[ {tmp, dir,file, files},
        dir = FileNameJoin[{$UserBaseDirectory,"Connections","Services",name}];
        If[ DirectoryQ[dir],
            If[ MatchQ[fileid,Automatic|"Connections"],
                files = FileNames["connection-*.txt", dir];
                If[ fileid==="Connections",
                    Throw[FileBaseName/@files]
                ];
                Switch[Length[files],
                    1,file = First[files],
                    0,Return[$Failed],
                    _,If[ $UseLatestSavedConnection,
                          file = files[[Last[Ordering[FileDate /@ files]]]],
                          Message[ServiceConnect::multst,dir];
                          Return["Multiple"]
                      ]
                ],
                file = FileNameJoin[{dir,fileid<>".txt"}];
                If[ !FileExistsQ[file],
                    Message[ServiceConnect::nost,dir];
                    Return[$Failed]
                ]
            ];
            tmp = Get[file];
            {FileBaseName@file,parseStoredConnection[tmp]},
            $Failed
        ]
    ]

loadoauthConnectionCloud[name_, fileid_] :=
    Block[ {co, file, data,
    OAuthClient`Private`deobflag = True, res,stored,fileid1},
        If[ !$CloudConnected,
            CloudConnect[]
        ];
        If[ !$CloudConnected,
            Return[$Failed]
        ];
        co = CloudObject["connections/services/"<>name];
        stored = Quiet[Import[co,"JSON"]];
        If[ FailureQ[stored],
            Return[$Failed]
        ];
        data = If[ MatchQ[fileid,Automatic|"Connections"],
                   If[ fileid==="Connections",
                       Throw[If[ Length[stored]>0,
                                 First/@stored,
                                 {}
                             ]]
                   ];
                   Switch[Length[stored],
                           1,List@@stored[[1]],
                           0,Return[$Failed],
                           _,If[ $UseLatestSavedConnection,
                                 List@@Last[stored],
                                 Message[ServiceConnect::multst,dir];
                                 Return["Multiple"]
                             ]
                       ],
                   stored = Cases[stored,HoldPattern[fileid->_],1];
                   If[ stored==={},
                       Message[ServiceConnect::nost];
                       Return[$Failed]
                   ];
                   If[ MatchQ[stored,{_Rule}],
                       List@@stored[[1]]
                   ]
               ];
        If[ !ListQ[data],
            Return[$Failed],
            {fileid1, data} = data
        ];
        data = OAuthClient`Private`deob[data];
        res = {fileid1, data};
        res/;!FailureQ[res]
    ]

loadoauthConnectionCloud[___] :=
    $Failed

parseStoredConnection[tmp:{_Rule..}] :=
    Module[ {service,servicename,id},
        servicename = "ServiceName"/.tmp;
        id = "ID"/.tmp;
        service = ServiceConnections`Private`createServiceObject["OAuth",servicename, "Authentication"/.tmp, id];
        serviceRawRequests[id] = "RawRequests"/.tmp;
        serviceRequests[id] = "Requests"/.tmp;
        serviceRawPosts[id] = "RawPostRequests"/.tmp;
        servicePosts[id] = "PostRequests"/.tmp;
        serviceRawDeletes[id] = "RawDeleteRequests"/.tmp;
        serviceDeletes[id] = "DeleteRequests"/.tmp;
        serviceRawPuts[id] = "RawPutRequests"/.tmp;
        servicePuts[id] = "PutRequests"/.tmp;
        urlfetchFun[id] = "urlfetch"/.tmp;
        tokenread[id] = "tokenread"/.tmp;
        refreshtoken[id] = "refreshtoken"/.tmp;
        serviceInfo[id] := "Information"/.tmp;
        logout[id] = "logout"/.tmp;
        ServiceConnections`Private`setQueryData[id,#]&/@("RawPropertyData"/.tmp);
        service
    ]

parseStoredConnection[tmp:(tokenpattern|{tokenpattern,_})] :=
    tmp

OAuthClient`deleteOAuthConnection[so_ServiceObject]:=OAuthClient`deleteOAuthConnection[getServiceName[so], getServiceID[so]]

OAuthClient`deleteOAuthConnection[name_String,id_String]:=(
	deleteSavedOAuthConnections[name, id];
	OAuthClient`oauthdisconnect[name, id];

)

deleteSavedOAuthConnections[name_, id_]:=(
	deleteSavedOAuthConnectionsCloud[name, id];
	deleteSavedOAuthConnectionsLocal[name, id]
	)

deleteSavedOAuthConnectionsCloud[name_, id_]:=Block[ { co, file, temp1, temp2,
    OAuthClient`Private`deobflag = True, res,current},
        co = CloudObject["connections/services/"<>name];
        current = Quiet[Import[co,"JSON"]];
        If[ FailureQ[current],
            Null,
            If[FreeQ[current,id],
            	Null
            	,
            	Export[co,DeleteCases[current,Rule[id,_]],"JSON"]
            ]
        ]
    ]/;$CloudConnected

deleteSavedOAuthConnectionsLocal[name_, id_]:=Module[ {dir, file},
        dir = FileNameJoin[{$UserBaseDirectory,"Connections","Services",name}];
        If[ DirectoryQ[dir],
        	file = FileNameJoin[{dir,id<>".txt"}];
        	If[ FileExistsQ[file],
            	DeleteFile[file]
        	]
        ]
    ]
    

OAuthClient`findSavedOAuthConnections[name_String]:=Join[
	findSavedOAuthConnectionsCloud[name],
	findSavedOAuthConnectionsLocal[name]]


findSavedOAuthConnectionsCloud[name_String]:=Block[{co, stored,
	OAuthClient`Private`deobflag = True},
	co = CloudObject["connections/services/"<>name];
    stored = Quiet[Import[co,"JSON"]];
    If[ListQ[stored],
    	Keys[stored],
    	{}
    ]
]/;$CloudConnected

findSavedOAuthConnectionsCloud[_]:={}

findSavedOAuthConnectionsLocal[name_String]:=Block[{dir=FileNameJoin[{$UserBaseDirectory,"Connections","Services",name}],
	files},
	If[DirectoryQ[dir],
		files = FileNames["connection-*.txt", dir];
          If[Length[files]>0,
          	FileBaseName/@files
          	,
          	{}
          ]
		,
		{}
	]	
]


(*********************** Cloud Stored Client credentials *************************)
oauthCloudCredentials[parameters_,uuid_] :=
    Block[ {name = ("ServiceName"/.parameters)},
        If[ MemberQ[OAuthClient`$predefinedOAuthservicelist,name],
            If[ MatchQ[("OAuthVersion"/.parameters),"1.0"|"1.0a"|"1"|1],
                oauth10CloudCredentials[parameters],
                oauth20CloudCredentials[parameters,uuid]
            ],
            OAuthSigning`OAuthAuthentication[parameters]
        ]
    ]

(* OAuth 2.0 *)
cloudAuthorizationBaseURL = "https://www.wolframcloud.com/objects/user-00e58bd3-2dfd-45b3-b80b-d281d360703a/OAuth20/oauth20authurl";
cloudAccessBaseURL = "https://www.wolframcloud.com/objects/user-00e58bd3-2dfd-45b3-b80b-d281d360703a/OAuth20/oauth20accesstoken";

cloudassembleauthurl[rules_,scope_,state_,uuid_] :=
    Block[ {url, json},
		url=URLBuild[cloudAuthorizationBaseURL,Join[rules,{"scope"->scope,"state"->state,"connectionid"->uuid,
			Sequence@@If[OAuthClient`Private`$AllowNonBlockingDialogsQ,{"ChannelBrokerQ"->"True"},{}]}]];
        json = URLFetch[url,"VerifyPeer"->False];
        url = ImportString[json,"JSON"];
        If[ !StringQ[url],
            Throw[$Failed]
        ];
        url
    ]
cloudassembleauthurl[___] :=
    $Failed

cloudaccesstoken[rules_,verifier_,state_] :=
    Block[ {url, stringtoken,accesstoken},
		url=URLBuild[cloudAccessBaseURL,Join[rules,{"verifier"->verifier,"state"->state,
			Sequence@@If[OAuthClient`Private`$AllowNonBlockingDialogsQ,{"ChannelBrokerQ"->"True"},{}]}]];
        stringtoken = URLFetch[url,"VerifyPeer"->False];
        accesstoken = updateTokenContext[ToExpression[stringtoken]];
        (accesstoken)/;MatchQ[accesstoken,_OAuthSigning`Private`Token20]
    ]

cloudaccesstoken[args___] :=
    $Failed

preparescope[{}|None] :=
    "None"
preparescope[str_String] :=
    str
preparescope[{str_String}] :=
    str
preparescope[l:{_String..}] :=
    StringJoin[Riffle[l,"+"]]

authToAuthRules20[auth_] :=
    {
    "ServiceName"->auth[[1]],
    "AuthorizationFunction"->ToString[auth[[16]],InputForm],
    "AuthorizeEndpoint"->auth[[9]],
    "RedirectURI"->auth[[13]],
    "consumerKey"->auth[[7]]
    }

authToAccRules20[auth_] :=
    {
    "ServiceName"->auth[[1]],
    "AccessEndpoint"->auth[[11]],
    "AccessVerb"->auth[[12]],
    "AccessTokenExtractor"->auth[[14]],
    "AccessTokenRequestor"->ToString[auth[[17]],InputForm],
    "RedirectURI"->auth[[13]],
    "VerifyPeer"->ToString[auth[[3]],InputForm],
    "consumerKey"->auth[[7]],
    "consumerSecret"->auth[[8]]
    }

oauth20CloudCredentials[parameters_,uuid_] :=
    Block[ {OAuthSigning`Private`assembleAuthorizationURL20, OAuthSigning`Private`getAccessToken20},
        OAuthSigning`Private`assembleAuthorizationURL20[before_,
            auth_OAuthSigning`Private`OAuth20Parameters, token_, scope_, state_] :=
            (
            cloudassembleauthurl[
            	authToAuthRules20[auth],ToString[scope,InputForm],ToString[state,InputForm],ToString[uuid,InputForm]]);
        OAuthSigning`Private`getAccessToken20[auth_, token_, verifier_, state_] :=
            cloudaccesstoken[authToAccRules20[auth],verifier,ToString[state,InputForm]];
        OAuthSigning`OAuthAuthentication[parameters]
    ]

(* OAuth 1.0 *)
cloudSignBaseURL="https://www.wolframcloud.com/objects/user-00e58bd3-2dfd-45b3-b80b-d281d360703a/OAuth10/URLSigner";

cloudsignurl[name_,unsignedURL_, signatureMethod_, accessVerb_, consumerKey_, consumerSecret_, keyStr_, secretStr_] :=
    Block[ {url, json},
		url=URLBuild[cloudSignBaseURL,{
			"name"->name,"unsignedURL"->unsignedURL,"signatureMethod"->signatureMethod,"accessVerb"->accessVerb,
			"consumerKey"->consumerKey,"consumerSecret"->consumerSecret,"keyStr"->keyStr,"secretStr"->secretStr,
			"ChannelBrokerQ"->ToString[OAuthClient`Private`$AllowNonBlockingDialogsQ]}];
        json = URLFetch[url,"VerifyPeer"->False];
        url = ImportString[json,"JSON"];
        If[ !StringQ[url],
            Throw[$Failed]
        ];
        url
    ]

oauth10CloudCredentials[parameters_] :=
    Block[ {OAuthSigning`Private`HMACSha1SignatureService},
        With[ {name = "ServiceName"/.parameters},
            OAuthSigning`Private`HMACSha1SignatureService[
                unsignedURL_, signatureMethod_, accessVerb_, consumerKey_, consumerSecret_, keyStr_, secretStr_] :=
                If[ $useAuthHeader=!=False,
                    (Sequence @@ OAuthClient`Private`fromURLtoAuthorizationHeaders[{#}, "1.0a",$useAuthHeader])&,
                    Identity
                ]
                [cloudsignurl[name,unsignedURL,signatureMethod,accessVerb,consumerKey, consumerSecret, keyStr, secretStr]]
        ];
        OAuthSigning`OAuthAuthentication[parameters]
    ]

getsignedurl[url_,auth_, opts___] :=
    Block[ {OAuthSigning`Private`HMACSha1SignatureService, name = auth[[1,1]], version},
        OAuthSigning`Private`HMACSha1SignatureService[
            unsignedURL_, signatureMethod_, accessVerb_, consumerKey_, consumerSecret_, keyStr_, secretStr_] :=
            If[ $useAuthHeader=!=False,
                (Sequence @@ OAuthClient`Private`fromURLtoAuthorizationHeaders[{#}, "1.0a",$useAuthHeader])&,
                Identity
            ]
            [cloudsignurl[name, unsignedURL,signatureMethod,accessVerb,consumerKey, consumerSecret, keyStr, secretStr]];
        OAuthSigning`OAuthSignURL[url, "OAuthAuthentication" -> auth, opts]
    ]/;$OAuthCloudCredentialsQ&&!FreeQ[auth,_OAuthSigning`Private`OAuth10Parameters]

getsignedurl[url_,auth_, opts___] :=
    OAuthSigning`OAuthSignURL[url, "OAuthAuthentication" -> auth, opts]



getOAuthDialogFun[dialog_,{connectionname_,connectionid_}]:=Switch[{dialog,$CloudEvaluation},
				{"TokenDialog",True},
				OAuthClient`tokenOAuthDialog[#, {connectionname,connectionid}]&,
				{"TokenDialog",_},
				OAuthClient`tokenOAuthDialog[#, connectionname]&,
		        {"WolframConnectorChannel",_},
		        OAuthClient`oauthChannelVerify[#, {connectionname,connectionid}]&,
				{Except[_String],True},
				(dialog/.HoldPattern[OAuthClient`tokenOAuthDialog][first_,second_String, rest___]:>OAuthClient`tokenOAuthDialog[first,{second, connectionid}, rest]),
				{Except[_String],_},dialog,
				_,
				Message[ServiceConnect::dialog,dialogfun];Throw[$Failed]
			]

getOAuthFetchFun[requestformat_, version_]:=
        Switch[requestformat,
            "URL",
            URLFetch,
            "Headers"|{"Headers",__},
            With[ {v = version,
                (* do not include extra headers, they are only for authorization *)
                r = If[ ListQ[requestformat],
                        requestformat[[1;;2]],
                        requestformat
                    ]},
                (With[ {newurl = fromURLtoAuthorizationHeaders[{##}, v,r]},
                     URLFetch@@newurl
                 ]&)
            ],
            _Function,
            requestformat,
            _,
            Message[ServiceConnect::reqform,requestformat];
            Throw[$Failed]
        ];

getOAuthRefreshFun[Name_, RefAToken_, AccessEndpoint_, ConsumerKey_, ConsumerSecret_, VerifyOpt_]:=
		Switch[RefAToken,
              None,
                {(Null)&},
	  	        Automatic,
	  	        	{automaticrefreshfun[Name,AccessEndpoint,ConsumerKey,ConsumerSecret,VerifyOpt],
	  	            	automaticrefreshfun[AccessEndpoint,ConsumerKey,ConsumerSecret,VerifyOpt]
	  	        },
	  	        "HTTPBasic",
	  	        {httpbasicrefreshfun[Name,AccessEndpoint,ConsumerKey,ConsumerSecret,VerifyOpt],
	  	            	httpbasicrefreshfun[AccessEndpoint,ConsumerKey,ConsumerSecret,VerifyOpt]
	  	        },
	  	        {_Function,_Function},
	  	        RefAToken,
	  	        _,
	  	        Message[ServiceConnect::reffun,RefAToken];
	  	        Throw[$Failed]
			];


End[];
End[];

SetAttributes[{
  OAuthClient`saveOAuthConnection,OAuthClient`loadOAuthConnection,OAuthClient`oauthdata
},
   {ReadProtected, Protected}
];