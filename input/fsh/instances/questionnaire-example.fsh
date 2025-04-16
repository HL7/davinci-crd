Instance: questionnaire-example
InstanceOf: CRDTaskQuestionnaire
Title: "Questionnaire Task example"
Description: "Example questionnaire-completion Task populated based on CRD profile"
Usage: #example
* basedOn = Reference(MedicationRequest/example)
* status = #ready
* intent = #order
* code = $temp_1#complete-questionnaire
* for = Reference(Patient/example)
* encounter = Reference(Encounter/example)
* authoredOn = "2018-08-09"
* requester = Reference(http://example.org/fhir/Organization/payer)
* reasonCode
  * text = "Helps assess opioid appropriateness"
* input[questionnaire].valueCanonical = "http://example.org/Questionnaire/XYZ|2"
* input[responseEndpoint].valueUrl = "http://example.org/somePayer"