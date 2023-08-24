Profile: Patient
Parent: USCorePatientProfile
Id: profile-patient
Title: "CRD Patient"
Description: "This profile specifies additional constraints on the US Core Patient profile to support coverage requirements discovery."
* ^version = "1.1.0-ci-build"
* ^status = #active
* ^experimental = false
* ^date = "2023-05-30T11:47:53-07:00"
* ^publisher = "HL7 International - Financial Management Work Group"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.hl7.org/Special/committees/fm"
* ^jurisdiction = urn:iso:std:iso:3166#US
* . ^definition = "This profile specifies additional constraints on the US Core Patient profile to support coverage requirements discovery."
* identifier MS
  * ^slicing.discriminator[0].type = #value
  * ^slicing.discriminator[=].path = "type.coding.system"
  * ^slicing.discriminator[+].type = #pattern
  * ^slicing.discriminator[=].path = "type"
  * ^slicing.rules = #open
* identifier contains MRIdentifier 1..1 MS
* identifier[MRIdentifier].type 1.. MS
* identifier[MRIdentifier].type only CodeableConcept
* identifier[MRIdentifier].type = $v2-0203#MR
* address MS
  * state MS
  * country MS