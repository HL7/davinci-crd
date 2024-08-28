Profile: CRDMedicationRequest
Parent: USCoreMedicationRequestProfile
Id: profile-medicationrequest
Title: "CRD Medication Request"
Description: "This profile specifies additional constraints on the US Core MedicationRequest profile to support coverage requirements discovery."
* ^experimental = false
* extension contains CRDCoverageInformation named Coverage-Information 0..* MS
* extension[Coverage-Information] ^short = "Coverage Info"
* identifier MS
* status MS
  * ^example.label = "General"
  * ^example.valueCode = #draft
  * ^comment "This will be 'draft' when using order-select or an initial order-sign, but may be 'active' or other values for order-sign representing edits to the order or for order-dispatch."
* doNotPerform ..0
* reported[x] only boolean or Reference(CRDPatient or USCorePractitionerProfile or CRDOrganization)
//* reported[x] only boolean or Reference(CRDPatient or USCorePractitionerProfile or CRDOrganization)
* medication[x] from $USCoreMedicationCodes (extensible)
* encounter only Reference(CRDEncounter3_1 or CRDEncounter6_1)
  * ^comment = "potentially relevant for CRD in some situations."
* authoredOn 1..
* requester 1..
//* requester only Reference(USCorePractitionerProfile or HRexPractitionerRole)
* requester only Reference(USCorePractitionerProfile)
* performer MS
* performer only Reference(USCorePractitionerProfile or HRexPractitionerRole)
* reasonCode MS
  * ^comment = "potentially relevant for CRD in some situations."
* reasonReference MS
  * ^comment = "potentially relevant for CRD in some situations."
//* reasonReference only Reference(USCoreConditionProblemsHealthConcernsProfile or USCoreConditionUSCoreConditionEncounterDiagnosisProfile or USCoreLaboratoryResultObservationProfile)
* basedOn only Reference(CRDMedicationRequest or CRDServiceRequest)
  * ^comment = "potentially relevant for CRD in some situations."
* substitution MS
* priorPrescription MS
* priorPrescription only Reference(CRDMedicationRequest)