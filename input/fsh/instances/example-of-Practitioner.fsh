Instance: example-of-Practitioner
InstanceOf: CRDPractitioner
Title: "Practitioner example"
Description: "Example practitioner populated based on CRD profile"
Usage: #example
* id = "example"
* identifier[NPI]
  * value = "1234567893"
* identifier[+]
  * system = "http://www.acme.org/practitioners"
  * value = "25456"
* name
  * family = "Careful"
  * given = "Adam"
  * prefix = "Dr"
* address
  * use = #home
  * line = "1003 Healthcare Drive"
  * city = "Amherst"
  * state = "MA"
  * postalCode = "01002"
* qualification
  * identifier
    * system = "http://example.org/UniversityIdentifier"
    * value = "12345"
  * code = $v2-0360#BS "Bachelor of Science"
    * text = "Bachelor of Science"
  * period.start = "1995"
  * issuer.display = "Example University"