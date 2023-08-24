Profile: Coverage
Parent: $Coverage
Id: profile-coverage
Title: "CRD Coverage"
Description: "This profile specifies constraints on the Coverage resource to support coverage requirements discovery."
* . obeys us-core-15
* ^version = "1.1.0-ci-build"
* ^status = #active
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
* type from http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.114222.4.11.3591 (extensible)
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
* class ..* MS
  * ^slicing.discriminator[0].type = #pattern
  * ^slicing.discriminator[=].path = "type"
  * ^slicing.rules = #open
* class contains group 0..1 MS
* class contains plan 0..1 MS
* class[group]
  * type = $coverage-class#group
  * value MS
    * ^short = "Group Number"
  * name MS 
    * ^short = "Group Name"
* class[plan]
  * type = $coverage-class#plan
  * value MS
    * ^short = "Plan Number"
  * name MS
    * ^short = "Plan Name"
* order MS
* network MS
* costToBeneficiary ..0

Invariant:   us-core-15
Description: "Member Id in Coverage.identifier or Coverage.subscriberId SHALL be present"
Severity:    #error
Expression:  "identifier.type.coding.where(system='http://terminology.hl7.org/CodeSystem/v2-0203' and code='MB').exists() or subscriberId.exists()"
XPath:       "exists(f:identifier[f:type/f:coding[f:system/@value='http://terminology.hl7.org/CodeSystem/v2-0203' and code='MB']]) or exists(f:subscriberId)"