Profile: MedicationRequest
Parent: $MedicationRequest
Id: profile-medicationrequest
Title: "CRD Medication Request"
Description: "This profile specifies additional constraints on the US Core MedicationRequest profile to support coverage requirements discovery."
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
* intent MS
* doNotPerform ..0
* reported[x] MS
  * ^slicing.discriminator.type = #type
  * ^slicing.discriminator.path = "$this"
  * ^slicing.rules = #open
* reportedBoolean only boolean
  * ^sliceName = "reportedBoolean"
* reportedReference only Reference(USCorePatientProfile or USCorePractitionerProfile or USCoreOrganizationProfile)
  * ^sliceName = "reportedReference"
* medication[x] MS
  * ^slicing.discriminator.type = #type
  * ^slicing.discriminator.path = "$this"
  * ^slicing.rules = #open
* medicationCodeableConcept only CodeableConcept
* medicationCodeableConcept from USCoreMedicationCodes (extensible)
  * ^sliceName = "medicationCodeableConcept"
  * ^min = 0
* medicationReference only Reference(USCoreMedicationProfile)
  * ^sliceName = "medicationReference"
  * ^min = 0
* subject only Reference(Patient)
* subject MS
* encounter only Reference(Encounter)
* encounter MS
  * ^comment = "potentially relevant for CRD in some situations."
* authoredOn 1.. MS
* requester 1.. MS
* requester only Reference(Practitioner or USCorePractitionerRoleProfile)
* performer only Reference(Practitioner or USCorePractitionerRoleProfile)
* performer MS
* reasonCode MS
  * ^comment = "potentially relevant for CRD in some situations."
* reasonReference only Reference(USCoreCondition or USCoreLaboratoryResultObservationProfile)
* reasonReference MS
  * ^comment = "potentially relevant for CRD in some situations."
* basedOn only Reference(MedicationRequest or ServiceRequest)
  * ^comment = "potentially relevant for CRD in some situations."
* dosageInstruction MS
  * text MS
* dispenseRequest MS
* substitution MS
* priorPrescription only Reference(MedicationRequest)
* priorPrescription MS