ValueSet: CRDCoveredInfo
Id: coverageInfo
Title: "CRD Coverage Information Covered Value Set"
Description: "Codes defining whether the ordered/requested service is covered under patient's plan"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* CRDTempCodes#not-covered
* CRDTempCodes#covered
* CRDTempCodes#conditional

ValueSet: CRDCoveragePaDetail
Id: coveragePaDetail
Title: "CRD Coverage Information Prior Authorization Value Set"
Description: "Codes defining whether prior auth will be needed for coverage to be provided"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* CRDTempCodes#no-auth
* CRDTempCodes#auth-needed
* CRDTempCodes#satisfied
* CRDTempCodes#performpa
* CRDTempCodes#conditional

ValueSet: CRDAdditionalDoc
Id: AdditionalDocumentation
Title: "CRD Coverage Information Additional Documentation Value Set"
Description: "Codes defining whether additional documentation needs to be captured"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* CRDTempCodes#clinical
* CRDTempCodes#admin
* CRDTempCodes#both
* CRDTempCodes#conditional

ValueSet: CRDDocReason
Id: DocReason
Title: "CRD Coverage Information Documentation Reason Value Set"
Description: "List of reasons for additional documentation"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* include codes from system CRDTempCodes where concept descendent-of #_docReason
* $v3-NullFlavor#OTH

ValueSet: CRDInformationNeeded
Id: informationNeeded
Title: "CRD Information Needed Value Set"
Description: "Codes defining whether information about the perfomer, location, and/or performance date is needed to determine coverage information"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* CRDTempCodes#performer
* CRDTempCodes#location
* CRDTempCodes#timeframe
* $v3-NullFlavor#OTH

ValueSet: CRDCoverageAssertionReasons
Id: coverageAssertionReasons
Title: "CRD Coverage Assertion Reasons"
Description: "Reasons for a coverage assertion in the coverage-information extension"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* CRDTempCodes#gold-card
* CRDTempCodes#detail-code