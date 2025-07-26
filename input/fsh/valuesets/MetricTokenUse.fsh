ValueSet: MetricTokenUse
Id: metricTokenUse
Title: "CRD Metric Token Use Value Set"
Description: "A list of codes indicating whether an access token was used as part of CDS Hooks processing"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* CRDMetricCodes#used
* CRDMetricCodes#not-used
* CRDMetricCodes#rejected