Profile: CRDServiceRequest
Parent: USCoreServiceRequestProfile|7.0.0
Id: profile-servicerequest
Title: "CRD Service Request"
Description: "This profile specifies constraints on the ServiceRequest resource to support coverage requirements discovery."
* ^experimental = false
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-servicerequest|6.1.0"
* extension contains CRDCoverageInformation named Coverage-Information 0..* MS
* extension[Coverage-Information] ^short = "Coverage Info"
* contained MS
  * ^comment = "Any references found in this resource, with the exception of 'Patient' could potentially be resource-specific and thus transmitted as contained resources."
* identifier MS
* basedOn only Reference(CRDServiceRequest or CRDMedicationRequest)
* basedOn MS
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
* doNotPerform MS
  * ^comment = "...Client systems that do not allow ordering services with 'doNotPerform' of 'true' do not need to add support for this capability.  CRD servers SHALL understand this element if populated.  Typically, 'doNotPerform' orders will not result in coverage-related card responses and might not result in any decision support at all.  In some cases, a payer might have documentation or other requirements relating to doNotPerform orders that they wish to communicate."
* code 1.. MS
* code only CodeableConcept
* code from CRDServiceRequestCodes (extensible)
  * ^short = "Codes to identify requested services. (CPT, SNOMED CT or LOINC)"
  * ^binding.description = "Codes describing the type of  Service"
  * extension contains CRDBillingOptions named BillingOptions 0..* MS
  * extension[BillingOptions] ^short = "Expected Billing Code(s)"
* quantity[x] MS
* subject MS
* subject only Reference(CRDPatient)
* encounter only Reference(CRDEncounter)
  * ^comment = "potentially relevant for CRD in some situations."
* occurrence[x] MS
* authoredOn 1.. MS
* requester 1.. MS
* requester only Reference(USCorePractitionerProfile or HRexPractitionerRole)
  * ^type[0].targetProfile[0].extension[$typeMS].valueBoolean = true
  * ^type[0].targetProfile[1].extension[$typeMS].valueBoolean = true
* performerType MS
* performerType from HealthcareProviderTaxonomy (extensible)
  * ^comment = "If there are multiple possible codes that could apply, send them using codeOptions and omit the coding elements"
  * extension contains CodeOptions named codeOptions 0..* MS
// TODO: Put the correct extension name here
* performer only Reference(USCorePractitionerProfile or HRexPractitionerRole or HRexOrganization)
  * ^type[0].targetProfile[0].extension[$typeMS].valueBoolean = true
  * ^type[0].targetProfile[1].extension[$typeMS].valueBoolean = true
  * ^type[0].targetProfile[2].extension[$typeMS].valueBoolean = true
* performer MS
* locationReference 0..1 MS
* locationReference only Reference(CRDLocation)
* reasonCode MS
* reasonReference only Reference(USCoreConditionProblemsHealthConcernsProfile or USCoreConditionEncounterDiagnosisProfile or USCoreDiagnosticReportProfileLaboratoryReporting or USCoreDiagnosticReportProfileNoteExchange or USCoreDocumentReferenceProfile or Observation)
* reasonReference MS
  * ^comment = "Observations **SHOULD** use US Core profiles when applicable, but not all relevant observations have appropriate US Core profiles (and there are too many to practically list all US Core profiles)."