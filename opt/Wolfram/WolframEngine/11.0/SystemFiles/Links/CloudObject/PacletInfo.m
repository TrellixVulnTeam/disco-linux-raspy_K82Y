(* Paclet Info File *)

(* created 2015/04/16*)

Paclet[
    Name -> "CloudObject",
    (* For paclet builds, the Version field is ignored and Jenkins constructs its own version number at build time.
     * See the 'Paclet.CloudObject.prebuild' target in re_build_CloudObject.xml.
     * For the convenience of developers using local branches, set the Version higher 
     * than the paclet build numbers: *)
    Version -> "11.0.1214",
    MathematicaVersion -> "10.1+",
    Loading -> Automatic,
    Creator -> "Jan Poeschko <jpoeschko@wolfram.com>, Joel Klein <jfklein@wolfram.com>",
	Extensions -> {
		{"Kernel",
			Root->"Kernel",
			Context->{
                "CloudObjectLoader`",
                "CloudObject`"
            },
			Symbols-> {
				"System`$CloudConnected",
				"System`$CloudCreditsAvailable",
				"System`$CloudRootDirectory",
				"System`$CloudSymbolBase",
				"System`$HTTPRequest",
                "System`$Permissions",
                "System`$PermissionsGroupBase",
				"System`$RegisteredUserName",
				"System`$SourceLink",
                "System`AbortScheduledTask",
                "System`AddUsers",
                "System`AutoCopy",
                "System`AutoRefreshed",
				"System`AutoRemove",
				"System`CloudBase",
				"System`CloudAccountData",
				"System`CloudConnect",
				"System`CloudDeploy",
				"System`CloudDirectory",
				"System`CloudDisconnect",
				"System`CloudEvaluate",
				"System`CloudExport",
				"System`CloudFunction",
				"System`CloudGet",
				"System`CloudImport",
				"System`CloudLoggingData",
				"System`CloudObject",
				"System`CloudObjects",
				"System`CloudObjectInformation",
				"System`CloudObjectInformationData",
				"System`CloudPut",
				"System`CloudSave",
                "System`CloudSubmit",
				"System`CloudSymbol",
                "System`ContinuousTask",
                "System`CreatePermissionsGroup",
				"System`CreateUUID",
				"System`Delayed",
				"System`CachePersistence",
				"System`DeletePermissionsKey",
                "System`DeliveryFunction",                
				"System`DocumentGenerator",
                "System`DocumentGeneratorInformation",
                "System`DocumentGeneratorInformationData",
                "System`DocumentGenerators",
                "System`EpilogFunction",
                "System`EvaluationData",
				"System`ExternalBundle",
				"System`ExportForm",
                "System`GeneratedDocumentBinding",
                "System`GeneratorDescription",
				"System`GeneratorHistoryLength",
                "System`GeneratorOutputType",
				"System`GenerateHTTPResponse",
				"System`HTTPRequestData",
                "System`HTTPResponse",
                "System`HTTPRequest",
                "System`HTTPErrorResponse",
                "System`HTTPRedirect",
				"System`IconRules",
				"System`IncludeGeneratorTasks",
				"System`LocalizeDefinitions",
                "System`MailReceiverFunction",
                "System`MailResponseFunction",
                "System`ReturnReceiptFunction",
                "System`NextScheduledTaskTime",
				"System`NotificationFunction",
				"System`Permissions",
                "System`PermissionsGroup",
                "System`PermissionsGroups",
                "System`PermissionsKey",
                "System`PermissionsKeys",
                "System`SetPermissions",
                "System`ClearPermissions",
                "System`CloudPublish",
                "System`CloudShare",
                "System`SharingList",
                "System`RemoveUsers",
                "System`ResponseForm",
                "System`RestartInterval",
                "System`ScheduledTask",
                "System`ScheduledTasks",
                "System`ScheduledTaskActiveQ",
                "System`ScheduledTaskInformation",
                "System`ScheduledTaskInformationData",
                "System`SetCloudDirectory",
                "System`SetUsers",
                "System`SourceLink",
                "System`URLDispatcher",
                "CloudObject`$EvaluationParameters",
                "CloudObject`Internal`SetAuthentication",
                "CloudObject`Internal`GetAuthentication",
                "CloudObject`Internal`CloudConnectStatus",
                "CloudObject`Internal`WolframIDStatus",
                "CloudObject`Internal`WolframUUIDStatus",
                "CloudObject`Internal`RegisteredUserNameStatus",
                "CloudObject`Utilities`AddAuthenticationInformation",
                "CloudObject`Utilities`AuthenticationInformation",
                "CloudObject`Utilities`RemoveAuthenticationInformation",
                "CloudObject`ToCharacterEncoding"
			}
		},
		{"FrontEnd", Prepend -> True},
		{"Documentation", Language -> "English"},
		{"LibraryLink", Root->"LibraryResources"}
	}
]

