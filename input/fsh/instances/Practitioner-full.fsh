Instance: Practitioner-full
InstanceOf: CRDPractitioner
Title: "Practitioner full example"
Description: "An example showing a fully populated US Core Practitioner instance (used in CRD examples)"
Usage: #example
* id = "full"
* identifier[0]
  * system = "http://example.org/some-code-system"
  * value = "9941339108"
* identifier[+]
  * system = "http://hl7.org/fhir/sid/us-npi"
  * value = "1234567893"
* identifier[+]
  * system = "urn:oid:2.16.840.1.113883.4.4"
  * value = "123456789"
* name.family = "Bone"
* telecom[+]
  * system = #phone
  * value = "1-234-567-8900"
* telecom[+]
  * system = #email
  * value = "bones@example.org"
* address[+]
  * line[+] = "Suite 100"
  * line[+] = "101 Some Street"
  * city = "Las Vegas"
  * state = "CA"
  * postalCode = "99999"
  * country = "U.S.A."
* address[+]
  * line[+] = "Care of Docs R Us"
  * line[+] = "123 Another Street"
  * city = "Vancouver"
  * state = "BC"
  * postalCode = "V1A 2B3"
* qualification[0].code.text = "Cardiologist"
* qualification[+].code.text = "Surgeon"