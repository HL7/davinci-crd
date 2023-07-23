Profile: ServiceRequest
Parent: $ServiceRequest
Id: profile-servicerequest
Title: "CRD Service Request"
Description: "This profile specifies constraints on the ServiceRequest resource to support coverage requirements discovery."
* ^version = "1.1.0-ci-build"
* ^status = #draft
* ^experimental = false
* ^date = "2023-05-30T11:47:53-07:00"
* ^publisher = "HL7 International - Financial Management Work Group"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.hl7.org/Special/committees/fm"
* ^jurisdiction = urn:iso:std:iso:3166#US
* extension contains CoverageInformation named Coverage-Information 0..* MS
* extension[Coverage-Information] ^short = "Coverage Info"
* identifier MS
* basedOn only Reference(ServiceRequest or MedicationRequest)
* basedOn MS
* status only code
* status = #draft (exactly)
* status MS
* doNotPerform MS
  * ^comment = "...Client systems that do not allow ordering services with 'doNotPerform' of 'true' do not need to add support for this capability.  CRD services SHALL understand this element if populated.  Typically, 'doNotPerform' orders will not result in coverage-related card responses and might not result in any decision support at all.  In some cases, a payer might have documentation or other requirements relating to doNotPerform orders that they wish to communicate."
* code 1.. MS
* code only CodeableConcept
* code from CRDServiceRequestCodes (extensible)
  * ^short = "Codes to identify requested services. (CPT, SNOMED CT or LOINC)"
  * ^binding.description = "Codes describing the type of  Service"
* quantity[x] MS
* subject only Reference(Patient)
* subject MS
* encounter only Reference(Encounter)
  * ^comment = "potentially relevant for CRD in some situations."
* occurrence[x] MS
* authoredOn 1.. MS
* requester 1.. MS
* requester only Reference(Practitioner or USCorePractitionerRoleProfile)
* performer only Reference(Practitioner or USCorePractitionerRoleProfile)
* performer MS
* locationReference 0..1 MS
* locationReference only Reference(Location)
* reasonCode MS
* reasonReference only Reference(USCoreCondition or USCoreLaboratoryResultObservationProfile)
* reasonReference MS
  * ^comment = "potentially relevant for CRD in some situations."