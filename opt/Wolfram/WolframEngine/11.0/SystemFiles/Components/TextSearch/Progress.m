Package["TextSearch`"]

PackageExport["$DisableProgressBar"]

$DisableProgressBar = False;

PackageScope["displayProgressBar"]
PackageScope["deleteProgressBar"]
PackageScope["incrementProgressBar"]
PackageScope["setProgressBarText"]

$FEQ := $FEQ = (Head[$FrontEnd] === FrontEndObject);
$ProgressQ := ($FEQ && !TrueQ[$DisableProgressBar]);
$temporaryCell = None;
$pbProgress = 0;
$pbText = "";

(* using similar style as that used in DataPaclets`PrintInitializationStatus *)
displayProgressBar[files_List] := If[$ProgressQ,
	deleteProgressBar[];
	With[{n = Length[files], nstr = IntegerString[Length[files]]},
	(* avoid creating a progress bar if we have a smallish job *)
	If[n < 50 && Quiet[Total[FileByteCount /@ files]] < 5000000, Return[]];
	$pbProgress = 0;
	$pbText = "";
	$pbInfo = {0, "0", ""};
	$temporaryCell = PrintTemporary @ RawBoxes @ 
		DynamicBox[RowBox[{
			ProgressIndicatorBox[$pbInfo[[1]], {0, n}], 
			"    ",
			RowBox[{$pbInfo[[2]], "/", nstr}],
			"    ", 
			StyleBox[
				$pbInfo[[3]],
				FontFamily -> "Verdana", FontSize -> 11,
				FontColor -> RGBColor[0.2, 0.4, 0.6]
			]
		}], TrackedSymbols :> {$pbInfo}]
	];
];

$trigger = 0;
incrementProgressBar[$ExplicitFile[path_]] := incrementProgressBar[path];
incrementProgressBar[path_String, increment_Integer:1] := If[$ProgressQ, Module[{at},
	$pbProgress += increment;
	at = AbsoluteTime[];
	If[at > $trigger, 
		$trigger = at + 0.2;
		$pbInfo = {$pbProgress, IntegerString[$pbProgress], If [path === "", "", ToBoxes[FileNameTake[path]]]};
	];
]];

deleteProgressBar[] := If[$ProgressQ && $temporaryCell =!= None, 
	NotebookDelete[$temporaryCell]; $temporaryCell = None;
];

setProgressBarText[text_] := If[$ProgressQ,
	$pbInfo = {$pbProgress, IntegerString[$pbProgress], ToBoxes[text]};
	$trigger = 0; (* force the next increment to take effect immediately *)
	(*FrontEndExecute[FrontEnd`UpdateDynamicObjects[{}]];*)
];

