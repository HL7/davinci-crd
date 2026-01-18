Profile: CRDMedicationRequest
Parent: USCoreMedicationRequestProfile|7.0.0
Id: profile-medicationrequest
Title: "CRD Medication Request"
Description: "This profile specifies additional constraints on the US Core MedicationRequest profile to support coverage requirements discovery."
* ^experimental = false
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-medicationrequest|6.1.0"
* extension contains CRDCoverageInformation named Coverage-Information 0..* MS
* extension[Coverage-Information] ^short = "Coverage Info"
* contained MS
  * ^comment = "Any references found in this resource, with the exception of 'Patient' could potentially be resource-specific and thus transmitted as contained resources."
* identifier MS
* status MS
  * ^example.label = "General"
  * ^example.valueCode = #draft
  * ^comment = "This will be 'draft' when using order-select or an initial order-sign, but may be 'active' or other values for order-sign representing edits to the order or for order-dispatch."
* category contains encounterType 0..1 MS and serviceType 0..1 MS
* category[encounterType] from ActEncounterCode (required)
* category[encounterType]
  * ^short = "inpatient, outpatient, etc."
* category[serviceType] from X12ServiceType (required)
* category[serviceType]
  * ^short = "X-ray, Lab, consulation, surgical, etc."
* doNotPerform ..0
* reported[x] only boolean or Reference(CRDPatient or USCorePractitionerProfile or CRDOrganization)
* medication[x] only CodeableConcept or Reference(CRDMedication)
* medication[x] from $USCoreMedicationCodes (extensible)
* medicationCodeableConcept MS
  * extension contains CRDBillingOptions named BillingOptions 0..* MS
  * extension[BillingOptions] ^short = "Expected Billing Code(s)"
* medicationReference MS
* encounter only Reference(CRDEncounter)
  * ^comment = "potentially relevant for CRD in some situations."
* authoredOn 1..
* requester 1.. MS
//* requester only Reference(USCorePractitionerProfile or HRexPractitionerRole)
* requester only Reference(USCorePractitionerProfile)
* performer MS
* performer only Reference(USCorePractitionerProfile or HRexPractitionerRole)
  * ^type[0].targetProfile[0].extension[$typeMS].valueBoolean = true
  * ^type[0].targetProfile[1].extension[$typeMS].valueBoolean = true
* reasonCode MS
  * ^comment = "potentially relevant for CRD in some situations."
* reasonReference MS
  * ^comment = "potentially relevant for CRD in some situations."
//* reasonReference only Reference(USCoreConditionProblemsHealthConcernsProfile or USCoreConditionUSCoreConditionEncounterDiagnosisProfile or USCoreLaboratoryResultObservationProfile)
* basedOn only Reference(CRDMedicationRequest or CRDServiceRequest)
  * ^comment = "potentially relevant for CRD in some situations."
* dosageInstruction.timing only CRDTiming
* dispenseRequest MS
  * performer MS
  * performer only Reference(CRDOrganization)
* substitution MS
* priorPrescription MS
* priorPrescription only Reference(CRDMedicationRequest)