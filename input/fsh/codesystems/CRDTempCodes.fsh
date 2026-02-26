/*
 * The content in this code system is maintained for backwards compatibility only.  These codes are deprecated and will eventually be retired.
 */

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
// Coverage assertion reasons - https://jira.hl7.org/browse/UP-668, https://jira.hl7.org/browse/UP-782
// Now maintained in sourceOfTruth/v3/codeSystems/v3-ActReason.xml
* #gold-card               "Gold card"                           "Ordering Practitioner has been granted 'gold card' status with this payer/coverage type."
* #no-member-found         "Member not found"                    "The server was unable to find a matching member or was unable to resolve to a single member, so no coverage information can be provided."
* #no-active-coverage      "Coverage not active"                 "The referenced coverage for the member was found but is not in force during the relevant time period for which the coverage is being evaluated."
* #coverage-not-found      "Coverage not found"                  "The payer is not available to resolve the provided coverage information to an existing coverage record, or it is not specific enough to resolve to a single coverage."
* #auth-out-network        "Authorization needed out-of-network" "Authorization is necessary if out-of-network."
* #technical               "Technical issues"                    "The server encountered technical issues either internally or with their interaction with the client.  It is possible these issues are transient and later calls might provide more information."

// Coverage detail types - https://jira.hl7.org/browse/UP-670
// Now maintained in sourceOfTruth/fhir/codeSystems/CodeSystem-crd-coverage-detail.xml
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
// Now maintained in sourceOfTruth/fhir/codeSystems/CodeSystem-cdshooks-card-type.xml
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

// Requirement categories - https://jira.hl7.org/browse/UP-783
// To be maintained in sourceOfTruth/fhir/codeSystems/CodeSystem-requirement-category.xml
* #_reqcat      "Requirements Categories"  "Codes that help to categorize requirements statements"
  * ^property.code = #abstract
  * ^property.valueBoolean = true
  * #behavioral "Behavioral"                   "Categories related to how the system behaves"
    * ^property.code = #abstract
    * ^property.valueBoolean = true
    * #business   "Business"                   "Requirements relating to the business operations of the entities responsible for a system"
    * #functional "Functional"                 "Requirements related to what the system does (inputs turned into outputs)"
      * #exchange    "Exchange"                "Requirements relating to when, how, or what data is exchanged with other systems"
      * #processing  "Processing"              "Requirements related to how data must be analyzed, transformed, considered, or otherwise used within a system"
      * #storage     "Storage"                 "Requirements related to if or how data is persisted in a system"
    * #non-functional "Non-functional"         "Requirements related to how the system accomplishes functional requirements"
      * #availability "Availability"           "Requirements related to how and when a system needs to be reachable and useable"
      * #ui           "User Interface"         "Requirements related to how information is collected from and exposed to humans (or animals)"
        * #ui-accessibility "UI Accessibility" "Requirements around user interface that ensure a satisfactory experience for users from different backgrounds or with varying physical, cognitive, and/or sensory abilities"
        * #ui-consistency   "UI Consistency"   "Requirements around ensuring that different implementations have sufficiently aligned appearance and mechanisms of interaction"
        * #ui-usability     "UI Usability"     "Requirements related to the intuitiveness, simplicity, and ease-of-use of a user-interface"
      * #security    "Security/Privacy"        "Requirements that ensure that data is appropriately protected from threats and respects rules around what parties are permitted to access or manipulate"
      * #safety      "Safety"                  "Requirements that ensure that system operation does not negatively impact the wellbeing of people or assets"
      * #performance "Performance/Scalability" "Requirements that deal with timeliness of processing and/or responsiveness under differing levels of load/volume"
  * #source     "Source"                       "Categories related to where the requirement came from"
    * ^property.code = #abstract
    * ^property.valueBoolean = true
    * #user   "User Requirements"              "Requirements originating from the community of individuals expected to use the system/solution"
    * #legal  "Legal Requirements"             "Requirements originating from regulation or law"
    * #design "Design Decisions"               "Requirements documenting decisions made in the design of the solution"
