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
* #no-member-found         "Member not found"                    "The CRD service was unable to find a matching member, so no coverage information can be provided"
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
  * #duplicate-therapy        "Duplicate Therapy"              "Notice that the proposed intervention has already recently occurred with a different provider when that information isn't already available in the provider system"
  * #contraindication         "Contraindication"               "Notice that the proposed intervention may be contraindicated based on information the payer has in their record that the provider doesn't have in theirs"
  * #guideline                "Guideline"                      "Indication that there is a guideline available for the proposed therapy (with an option to view)"
  * #off-guideline            "Off Guideline"                  "Notice that the proposed therapy may be contrary to best-practice guidelines, typically with an option to view the relevant guideline"

// Waiting on approval from CMS to propose migrating these into THO
* #_cmsLocation          "CMS Location codes"                  "A collector for CMS location codes"
  * #1 "Pharmacy **" "A facility or location where drugs and other medically related items and services are sold, dispensed, or otherwise provided directly to patients."
  * #2 "Telehealth Provided Other than in Patient's Home" "The location where health services and health related services are provided or received, through telecommunication technology. Patient is not located in their home when receiving health services or health related services through telecommunication technology."
  * #3 "School" "A facility whose primary purpose is education."
  * #4 "Homeless Shelter" "A facility or location whose primary purpose is to provide temporary housing to homeless individuals (e.g., emergency shelters, individual or family shelters)."
  * #5 "Indian Health Service" "A facility or location, owned and operated by the Indian Health Service, which provides diagnostic, therapeutic (surgical and non-surgical), and rehabilitation services to American Indians and Alaska Natives who do not require hospitalization. (Effective January 1, 2003)"
  * #6 "Indian Health Service" "A facility or location, owned and operated by the Indian Health Service, which provides diagnostic, therapeutic (surgical and non-surgical), and rehabilitation services rendered by, or under the supervision of, physicians to American Indians and Alaska Natives admitted as inpatients or outpatients."
  * #7 "Tribal 638" "A facility or location owned and operated by a federally recognized American Indian or Alaska Native tribe or tribal organization under a 638 agreement, which provides diagnostic, therapeutic (surgical and non-surgical), and rehabilitation services to tribal members who do not require hospitalization. (Effective January 1, 2003)"
  * #8 "Tribal 638" "A facility or location owned and operated by a federally recognized American Indian or Alaska Native tribe or tribal organization under a 638 agreement, which provides diagnostic, therapeutic (surgical and non-surgical), and rehabilitation services to tribal members admitted as inpatients or outpatients."
  * #9 "Correctional Facility" "A prison, jail, reformatory, work farm, detention center, or any other similar facility maintained by either Federal, State or local authorities for the purpose of confinement or rehabilitation of adult or juvenile criminal offenders."
  * #10 "Telehealth Provided in Patient's Home" "The location where health services and health related services are provided or received, through telecommunication technology. Patient is located in their home (which is a location other than a hospital or other facility where the patient receives care in a private residence) when receiving health services or health related services through telecommunication technology."
  * #11 "Office" "Location, other than a hospital, skilled nursing facility (SNF), military treatment facility, community health center, State or local public health clinic, or intermediate care facility (ICF), where the health professional routinely provides health examinations, diagnosis, and treatment of illness or injury on an ambulatory basis."
  * #12 "Home" "Location, other than a hospital or other facility, where the patient receives care in a private residence."
  * #13 "Assisted Living Facility" "Congregate residential facility with self-contained living units providing assessment of each resident's needs and on-site support 24 hours a day, 7 days a week, with the capacity to deliver or arrange for services including some health care and other services."
  * #14 "Group Home *" "A residence, with shared living areas, where clients receive supervision and other services such as social and/or behavioral services, custodial service, and minimal services (e.g., medication administration)."
  * #15 "Mobile Unit" "A facility/unit that moves from place-to-place equipped to provide preventive, screening, diagnostic, and/or treatment services."
  * #16 "Temporary Lodging" "A short term accommodation such as a hotel, camp ground, hostel, cruise ship or resort where the patient receives care, and which is not identified by any other POS code."
  * #17 "Walk-in Retail Health Clinic" "A walk-in health clinic, other than an office, urgent care facility, pharmacy or independent clinic and not described by any other Place of Service code, that is located within a retail operation and provides, on an ambulatory basis, preventive and primary care services. (This code is available for use immediately with a final effective date of May 1, 2010)"
  * #18 "Place of Employment-" "A location, not described by any other POS code, owned or operated by a public or private entity where the patient is employed, and where a health professional provides on-going or episodic occupational medical, therapeutic or rehabilitative services to the individual. (This code is available for use effective January 1, 2013 but no later than May 1, 2013)"
  * #19 "Off Campus-Outpatient Hospital" "A portion of an off-campus hospital provider based department which provides diagnostic, therapeutic (both surgical and nonsurgical), and rehabilitation services to sick or injured persons who do not require hospitalization or institutionalization. (Effective January 1, 2016)"
  * #20 "Urgent Care Facility" "Location, distinct from a hospital emergency room, an office, or a clinic, whose purpose is to diagnose and treat illness or injury for unscheduled, ambulatory patients seeking immediate medical attention."
  * #21 "Inpatient Hospital" "A facility, other than psychiatric, which primarily provides diagnostic, therapeutic (both surgical and nonsurgical), and rehabilitation services by, or under, the supervision of physicians to patients admitted for a variety of medical conditions."
  * #22 "On Campus-Outpatient Hospital" "A portion of a hospital's main campus which provides diagnostic, therapeutic (both surgical and nonsurgical), and rehabilitation services to sick or injured persons who do not require hospitalization or institutionalization. (Description change effective January 1, 2016)"
  * #23 "Emergency Room - Hospital" "A portion of a hospital where emergency diagnosis and treatment of illness or injury is provided."
  * #24 "Ambulatory Surgical Center" "A freestanding facility, other than a physician's office, where surgical and diagnostic services are provided on an ambulatory basis."
  * #25 "Birthing Center" "A facility, other than a hospital's maternity facilities or a physician's office, which provides a setting for labor, delivery, and immediate post-partum care as well as immediate care of new born infants."
  * #26 "Military Treatment Facility" "A medical facility operated by one or more of the Uniformed Services. Military Treatment Facility (MTF) also refers to certain former U.S. Public Health Service (USPHS) facilities now designated as Uniformed Service Treatment Facilities (USTF)."
  * #27 "Outreach Site/ Street" "A non-permanent location on the street or found environment, not described by any other POS code, where health professionals provide preventive, screening, diagnostic, and/or treatment services to unsheltered homeless individuals."
  * #31 "Skilled Nursing Facility" "A facility which primarily provides inpatient skilled nursing care and related services to patients who require medical, nursing, or rehabilitative services but does not provide the level of care or treatment available in a hospital."
  * #32 "Nursing Facility" "A facility which primarily provides to residents skilled nursing care and related services for the rehabilitation of injured, disabled, or sick persons, or, on a regular basis, health-related care services above the level of custodial care to other than individuals with intellectual disabilities."
  * #33 "Custodial Care Facility" "A facility which provides room, board and other personal assistance services, generally on a long-term basis, and which does not include a medical component."
  * #34 "Hospice" "A facility, other than a patient's home, in which palliative and supportive care for terminally ill patients and their families are provided."
  * #41 "Ambulance - Land" "A land vehicle specifically designed, equipped and staffed for lifesaving and transporting the sick or injured."
  * #42 "Ambulance - Air or Water" "An air or water vehicle specifically designed, equipped and staffed for lifesaving and transporting the sick or injured."
  * #49 "Independent Clinic" "A location, not part of a hospital and not described by any other Place of Service code, that is organized and operated to provide preventive, diagnostic, therapeutic, rehabilitative, or palliative services to outpatients only."
  * #50 "Federally Qualified Health Center" "A facility located in a medically underserved area that provides Medicare beneficiaries preventive primary medical care under the general direction of a physician."
  * #51 "Inpatient Psychiatric Facility" "A facility that provides inpatient psychiatric services for the diagnosis and treatment of mental illness on a 24-hour basis, by or under the supervision of a physician."
  * #52 "Psychiatric Facility-Partial Hospitalization" "A facility for the diagnosis and treatment of mental illness that provides a planned therapeutic program for patients who do not require full time hospitalization, but who need broader programs than are possible from outpatient visits to a hospital-based or hospital-affiliated facility."
  * #53 "Community Mental Health Center" "A facility that provides the following services: outpatient services, including specialized outpatient services for children, the elderly, individuals who are chronically ill, and residents of the CMHC's mental health services area who have been discharged from inpatient treatment at a mental health facility; 24 hour a day emergency care services; day treatment, other partial hospitalization services, or psychosocial rehabilitation services; screening for patients being considered for admission to State mental health facilities to determine the appropriateness of such admission; and consultation and education services."
  * #54 "Intermediate Care Facility/ Individuals with Intellectual Disabilities" "A facility which primarily provides health-related care and services above the level of custodial care to individuals but does not provide the level of care or treatment available in a hospital or SNF."
  * #55 "Residential Substance Abuse Treatment Facility" "A facility which provides treatment for substance (alcohol and drug) abuse to live-in residents who do not require acute medical care. Services include individual and group therapy and counseling, family counseling, laboratory tests, drugs and supplies, psychological testing, and room and board."
  * #56 "Psychiatric Residential Treatment Center" "A facility or distinct part of a facility for psychiatric care which provides a total 24-hour therapeutically planned and professionally staffed group living and learning environment."
  * #57 "Non-residential Substance Abuse Treatment Facility" "A location which provides treatment for substance (alcohol and drug) abuse on an ambulatory basis.  Services include individual and group therapy and counseling, family counseling, laboratory tests, drugs and supplies, and psychological testing."
  * #58 "Non-residential Opioid Treatment Facility" "A location that provides treatment for opioid use disorder on an ambulatory basis. Services include methadone and other forms of Medication Assisted Treatment (MAT). (Effective January 1, 2020)"
  * #60 "Mass Immunization Center" "A location where providers administer pneumococcal pneumonia and influenza virus vaccinations and submit these services as electronic media claims, paper claims, or using the roster billing method. This generally takes place in a mass immunization setting, such as, a public health center, pharmacy, or mall but may include a physician office setting."
  * #61 "Comprehensive Inpatient Rehabilitation Facility" "A facility that provides comprehensive rehabilitation services under the supervision of a physician to inpatients with physical disabilities. Services include physical therapy, occupational therapy, speech pathology, social or psychological services, and orthotics and prosthetics services."
  * #62 "Comprehensive Outpatient Rehabilitation Facility" "A facility that provides comprehensive rehabilitation services under the supervision of a physician to outpatients with physical disabilities. Services include physical therapy, occupational therapy, and speech pathology services."
  * #65 "End-Stage Renal Disease Treatment Facility" "A facility other than a hospital, which provides dialysis treatment, maintenance, and/or training to patients or caregivers on an ambulatory or home-care basis."
  * #71 "Public Health Clinic" "A facility maintained by either State or local health departments that provides ambulatory primary medical care under the general direction of a physician."
  * #72 "Rural Health Clinic" "A certified facility which is located in a rural medically underserved area that provides ambulatory primary medical care under the general direction of a physician."
  * #81 "Independent Laboratory" "A laboratory certified to perform diagnostic and/or clinical tests independent of an institution or a physician's office."
  * #99 "Other Place of Service" "Other place of service not identified above."
