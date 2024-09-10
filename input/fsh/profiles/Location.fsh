Profile: CRDLocation
Parent: USCoreLocation|6.1.0
Id: profile-location
Title: "CRD Location"
Description: "This profile specifies constraints on the US Core Location profile to support coverage requirements discovery."
* obeys crd-loc1
* ^experimental = false
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-location|3.1.1"
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-location|6.1.0"
* type MS
* type from CMSMappableLocationCodes (extensible)
  * ^condition[+] = crd-loc1
* address 1..
* address only Address
  * type MS
  * type from CRDLocationAddressTypes (required)
    * ^short = "physical | both"
    * ^binding.description = "Address Type for CRD"
* managingOrganization 1..
* managingOrganization only Reference(CRDOrganization)
* partOf only Reference(CRDLocation)
  * ^condition[+] = crd-loc1

Invariant: crd-loc1
Description: "Must either have a type or must have a parent (meaning there must be a type somewhere in the hierarchy)"
Severity: #error
Expression: "type.exists() or partOf.exists()"
