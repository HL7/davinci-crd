Profile: CRDPatient
Parent: USCorePatientProfile|6.1.0
Id: profile-patient
Title: "CRD Patient"
Description: "This profile specifies additional constraints on the US Core Patient profile to support coverage requirements discovery."
* ^experimental = false
* . ^definition = "This profile specifies additional constraints on the US Core Patient profile to support coverage requirements discovery."
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient|3.1.1"
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient|6.1.0"
* identifier MS
  * ^slicing.discriminator[+].type = #value
  * ^slicing.discriminator[=].path = "type"
  * ^slicing.rules = #open
* identifier contains MRIdentifier 1..1 MS
* identifier[MRIdentifier].type 1.. MS
* identifier[MRIdentifier].type only CodeableConcept
* identifier[MRIdentifier].type = $v2-0203#MR
* address MS
  * state MS
  * country MS