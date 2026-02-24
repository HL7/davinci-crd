ValueSet: CRDCoverageDetailCodes
Id: coverageDetail
Title: "Deprecated CRD Coverage Detail Codes Value Set"
Description: "Codes for name-value-pair details on a coverage assertion - replaced by the coverageDetailNew value set.  Support for this ValueSet will be dropped in a future version."
* ^status = #retired
* ^experimental = false
* ^extension[$standards-status].valueCode = #deprecated
* CRDTempCodes#allowed-quantity
* CRDTempCodes#allowed-period
* CRDTempCodes#in-network-copay
* CRDTempCodes#out-network-copay
* CRDTempCodes#concurrent-review
* CRDTempCodes#appropriate-use-needed
* CRDTempCodes#policy-link
* CRDTempCodes#instructions

ValueSet: CRDCoverageDetailCodesNew
Id: coverageDetailNew
Title: "Official CRD Coverage Detail Codes Value Set"
Description: "Codes for name-value-pair details on a coverage assertion - now using official FHIR codes"
* ^status = #active
* ^experimental = false
* include codes from system $crd-coverage-detail
