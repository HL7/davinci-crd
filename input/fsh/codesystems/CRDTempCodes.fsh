CodeSystem: CRDTempCodes
Id: temp
Title: "CRD Temporary Codes"
Description: "Codes temporarily defined as part of the CRD implementation guide.  These will eventually migrate into an officially maintained terminology (likely either SNOMED CT or HL7's UTG code systems)."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^hierarchyMeaning = #is-a
* ^content = #complete
// after-completion code
* #prior-auth-include      "Include in prior authorization"    "Include information in prior authorization"
* #initial-claim-include   "Include in initial claim"          "Include information in initial claim submission"
* #all-claims-include      "Include in all claims"             "Include information in all claim submissions"
* #to-endpoint             "Send to endpoint"                  "Send information to the specified endpoint"
// Task reason
* #reason-prior-auth       "Prior authorization"               "Task action is needed for prior authorization"
// Task input codes
* #after-completion-action "After-completion action"           "A task input indicating an action that should be taken after a QuestionnaireResponse has been completed on a specified Questionnaire.  (Multiple completion actions can be specified.)"
// Coverage assertion reasons
* #gold-card               "Gold card"                         "Ordering Practitioner has been granted 'gold card' status with this payer/coverage type."
* #detail-code             "Detail code"                       "The ordered code is at too high a level of granularity to make decisions about coverage/pa/etc.  Can only be present if something is 'conditional'"
// Coverage detail types
* #allowed-quantity        "Maximum quantity"                  "Indicates limitations on the number of services/products allowed (possibly per time period).  Value should be a Quantity"
* #allowed-period          "Maximum allowed period"            "Indicates the maximum period of time that can be covered in a single order.  Value should be a Period"
* #in-network-copay        "Copay for in-network"              "Indicates a percentage co-pay to expect if delivered in-network.  Value should be a Quantity."
* #out-network-copay       "Copay for out-of-network"          "Indicates a percentage co-pay to expect if delivered out-of-network.  Value should be a Quantity."
* #auth-out-network-only   "Authorization out-of-network only" "Authorization is only necessary if out-of-network.  Value should be a boolean."
* #concurrent-review       "Concurrent review"                 "Additional payer-defined documentation will be required prior to claim payment.  Value should be a boolean."
* #appropriate-use-needed  "Appropriate use"                   "Payer-defined appropriate use process must be invoked to determine coverage.  Value should be a boolean."
// Coverage guidance - general
* #conditional             "Conditional"                       "Decision cannot be made without more information (more detailed code, service rendering information, etc.)"
// Coverage guidance - covered
* #covered                 "Covered"                           "Regular coverage applies"
* #not-covered             "Not covered"                       "No coverage or possibility of coverage for this service)"
// Coverage guidance - doc
* #clinical                "Clinical Documentation"            "Details most likely to originate from a clinician are required to satisfy additional documentation requirements, determine coverage and/or prior auth applicability - e.g. via DTR by clinician.  Indicates that the CRD client should expose the need to launch DTR to clinical users."
* #admin                   "Administrative Documentation"      "Administrative details not likely to require clinical expertise are needed to satisfy additional documentation requirements, determine coverage and/or prior auth applicability - e.g. via DTR by back-end staff.  Indicates that while the CRD client might expose the ability to launch DTR as an option for clinical users, it should be clear that clinical input is not necessary and deferring the use of DTR to back-end staff is perfectly appropriate.  Some CRD clients might be configured (based on provider preference) to not even show clinicians the option to launch."
* #both                    "Administrative & clinical doc"     "Both clinical and administrative details are required to satisfy additional documentation requirements, determine coverage and/or prior auth applicability.  Equivalent to the union of #admin and #clinical."
// Coverage guidance - auth
* #no-auth                 "No Prior Authorization"            "The ordered service does not require prior authorization"
* #auth-needed             "Prior Authorization Needed"        "The ordered service will require prior authorization" 
  * #performpa             "Performer Prior Authorization"     "Prior authorization is needed for the service, however such prior authoriation must be initiated by the performing (rather than ordering) provider."
* #satisfied               "Authorization Satisfied"           "While prior authorization would typically be needed, the conditions evaluated by prior authorization have already been evaluated and therefore prior authorization can be bypassed"
// Coverage guidance - info needed
* #performer               "Performer Needed"                  "Information about who (specifically, or at least performer type and affiliation) is necessary to make a determination of coverage and/or prior auth expectations"
* #location                "Location Needed"                   "Information about where (specific clinic/site or organization) is necessary to make a determination of coverage and/or prior auth expectations"
* #timeframe               "Timeframe Needed"                  "Information about when the service will be performed that is more granular than the order effective period is necessary to make a determination of coverage and/or prior auth expectations"
// Metric token use
* #used                    "Authorization Token Used"          "An authorization token was used by the payer to access additional information from the provider system as part of the CDS Hook call"
  * #rejected              "Authorization Token Rejected"      "The payer attempted to use an authorization token to access additional information from the provider system as part of the CDS Hook call, however the access request failed.  (This is not used if the request succeeded but returned no records.)"
* #not-used                "Authorization Token Not Used"      "The payer did not attempt to use an authorization token to access additional information from the provider system as part of the CDS Hook call"
// Metric data source
* #provider-src            "Provider-sourced"                  "The metric information was captured from the provider system's perspective"
* #payer-src               "Payer-sourced"                     "The metric information was captured from the payer system's perspective"
* #_cardType               "Card Type (abstract)"              "A collector for different profiles on CDS Hooks card"
  * ^property.code = #abstract
  * ^property.valueBoolean = true
// Card types
  * #coverage-info            "Coverage Information"           "Information related to the patient's coverage, including whether a service is covered, requires prior authorization, is approved without seeking prior authorization, and/or requires additional documentation or data collection"
  * #claim                    "Claim"                          "Information about what steps need to be taken to submit a claim for the service"
  * #insurance                "Insurance"                      "Allows a provider to update the patient's coverage information with additional details from the payer (e.g. expiry date, coverage extensions)"
  * #limits                   "Limits"                         "Messages warning about the patient approaching or exceeding their limits for a particular type of coverage or expiry date for coverage in general"
  * #network                  "Network"                        "Providing information about in-network providers that could deliver the order (or in-network alternatives for an order directed out-of-network)"
  * #appropriate-use          "Appropriate Use"                "Guidance on whether appropriate-use documentation is needed"
  * #cost                     "Cost"                           "What is the anticipated cost to the patient based on their coverage"
  * #therapy-alternatives-opt "Optional Therapy Alternatives"  "Are there alternative therapies that have better coverage and/or are lower-cost for the patient"
  * #therapy-alternatives-req "Required Therapy Alternatives"  "Are there alternative therapies that must be tried first prior to coverage being available for the proposed therapy"
  * #clinical-reminder        "Clinical Reminder"              "Reminders that a patient is due for certain screening or other therapy (based on payer recorded date of last intervention)"
  * #duplicate-therapy        "Duplicate Therapy"              "Notice that the proposed intervention has already recently occurred with a different provider when that information isn't already available in the provider system"
  * #contraindication         "Contraindication"               "Notice that the proposed intervention may be contraindicated based on information the payer has in their record that the provider doesn't have in theirs"
  * #guideline                "Guideline"                      "Indication that there is a guideline available for the proposed therapy (with an option to view)"
  * #off-guideline            "Off Guideline"                  "Notice that the proposed therapy may be contrary to best-practice guidelines, typically with an option to view the relevant guideline"
* #_HookType               "CDS Hook Type (abstract)"          "A collector for the different types of CDS Hooks"
  * ^property.code = #abstract
  * ^property.valueBoolean = true
  * #appointment-book    "Appointment Book"
  * #encounter-start     "Encounter Start"
  * #encounter-discharge "Encounter Discharge"
  * #order-dispatch"     "Order Dispatch"
  * #order-select        "Order Select"
  * #order-sign          "Order Sign"
* #_docReason              "Additional Information Purposes"   "A collector for codes representing different reasons for capturing additional information"
  * ^property.code = #abstract
  * ^property.valueBoolean = true
  * #withpa              "Include in prior authorization"      "The information in this QuestionnaireResponse should be packaged into a Bundle and submitted as part of (or in association with) a prior authorization for the associated request resource(s)."
  * #withclaim           "Include with claim"                  "The information in this QuestionnaireResponse should be packaged into a Bundle and submitted as part of (or in association with) the insurance claim for the services ordered by the associated request resource(s)."
  * #withorder           "Include with order"                  "The information in this QuestionnaireResponse should be packaged into a Bundle and submitted along with (or referenced as supporting information to) the associated request resource(s) when transmitting the order to the fulfilling system."
  * #retain-doc          "Medical necessity"                   "The information in this QuestionnaireResponse should be retained within the EHR as supporting evidence of the medical necessity of the associated request resource(s)."