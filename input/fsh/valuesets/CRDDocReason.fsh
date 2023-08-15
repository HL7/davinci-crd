ValueSet: CRDDocReason
Id: crdDocReason
Title: "CRD Documentation Reason Value Set"
Description: "List of reasons for additional documentation"
* ^status = #draft
* ^experimental = false
* include codes from system CRDTempCodes where concept descendent-of #_docReason