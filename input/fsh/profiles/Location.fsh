Profile: Location
Parent: USCoreLocation
Id: profile-location
Title: "CRD Location"
Description: "This profile specifies constraints on the US Core Location profile to support coverage requirements discovery."
* ^version = "1.1.0-ci-build"
* ^status = #active
* ^experimental = false
* ^date = "2023-05-30T11:47:53-07:00"
* ^publisher = "HL7 International - Financial Management Work Group"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.hl7.org/Special/committees/fm"
* ^jurisdiction = urn:iso:std:iso:3166#US
* type from CMSMappableLocationCodes (extensible)
* address 1.. MS
* address only Address
  * type MS
  * type from CRDLocationAddressTypes (required)
    * ^short = "physical | both"
    * ^binding.description = "Address Type for CRD"
* managingOrganization 1.. MS
* managingOrganization only Reference(Organization)
* partOf only Reference(Location)