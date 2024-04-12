Profile: CRDMedicationRequest
Parent: USCoreMedicationRequestProfile
Id: profile-medicationrequest
Title: "CRD Medication Request"
Description: "This profile specifies additional constraints on the US Core MedicationRequest profile to support coverage requirements discovery."
* ^experimental = false
* extension contains CRDCoverageInformation named Coverage-Information 0..* MS
* extension[Coverage-Information] ^short = "Coverage Info"
* identifier MS
* doNotPerform ..0
* reported[x] only boolean or Reference(CRDPatient or CRDPractitioner or CRDOrganization)
//* reported[x] only boolean or Reference(CRDPatient or CRDPractitioner or CRDOrganization)
* medication[x] from $USCoreMedicationCodes (extensible)
* encounter only Reference(CRDEncounter3_1 or CRDEncounter6_1)
  * ^comment = "potentially relevant for CRD in some situations."
* authoredOn 1..
* requester 1..
//* requester only Reference(CRDPractitioner or HRexPractitionerRole)
* requester only Reference(CRDPractitioner)
* performer MS
* performer only Reference(CRDPractitioner or HRexPractitionerRole)
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