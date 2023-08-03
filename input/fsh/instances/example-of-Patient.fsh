Instance: example-of-Patient
InstanceOf: Patient
Title: "Patient example"
Description: "Example patient populated based on CRD profile"
Usage: #example
* id = "example"
* extension[race]
  * extension[ombCategory].valueCoding = $raceEthnicity#2106-3 "White"
  * extension[ombCategory].valueCoding = $raceEthnicity#1002-5 "American Indian or Alaska Native"
  * extension[ombCategory].valueCoding = $raceEthnicity#2028-9 "Asian"
  * extension[detailed].valueCoding = $raceEthnicity#1586-7 "Shoshone"
  * extension[detailed].valueCoding = $raceEthnicity#2036-2 "Filipino"
  * extension[text].valueString = "Mixed"
* extension[ethnicity]
  * extension[ombCategory].valueCoding = $raceEthnicity#2135-2 "Hispanic or Latino"
  * extension[detailed].valueCoding = $raceEthnicity#2184-0 "Dominican"
  * extension[detailed].valueCoding = $raceEthnicity#2148-5 "Mexican"
  * extension[text].valueString = "Hispanic or Latino"
* extension[birthsex].valueCode = #F
* identifier[MRIdentifier]
  * use = #usual
  * type.text = "Medical Record Number"
  * system = "http://hospital.smarthealthit.org"
  * value = "1032702"
* active = true
* name[+]
  * family = "Shaw"
  * given[+] = "Amy"
  * given[+] = "V."
  * period
    * start = "2016-12-06"
    * end = "2020-07-22"
* name[+]
  * family = "Baxter"
  * given[+] = "Amy"
  * given[+] = "V."
  * suffix = "PharmD"
  * period.start = "2020-07-22"
* telecom[+]
  * system = #phone
  * value = "555-555-5555"
  * use = #home
* telecom[+]
  * system = #email
  * value = "amy.shaw@example.com"
* gender = #female
* birthDate = "1987-02-20"
* address[+]
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