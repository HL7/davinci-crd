Profile: CRDDeviceRequest
Parent: $DeviceRequest
Id: profile-devicerequest
Title: "CRD Device Request"
Description: "This profile specifies extensions and constraints on the DeviceRequest resource to support coverage requirements discovery."
* ^experimental = false
* extension contains CRDCoverageInformation named Coverage-Information 0..* MS
* identifier MS
* basedOn MS
* status 1.. MS
  * ^example.label = "General"
  * ^example.valueCode = #draft
  * ^comment = "This will be 'draft' when using order-select or an initial order-sign, but may be 'active' or other values for order-sign representing edits to the order or for order-dispatch."
* code[x] MS
* code[x] only CodeableConcept or Reference(CRDDevice)
* code[x] from CRDDeviceRequests (extensible)
* parameter MS
* subject MS
* subject only Reference(CRDPatient)
* encounter only Reference(CRDEncounter)
  * ^comment = "potentially relevant for CRD in some situations."
* occurrence[x] MS
* authoredOn 1.. MS
* requester 1.. MS
* requester only Reference(USCorePractitionerProfile or HRexPractitionerRole)
  * ^type[0].targetProfile[0].extension[$typeMS].valueBoolean = true
  * ^type[0].targetProfile[1].extension[$typeMS].valueBoolean = true
* performer MS
* performer only Reference(USCorePractitionerProfile or HRexPractitionerRole)
  * ^type[0].targetProfile[0].extension[$typeMS].valueBoolean = true
  * ^type[0].targetProfile[1].extension[$typeMS].valueBoolean = true
* reasonCode MS
* reasonReference only Reference(USCoreConditionProblemsHealthConcernsProfile or USCoreConditionEncounterDiagnosisProfile or USCoreDiagnosticReportProfileLaboratoryReporting or USCoreDiagnosticReportProfileNoteExchange or USCoreDocumentReferenceProfile or Observation)
* reasonReference MS
  * ^comment = "Observations **SHOULD** use US Core profiles when applicable, but not all relevant observations have appropriate US Core profiles (and there are too many to practically list all US Core profiles)."
