Logical: CDSHookServicesExtensionConfig
Id: CDSHookServicesExtensionConfig
Title: "CDS Hooks Services Configuration Extension"
Description: "An extension for the CDS Hooks 'services' object that indicates configuration options supported by the CDS server"
* ^status = #draft
* ^experimental = false
* . ^extension.url = "http://hl7.org/fhir/tools/StructureDefinition/elementdefinition-json-name"
  * ^extension.valueString = "davinci-crd.configuration-options"
  * ^short = "An allowed configuration option"
  * ^definition = "A specific configuration option that is supported by the server and can be transmitted when invoking a hooks service"
* code 1..1 code "Identifies the setting configuration when hook is invoked" "A code that will be used when setting configuration during hook invocation, and has an (extensible) binding to the CRD Card Types ValueSet."
* type 1..1 code "boolean | integer (JSON types)" "A data type for the parameter. At present, allowed values are “boolean” and “integer”"
* name 1..1 string "A display name for the configuration option" "A display name for the configuration option to appear in the client’s user interface when performing configuration"
* description 1..1 string "1-2 sentences - the effect of the configuration option" "A description providing a 1-2 sentence description of the effect of the configuration option"
* default[x] 0..1 integer or boolean "Shows users what to expect when an override is not specified" "A default value SHOULD also be provided to show users what to expect when an override is not specified"
  * ^extension.url = "http://hl7.org/fhir/tools/StructureDefinition/json-primitive-choice"
  * ^extension.valueBoolean = true