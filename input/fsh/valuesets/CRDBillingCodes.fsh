ValueSet: CRDBillingCodes
Id: billingCodes
Title: "CRD Billing Codes"
Description: "Codes appropriate for inclusion in a claim or prior authorization"
* ^status = #active
* ^experimental = false
* include codes from system $cpt
* include codes from system $HCPCSReleaseCodeSets
* include codes from system $rxnorm