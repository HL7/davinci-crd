CodeSystem: CoverageInformationCodes
Id: coverage-information-codes
Title: "Coverage Information Codes"
Description: "Codes used by 'code' elements within the Coverage-Information extension."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^hierarchyMeaning = #is-a
* ^content = #complete
* ^property[0].code = #abstract
* ^property[0].uri = "http://hl7.org/fhir/concept-properties#notSelectable"
* ^property[0].type = #boolean
// Coverage guidance - general
* #conditional             "Conditional"                       "There is the potential for information requirements from a participant type not listed.  However, a decision on whether there in fact are additional information requirements cannot be made without more information (more detailed code, service rendering information, etc.)"
// Coverage guidance - covered
* #covered                 "Covered"                           "Regular coverage applies.  Coverage is still subject to normal plan limits, deductibles, and other considerations meaning there is no guarantee of payment.  This response does NOT replace any need for a pre-determination, if required."
* #not-covered             "Not covered"                       "No coverage or possibility of coverage for this service"
// Coverage guidance - auth
* #no-auth                 "No Prior Authorization"            "The ordered service does not require prior authorization"
* #auth-needed             "Prior Authorization Needed"        "The ordered service will require prior authorization" 
  * #performpa             "Performer Prior Authorization"     "Prior authorization is needed for the service, however such prior authoriation must be initiated by the performing (rather than ordering) provider."
* #satisfied               "Authorization Satisfied"           "While prior authorization would typically be needed, the conditions evaluated by prior authorization have already been evaluated and therefore prior authorization can be bypassed"
// Coverage guidance - doc
* #clinical                "Clinical Documentation"            "Details most likely to originate from a clinician are required to satisfy additional documentation requirements, determine coverage and/or prior auth applicability - e.g. via DTR by clinician.  Indicates that the CRD client should expose the need to launch DTR to clinical users."
* #admin                   "Administrative Documentation"      "Administrative details not likely to require clinical expertise are needed to satisfy additional documentation requirements, determine coverage and/or prior auth applicability - e.g. via DTR by back-end staff.  Indicates that while the CRD client might expose the ability to launch DTR as an option for clinical users, it should be clear that clinical input is not necessary and deferring the use of DTR to back-end staff is perfectly appropriate.  Some CRD clients might be configured (based on provider preference) to not even show clinicians the option to launch."
//* #both                    "Administrative & clinical doc"     "Both clinical and administrative details are required to satisfy additional documentation requirements, determine coverage and/or prior auth applicability.  Equivalent to the union of #admin and #clinical."
* #patient                 "Patient-sourced Information"       "Details most likely to originate from the patient or their personal representative (e.g. parent, spouse, etc.) are required to satisfy additional documentation requirements, determine coverage and/or prior auth applicability.  For example, information about household composition, accessibility considerations, etc.  This should be used when the data needs to come from the patient themselves, rather than a clinician's assessment of the patient"
* #_docReason              "Additional Information Purposes"   "A collector for codes representing different reasons for capturing additional information"
  * ^property.code = #abstract
  * ^property.valueBoolean = true
  * #withpa              "Include in prior authorization"      "The information in this QuestionnaireResponse should be packaged into a Bundle and submitted as part of (or in association with) a prior authorization for the associated request resource(s)."
  * #withclaim           "Include with claim"                  "The information in this QuestionnaireResponse should be packaged into a Bundle and submitted as part of (or in association with) the insurance claim for the services ordered by the associated request resource(s)."
  * #withorder           "Include with order"                  "The information in this QuestionnaireResponse should be packaged into a Bundle and submitted along with (or referenced as supporting information to) the associated request resource(s) when transmitting the order to the fulfilling system."
  * #retain-doc          "Medical necessity"                   "The information in this QuestionnaireResponse should be retained within the EHR as supporting evidence of the medical necessity of the associated request resource(s)."
// Coverage guidance - info needed
* #performer               "Performer Needed"                  "Information about who (specifically, or at least performer type and affiliation) is necessary to make a determination of coverage and/or prior auth expectations"
* #location                "Location Needed"                   "Information about where (specific clinic/site or organization) is necessary to make a determination of coverage and/or prior auth expectations"
* #timeframe               "Timeframe Needed"                  "Information about when the service will be performed that is more granular than the order effective period is necessary to make a determination of coverage and/or prior auth expectations"
* #contract-window         "New Contract Window"               "The target performance time for the event falls outside the contract window for the patient's current coverage.  Information will not be available until a contract is in place covering the service time period"
* #detail-code             "Detail code"                       "The ordered code is at too high a level of granularity to make decisions about coverage/pa/etc.  Can only be present if something is 'conditional'"
// Coverage detail-category
* #cat-limitation       "Coverage Limitation"      "The statement being made about coverage or authorization that are being constrained in scope in some way.  I.e. It is not safe to interpret the statements of 'this is covered' or 'this does not require prior auth' without looking at this detail."
* #cat-decisional       "Decision Considerations"  "The statement does not qualify the coverage statement, however it does provide information that may be relevant to the patient & caregiver decision of whether a therapy is appropriate/reasonable."
* #cat-other            "Other Details"            "The statement does not limit the coverage statement being made and is unlikely to influence a decision to proceed with care.  For example, instructions on how to submit a claim, reference to to policy, etc."