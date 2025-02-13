Package["TextSearch`"]

PackageImport["Macros`"]

PackageExport["ContentObject"]

PackageExport["SearchResultObject"]

PackageScope["getFileMetadata"]

PackageScope["bytesToSize"]
(* copied from crypto, this shoudl go into Developer`, of course *)
$ByteQuantityStrings = {"bytes", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"};
bytesToSize[bytes_Integer] := Module[{i, k = 1000.},
    If[bytes == 0, "0 bytes",
        i = Floor[Log[bytes]/Log[k]];
        If[i == 0, ToString[bytes]  <> " bytes",
            ToString[NumberForm[N[bytes/k^i], {4, 1}]] <> " " <> $ByteQuantityStrings[[i + 1]]
        ]
    ]
];

forceQuantity[q_, u_] := System`Private`SetValid[Unevaluated[Quantity[q, u]]];

$ByteQuantityUnits = {"Bytes", "Kilobytes", "Megabytes", "Gigabytes", "Terabytes"};
bytesToQuantity[bytes_Integer] := Module[{i, k = 1000.},
    If[bytes == 0, forceQuantity[0, "Bytes"],
        i = Floor[Log[bytes]/Log[k]];
        If[i == 0, forceQuantity[bytes, "Bytes"],
            forceQuantity[N[bytes/k^i], $ByteQuantityUnits[[i + 1]]]
        ]
    ]
];

ContentObject::invpath  = "`Path` is not a valid path to a file";
contentObjectFailure["Invalid path", path_] := Failure[ContentObject, <|"MessageTemplate" :> ContentObject::invpath, "MessageParameters" -> <|"Path" -> path|>|>]


PackageExport["ValidContentObjectQ"]

ValidContentObjectQ[c:ContentObject[_Association ? AssociationQ]] := holdValidQ[c];
ValidContentObjectQ[_] := False;

SetAttributes[{holdValidQ, holdNotValidQ}, HoldAllComplete];

holdValidQ[e_] := System`Private`ValidQ[Unevaluated[e]];
holdNotValidQ[e_] := !System`Private`ValidQ[Unevaluated[e]];


(c:ContentObject[assoc_] ? holdValidQ)[prop_String ? StringQ] := 
    Block[{$assoc = assoc, $co = c}, getProperty[prop]];

(* Get multiple properties *)
(c:ContentObject[assoc_] ? holdValidQ)[propList_List] := 
    Block[{$assoc = assoc, $co = c}, getProperty /@ propList];

(* constructors *)
(* file -> ContentObject *)
ContentObject[File[path_String]] ? holdNotValidQ := Which[
    !StringQ[path] || FileType[path] =!= File,
        contentObjectFailure["Invalid path", path],
    True,
        (* The 'includeContent' argument of ReadFileFields needs
           to be True here so that the "Plaintext" key will have
           a value. Otherwise, if you were to use
           ContextObject[File[...]] as a source object in
           a CreateSearchIndex call, it would evaluate to something
           with no "Plaintext" value, and thus wouldn't be searchable.
           Note that, at least for text files, ReadFileFields here is
           setting "Plaintext" -> Text[File[filename_String]] rather
           than populating "Plaintext" with the actual content. That
           has the advantage that a person could create lots of
           ContentObject[File[...]] objects without running into
           memory issues, although it might also be viewed as strange
           for a user to get back a "Plaintext" value that doesn't
           actually have the plaintext. *)
        constructContentObject[ReadFileFields[path, True]]
]

ContentObject[str_String] ? holdNotValidQ := 
	constructContentObject[<|"Plaintext" -> str, "CreationDate" -> Now|>];

ContentObject[assoc_Association] ? holdNotValidQ := 
	constructContentObject[assoc] /; AssociationQ[assoc];

(*
ContentObject::invcnt = "`` is not a string or File.";
ContentObject[expr_] ? holdNotValidQ := RuleCondition[Message[ContentObject::invcnt, expr]; Fail];
*)

ContentObject[] := RuleCondition[ArgumentCountQ[ContentObject, 0, 1, 1]; Fail];
ContentObject[_, args__] := RuleCondition[ArgumentCountQ[ContentObject, 1 + Length[{args}], 1, 1]; Fail];


constructContentObject[assoc_Association ? AssociationQ] := System`Private`SetValid[Unevaluated[ContentObject[assoc]]];
constructContentObject[_] := $Failed;


getProperty[prop_] := Lookup[$assoc, prop, getDerivedProperty[prop]];

getDerivedProperty[prop_] := 
	Lookup[$DerivedProperties, prop, Missing["UnknownProperty", prop]] // 
	Replace[Hold[src_, test_, f_] :> (
		getProperty[src] // 
		If[test[#], f[#], Missing["NotAvailable", prop]]&
	)];

PackageExport["$DerivedProperties"]

$DerivedProperties = Association[
	"Plaintext" ->  Hold["Location", fileQ, ReadPlaintext],
	"Snippet" :>    Snippet[$co], (* special cased, so we can avoid reading in whole file *)
	"FileSize" ->   Hold["FileByteCount", IntegerQ, bytesToQuantity],
	"FileName" ->   Hold["Location", StringQ, FileNameDrop],
	"WordCloud" ->  Hold["Plaintext", StringQ, DeleteStopwords /* WordCloud]
];

fileQ[path_String | File[path_String]] := True;

ContentObject /: SystemOpen[ContentObject[assoc_Association ? AssociationQ] ? holdValidQ] :=
	SystemOpen @ ExpandFileName @ Lookup[assoc, "Location", Return[$Failed]];


ContentObject /: MakeBoxes[expr:ContentObject[assoc_Association ? AssociationQ] ? holdValidQ, StandardForm] := 
    formatContentObject[expr, assoc];
   
formatContentObject[expr_, assoc_] := Block[{$assoc = assoc, shorts, longs},
	shorts = makeItems[shortItem];
	longs = makeItems[longItem];
	If[shorts === {} && longs =!= {}, shorts = Take[longs, 1]; longs = Rest[longs]];
	BoxForm`ArrangeSummaryBox[
		ContentObject, expr, 
		$contentObjectIcon, 
		shorts, longs,
		StandardForm
	]
];

makeItems[f_] := toItem /@ KeyValueMap[f, $assoc];

toItem[k_ -> v_] := BoxForm`SummaryItem[{k <> ": ", formatMissing[v]}];
toItem[_] := Nothing;
formatMissing[x_] := x;
formatMissing[m_Missing] := Interpretation[Evaluate @ Style["missing", Gray, FontFamily -> "Verdana"], m];

makeSystemHyperlink[File[path_String]] := makeSystemHyperlink[path];

$FullHomeDirectory = $HomeDirectory <> $PathnameSeparator;
makeSystemHyperlink[path_String] := With[
	{full = ExpandFileName[path], short =
	short = If[StringStartsQ[path, $FullHomeDirectory],
		"~" <> StringDrop[path, StringLength[$HomeDirectory]], path]},
	ToBoxes[Hyperlink[short], StandardForm] //
	Insert[Evaluator -> Automatic, {1,2}] //
	Insert[ButtonFunction -> Function[SystemOpen[full]], {1,2}]
] // RawBoxes // Style[#, FontFamily -> "Courier"]&;

makeSystemHyperlink[e_] := e;

longItem["Location", p_String | File[p_String] | URL[p_String]] := "Location" -> makeSystemHyperlink[p];
longItem["FileName", p_] := Nothing;
longItem["Plaintext", _] := Nothing;
longItem[name_, do_DateObject] := name -> DateString[do, "DateTimeShort"];
longItem[name_, p_] := name -> p;

shortItem["Plaintext", p_String | p_File] := "Plaintext" -> Snippet[p, 2, PageWidth -> 20];
shortItem["FileName", p_String] := "FileName" -> p;
shortItem["FileByteCount", p_Integer] := "FileSize" -> bytesToSize[p]; (*bytesToQuantity loading Quantity takes a LONG time *)
shortItem[name_, p_] := Nothing;

SearchResultObject /: MakeBoxes[expr_SearchResultObject, StandardForm] :=
    formatSearchResultObject[expr];

takeAtMost[l_, n_] := l[[1 ;; Min[n, Length@l]]]

formatSearchResultObject[res_] := Block[{shorts, longs},
	shorts = { toItem["Result count" -> res["Count"]] };
	longs = {Dataset @ Map[
		KeySortBy[#, Position[keyOrder, #]&]&,
		takeAtMost[res[All], 10][[All, 1]]]};
	If[shorts === {} && longs =!= {}, shorts = Take[longs, 1]; longs = Rest[longs]];
	BoxForm`ArrangeSummaryBox[
		SearchResultObject, res,
		$contentObjectIcon,
		shorts, longs,
		StandardForm
	]
];
