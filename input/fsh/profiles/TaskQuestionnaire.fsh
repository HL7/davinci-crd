Profile: TaskQuestionnaire
Parent: SDCTaskQuestionnaire
Id: profile-taskquestionnaire
Title: "CRD Questionnaire Task"
Description: "This profile specifies constraints on the Task resource to support requests for form (Questionnaire) completion."
* ^version = "1.1.0-ci-build"
* ^status = #draft
* ^experimental = false
* ^date = "2023-05-30T11:47:53-07:00"
* ^publisher = "HL7 International - Financial Management Work Group"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.hl7.org/Special/committees/fm"
* ^jurisdiction = urn:iso:std:iso:3166#US
* basedOn MS
  * ^requirements = "Allows linking the Questionnaire to the particular 'request' that triggered its creation."
* status only code
* status = #ready (exactly)
* status MS
* intent only code
* intent = #order (exactly)
* intent MS
* for 1.. MS
* for only Reference(USCorePatientProfile)
* encounter only Reference(Encounter)
* encounter MS
  * ^comment = "This should be set to the same encounter as specified in the launch context (if any)."
* authoredOn 1.. MS
* requester 1.. MS
* requester only Reference(Organization)
  * ^short = "Payer requesting form completion"
* owner 0..1 MS
* owner only Reference(Practitioner)
  * ^comment = "This can be populated within the CRD client to delegate responsibility for filling out the form to someone else."
* reasonCode MS
* reasonCode from CRDReasonCodes (extensible)
  * ^requirements = "Captures additional details about why the form is needed.  E.g. \"For prior authorization\" or \"For audit documentation\"."
  * ^binding.description = "CRD Task Reason"
* input contains afterCompletion 1..* MS
* input[afterCompletion] ^definition = "Indicates the action to take after completing the form."
  * type only CodeableConcept
  * type = $temp#after-completion-action
  * type MS
  * valueCodeableConcept only CodeableConcept
  * valueCodeableConcept MS
  * valueCodeableConcept from CRDAfterCompletionCode (extensible)
    * ^binding.description = "CRD After Completion"