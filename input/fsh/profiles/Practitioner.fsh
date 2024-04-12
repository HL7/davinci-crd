Profile: CRDPractitioner
Parent: USCorePractitionerProfile
Id: profile-practitioner
Title: "CRD Practitioner"
Description: "This profile specifies constraints on the US Core profile on the Practitioner resource to support coverage requirements discovery."
* ^experimental = false
* ^extension[$compliesWithProfile].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner|3.1.1"
* identifier[NPI] 1..1 MS
  * system = "http://hl7.org/fhir/sid/us-npi"
* qualification MS
  * code MS