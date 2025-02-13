(* Wolfram Language Package *)

(Unprotect[#]; Clear[#])& /@ {}

BeginPackage["ResourceSystemClient`"]
(* Exported symbols added here with SymbolName::usage *)  

Begin["`Private`"] (* Begin Private Context *) 

submissionInfo[_]:=Association[]

getSubmissionInfo[id_]:=Block[{res, url},
	res=apifun["GetSubmission",{"SubmissionID"->id,"Element"->"Submission"},System`ResourceSubmissionObject];
	If[KeyExistsQ[res,"ResourceType"],
		loadResourceType[res["ResourceType"]];
		System`ResourceSubmissionObject[res]
		,
		$Failed
	]
]


submissionRequest[info_,"Status",args_]:=getSubmissionStatus[Lookup[info,"UUID",Lookup[info,"SubmissionID"]]]

submissionRequest[info_,req_,args_]:=(Message[ResourceSubmissionObject::unkreq,req];$Failed)

importSubmission[str_]:=getSubmissionInfo[str]


getSubmissionStatus[id_String]:=Block[{res},
	res=apifun["SubmissionStatus",{"SubmissionID"->id}, System`ResourceSubmissionObject];
	If[KeyExistsQ[res,"SubmissionStatus"],
		Lookup[res["SubmissionStatus"],"Submission"]
		,
		Missing["Not Found"]
	]
]

getSubmissionStatus[___]:=$Failed


End[] (* End Private Context *)

EndPackage[]

SetAttributes[{},
   {ReadProtected, Protected}
];