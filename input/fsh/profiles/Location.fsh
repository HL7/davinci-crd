Profile: CRDLocation
Parent: USCoreLocationProfile|7.0.0
Id: profile-location
Title: "CRD Location"
Description: "This profile specifies constraints on the US Core Location profile to support coverage requirements discovery."
* obeys crd-loc1
* ^experimental = false
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-location|6.1.0"
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-location|3.1.1"
* type MS
* type from CMSSupplementedLocationCodes (extensible)
  * ^condition[+] = crd-loc1
  * ^comment = "Where a CRD client has a CMS code and the value set requires an HL7 code, they **SHALL** send both the CMS code and the required value set code."
* address
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
