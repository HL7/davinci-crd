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
//* status only code
* status MS
* status = #draft (exactly)
* doNotPerform ..0
* subject 1.. MS
* subject only Reference(CRDPatient)
* encounter only Reference(CRDEncounter3_1 or CRDEncounter6_1)
  * ^comment = "potentially relevant for CRD in some situations."
* payload 1.. MS
  * extension contains $extension-CommunicationRequest.payload.content named codeableConcept 1..1 MS
  * extension[codeableConcept] ^comment = "If the actual communication request being authored is conveying resources or an attachment, the CRD client SHALL either determine a coded way to indicate what information sharing is being requested or shall omit sharing the CommunicationRequest - i.e. don't bother calling the hook service."
    * value[x] only CodeableConcept
* occurrence[x] MS
* authoredOn 1.. MS
* requester 1.. MS
* requester only Reference(USCorePractitionerProfile or HRexPractitionerRole)
* recipient MS
* recipient only Reference(USCorePractitionerProfile or HRexPractitionerRole or CRDOrganization)
* sender MS
* sender only Reference(USCorePractitionerProfile or HRexPractitionerRole or CRDOrganization)
* reasonCode MS
//* reasonReference only Reference(USCoreConditionProblemsHealthConcernsProfile or USCoreConditionUSCoreConditionEncounterDiagnosisProfile or USCoreLaboratoryResultObservationProfile)
* reasonReference MS
  * ^comment = "potentially relevant for CRD in some situations."