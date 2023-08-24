Logical: CDSHookSuggestionActionExtensionIfNoneExist
Id: CDSHookSuggestionActionExtensionIfNoneExist
Title: "CDS Hooks suggestion.action if-none-exist Extension"
Description: "An extension for the CDS Hooks Card suggestion.action that specifies an if-none-exist header to be used as part of the action"
* ^status = #active
* ^experimental = false
* . ^extension.url = "http://hl7.org/fhir/tools/StructureDefinition/elementdefinition-json-name"
  * ^extension.valueString = "davinci-crd.if-none-exist"
  * ^short = "Query to be empty for action"
  * ^definition = "An extension for the CDS Hooks Card suggestion.action that specifies an if-none-exist header to be used as part of the action"
  * ^type.code = #string
  * ^max = "1"