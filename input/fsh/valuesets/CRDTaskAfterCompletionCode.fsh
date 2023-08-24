ValueSet: CRDTaskAfterCompletionCode
Id: afterCompletionCode
Title: "CRD After Completion Code Value Set"
Description: "Actions to take after completing form"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* CRDTempCodes#prior-auth-include
* CRDTempCodes#initial-claim-include
* CRDTempCodes#all-claims-include