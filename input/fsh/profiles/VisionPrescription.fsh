Profile: VisionPrescription
Parent: $VisionPrescription
Id: profile-visionprescription
Title: "CRD Vision Prescription"
Description: "This profile defines an initial profile on the VisionPrescription resource to support coverage requirements discovery."
* ^version = "1.1.0-ci-build"
* ^status = #draft
* ^experimental = false
* ^date = "2023-05-30T11:47:53-07:00"
* ^publisher = "HL7 International - Financial Management Work Group"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.hl7.org/Special/committees/fm"
* ^jurisdiction = urn:iso:std:iso:3166#US
* extension contains CoverageInformation named Coverage-Information 0..* MS
* extension[Coverage-Information] ^short = "Coverage Info"
* identifier MS
* status only code
* status = #draft (exactly)
* status MS
* created MS
* patient only Reference(Patient)
* patient MS
* encounter only Reference(Encounter)
* encounter MS
  * ^comment = "potentially relevant for CRD in some situations."
* dateWritten MS
* prescriber 1.. MS
* prescriber only Reference(Practitioner or USCorePractitionerRoleProfile)
* lensSpecification MS
  * product MS
  * eye MS
  * sphere MS
  * cylinder MS
  * axis MS
  * prism MS
    * amount MS
    * base MS
  * add MS
  * power MS
  * backCurve MS
  * diameter MS
  * duration MS