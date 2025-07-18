Profile: CRDPatient
Parent: USCorePatientProfile|7.0.0
Id: profile-patient
Title: "CRD Patient"
Description: "This profile specifies additional constraints on the US Core Patient profile to support coverage requirements discovery."
* ^experimental = false
* . ^definition = "This profile specifies additional constraints on the US Core Patient profile to support coverage requirements discovery."
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient|6.1.0"
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient|3.1.1"
* address MS
  * state MS
  * country MS