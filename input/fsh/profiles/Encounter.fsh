Profile: CRDEncounter
Parent: USCoreEncounterProfile|7.0.0
Id: profile-encounter
Title: "CRD Encounter"
Description: "This profile specifies additional extensions and constraints on the US Core Encounter profile to support coverage requirements discovery."
* ^experimental = false
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter|6.1.0"
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter|3.1.1"
* extension contains CRDCoverageInformation named Coverage-Information 0..* MS
* serviceType MS
  * extension contains CRDBillingOptions named BillingOptions 0..* MS
  * extension[BillingOptions] ^short = "Expected Billing Code(s)"
* subject only Reference(CRDPatient)
* basedOn only Reference(CRDServiceRequest)
* appointment MS
* appointment only Reference(CRDAppointmentWithOrder or CRDAppointmentNoOrder)
* length MS
* diagnosis MS
  * condition only Reference(USCoreConditionProblemsHealthConcernsProfile or USCoreConditionEncounterDiagnosisProfile or USCoreProcedureProfile)
  * condition MS
* location
  * location only Reference(CRDLocation)
  * status MS
  * period MS
* participant.individual
  * ^comment = "...  While the package for US Core 3.1.1 limits references to only Practitioner, there is a patch that indicates that PractitionerRole is also permitted"
* partOf only Reference(CRDEncounter)

