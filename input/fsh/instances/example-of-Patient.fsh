Instance: example-of-Patient
InstanceOf: Patient
Title: "Patient example"
Description: "Example patient populated based on CRD profile"
Usage: #example
* id = "example"
* extension[0]
  * extension[0]
    * url = "ombCategory"
    * valueCoding = urn:oid:2.16.840.1.113883.6.238#2106-3 "White"
  * extension[+]
    * url = "ombCategory"
    * valueCoding = urn:oid:2.16.840.1.113883.6.238#1002-5 "American Indian or Alaska Native"
  * extension[+]
    * url = "ombCategory"
    * valueCoding = urn:oid:2.16.840.1.113883.6.238#2028-9 "Asian"
  * extension[+]
    * url = "detailed"
    * valueCoding = urn:oid:2.16.840.1.113883.6.238#1586-7 "Shoshone"
  * extension[+]
    * url = "detailed"
    * valueCoding = urn:oid:2.16.840.1.113883.6.238#2036-2 "Filipino"
  * extension[+]
    * url = "text"
    * valueString = "Mixed"
  * url = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race"
* extension[+]
  * extension[0]
    * url = "ombCategory"
    * valueCoding = urn:oid:2.16.840.1.113883.6.238#2135-2 "Hispanic or Latino"
  * extension[+]
    * url = "detailed"
    * valueCoding = urn:oid:2.16.840.1.113883.6.238#2184-0 "Dominican"
  * extension[+]
    * url = "detailed"
    * valueCoding = urn:oid:2.16.840.1.113883.6.238#2148-5 "Mexican"
  * extension[+]
    * url = "text"
    * valueString = "Hispanic or Latino"
  * url = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity"
* extension[+]
  * url = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex"
  * valueCode = #F
* identifier[0]
  * use = #usual
  * type = $v2-0203#MR "Medical Record Number"
    * text = "Medical Record Number"
  * system = "http://hospital.smarthealthit.org"
  * value = "1032702"
* active = true
* name[0]
  * family = "Shaw"
  * given[0] = "Amy"
  * given[+] = "V."
  * period
    * start = "2016-12-06"
    * end = "2020-07-22"
* name[+]
  * family = "Baxter"
  * given[0] = "Amy"
  * given[+] = "V."
  * suffix = "PharmD"
  * period.start = "2020-07-22"
* telecom[0]
  * system = #phone
  * value = "555-555-5555"
  * use = #home
* telecom[+]
  * system = #email
  * value = "amy.shaw@example.com"
* gender = #female
* birthDate = "1987-02-20"
* address[0]
  * line = "49 Meadow St"
  * city = "Mounds"
  * state = "OK"
  * postalCode = "74047"
  * country = "US"
  * period
    * start = "2016-12-06"
    * end = "2020-07-22"
* address[+]
  * line = "183 Mountain View St"
  * city = "Mounds"
  * state = "OK"
  * postalCode = "74048"
  * country = "US"
  * period.start = "2020-07-22"