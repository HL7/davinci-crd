Instance: example-of-Organization
InstanceOf: CRDOrganization
Title: "Organization example"
Description: "Example organization populated based on CRD profile"
Usage: #example
* id = "example"
* identifier
  * system = "http://hl7.org/fhir/sid/us-npi"
  * value = "1234567893"
* active = true
* name = "University Medical Center"
* telecom[0]
  * system = #phone
  * value = "+1 555 234 3523"
  * use = #work
* telecom[+]
  * system = #email
  * value = "info@acme.org"
  * use = #work
* address
  * use = #work
  * line = "Galapagosweg 91"
  * city = "San Francisco"
  * state = "CA"
  * postalCode = "94107"
  * country = "US"