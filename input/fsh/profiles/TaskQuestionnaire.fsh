Profile: CRDTaskQuestionnaire
Parent: SDCTaskQuestionnaire
Id: profile-taskquestionnaire
Title: "CRD Questionnaire Task"
Description: "This profile specifies constraints on the Task resource to support requests for form (Questionnaire) completion."
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* basedOn MS
  * ^requirements = "Allows linking the Questionnaire to the particular 'request' that triggered its creation."
//* status only code
* status MS
* status = #ready (exactly)
//* intent only code
* intent MS
* intent = #order (exactly)
* for 1.. MS
* for only Reference(CRDPatient)
* encounter MS
* encounter only Reference(CRDEncounter)
  * ^comment = "This should be set to the same encounter as specified in the launch context (if any)."
* authoredOn 1.. MS
* requester 1.. MS
* requester only Reference(CRDOrganization)
  * ^short = "Payer requesting form completion"
* owner 0..1 MS
* owner only Reference(USCorePractitionerProfile)
  * ^comment = "This can be populated within the CRD client to delegate responsibility for filling out the form to someone else."
* reasonCode MS
* reasonCode from CRDTaskReason (extensible)
  * ^requirements = "Captures additional details about why the form is needed.  E.g. \"For prior authorization\" or \"For audit documentation\"."
  * ^binding.description = "CRD Task Reason"
* input contains afterCompletion 1..* MS
* input[afterCompletion] ^definition = "Indicates the action to take after completing the form."
  * type only CodeableConcept
  * type = $temp#after-completion-action
  * type MS
  * value only CodeableConcept
  * value MS
  * value from CRDTaskAfterCompletionCode (extensible)
    * ^binding.description = "CRD After Completion"