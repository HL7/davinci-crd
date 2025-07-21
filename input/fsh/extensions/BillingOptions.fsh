Extension: CRDBillingOptions
Id: ext-billing-options
Title: "Billing Options"
Description: "Identifies billing codes that could potentially be used for this clinical code"
* ^purpose = "Used to allow conveying multiple (possibly conflicting) billing codes that can't be provided as translations because they don't necessarily all represent the same ordering concept."
* ^experimental = false
* ^context[0].type = #element
* ^context[=].expression = "Appointment.serviceType"
* ^context[+].type = #fhirpath
* ^context[=].expression = "CommunicationRequest.payload.content.extension('http://hl7.org/fhir/5.0/StructureDefinition/extension-CommunicationRequest.payload.content%5Bx%5D')"
* ^context[+].type = #element
* ^context[=].expression = "Device"
* ^context[+].type = #fhirpath
* ^context[=].expression = "DeviceRequest.code.ofType(CodeableConcept)"
* ^context[+].type = #element
* ^context[=].expression = "Encounter.serviceType"
* ^context[+].type = #element
* ^context[=].expression = "Medication.code"
* ^context[+].type = #fhirpath
* ^context[=].expression = "MedicationRequest.medication.ofType(CodeableConcept)"
* ^context[+].type = #element
* ^context[=].expression = "NutritionOrder"
* ^context[+].type = #element
* ^context[=].expression = "ServiceRequest.code"
* ^context[+].type = #element
* ^context[=].expression = "VisionPrescription.lensSpecification.product"
* ^extension[$fmm].valueInteger = 1
* . ^short = "Billing Options"
* . ^definition = "Identifies billing codes that could potentially be used for this clinical code"
* . ^comment = "This will typically only be populated if the ordering and performing systems are the same"
* value[x] only CodeableConcept
* value[x] from CRDBillingCodes (extensible)
