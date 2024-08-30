Instance: example-of-Location
InstanceOf: CRDLocation
Title: "Location example"
Description: "Example location populated based on CRD profile"
Usage: #example
* id = "example"
* identifier.value = "B1-S.F2"
* status = #active
* name = "South Wing, second floor"
* alias[0] = "MC, SW, F2"
* alias[+] = "University Medical Center, South Wing, second floor"
* description = "Second floor of the Old South Wing, formerly in use by Psychiatry"
* mode = #instance
* type = $v3-RoleCode#HOSP
* telecom[0]
  * system = #phone
  * value = "2328"
  * use = #work
* telecom[+]
  * system = #fax
  * value = "2329"
  * use = #work
* telecom[+]
  * system = #email
  * value = "second-wing-admissions@sampleorg.com"
* telecom[+]
  * system = #url
  * value = "http://sampleorg.com/southwing"
  * use = #work
* address
  * use = #work
  * line = "Galapagosweg 91, Building A"
  * city = "San Francisco"
  * state = "CA"
  * postalCode = "94107"
  * country = "US"
* physicalType = $location-physical-type#wi "Wing"
* managingOrganization = Reference(Organization/example)
* endpoint = Reference(http://example.org/fhir/Endpoint/example)