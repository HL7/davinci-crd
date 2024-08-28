Profile: CRDLocation
Parent: USCoreLocation
Id: profile-location
Title: "CRD Location"
Description: "This profile specifies constraints on the US Core Location profile to support coverage requirements discovery."
* ^experimental = false
* ^extension[$compliesWithProfile].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-location|3.1.1"
* type MS
* type from CMSMappableLocationCodes (extensible)
* address 1..
* address only Address
  * type MS
  * type from CRDLocationAddressTypes (required)
    * ^short = "physical | both"
    * ^binding.description = "Address Type for CRD"
* managingOrganization 1..
* managingOrganization only Reference(CRDOrganization)
* partOf only Reference(CRDLocation)