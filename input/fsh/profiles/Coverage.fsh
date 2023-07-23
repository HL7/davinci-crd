Profile: Coverage
Parent: $Coverage
Id: profile-coverage
Title: "CRD Coverage"
Description: "This profile specifies constraints on the Coverage resource to support coverage requirements discovery."
* ^version = "1.1.0-ci-build"
* ^status = #draft
* ^experimental = false
* ^date = "2023-05-30T11:47:53-07:00"
* ^publisher = "HL7 International - Financial Management Work Group"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.hl7.org/Special/committees/fm"
* ^jurisdiction = urn:iso:std:iso:3166#US
* . ^definition = "This profile specifies constraints on the Coverage resource to support coverage requirements discovery."
* identifier MS
  * ^slicing.discriminator[0].type = #pattern
  * ^slicing.discriminator[=].path = "type"
  * ^slicing.rules = #open
* identifier contains MBIdentifier 0..1 MS
* identifier[MBIdentifier]
  * ^short = "EMR Identifier for MB"
  * type 1.. MS
  * type = $v2-0203#MB
* status MS
* type MS
* policyHolder only Reference(Patient or Organization)
* policyHolder MS
* subscriber only Reference(Patient)
* subscriber MS
* subscriberId MS
* beneficiary only Reference(Patient)
* beneficiary MS
* dependent MS
* relationship MS
* period MS
* payor only Reference(Patient or Organization)
* payor MS
* class ..1 MS
  * type only CodeableConcept
  * type MS
  * type from CRDCoverageClasses (required)
    * ^binding.description = "CRD Coverage Classes"
  * value MS
  * name MS
* order MS
* network MS
* costToBeneficiary ..0