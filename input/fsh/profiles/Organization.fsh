Profile: CRDOrganization
Parent: USCoreOrganizationProfile
Id: profile-organization
Title: "CRD Organization"
Description: "This profile specifies additional constraints on the US Core Organization profile to support coverage requirements discovery."
* ^experimental = false
* ^extension[$compliesWithProfile].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization|3.1.1"
* identifier MS
  * ^comment = "If the organization has an NPI, it **SHALL** be one of the identifiers."
* partOf only Reference(CRDOrganization)
* partOf MS