ValueSet: MetricOrderDetail
Id: orderDetail
Title: "CRD Order Detail Codes Value Set"
Description: "Detail codes for products and services that are the focus of a CRD call"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* include codes from valueset ServiceType
* include codes from valueset CRDDeviceRequests
* include codes from valueset $USCoreMedicationCodes
* include codes from valueset CRDServiceRequestCodes
* include codes from valueset ExampleVisionPrescriptionProductCodes