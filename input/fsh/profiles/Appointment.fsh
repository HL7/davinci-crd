Profile: Appointment
Parent: $Appointment
Id: profile-appointment
Title: "CRD Appointment"
Description: "This profile specifies extensions and constraints on the Appointment resource to support coverage requirements discovery."
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
* status MS
  * ^short = "Appointment status"
  * ^example.label = "General"
  * ^example.valueCode = #proposed
* serviceCategory MS
* serviceType MS
* specialty MS
* appointmentType MS
* reasonReference only Reference(USCoreCondition or Procedure)
* reasonReference MS
  * ^comment = "potentially relevant for CRD in some situations."
* start 1.. MS
* end 1.. MS
* basedOn only Reference(ServiceRequest)
  * ^comment = "potentially relevant for CRD in some situations."
* participant MS
  * actor only Reference(Patient or Practitioner or Location)
  * actor MS
    * ^short = "Patient, Practitioner  or Location"
  * status MS
* requestedPeriod 1..1 MS