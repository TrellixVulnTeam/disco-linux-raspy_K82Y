(* Wolfram Language Package *)

(Unprotect[#]; Clear[#])& /@ {}


BeginPackage["ResourceSystemClient`"]

Begin["`Private`"] (* Begin Private Context *) 

ClearAll[loadResourceType];

loadResourceType[rtype_String]:=Block[{pacletname=pacletName[rtype], contextname=contextName[rtype], res},
	res=checkPaclet[pacletname];
	If[res===$Failed,
		$Failed;
		loadResourceType[rtype]=$Failed;
		,
		Needs[contextname];
		addToResourceTypes[rtype];
		loadResourceType[rtype]=Null;
	]
]

pacletName["DataResource"]="DataResource";
contextName["DataResource"]="DataResource`";


pacletName[rtype_]:=rtype;
contextName[rtype_]:=rtype<>"`";

checkPaclet[pacletname_]:=Block[{paclets},
	paclets=PacletManager`PacletFind[pacletname];
	If[Length[paclets]>0,
		Return[]];
	paclets=PacletManager`PacletFindRemote[pacletname];
	If[Length[paclets]>0,
		PacletManager`PacletInstall[pacletname]
		,
		Message[ResourceObject::unkrt,pacletname];
		$Failed
		]
]

$availableResourceTypes={None};
addToResourceTypes[rtype_]:=($availableResourceTypes=DeleteDuplicates[Flatten[{$availableResourceTypes,rtype}]])

End[] (* End Private Context *)

EndPackage[]

SetAttributes[{},
   {ReadProtected, Protected}
];