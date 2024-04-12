Profile: CRDCoverage
Parent: USCoreCoverageProfile
Id: profile-coverage
Title: "CRD Coverage"
Description: "This profile specifies constraints on the Coverage resource to support coverage requirements discovery."
* ^experimental = false
* . ^definition = "This profile specifies constraints on the Coverage resource to support coverage requirements discovery."
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
