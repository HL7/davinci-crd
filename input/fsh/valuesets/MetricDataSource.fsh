ValueSet: MetricDataSource
Id: metricDataSource
Title: "CRD Metric Data Source Value Set"
Description: "A list of codes indicating the perspective from which metric data was captured"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* CRDMetricCodes#payer-src
* CRDMetricCodes#provider-src