ValueSet: CRDBillingCodes
Id: billingCodes
Title: "CRD Billing Codes Value Set"
Description: "Codes appropriate for inclusion in a claim or prior authorization"
* ^status = #active
* ^experimental = false
* ^copyright = "Current Procedural Terminology (CPT) is copyright 2020 American Medical Association. All rights reserved."
* include codes from system $cpt
* include codes from system $HCPCSReleaseCodeSets
* include codes from system $rxnorm