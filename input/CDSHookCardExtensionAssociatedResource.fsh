Logical: CDSHookCardExtensionAssociatedResource
Id: CDSHookCardExtensionAssociatedResource
Title: "CDS Hooks Card associated-resource if-none-exist Extension"
Description: "An extension for the CDS Hooks Card object that specifies the source resources the card relates to"
* ^status = #active
* ^experimental = false
* . ^extension.url = "http://hl7.org/fhir/tools/StructureDefinition/elementdefinition-json-name"
  * ^extension.valueString = "davinci-crd.associated-resource"
  * ^short = "Resources related to this card"
  * ^definition = "A list of local resource references that identifies the resource or set of resources passed to the hook that this card relates to"
  * ^type.code = #uri
//  * ^extension.url = "http://hl7.org/fhir/tools/StructureDefinition/json-type-is-value"
//  * ^extension.valueBoolean = true