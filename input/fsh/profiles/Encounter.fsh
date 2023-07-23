Profile: Encounter
Parent: USCoreEncounterProfile
Id: profile-encounter
Title: "CRD Encounter"
Description: "This profile specifies additional extensions and constraints on the US Core Encounter profile to support coverage requirements discovery."
* ^version = "1.1.0-ci-build"
* ^status = #draft
* ^experimental = false
* ^date = "2023-05-30T11:47:53-07:00"
* ^publisher = "HL7 International - Financial Management Work Group"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.hl7.org/Special/committees/fm"
* ^jurisdiction = urn:iso:std:iso:3166#US
* extension contains CoverageInformation named Coverage-Information 0..* MS
* serviceType MS
* subject only Reference(Patient)
* subject MS
* basedOn only Reference(ServiceRequest)
* participant.individual only Reference(Practitioner)
* participant.individual MS
* appointment only Reference(Appointment)
* appointment MS
* length MS
* reasonCode MS
* reasonReference only Reference(USCoreCondition or Procedure)
* reasonReference MS
* diagnosis MS
  * condition MS
* location MS
  * location only Reference(Location)
  * location MS
  * status MS
  * period MS
* partOf only Reference(Encounter)