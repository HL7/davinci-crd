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
* status = #ready
//* intent only code
* intent MS
* intent = #order
* focus 0..0
  * ^requirements = "Questionnaire tasks resulting from decision support are never orders, merely to-dos"
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
  * text MS
* input[questionnaire] 1..1
