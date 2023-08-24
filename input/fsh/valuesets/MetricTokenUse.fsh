ValueSet: MetricTokenUse
Id: metricTokenUse
Title: "CRD Metric Token Use"
Description: "A list of codes indicating whether an access token was used as part of CDS Hook processing"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* CRDTempCodes#used
* CRDTempCodes#not-used
* CRDTempCodes#rejected