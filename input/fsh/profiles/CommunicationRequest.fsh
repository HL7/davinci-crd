Profile: CommunicationRequest
Parent: $CommunicationRequest
Id: profile-communicationrequest
Title: "CRD Communication Request"
Description: "This profile specifies constraints on the CommunicationRequest resource to support coverage requirements discovery."
* ^version = "1.1.0-ci-build"
* ^status = #active
* ^experimental = false
* ^date = "2023-05-30T11:47:53-07:00"
* ^publisher = "HL7 International - Financial Management Work Group"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.hl7.org/Special/committees/fm"
* ^jurisdiction = urn:iso:std:iso:3166#US
* ^extension[$fmm].valueInteger = 1
* extension contains CoverageInformation named Coverage-Information 0..* MS
* identifier MS
* basedOn 1..1 MS
* replaces only Reference(CommunicationRequest)
  * ^comment = "potentially relevant for CRD in some situations."
* status only code
* status = #draft (exactly)
* status MS
* doNotPerform ..0
* subject 1.. MS
* subject only Reference(Patient)
* encounter only Reference(Encounter)
  * ^comment = "potentially relevant for CRD in some situations."
* payload 1.. MS
  * extension contains $extension-CommunicationRequest.payload.content named codeableConcept 1..1 MS
  * extension[codeableConcept] ^comment = "If the actual communication request being authored is conveying resources or an attachment, the CRD client SHALL either determine a coded way to indicate what information sharing is being requested or shall omit sharing the CommunicationRequest - i.e., don't bother calling the hook service."
    * value[x] only CodeableConcept
* occurrence[x] MS
* authoredOn 1.. MS
* requester 1.. MS
* requester only Reference(Practitioner or USCorePractitionerRoleProfile)
* recipient only Reference(Practitioner or USCorePractitionerRoleProfile or USCoreOrganizationProfile)
* recipient MS
* sender only Reference(Practitioner or USCorePractitionerRoleProfile or USCoreOrganizationProfile)
* sender MS
* reasonCode MS
* reasonReference only Reference(USCoreCondition or USCoreLaboratoryResultObservationProfile)
* reasonReference MS
  * ^comment = "potentially relevant for CRD in some situations."