Output: ComputedType[
	EitherT[{IndexIntegerT[SizeT], VectorT[$Count]}], 
	Switch[$OutputForm, 
		"Index", IndexIntegerT[$Count], 
		"UnitVector", VectorT[$Count],
		_, $Failed
	]
]

Parameters:
	$Labels: ListT[$Count, ExpressionT]
	$OutputForm: Defaulting[EnumT[{"Index", "UnitVector"}]]
	$Count: SizeT

ToEncoderFunction: Function[
	If[#2, Replace1, Replace] @ 
	If[#OutputForm === "Index", makeSparseDispatch, makeOneHotDispatch][#Labels, #Count]
]

MLType: Function["Nominal"]

makeSparseDispatch[labels_, dim_] :=
	Thread[labels -> Range[dim]] //
	Append[l_ :> EncodeFail[StringForm["`` is not one of ``", l, labels]]] //
	Dispatch;

makeOneHotDispatch[labels_, dim_] :=
	Thread[labels -> IdentityMatrix[dim]] //
	Append[l_ :> EncodeFail[StringForm["`` is not one of ``", l, labels]]] //
	Dispatch;
