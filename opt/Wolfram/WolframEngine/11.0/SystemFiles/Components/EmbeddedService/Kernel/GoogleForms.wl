GoogleForms[id_] := Module[{},
 template = FileTemplate[ FileNameJoin[ {$TemplatesDirectory, "googleforms.template"} ] ];
 embedding = TemplateApply[ template, <| "id" -> id |> ];
 EmbeddedHTML[ embedding ]
]
