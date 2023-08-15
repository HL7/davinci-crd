Extension: CoverageInformation
Id: ext-coverage-information
Title: "Coverage Information"
Description: "Captures assertions from a payer about whether the service is covered and/or requires prior authorization."
* ^version = "1.1.0-ci-build"
* ^status = #draft
* ^experimental = false
* ^date = "2023-05-30T11:47:53-07:00"
* ^publisher = "HL7 International - Financial Management Work Group"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.hl7.org/Special/committees/fm"
* ^jurisdiction = urn:iso:std:iso:3166#US
* ^context[0].type = #element
* ^context[=].expression = "Appointment"
* ^context[+].type = #element
* ^context[=].expression = "Encounter"
* ^context[+].type = #element
* ^context[=].expression = "NutritionOrder"
* ^context[+].type = #element
* ^context[=].expression = "CommunicationRequest"
* ^context[+].type = #element
* ^context[=].expression = "DeviceRequest"
* ^context[+].type = #element
* ^context[=].expression = "ServiceRequest"
* ^context[+].type = #element
* ^context[=].expression = "MedicationRequest"
* ^context[0].type = #element
* ^context[=].expression = "QuestionnaireResponse"
* obeys crd-ci-q1 and crd-ci-q2 and crd-ci-q3 and crd-ci-q4 and crd-ci-q5
* . ^short = "CoverageInfo"
  * ^definition = "Indicates coverage information."
* extension contains
    coverage 1..1 and
    covered 1..1 MS and
    pa-needed 0..1 MS and
    doc-needed 0..1 MS and
    doc-purpose 0..* MS and
    info-needed 0..* MS and
    billingCode 0..* and
    reason 0..* and
    detail 0..* and
    dependency 0..* and
    questionnaire 0..* and
    response 0..* and
    date 1..1 and
    coverage-assertion-id 1..1 and
    satisfied-pa-id 0..1 and
    contact 0..*
* extension[coverage] only Extension
  * ^short = "Reference to Coverage"
  * ^definition = "Reference to Coverage that assertion applies to."
  * value[x] 1..1
  * value[x] only Reference(Coverage)
* extension[covered] only Extension
  * ^short = "covered | not-covered | conditional"
  * ^definition = "Indicates whether the ordered/requested service is covered under patient's plan"
  * value[x] 1..1
  * value[x] only code
  * value[x] from CoveredInfo (required)
* extension[pa-needed] only Extension
  * ^short = "no-auth | auth-needed | satisfied | performpa | conditional"
  * ^definition = "Indicates whether prior auth will be needed for coverage to be provided"
  * value[x] 1..1
  * value[x] only code
  * value[x] from CoveragePaDetail (required)
* extension[doc-needed] only Extension
  * ^short = "no-doc | clinical | admin | both | conditional"
  * ^definition = "Indicates whether additional documentation needs to be captured (purpose in next element)"
  * value[x] 1..1
  * value[x] only code
  * value[x] from AdditionalDocumentation (required)
* extension[doc-purpose] only Extension
  * ^short = "Documentation purpose"
  * value[x] 1..1
  * value[x] only code
  * value[x] from CRDDocReason (required)
* extension[info-needed] only Extension
  * ^short = "performer | location | timeframe"
  * ^definition = "Indicates whether information about the perfomer, location, and/or performance date is needed to determine coverage information"
  * value[x] 1..1
  * value[x] only code
  * value[x] from InformationNeeded (required)
* extension[billingCode] only Extension
  * ^short = "Billing code"
  * ^definition = "Billing code(s) that must be used in the eventual claim for the coverage assertion to hold"
  * ^comment = "Codes may include modifier codes, leveraging [CPT's post-coordination syntax](https://terminology.hl7.org/CPT.html)"
  * value[x] 1..1
  * value[x] only Coding
  * value[x] from USCLSCodes (example)
* extension[reason] only Extension
  * ^short = "Reason for assertion"
  * ^definition = "Indicates the 'reason' for the coverage assertion"
  * ^comment = "This can be used whenever the reason may not be obvious to the practitioner.  E.g. prior authorization waived because the provider is gold-carded; patient is no longer a minor and hasn't been registered as an adult dependent; patient has reached their limit for this type of service this year; etc.  Additional standard reason codes may be introduced in the future.  If no standard code applies, use text."
  * value[x] 1..1
  * value[x] only CodeableConcept
  * value[x] from CRDCoverageAssertionReasons (extensible)
* extension[detail] only Extension
  * ^short = "detail for assertion"
  * ^definition = "Indicates the 'detail' for the coverage assertion"
  * ^comment = "Additional information that qualifies, describes, or provides additional guidance about coverage or documentation requirements."
  * extension contains
      code 1..1 and
      value 1..1 and
      qualification 0..1
  * extension[code] ^short = "Name of name-value pair"
    * ^definition = "The type of detail or qualification expressed."
    * value[x] only CodeableConcept
    * value[x] from CRDCoverageDetailCodes (extensible)
  * extension[value] ^short = "Value of name-value pair"
    * ^definition = "The detail or qualification that applies to this coverage assertion."
    * value[x] only boolean or string or SimpleQuantity or Period
  * extension[qualification] ^short = "Additional info about detail"
    * ^definition = "Additional text that qualifies/expands on the computable detail.  E.g. 'Provided coverage is renewed' or 'Does not account for deductible'"
    * value[x] only string
* extension[dependency] ^short = "Resources that impact this assertion"
  * ^definition = "If present, indicates that the determination represented here is dependent on the content, determination, and possibly execution of the referenced order(s)"
  * ^requirements = "For example, the authorization decision on a request for post-surgical physiotherapy might be dependent on the order for the surgery itself.  If coverage for the surgery is not approved or the order for the surgery is cancelled, that might impact the decision on covering the physiotherapy."
  * value[x] only Reference(Appointment or CommunicationRequest or DeviceRequest or MedicationRequest or NutritionOrder or ServiceRequest)
* extension[questionnaire] only Extension
  * ^short = "Questionnaire"
  * ^definition = "A form to be filled out to gather more information.  Only for use if the response indicates a need to use DTR"
  * ^condition = "crd-ci-q1"
  * value[x] only canonical
    * ^type.targetProfile = "http://hl7.org/fhir/StructureDefinition/Questionnaire"
* extension[response] only Extension
  * ^short = "Questionnaire Response"
  * ^definition = "A reference to a partially completed Questionnaire Response that is intended to be used as a basis for subsequent form filling in DTR."
  * ^comment = "If a QuestionnaireResponse is provided, no corresponding 'questionnaire' extension should be present - the canonical for the needed Questionnaire will be found inside the QuestionnaireResponse."
  * ^condition = "crd-ci-q1"
  * value[x] only Reference(QuestionnaireResponse)
    * ^comment = "QuestionnaireResponse.author SHALL have a type of Device, with an identifier and display value.  It MAY have a Reference.reference, but need not do so."
* extension[date] only Extension
  * ^short = "Assertion date"
  * ^definition = "Date on which assertion was made."
  * value[x] 1..1
  * value[x] only date
* extension[coverage-assertion-id] only Extension
  * ^short = "coverage-assertion-id"
  * ^definition = "Trace identifier to allow tracking the guidance in source system.  This identifier can also be used used to re-establish cached context information when subsequently launching DTR."
  * value[x] only string
* extension[satisfied-pa-id] only Extension
  * ^short = "satisfied-pa-id"
  * value[x] only string
* extension[contact] only Extension
  * ^short = "Contact"
  * ^definition = "Phone number, fax number, email address, website, or other ContactPoint that can be used to ask questions/escalate issues related to a coverage assertion."
  * ^comment = "This **SHOULD** only be populated if the contact information is context-specific rather than a generic contact for the payer as a whole."
  * value[x] only ContactPoint
* url only uri

Invariant: crd-ci-q1
Description: "Questionnaire and QuestionnaireResponse are only allowed when doc-needed exists and not equal to 'no-doc'"
Severity: #error
Expression: "extension.where(url='questionnaire' or url='response').exists() implies (extension.where(url = 'doc-needed').exists() and extension.where(url = 'doc-needed').all(value != 'no-doc'))"

Invariant: crd-ci-q2
Description: "If covered is set to 'not-covered', then 'pa-needed' should not exist."
Severity: #error
Expression: "extension.where(url = 'covered' and value != 'not-covered') implies extension.where(url = 'pa-needed').exists()"

Invariant: crd-ci-q3
Description: "If 'info-needed' exists, then at least one of 'covered', 'pa-needed', or 'doc-needed' must be 'conditional'."
Severity: #error
Expression: "extension.where(url = 'info-needed').exists() implies extension.where((url = 'covered' or url = 'pa-needed' or url = 'doc-needed') and value = 'conditional').count() >= 1"

Invariant: crd-ci-q4
Description: "If 'pa-needed' is 'satisfied', then 'Doc-purpose' can't be 'PA'."
Severity: #error
Expression: "extension.where(url = 'pa-needed' and value = 'satisfied') and extension.where(url = 'doc-purpose').exists() implies extension.where(url = 'doc-purpose').all(value != 'PA')"

Invariant: crd-ci-q5
Description: "'satisfied-pa-id' must exist if and only if 'pa-needed' is set to 'satisfied'."
Severity: #error
Expression: "extension.where(url = 'pa-needed' and value = 'satisfied').exists() = extension.where(url = 'satisfied-pa-id').exists()"
