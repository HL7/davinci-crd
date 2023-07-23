Profile: Device
Parent: $Device
Id: profile-device
Title: "CRD Device"
Description: "This profile specifies additional constraints on the US Core Device Profile to support coverage requirements discovery."
* ^version = "1.1.0-ci-build"
* ^status = #draft
* ^experimental = false
* ^date = "2023-05-30T11:47:53-07:00"
* ^publisher = "HL7 International - Financial Management Work Group"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.hl7.org/Special/committees/fm"
* ^jurisdiction = urn:iso:std:iso:3166#US
* udiCarrier ..1 MS
  * deviceIdentifier MS
* property MS
  * type MS
  * valueQuantity MS
  * valueCode MS