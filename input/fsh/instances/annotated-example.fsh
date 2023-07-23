Instance: annotated-example
InstanceOf: MedicationRequest
Title: "MedicationRequest annotated example"
Description: "Example medication request with an annotation showing coverage expectations"
Usage: #example
* extension
  * extension[0]
    * url = "coverageInfo"
    * valueCoding = $temp#covered-prior-auth "Covered with prior authorization"
  * extension[+]
    * url = "coverage"
    * valueReference = Reference(Coverage/example)
  * extension[+]
    * url = "billingCode"
    * valueCoding = $cpt#77065
  * extension[+]
    * url = "billingCode"
    * valueCoding = $cpt#77066
  * extension[+]
    * url = "billingCode"
    * valueCoding = $cpt#77067
  * extension[+]
    * url = "reason"
    * valueCodeableConcept.text = "In-network required unless exigent circumstances"
  * extension[+]
    * url = "detail"
    * extension[0]
      * url = "code"
      * valueCodeableConcept = $temp#auth-out-network-only
    * extension[+]
      * url = "value"
      * valueBoolean = true
    * extension[+]
      * url = "qualification"
      * valueString = "Out-of-network prior auth does not apply if delivery occurs at a service site designated as 'remote'"
  * extension[+]
    * url = "date"
    * valueDate = "2019-02-15"
  * extension[+]
    * url = "identifier"
    * valueString = "12345ABC"
  * extension[+]
    * url = "contact"
    * valueContactPoint
      * system = #url
      * value = "http://some-payer/xyz-sub-org/get-help-here.html"
  * url = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/ext-coverage-information"
* status = #draft
* intent = #original-order
* medicationCodeableConcept = $rxnorm#616447 "Cellcept 250 MG Oral Capsule"
* subject = Reference(http://example.org/Patient/123) "Jane Smith"
* encounter = Reference(http://example.org/Encounter/ABC)
* authoredOn = "2019-02-15"
* requester = Reference(http://example.org/PractitionerRole/987) "Dr. Jones"
* note
  * authorString = "XYZ Insurance"
  * time = "2019-02-15T15:07:18-05:00"
  * text = "Unsolicited prior authorization for Jane Smith to receive 6 tablets Cellcept 250 MG Oral Capsule BID granted.  Please note prior authorization # 12345 on claim submission."
* dosageInstruction
  * text = "6 tablets every 12 hours."
  * timing.repeat
    * frequency = 1
    * period = 12
    * periodUnit = #h
  * doseAndRate.doseQuantity
    * value = 6
    * unit = "tablet"