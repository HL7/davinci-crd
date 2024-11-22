Profile: CRDServiceRequest
Parent: USCoreServiceRequestProfile|7.0.0
Id: profile-servicerequest
Title: "CRD Service Request"
Description: "This profile specifies constraints on the ServiceRequest resource to support coverage requirements discovery."
* ^experimental = false
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient|6.1.0"
* extension contains CRDCoverageInformation named Coverage-Information 0..* MS
* extension[Coverage-Information] ^short = "Coverage Info"
* identifier MS
* basedOn only Reference(CRDServiceRequest or CRDMedicationRequest)
* basedOn MS
* status MS
  * ^example.label = "General"
  * ^example.valueCode = #draft
  * ^comment = "This will be 'draft' when using order-select or an initial order-sign, but may be 'active' or other values for order-sign representing edits to the order or for order-dispatch."
* doNotPerform MS
  * ^comment = "...Client systems that do not allow ordering services with 'doNotPerform' of 'true' do not need to add support for this capability.  CRD services SHALL understand this element if populated.  Typically, 'doNotPerform' orders will not result in coverage-related card responses and might not result in any decision support at all.  In some cases, a payer might have documentation or other requirements relating to doNotPerform orders that they wish to communicate."
* code 1.. MS
* code only CodeableConcept
* code from CRDServiceRequestCodes (extensible)
  * ^short = "Codes to identify requested services. (CPT, SNOMED CT or LOINC)"
  * ^binding.description = "Codes describing the type of  Service"
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
* performer only Reference(USCorePractitionerProfile or HRexPractitionerRole)
  * ^type[0].targetProfile[0].extension[$typeMS].valueBoolean = true
  * ^type[0].targetProfile[1].extension[$typeMS].valueBoolean = true
* performer MS
* locationReference 0..1 MS
* locationReference only Reference(CRDLocation)
* reasonCode MS
* reasonReference MS
  * ^comment = "potentially relevant for CRD in some situations."