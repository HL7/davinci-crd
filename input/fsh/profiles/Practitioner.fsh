Profile: Practitioner
Parent: USCorePractitionerProfile
Id: profile-practitioner
Title: "CRD Practitioner"
Description: "This profile specifies constraints on the US Core profile on the Practitioner resource to support coverage requirements discovery."
* ^version = "1.1.0-ci-build"
* ^status = #active
* ^experimental = false
* ^date = "2023-05-30T11:47:53-07:00"
* ^publisher = "HL7 International - Financial Management Work Group"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.hl7.org/Special/committees/fm"
* ^jurisdiction = urn:iso:std:iso:3166#US
* identifier[NPI] 1..1 MS
  * system = "http://hl7.org/fhir/sid/us-npi"
* qualification MS
  * code MS