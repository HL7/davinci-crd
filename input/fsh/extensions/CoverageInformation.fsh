Extension: CRDCoverageInformation
Id: ext-coverage-information
Title: "Coverage Information"
Description: "Captures assertions from a payer about whether the service is covered and/or requires prior authorization."
* ^version = "1.1.0-ci-build"
* ^experimental = false
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
* ^extension[$fmm].valueInteger = 1
* extension contains
    coverage 1..1 MS and
    covered 1..1 MS and
    pa-needed 0..1 MS and
    doc-needed 0..* MS and
    doc-purpose 0..* MS and
    info-needed 0..* MS and
    billingCode 0..* MS and
    reason 0..* MS and
    detail 0..* MS and
    dependency 0..* MS and
    questionnaire 0..* MS and
    date 1..1 MS and
    coverage-assertion-id 1..1 MS and
    satisfied-pa-id 0..1 MS and
    contact 0..* MS and 
    expiry-date 0..1 MS
* extension[coverage] only Extension
  * ^short = "Reference to Coverage"
  * ^definition = "Reference to Coverage that assertion applies to."
  * value[x] 1..1
  * value[x] only Reference(CRDCoverage)
* extension[covered] only Extension
  * ^short = "covered | not-covered | conditional"
  * ^definition = "Indicates whether the ordered/requested service is covered under patient's plan"
  * value[x] 1..1
  * value[x] only code
  * value[x] from CRDCoveredInfo (required)
* extension[pa-needed] only Extension
  * ^short = "no-auth | auth-needed | satisfied | performpa | conditional"
  * ^definition = "Indicates whether prior auth will be needed for coverage to be provided"
  * value[x] 1..1
  * value[x] only code
  * value[x] from CRDCoveragePaDetail (required)
* extension[doc-needed] only Extension
  * ^short = "clinical | admin | patient | conditional"
  * ^definition = "Indicates whether additional documentation needs to be captured (purpose in next element)"
  * value[x] 1..1
  * value[x] only code
  * value[x] from CRDAdditionalDoc (required)
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
  * value[x] from CRDInformationNeeded (required)
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
  * value[x] only Reference(CRDAppointment or CRDCommunicationRequest or CRDDeviceRequest or CRDMedicationRequest or CRDNutritionOrder or CRDServiceRequest)
* extension[questionnaire] only Extension
  * ^short = "Questionnaire"
  * ^definition = "A form to be filled out to gather more information.  Only for use if the response indicates a need to use DTR"
  * ^condition = "crd-ci-q1"
  * value[x] only canonical
    * ^type.targetProfile = "http://hl7.org/fhir/StructureDefinition/Questionnaire"
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
* extension[expiry-date] only Extension
  * ^short = "Expiration date"
  * ^definition = "Date after which the coverage assertion would no longer be valid."
  * ^comment = "In this case, mustSupport means that if the payer knows of an expiry date, they must share it.  However, if the payer never has expiry dates for their assertions, it is fine to omit."
  * value[x] 0..1
  * value[x] only date
* url only uri

Invariant: crd-ci-q1
Description: "Questionnaire and QuestionnaireResponse are only allowed when doc-needed exists and not equal to 'no-doc'"
Severity: #error
Expression: "extension.where(url='questionnaire' or url='response').exists() implies (extension.where(url = 'doc-needed').exists() and extension.where(url = 'doc-needed').all(value != 'no-doc'))"

Invariant: crd-ci-q2
Description: "If covered is set to 'not-covered', then 'pa-needed' must not exist."
Severity: #error
Expression: "extension.where(url = 'covered' and value = 'not-covered').exists() implies extension.where(url = 'pa-needed').exists().not()"

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
