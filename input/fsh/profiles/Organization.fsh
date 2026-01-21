Profile: CRDOrganization
Parent: HRexOrganization
Id: profile-organization
Title: "CRD Organization"
Description: "This profile specifies additional constraints on the US Core Organization profile to support coverage requirements discovery."
* ^experimental = false
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization|6.1.0"
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-organization|3.1.1"
* identifier MS
  * ^comment = "If the organization has an NPI, it **SHALL** be one of the identifiers."
* address
  * ^comment = "...  Addresses conveyed here are 'contact' addresses for the organization, not (necessarily) a physical address.  Physical address are usually conveyed on the Location resource."
* partOf only Reference(CRDOrganization)
* partOf MS