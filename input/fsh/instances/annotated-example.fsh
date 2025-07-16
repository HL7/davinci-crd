Instance: annotated-example
InstanceOf: CRDMedicationRequest
Title: "MedicationRequest annotated example"
Description: "Example medication request with an annotation showing coverage expectations"
Usage: #example
* extension[Coverage-Information]
  * extension[coverage].valueReference = Reference(Coverage/example)
  * extension[covered].valueCode = CoverageInformationCodes#conditional
  * extension[pa-needed].valueCode = CoverageInformationCodes#satisfied
  * extension[doc-needed].valueCode = CoverageInformationCodes#admin
  * extension[doc-purpose].valueCode = CoverageInformationCodes#withclaim
  * extension[info-needed].valueCode = CoverageInformationCodes#performer
  * extension[billingCode].valueCoding = $cpt#77065
  * extension[billingCode].valueCoding = $cpt#77066
  * extension[billingCode].valueCoding = $cpt#77067
  * extension[reason].valueCodeableConcept.text = "Prior auth waved due to gold-card status"
  * extension[reason].valueCodeableConcept = $temp#gold-card
  * extension[detail]
    * extension[category].valueCode = CoverageInformationCodes#cat-other
    * extension[code].valueCodeableConcept = $temp#policy-link
    * extension[value].valueUrl = "http://example.org/somepayer/policy123.pdf#abc"
    * extension[qualification].valueString = "Additional policy details can be found here"
  * extension[questionnaire].valueCanonical = "http://example.org/some-payer/Questionnaire/123|1.3.0"
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
