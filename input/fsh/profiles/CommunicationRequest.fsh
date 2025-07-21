Profile: CRDCommunicationRequest
Parent: $CommunicationRequest
Id: profile-communicationrequest
Title: "CRD Communication Request"
Description: "This profile specifies constraints on the CommunicationRequest resource to support coverage requirements discovery."
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* extension contains CRDCoverageInformation named Coverage-Information 0..* MS
* identifier MS
* basedOn 1..1 MS
* replaces only Reference(CRDCommunicationRequest)
  * ^comment = "potentially relevant for CRD in some situations."
* status MS
  * ^example.label = "General"
  * ^example.valueCode = #draft
  * ^comment = "This will be 'draft' when using order-select or an initial order-sign, but may be 'active' or other values for order-sign representing edits to the order, for order-dispatch or when referenced by an appointment."
* doNotPerform ..0
* subject 1.. MS
* subject only Reference(CRDPatient)
* encounter only Reference(CRDEncounter)
  * ^comment = "potentially relevant for CRD in some situations."
* payload 1.. MS
  * extension contains $extension-CommunicationRequest.payload.content named codeableConcept 1..1 MS
  * extension[codeableConcept] ^comment = "If the actual communication request being authored is conveying resources or an attachment, the CRD client SHALL either determine a coded way to indicate what information sharing is being requested or shall omit sharing the CommunicationRequest - i.e. don't bother calling the hook service."
    * value[x] only CodeableConcept
      * extension contains CRDBillingOptions named BillingOptions 0..* MS
      * extension[BillingOptions] ^short = "Expected Billing Code(s)"
* occurrence[x] MS
* authoredOn 1.. MS
* requester 1.. MS
* requester only Reference(USCorePractitionerProfile or HRexPractitionerRole)
  * ^type[0].targetProfile[0].extension[$typeMS].valueBoolean = true
  * ^type[0].targetProfile[1].extension[$typeMS].valueBoolean = true
* recipient MS
* recipient only Reference(USCorePractitionerProfile or HRexPractitionerRole or CRDOrganization)
  * ^type[0].targetProfile[0].extension[$typeMS].valueBoolean = true
  * ^type[0].targetProfile[1].extension[$typeMS].valueBoolean = true
  * ^type[0].targetProfile[2].extension[$typeMS].valueBoolean = true
* sender MS
* sender only Reference(USCorePractitionerProfile or HRexPractitionerRole or CRDOrganization)
  * ^type[0].targetProfile[0].extension[$typeMS].valueBoolean = true
  * ^type[0].targetProfile[1].extension[$typeMS].valueBoolean = true
  * ^type[0].targetProfile[2].extension[$typeMS].valueBoolean = true
* reasonCode MS
* reasonReference only Reference(USCoreConditionProblemsHealthConcernsProfile or USCoreConditionEncounterDiagnosisProfile or USCoreDiagnosticReportProfileLaboratoryReporting or USCoreDiagnosticReportProfileNoteExchange or USCoreDocumentReferenceProfile or Observation)
* reasonReference MS
  * ^comment = "Observations **SHOULD** use US Core profiles when applicable, but not all relevant observations have appropriate US Core profiles (and there are too many to practically list all US Core profiles)."