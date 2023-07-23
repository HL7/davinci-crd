ValueSet: CRDAfterCompletionCode
Id: afterCompletionCode
Title: "CRD After Completion Code"
Description: "Actions to take after completing form"
* ^status = #draft
* ^experimental = false
* CRDTempCodes#prior-auth-include
* CRDTempCodes#initial-claim-include
* CRDTempCodes#all-claims-include
* CRDTempCodes#to-endpoint