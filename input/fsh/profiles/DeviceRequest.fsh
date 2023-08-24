Profile: DeviceRequest
Parent: $DeviceRequest
Id: profile-devicerequest
Title: "CRD Device Request"
Description: "This profile specifies extensions and constraints on the DeviceRequest resource to support coverage requirements discovery."
* ^version = "1.1.0-ci-build"
* ^status = #active
* ^experimental = false
* ^date = "2023-05-30T11:47:53-07:00"
* ^publisher = "HL7 International - Financial Management Work Group"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.hl7.org/Special/committees/fm"
* ^jurisdiction = urn:iso:std:iso:3166#US
* extension contains CoverageInformation named Coverage-Information 0..* MS
* identifier MS
* basedOn MS
* status 1.. MS
* status only code
* status = #draft (exactly)
* code[x] only CodeableConcept or Reference(Device)
* code[x] MS
* code[x] from CRDDeviceRequests (extensible)
* parameter MS
* subject only Reference(Patient)
* subject MS
* encounter only Reference(Encounter)
  * ^comment = "potentially relevant for CRD in some situations."
* occurrence[x] MS
* authoredOn 1.. MS
* requester 1.. MS
* requester only Reference(Practitioner or USCorePractitionerRoleProfile)
* performer only Reference(Practitioner or USCorePractitionerRoleProfile)
* performer MS
* reasonCode MS
* reasonReference only Reference(USCoreCondition or USCoreLaboratoryResultObservationProfile)
* reasonReference MS
  * ^comment = "potentially relevant for CRD in some situations."