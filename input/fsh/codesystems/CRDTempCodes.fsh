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
// after-completion code
* #prior-auth-include      "Include in prior authorization"    "Include information in prior authorization"
* #initial-claim-include   "Include in initial claim"          "Include information in initial claim submission"
* #all-claims-include      "Include in all claims"             "Include information in all claim submissions"
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
* #policy-link             "Policy Link"                       "A URL pointing to the specific portion of a payer policy, coverage agreement or similar authoritative document that provides a portion of the basis for the decision documented in the coverage-information.  Value should be a url."
* #instructions            "Instructions"                      "Information to display to the user that gives guidance about what steps to take in achieving the recommended actions identified by this coverage-information (e.g. special instructions about requesting authorization, details about information needed, details about data retention, etc.).  Value should be a string."
  * #instructions-clinical   "Clinical instructions"           "Instructions specifically intended for the use of clinical (rather than administrative staff)"
  * #instructions-admin      "Administrative Instructions"     "Instructions specifically intended for the use of administrative (rather than clinical staff)"
// Coverage guidance - general
* #conditional             "Conditional"                       "There is the potential for information requirements from a participant type not listed.  However, a decision on whether there in fact are additional information requirements cannot be made without more information (more detailed code, service rendering information, etc.)"
// Coverage guidance - covered
* #covered                 "Covered"                           "Regular coverage applies"
* #not-covered             "Not covered"                       "No coverage or possibility of coverage for this service)"
// Coverage guidance - doc
* #clinical                "Clinical Documentation"            "Details most likely to originate from a clinician are required to satisfy additional documentation requirements, determine coverage and/or prior auth applicability - e.g. via DTR by clinician.  Indicates that the CRD client should expose the need to launch DTR to clinical users."
* #admin                   "Administrative Documentation"      "Administrative details not likely to require clinical expertise are needed to satisfy additional documentation requirements, determine coverage and/or prior auth applicability - e.g. via DTR by back-end staff.  Indicates that while the CRD client might expose the ability to launch DTR as an option for clinical users, it should be clear that clinical input is not necessary and deferring the use of DTR to back-end staff is perfectly appropriate.  Some CRD clients might be configured (based on provider preference) to not even show clinicians the option to launch."
* #both                    "Administrative & clinical doc"     "Both clinical and administrative details are required to satisfy additional documentation requirements, determine coverage and/or prior auth applicability.  Equivalent to the union of #admin and #clinical."
* #patient                 "Administrative & clinical doc"     "Details most likely to originate from the patient or their personal representative (e.g. parent, spouse, etc.) are required to satisfy additional documentation requirements, determine coverage and/or prior auth applicability.  For example, information about household composition, accessibility considerations, etc.  This should be used when the data needs to come from the patient themselves, rather than a clinician's assessment of the patient"
// Coverage guidance - auth
* #no-auth                 "No Prior Authorization"            "The ordered service does not require prior authorization"
* #auth-needed             "Prior Authorization Needed"        "The ordered service will require prior authorization" 
  * #performpa             "Performer Prior Authorization"     "Prior authorization is needed for the service, however such prior authoriation must be initiated by the performing (rather than ordering) provider."
* #satisfied               "Authorization Satisfied"           "While prior authorization would typically be needed, the conditions evaluated by prior authorization have already been evaluated and therefore prior authorization can be bypassed"
// Coverage guidance - info needed
* #performer               "Performer Needed"                  "Information about who (specifically, or at least performer type and affiliation) is necessary to make a determination of coverage and/or prior auth expectations"
* #location                "Location Needed"                   "Information about where (specific clinic/site or organization) is necessary to make a determination of coverage and/or prior auth expectations"
* #timeframe               "Timeframe Needed"                  "Information about when the service will be performed that is more granular than the order effective period is necessary to make a determination of coverage and/or prior auth expectations"
* #contract-window         "New Contract Window"               "The target performance time for the event falls outside the contract window for the patient's current coverage.  Information will not be available until a contract is in place covering the service time period"
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
* #_cmsLocation          "CMS Location codes"                  "A collector for CMS location codes"
  * #2  "Telehealth Provided Other than in Patient's Home"  "The location where health services and health related services are provided or received, through telecommunication technology. Patient is not located in their home when receiving health services or health related services through telecommunication technology."
  * #4  "Homeless Shelter"  "A facility or location whose primary purpose is to provide temporary housing to homeless individuals (e.g., emergency shelters, individual or family shelters)."
  * #5  "Indian Health Service"  "A facility or location, owned and operated by the Indian Health Service, which provides diagnostic, therapeutic (surgical and non-surgical), and rehabilitation services to American Indians and Alaska Natives who do not require hospitalization. (Effective January 1, 2003)"
  * #6  "Indian Health Service"  "A facility or location, owned and operated by the Indian Health Service, which provides diagnostic, therapeutic (surgical and non-surgical), and rehabilitation services rendered by, or under the supervision of, physicians to American Indians and Alaska Natives admitted as inpatients or outpatients."
  * #7  "Tribal 638"  "A facility or location owned and operated by a federally recognized American Indian or Alaska Native tribe or tribal organization under a 638 agreement, which provides diagnostic, therapeutic (surgical and non-surgical), and rehabilitation services to tribal members who do not require hospitalization. (Effective January 1, 2003)"
  * #8  "Tribal 638"  "A facility or location owned and operated by a federally recognized American Indian or Alaska Native tribe or tribal organization under a 638 agreement, which provides diagnostic, therapeutic (surgical and non-surgical), and rehabilitation services to tribal members admitted as inpatients or outpatients."
  * #9  "Correctional Facility"  "A prison, jail, reformatory, work farm, detention center, or any other similar facility maintained by either Federal, State or local authorities for the purpose of confinement or rehabilitation of adult or juvenile criminal offenders."
  * #10  "Telehealth Provided in Patient's Home"  "The location where health services and health related services are provided or received, through telecommunication technology. Patient is located in their home (which is a location other than a hospital or other facility where the patient receives care in a private residence) when receiving health services or health related services through telecommunication technology."
  * #12  "Home"  "Location, other than a hospital or other facility, where the patient receives care in a private residence."
  * #13  "Assisted Living Facility"  "Congregate residential facility with self-contained living units providing assessment of each resident's needs and on-site support 24 hours a day, 7 days a week, with the capacity to deliver or arrange for services including some health care and other services."
  * #14  "Group Home *"  "A residence, with shared living areas, where clients receive supervision and other services such as social and/or behavioral services, custodial service, and minimal services (e.g., medication administration)."
  * #16  "Temporary Lodging"  "A short term accommodation such as a hotel, camp ground, hostel, cruise ship or resort where the patient receives care, and which is not identified by any other POS code."
  * #17  "Walk-in Retail Health Clinic"  "A walk-in health clinic, other than an office, urgent care facility, pharmacy or independent clinic and not described by any other Place of Service code, that is located within a retail operation and provides, on an ambulatory basis, preventive and primary care services. (This code is available for use immediately with a final effective date of May 1, 2010)"
  * #19  "Off Campus-Outpatient Hospital"  "A portion of an off-campus hospital provider based department which provides diagnostic, therapeutic (both surgical and nonsurgical), and rehabilitation services to sick or injured persons who do not require hospitalization or institutionalization. (Effective January 1, 2016)"
  * #20  "Urgent Care Facility"  "Location, distinct from a hospital emergency room, an office, or a clinic, whose purpose is to diagnose and treat illness or injury for unscheduled, ambulatory patients seeking immediate medical attention."
  * #22  "On Campus-Outpatient Hospital"  "A portion of a hospital's main campus which provides diagnostic, therapeutic (both surgical and nonsurgical), and rehabilitation services to sick or injured persons who do not require hospitalization or institutionalization. (Description change effective January 1, 2016)"
  * #25  "Birthing Center"  "A facility, other than a hospital's maternity facilities or a physician's office, which provides a setting for labor, delivery, and immediate post-partum care as well as immediate care of new born infants."
  * #27  "Outreach Site/ Street"  "A non-permanent location on the street or found environment, not described by any other POS code, where health professionals provide preventive, screening, diagnostic, and/or treatment services to unsheltered homeless individuals."
  * #32  "Nursing Facility"  "A facility which primarily provides to residents skilled nursing care and related services for the rehabilitation of injured, disabled, or sick persons, or, on a regular basis, health-related care services above the level of custodial care to other than individuals with intellectual disabilities.  **NOTE: Must be sent alongside HL7 code NCCF**"
  * #33  "Custodial Care Facility"  "A facility which provides room, board and other personal assistance services, generally on a long-term basis, and which does not include a medical component.  **NOTE: Must be sent alongside HL7 code NCCF**"
  * #34  "Hospice"  "A facility, other than a patient's home, in which palliative and supportive care for terminally ill patients and their families are provided."
  * #41  "Ambulance - Land"  "A land vehicle specifically designed, equipped and staffed for lifesaving and transporting the sick or injured. **NOTE: Must be sent alongside HL7 code AMB**"
  * #42  "Ambulance - Air or Water"  "An air or water vehicle specifically designed, equipped and staffed for lifesaving and transporting the sick or injured.  **NOTE: Must be sent alongside HL7 code AMB**"
  * #49  "Independent Clinic"  "A location, not part of a hospital and not described by any other Place of Service code, that is organized and operated to provide preventive, diagnostic, therapeutic, rehabilitative, or palliative services to outpatients only."
  * #50  "Federally Qualified Health Center"  "A facility located in a medically underserved area that provides Medicare beneficiaries preventive primary medical care under the general direction of a physician."
  * #52  "Psychiatric Facility-Partial Hospitalization"  "A facility for the diagnosis and treatment of mental illness that provides a planned therapeutic program for patients who do not require full time hospitalization, but who need broader programs than are possible from outpatient visits to a hospital-based or hospital-affiliated facility."
  * #53  "Community Mental Health Center"  "A facility that provides the following services: outpatient services, including specialized outpatient services for children, the elderly, individuals who are chronically ill, and residents of the CMHC's mental health services area who have been discharged from inpatient treatment at a mental health facility; 24 hour a day emergency care services; day treatment, other partial hospitalization services, or psychosocial rehabilitation services; screening for patients being considered for admission to State mental health facilities to determine the appropriateness of such admission; and consultation and education services."
  * #57  "Non-residential Substance Abuse Treatment Facility"  "A location which provides treatment for substance (alcohol and drug) abuse on an ambulatory basis. Services include individual and group therapy and counseling, family counseling, laboratory tests, drugs and supplies, and psychological testing."
  * #58  "Non-residential Opioid Treatment Facility"  "A location that provides treatment for opioid use disorder on an ambulatory basis. Services include methadone and other forms of Medication Assisted Treatment (MAT). (Effective January 1, 2020)"
  * #60  "Mass Immunization Center"  "A location where providers administer pneumococcal pneumonia and influenza virus vaccinations and submit these services as electronic media claims, paper claims, or using the roster billing method. This generally takes place in a mass immunization setting, such as, a public health center, pharmacy, or mall but may include a physician office setting."
  * #62  "Comprehensive Outpatient Rehabilitation Facility"  "A facility that provides comprehensive rehabilitation services under the supervision of a physician to outpatients with physical disabilities. Services include physical therapy, occupational therapy, and speech pathology services."
  * #65  "End-Stage Renal Disease Treatment Facility"  "A facility other than a hospital, which provides dialysis treatment, maintenance, and/or training to patients or caregivers on an ambulatory or home-care basis."
  * #71  "Public Health Clinic"  "A facility maintained by either State or local health departments that provides ambulatory primary medical care under the general direction of a physician."
  * #72  "Rural Health Clinic"  "A certified facility which is located in a rural medically underserved area that provides ambulatory primary medical care under the general direction of a physician."
