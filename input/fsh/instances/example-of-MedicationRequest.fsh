Instance: example-of-MedicationRequest
InstanceOf: CRDMedicationRequest
Title: "MedicationRequest example"
Description: "Example medication request populated based on CRD profile"
Usage: #example
* id = "example"
* contained = med0320
* identifier
  * use = #official
  * system = "http://www.bmc.nl/portal/prescriptions"
  * value = "12345689"
* status = #draft
* intent = #order
* medicationReference = Reference(med0320)
* subject = Reference(Patient/example)
* encounter = Reference(Encounter/example)
* authoredOn = "2015-01-15"
* requester = Reference(Practitioner/example)
* reasonCode = $sct#11840006 "Traveler's Diarrhea (disorder)"
* note.text = "Patient told to take with food"
* dosageInstruction[0]
  * sequence = 1
  * text = "Two tablets at once"
  * additionalInstruction = $sct#311504000 "With or after food"
  * timing.repeat
    * frequency = 1
    * period = 1
    * periodUnit = #d
  * route = $sct#26643006 "Oral Route"
  * method = $sct#421521009 "Swallow - dosing instruction imperative (qualifier value)"
  * doseAndRate
    * type = $dose-rate-type#ordered "Ordered"
    * doseQuantity = 2 http://terminology.hl7.org/CodeSystem/v3-orderableDrugForm#TAB "TAB"
* dosageInstruction[+]
  * sequence = 2
  * text = "One tablet daily for 4 days"
  * additionalInstruction = $sct#311504000 "With or after food"
  * timing.repeat
    * frequency = 4
    * period = 1
    * periodUnit = #d
  * route = $sct#26643006 "Oral Route"
  * doseAndRate
    * type = $dose-rate-type#ordered "Ordered"
    * doseQuantity = 1 http://terminology.hl7.org/CodeSystem/v3-orderableDrugForm#TAB "TAB"
* insurance = Reference(Coverage/example)
* dispenseRequest
  * validityPeriod
    * start = "2015-01-15"
    * end = "2016-01-15"
  * numberOfRepeatsAllowed = 1
  * quantity = 6 http://terminology.hl7.org/CodeSystem/v3-orderableDrugForm#TAB "TAB"
  * expectedSupplyDuration = 5 'd' "days"
* substitution
  * allowedBoolean = true
  * reason = $v3-ActReason#FP "formulary policy"