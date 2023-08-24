Logical: CDSHookHookExtensionConfig
Id: CDSHookHookExtensionConfig
Title: "CDS Hooks Hook Configuration Settings Extension"
Description: "'An extension for the CDS Hooks hook invocation object that indicates configuration options set for this specific hook invocation"
* ^status = #active'
* ^experimental = false
* . ^extension.url = "http://hl7.org/fhir/tools/StructureDefinition/elementdefinition-json-name"
  * ^extension.valueString = "davinci-crd.configuration"
//  * ^extension[+].url = "http://hl7.org/fhir/tools/StructureDefinition/json-object"
//  * ^extension[=].valueBoolean = true
  * ^short = "A configuration option being set"
  * ^definition = "An extension for the CDS Hooks hook invocation object that indicates configuration options set for this specific hook invocation"
