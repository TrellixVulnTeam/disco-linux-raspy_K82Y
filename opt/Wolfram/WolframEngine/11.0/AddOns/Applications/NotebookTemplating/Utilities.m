(* Mathematica Package *)

BeginPackage["NotebookTemplating`Utilities`",{ "ResourceLocator`","NotebookTemplating`"}]
(* Exported symbols added here with SymbolName::usage *) 

GetEvaCellLabel::usage = "GetEvaCellLabel[ cell] returns the CellFrameLabel information for evaluatable cell"

evaluationTags::usage = "evaluationTags lists all the valid tags used to set the input cell behavior. "

deleteTags::usage = "deleteTags deletes all the report tags, including TemplateNameBlock tags and evaluation tags."

updateTemplateOptions::usage = "updateTemplateOptions rewrites the TaggingRules etc. for generated notebooks."

getRepeatingBlockLabel::usage = "getRepeatingBlockLabel[expr] extracts the CellFrameLabels information of the repeating block  "

reportInputMenuResource::usage = "  "

evaluationTooltipResource::usage = "evaluationTooltipLabels  "


ProcessWithFrontEnd::usage = "ProcessWithFrontEnd[expr] processes expr with a FrontEnd."

inheritQ::usage = "inheritQ  "

varLabelQ::usage = "varLabelQ  "

varLabel::usage = "varLabel  "

expLabelQ::usage = "expLabelQ  "

expLabel::usage = "expLabel  "

removeLabelsRB::usage = "removeLabelsRB  "

repeatingLabelQ::usage = "Check if the cell frame label indicates a repeating block"

$evaluationStyle::usage = "The default evaluation styles"

displayForms::usage = "displayForms  "

removeLabelsEvaCell::usage = "removeLabelsEvaCell  "

GetEvaCellTaggingRls::usage = "GetEvaCellTaggingRls  "

isEvaluationStyle::usage = "Checks if Cell is evaluatable"


Begin["`Private`"] (* Begin Private Context *) 

Needs["GeneralUtilities`"]

SetAttributes[ ProcessWithFrontEnd, HoldFirst]

ProcessWithFrontEnd[ expr_] :=
	If[ CloudSystem`$CloudNotebooks === True,
		expr,
		UsingFrontEnd[expr]
	]

GetEvaCellLabel[ cell_Cell] :=
    Module[ { cellOptions, cellFrameLabel,box, lab},
        cellOptions = getCellOptions[cell];
        cellFrameLabel = CellFrameLabels/.cellOptions;
        lab = If[ MatchQ[cellFrameLabel,{{_, _}, {_, _}}],
                  box = cellFrameLabel[[1,1]];
                  Replace[box, Cell[BoxData[
                    TemplateBox[{x_}, "NotebookTemplateCellBehavior", ___]]] :> x],
                  None      
              ];
        If[lab===None,lab={}];
        lab
    ]
	
GetEvaCellTaggingRls[cell_Cell]:= 
	Module[{ cellOptions, taggingRules, res},
		cellOptions = getCellOptions[cell];
		taggingRules = TaggingRules/.cellOptions;
		res = If[MatchQ[taggingRules, TaggingRules],
			{},
			Select[taggingRules, MemberQ[evaluationTags, #[[1]]] &]
		];
		If[MatchQ[res, {_Rule}],
    	res[[1,1]],
    	-1]

	]			

getCellOptions[ Cell[contents_, style_, ___, options___Rule] ] := {options}

getCellOptions[ Cell[contents_] ] := {}


    
$evaluationStyle := {"Input", "Code"}

(*TODO: Should probably be found from the StyleSheet (Inherrited Value) or Evaluatable ->True*)
isEvaluationStyle[style_]:=(MemberQ[$evaluationStyle, style])

displayForms := {InputForm, OutputForm, StandardForm, TraditionalForm}	    
    
reportInputMenuResource := {"reportInputMenuDelete","reportInputMenuHide","reportInputMenuUnevaluated","reportInputMenuExclude","reportInputMenuRemove"}

evaluationTooltipResource := {"evaluationTooltipLabelsDelete","evaluationTooltipLabelsHide","evaluationTooltipLabelsUnevaluated","evaluationTooltipLabelsExclude"}
               
evaluationTags := { "EvaluateDeleteInput", "EvaluateHideInput", "Unevaluated", "ExcludeCell"}

removeLabelsEvaCell[c_Cell]:=DeleteCases[c,Rule[CellFrameLabels,___]];    
removeLabelsEvaCell[other__]:=(other)

deleteTags[Cell[CellGroupData[cell_List, b___], c___], evaluationTags_] := 
 Cell[CellGroupData[
   deleteTags[#, evaluationTags] & /@ cell, b], c]

deleteTags[exp_Cell, evaluationTags_] := 
 Module[{tag, expNew}, 
 	tag = GetEvaCellLabel[exp];
 	expNew = 
 	If[ MatchQ[tag, _String] && MemberQ[evaluationTags, tag],
 	removeLabelsEvaCell[exp], exp
 	];
 	expNew
  ]

deleteTags[x_List, evaluationTags_] := 
 deleteTags[#, evaluationTags] & /@ x
 
deleteTags[Notebook[a_List, c___],evaluationTags_] := 
 Notebook[deleteTags[#, evaluationTags] & /@ a, c] 

deleteTags[x___, evaluationTags_] := x 

Options[updateTemplateOptions] = {
	"NotebookTemplate" -> False
};
updateTemplateOptions[ nb_, o:OptionsPattern[]] := 
	ReplaceAll[ nb, 
	(* Retain "NotebookTemplateVersion" to identify nbs generated by the system ... *)
    (*("NotebookTemplateVersion"->_) -> ... *)
    (* ... but Clobber "NotebookTemplate" unless template output is requested *)
    If[TrueQ@OptionValue["NotebookTemplate"], 
    	(Rule[TaggingRules, {opt___, "NotebookTemplate" -> _, opt2___}]) -> (Rule[TaggingRules, {opt, "NotebookTemplate" -> True, opt2}]),
    	(*else*)
    	{(Rule[ TaggingRules, {opt___, "NotebookTemplate" -> _, opt2___}]) -> (Rule[TaggingRules, {opt, opt2}]),
    	(*Clobber DockedCells*)
    	(DockedCells -> _) -> Sequence[]}
    	]]

getRepeatingBlockLabel[Cell[CellGroupData[{a_, b___}, ___],___]]:=
	getRepeatingBlockLabel[a]

getRepeatingBlockLabel[expr_] := Module[{lables, labelsNew},
  (*TODO: other way to grab label info without Off*)  
  Off[Options::optnf];
  lables = Options[expr, CellFrameLabels];
  labelsNew = If[MatchQ[lables, {}], {}, ( CellFrameLabels /. lables)[[2, 2]]] 
  ]
  
inheritQ[ce_Cell]:=
	Module[{inheritance},
		inheritance = ce/.Cell[BoxData[TemplateBox[{var_,type_,inher_}, "NotebookRepeatingBlock", ___]]] :> inher;
		If[Not[MemberQ[{True,False},inheritance]],inheritance = True];
		inheritance	
	]
	
inheritQ[{}]:= True

varLabelQ[Cell[BoxData[TemplateBox[{arg_, "NotebookTemplateSlot", inherit_}, "NotebookRepeatingBlock", ___]]]] := True

varLabelQ[x___] := False

varLabel[Cell[BoxData[TemplateBox[{x_, "NotebookTemplateSlot", inherit_}, "NotebookRepeatingBlock", ___]]]] := x

expLabelQ[ Cell[BoxData[TemplateBox[{arg_, "NotebookTemplateExpression", inherit_},"NotebookRepeatingBlock", ___]]]] := True

expLabelQ[x___] := False

expLabel[Cell[BoxData[TemplateBox[{var_, "NotebookTemplateExpression", inherit_},"NotebookRepeatingBlock", ___]]]] :=
    ToExpression[var]
    
expLabel[{}] := {}

removeLabelsRB[ce_] := 
	Module[{removeLabel},
		removeLabel = ReplaceAll[ce,
			Rule[CellFrameLabels, {{left_, right_}, {bottom_, top_}}] :> Rule[CellFrameLabels, {{left, right}, {bottom, None}}]];
		DeleteCases[removeLabel, Rule[CellBracketOptions, _]]	
	]

repeatingLabelQ[label_] :=
	varLabelQ[label] || expLabelQ[label]	  


TemplateNotebookQ[nb_NotebookObject] := 
    Module[ {tagRules},
    	tagRules = TaggingRules /. Options[nb, TaggingRules];
    	Length[Cases[ tagRules, f_["NotebookTemplate",True]]] > 0
    ]

TemplateNotebookQ[Notebook[{args___}, o___Rule]] := 
    Module[ {tagRules},
        tagRules = TaggingRules /. {o};
        Length[Cases[ tagRules, f_["NotebookTemplate",True]]] > 0
    ]

TemplateNotebookQ[nb_String] /; FileExistsQ[nb] := 
    TemplateNotebookQ[Import[nb]];
    
TemplateNotebookQ[___] := False;

GroupedCells[nb_NotebookObject] := 
 Module[{cells, cellObjects, toObj, counter}, 
  cells = First[NotebookGet[nb]];
  cellObjects = Cells[nb];
  toObj[a_List] := toObj /@ a;
  toObj[Cell[CellGroupData[a_List, b___], c___]] := 
   Cell[CellGroupData[toObj[a], b], c];
  toObj[a_Cell] := cellObjects[[counter++]];
  counter = 1;
  toObj[cells]]

collectInputOutputGps[nb_NotebookObject] := 
 Module[{inputCells, groupedCells, ot}, 
  inputCells = Cells[nb, CellStyle -> "Input"];
  groupedCells = GroupedCells[nb];
  Cases[groupedCells, 
   Cell[CellGroupData[{cell_ /; MemberQ[inputCells, cell], 
       others___CellObject}, ___]] :> (ot = {others}; 
     Rule[cell, If[Length[ot] === 1, ot[[1]], ot]]), Infinity]]


(*TODO:remove function def once it's built into Mma GeneralUtilities*)

ClearAll[MessageHandler];

SetAttributes[WithMessageHandler, HoldFirst];

MessageHandler[f_, id_][
   Hold[Message[msg : MessageName[symbol_, name_], args___], _]] := 
  If[! MessageQuietedQ[msg, id + 1], 
   f[Failure[
     symbol, <|"MessageTemplate" :> msg, 
      "MessageParameters" -> {args}, 
      "Stack" -> Internal`QuietStatus[]|>]]];

WithMessageHandler[body_, f_] := 
  Quiet@With[{id = MessageStackID[]}, 
    Internal`WithLocalSettings[
     Internal`AddHandler["Message", MessageHandler[f, id]], body, 
     Internal`RemoveHandler["Message", MessageHandler[f, id]]]];


(*If returned the last message twice if it's generated by the last \
input of the nb, because of how NotebookEvaluate works*)

getMessages[nb_NotebookObject] := 
 Module[{inOuts, inputCells, notebookMessages, SaveMessage, res},
  notebookMessages = {};
  SaveMessage[f_Failure] := 
   AppendTo[notebookMessages, EvaluationCell[] -> f];
  WithMessageHandler[NotebookEvaluate[nb, InsertResults -> True], 
   SaveMessage];
  res = Normal[GroupBy[notebookMessages, First -> Last]];
  res = Map[(If[Length[#[[2]]] === 1, 
       Rule[#[[1]], #[[2]][[1]]], #]) &, res];
  inOuts = collectInputOutputGps[nb];
  If[MatchQ[inOuts, {Rule__}], 
   inputCells = collectInputOutputGps[nb][[All, 1]];
   Select[res, MemberQ[inputCells, #[[1]]] &] /. 
    collectInputOutputGps[nb], {}]]

TemplateMessageAction[nb_NotebookObject, "Encapsulate"] := 
 Module[{mgs, i, outs, first}, mgs = getMessages[nb];
  For[i = 1, i <= Length[mgs], i++,
   outs = mgs[[i]][[1]];
   first = If[Length[outs] > 1, outs[[1]], outs];
   SelectionMove[first, All, Cell];
   NotebookDelete[mgs[[i]][[1]]];
   NotebookWrite[nb, 
    Cell[BoxData[ToBoxes[mgs[[i]][[2]]]], "Output"]];]]

TemplateMessageAction[nb_NotebookObject, "Drop"] := 
 Module[{mgs}, mgs = getMessages[nb]; 
  NotebookDelete[Flatten[mgs[[All, 1]]]]]	

End[] (* End Private Context *)



EndPackage[]