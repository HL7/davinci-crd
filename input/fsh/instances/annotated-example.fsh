Instance: annotated-example
InstanceOf: CRDMedicationRequest
Title: "MedicationRequest annotated example"
Description: "Example medication request with an annotation showing coverage expectations"
Usage: #example
* contained[+] = qr
* extension[Coverage-Information]
  * extension[coverage].valueReference = Reference(Coverage/example)
  * extension[covered].valueCode = $temp#conditional
  * extension[pa-needed].valueCode = $temp#satisfied
  * extension[doc-needed].valueCode = $temp#admin
  * extension[doc-purpose].valueCode = $temp#withclaim
  * extension[info-needed].valueCode = $temp#performer
  * extension[billingCode].valueCoding = $cpt#77065
  * extension[billingCode].valueCoding = $cpt#77066
  * extension[billingCode].valueCoding = $cpt#77067
  * extension[reason].valueCodeableConcept.text = "In-network required unless exigent circumstances"
  * extension[reason].valueCodeableConcept = $temp#gold-card
  * extension[detail]
    * extension[code].valueCodeableConcept = $temp#auth-out-network-only
    * extension[value].valueBoolean = true
    * extension[qualification].valueString = "Out-of-network prior auth does not apply if delivery occurs at a service site designated as 'remote'"
  * extension[questionnaire].valueCanonical = "http://example.org/some-payer/Questionnaire/123|1.3.0"
  * extension[response].valueReference.reference = "#qr"
  * extension[date].valueDate = "2019-02-15"
  * extension[coverage-assertion-id].valueString = "12345ABC"
  * extension[satisfied-pa-id].valueString = "XXYYZ"
  * extension[contact].valueContactPoint
    * system = #url
    * value = "http://some-payer.org/xyz-sub-org/get-help-here.html"
  * extension[expiry-date].valueDate = "2019-08-01"
* status = #draft
* intent = #original-order
* medicationCodeableConcept = $rxnorm#616447 "mycophenolate mofetil 250 MG Oral Capsule [Cellcept]"
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

Instance: qr
InstanceOf: QuestionnaireResponse
Usage: #inline
* questionnaire = "http://example.org/some-payer/Questionnaire/123|1.3.0"
* subject = Reference(http://example.org/Patient/123) "Jane Smith"
* status = #in-progress
* authored = "2019-02-15"
* author
  * identifier
    * system = "http://some-payer.org/xyz-sub-org/identifiers/application-ids"
    * value = "payer-CRD-service-id"
  * display = "Some payer app name"
* item[+]
  * linkId = "A1234"
  * text = "How many previous treatments have been tried for this issue?"
  * answer[+]
    * valueInteger = 2