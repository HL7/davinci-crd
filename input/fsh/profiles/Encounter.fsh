Profile: CRDEncounter6_1
Parent: USCoreEncounterProfile|6.1.0
Id: profile-encounter6.1
Title: "CRD Encounter - USCDI 3"
Description: "This profile specifies additional extensions and constraints on the US Core Encounter profile to support coverage requirements discovery.  Compliant with USCDI 3"
* ^experimental = false
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient|6.1.0"
* extension contains CRDCoverageInformation named Coverage-Information 0..* MS
* serviceType MS
* subject only Reference(CRDPatient)
* basedOn only Reference(CRDServiceRequest)
* appointment MS
* appointment only Reference(CRDAppointmentWithOrder or CRDAppointmentNoOrder)
* length MS
* diagnosis MS
  * condition MS
* location
  * location only Reference(CRDLocation)
  * status MS
  * period MS
* partOf only Reference(CRDEncounter6_1 or CRDEncounter3_1)

Profile: CRDEncounter3_1
Parent: CRDEncounter6_1
Id: profile-encounter3.1
Title: "CRD Encounter - USCDI 1"
Description: "This profile specifies additional extensions and constraints on the US Core Encounter profile to support coverage requirements discovery.  Compliant with USCDI 1"
* ^experimental = false
* ^extension[$compliesWithProfile].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter|3.1.1"
* participant.individual only Reference(USCorePractitionerProfile)
* partOf only Reference(CRDEncounter3_1)
