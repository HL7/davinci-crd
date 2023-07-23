Instance: questionnaire-example
InstanceOf: TaskQuestionnaire
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
* reasonCode = $temp#reason-prior-auth
  * text = "Needed for prior authorization"
* input[0]
  * type = $temp_1#questionnaire
  * valueCanonical = "http://example.org/Questionnaire/XYZ|2"
* input[+]
  * type = $temp_1#response-endpoint
  * valueUrl = "http://example.org/somePayer"
* input[afterCompletion]
  * type = $temp#after-completion-action
  * valueCodeableConcept = $temp#prior-auth-include "Include in prior authorization"