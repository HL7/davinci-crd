ValueSet: MetricTokenUse
Id: metricTokenUse
Title: "Metric Token Use"
Description: "A list of codes indicating whether an access token was used as part of CDS Hook processing"
* ^status = #draft
* ^experimental = false
* CRDTempCodes#used
* CRDTempCodes#not-used
* CRDTempCodes#rejected