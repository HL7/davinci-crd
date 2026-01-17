Extension: RequestCategory
Id: ext-request-category
Title: "Request Category"
Description: "A high-level categorization of the type of request"
* ^experimental = false
* ^context[0].type = #element
* ^context[=].expression = "DeviceRequest"
* ^context[1].type = #element
* ^context[=].expression = "NutritionOrder"
* ^context[2].type = #element
* ^context[=].expression = "VisionPrescription"
* ^extension[$fmm].valueInteger = 1
* . ^short = "Request Category"
* . ^definition = "A high-level categorization of the type of request"
* value[x] only CodeableConcept
