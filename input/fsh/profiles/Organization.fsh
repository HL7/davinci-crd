Profile: Organization
Parent: USCoreOrganizationProfile
Id: profile-organization
Title: "CRD Organization"
Description: "This profile specifies additional constraints on the US Core Organization profile to support coverage requirements discovery."
* ^version = "1.1.0-ci-build"
* ^status = #draft
* ^experimental = false
* ^date = "2023-05-30T11:47:53-07:00"
* ^publisher = "HL7 International - Financial Management Work Group"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.hl7.org/Special/committees/fm"
* ^jurisdiction = urn:iso:std:iso:3166#US
* identifier MS
  * ^comment = "If the organization has an NPI, it **SHALL** be one of the identifiers."
* partOf only Reference(Organization)
* partOf MS