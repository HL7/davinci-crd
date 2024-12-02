Profile: CRDCoverage
Parent: USCoreCoverageProfile|7.0.0
Id: profile-coverage
Title: "CRD Coverage"
Description: "This profile specifies constraints on the Coverage resource to support coverage requirements discovery."
* ^experimental = false
* . ^definition = "This profile specifies constraints on the Coverage resource to support coverage requirements discovery."
* ^extension[$compliesWithProfile][+].valueCanonical = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-coverage|6.1.0"
* policyHolder MS
* policyHolder only Reference(CRDPatient or CRDOrganization)
* subscriber MS
* subscriber only Reference(CRDPatient)
* beneficiary only Reference(CRDPatient)
* dependent MS
* payor only Reference(CRDPatient or CRDOrganization)
* order MS
* network MS
* costToBeneficiary ..0
