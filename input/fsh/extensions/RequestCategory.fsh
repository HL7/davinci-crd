Extension: RequestCategory
Id: ext-request-category
Title: "Request Category"
Description: "Partitions the DeviceRequest into one or more categories that can be used to filter searching, to govern access control and/or to guide system behavior."
* ^experimental = false
* ^context[0].type = #element
* ^context[=].expression = "DeviceRequest"
* ^extension[$fmm].valueInteger = 1
* . ^short = "Request Category"
* . ^definition = "Partitions the DeviceRequest into one or more categories that can be used to filter searching, to govern access control and/or to guide system behavior."
* value[x] only CodeableConcept
