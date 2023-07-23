Instance: visionprescription-example
InstanceOf: VisionPrescription
Title: "VisionPrescription example"
Description: "Example vision prescription based on CRD profile"
Usage: #example
* identifier
  * system = "http://www.happysight.com/prescription"
  * value = "15013"
* status = #draft
* created = "2014-06-15"
* patient = Reference(Patient/example)
* dateWritten = "2014-06-15"
* prescriber = Reference(Practitioner/example)
* lensSpecification[0]
  * product = $ex-visionprescriptionproduct#lens
  * eye = #right
  * sphere = -2.00
  * prism
    * amount = 0.5
    * base = #down
  * add = 2.00
* lensSpecification[+]
  * product = $ex-visionprescriptionproduct#lens
  * eye = #left
  * sphere = -1.00
  * cylinder = -0.50
  * axis = 180
  * prism
    * amount = 0.5
    * base = #up
  * add = 2.00