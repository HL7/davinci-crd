Profile: CRDPractitioner
Parent: USCorePractitionerProfile
Id: profile-practitioner
Title: "CRD Practitioner"
Description: "This profile specifies additional constraints on the US Core Practitioner profile to support coverage requirements discovery."
* ^experimental = false
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner|6.1.0"
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner|3.1.1"
* identifier contains tin 0..1 MS
* identifier[tin]
  * ^short = "U.S. Personal Tax Id Number"
  * ^comment = "This is used only for TIN's that are specific to the individual.  TINs for groups **SHALL** only be communicated on Organization."
  * ^patternIdentifier.system = "urn:oid:2.16.840.1.113883.4.4"
