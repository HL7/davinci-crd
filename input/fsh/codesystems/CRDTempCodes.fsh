CodeSystem: CRDTempCodes
Id: temp
Title: "CRD Temporary Codes"
Description: "Codes temporarily defined as part of the CRD implementation guide.  These will eventually migrate into an officially maintained terminology (likely either SNOMED CT or HL7's UTG code systems)."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^hierarchyMeaning = #is-a
* ^content = #complete
* ^property[0].code = #abstract
* ^property[0].uri = "http://hl7.org/fhir/concept-properties#notSelectable"
* ^property[0].type = #boolean
// Coverage assertion reasons - https://jira.hl7.org/browse/UP-668
* #gold-card               "Gold card"                           "Ordering Practitioner has been granted 'gold card' status with this payer/coverage type."
* #no-member-found         "Member not found"                    "The CRD server was unable to find a matching member, so no coverage information can be provided"
* #no-active-coverage      "Coverage not active"                 "The referenced insurance coverage for the member is not active, so no coverage information can be provided"
* #auth-out-network        "Authorization needed out-of-network" "Authorization is necessary if out-of-network."

// Coverage detail types - https://jira.hl7.org/browse/UP-670
* #_limitation              "Limitation details"                "Identifies detail codes that define limitations of coverage.  (Category should be 'cat-limitation')"
  * ^property.code = #abstract
  * ^property.valueBoolean = true
  * #allowed-quantity       "Maximum quantity"                  "Indicates limitations on the number of services/products allowed (possibly per time period).  Value should be a Quantity"
  * #allowed-period         "Maximum allowed period"            "Indicates the maximum period of time that can be covered in a single order.  Value should be a Period"
* #_decisional              "Decisional details"                "Identifies detail codes that may impact patient and clinician decision making  (Category should be 'cat-decisional')"
  * ^property.code = #abstract
  * ^property.valueBoolean = true
  * #in-network-copay       "Copay for in-network"              "Indicates a percentage co-pay to expect if delivered in-network.  Value should be a Quantity."
  * #out-network-copay      "Copay for out-of-network"          "Indicates a percentage co-pay to expect if delivered out-of-network.  Value should be a Quantity."
  * #concurrent-review      "Concurrent review"                 "Additional payer-defined documentation will be required prior to claim payment.  Value should be a boolean."
  * #appropriate-use-needed "Appropriate use"                   "Payer-defined appropriate use process must be invoked to determine coverage.  Value should be a boolean."
* #_other                   "Other details"                     "Identifies detail codes that are generally not relevant to clinicians/patients  (Category should be 'cat-other')"
  * ^property.code = #abstract
  * ^property.valueBoolean = true
  * #policy-link            "Policy Link"                       "A URL pointing to the specific portion of a payer policy, coverage agreement or similar authoritative document that provides a portion of the basis for the decision documented in the coverage-information.  Value should be a url."
* #instructions             "Instructions"                      "Information to display to the user that gives guidance about what steps to take in achieving the recommended actions identified by this coverage-information (e.g. special instructions about requesting authorization, details about information needed, details about data retention, etc.).  Value should be a string.  (Category may vary.)"

// Card types - https://jira.hl7.org/browse/UP-669
* #_cardType               "Card Type (abstract)"              "A collector for different profiles on CDS Hooks card"
  * ^property.code = #abstract
  * ^property.valueBoolean = true
  * #coverage-info            "Coverage Information"           "Information related to the patient's coverage, including whether a service is covered, requires prior authorization, is approved without seeking prior authorization, and/or requires additional documentation or data collection"
    * #unsolicited-determ     "Unsolicited Determination"      "An unsolicited approval of the service as having prior authorization requirements met without a formal submission of a prior authorization request"
  * #claim                    "Claim"                          "Information about what steps need to be taken to submit a claim for the service"
  * #insurance                "Insurance"                      "Allows a provider to update the patient's coverage information with additional details from the payer (e.g. expiry date, coverage extensions)"
  * #limits                   "Limits"                         "Messages warning about the patient approaching or exceeding their limits for a particular type of coverage or expiry date for coverage in general"
  * #network                  "Network"                        "Providing information about in-network providers that could deliver the order (or in-network alternatives for an order directed out-of-network)"
  * #appropriate-use          "Appropriate Use"                "Guidance on whether appropriate-use documentation is needed"
  * #cost                     "Cost"                           "What is the anticipated cost to the patient based on their coverage"
  * #therapy-alternatives-opt "Optional Therapy Alternatives"  "Are there alternative therapies that have better coverage and/or are lower-cost for the patient"
  * #therapy-alternatives-req "Required Therapy Alternatives"  "Are there alternative therapies that must be tried first prior to coverage being available for the proposed therapy"
  * #clinical-reminder        "Clinical Reminder"              "Reminders that a patient is due for certain screening or other therapy (based on payer recorded date of last intervention)"
  * #duplicate-therapy        "Duplicate Therapy"              "Notice that the proposed intervention has already recently occurred with a different provider when that information is not already available in the provider system"
  * #contraindication         "Contraindication"               "Notice that the proposed intervention may be contraindicated based on information the payer has in their record that the provider does not have in theirs"
  * #guideline                "Guideline"                      "Indication that there is a guideline available for the proposed therapy (with an option to view)"
  * #off-guideline            "Off Guideline"                  "Notice that the proposed therapy may be contrary to best-practice guidelines, typically with an option to view the relevant guideline"

* #_reqcat      "Requirements Categories"  "Codes that help to categorize requirements statements"
  * ^property.code = #abstract
  * ^property.valueBoolean = true
  * #business   "business"            "Requirements relating to the business operations of the entities responsible for a system"
  * #exchange   "exchange"            "Requirements relating to when or how data is exchanged with other systems"
  * #processing "processing"          "Requirements related to how data is dealt with internally to a system"
  * #storage    "storage"             "Requirements relating to when or how data is or is not persisted within a system"
  * #ui         "ui"                  "Requirements relating to the appearance of information on a user interface"
