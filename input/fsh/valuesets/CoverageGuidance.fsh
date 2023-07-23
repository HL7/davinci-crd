ValueSet: CoverageGuidance
Id: coverageGuidance
Title: "Coverage Guidance Value Set"
Description: "Codes defining types of coverage guidance"
* ^status = #draft
* ^experimental = false
* CRDTempCodes#not-covered
* CRDTempCodes#covered
* CRDTempCodes#covered-prior-auth
* CRDTempCodes#clinical
* CRDTempCodes#admin
* CRDTempCodes#perform
* CRDTempCodes#performpa
* CRDTempCodes#detailedcode

ValueSet: CoveredInfo
Id: coverageInfo
Title: "Covered Information Value Set"
Description: "Codes defining whether the ordered/requested service is covered under patient's plan"
* ^status = #draft
* ^experimental = false
* CRDTempCodes#no
* CRDTempCodes#yes
* CRDTempCodes#conditional

ValueSet: CoveragePaDetail
Id: coveragePaDetail
Title: "Coverage Prior Authorization Value Set"
Description: "Codes defining whether prior auth will be needed for coverage to be provided"
* ^status = #draft
* ^experimental = false
* CRDTempCodes#no
* CRDTempCodes#yes
* CRDTempCodes#satisfied
* CRDTempCodes#performing
* CRDTempCodes#conditional

ValueSet: AdditionalDocumentation
Id: AdditionalDocumentation
Title: "Additional Documentation Value Set"
Description: "Codes defining whether additional documentation needs to be captured"
* ^status = #draft
* ^experimental = false
* CRDTempCodes#no
* CRDTempCodes#clinical
* CRDTempCodes#admin
* CRDTempCodes#both
* CRDTempCodes#conditional

ValueSet: InformationNeeded
Id: informationNeeded
Title: "Information Needed Value Set"
Description: "Codes defining whether information about the perfomer, location, and/or performance date is needed to determine coverage information"
* ^status = #draft
* ^experimental = false
* CRDTempCodes#performer
* CRDTempCodes#location
* CRDTempCodes#timeframe
