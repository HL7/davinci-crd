Instance: example-of-Coverage
InstanceOf: Coverage
Title: "Coverage example"
Description: "Example identified coverage populated based on CRD profile"
Usage: #example
* id = "example"
* identifier
  * system = "http://example.com/fhir/NampingSystem/certificate"
  * value = "12345"
* status = #active
* type = $v3-ActCode#EHCPOL "extended healthcare"
* policyHolder = Reference(http://example.org/FHIR/Organization/CBI35)
* subscriber = Reference(Patient/example)
* beneficiary = Reference(Patient/example)
* dependent = "0"
* relationship = $subscriber-relationship#self
* period
  * start = "2011-05-23"
  * end = "2012-05-23"
* payor = Reference(http://example.org/fhir/Organization/example-payer) "Payer XYZ"
* class
  * type = $coverage-class#group
  * value = "CB135"
  * name = "Corporate Baker's Inc. Local #35"