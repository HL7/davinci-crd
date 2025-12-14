Extension: CRDCoverageInformation
Id: ext-coverage-information
Title: "Coverage Information"
Description: "Captures assertions from a payer about the coverage rules for a service - in particular, whether it is covered and/or requires prior authorization."
* ^experimental = false
* ^context[0].type = #element
* ^context[=].expression = "Appointment"
* ^context[+].type = #element
* ^context[=].expression = "CommunicationRequest"
* ^context[+].type = #element
* ^context[=].expression = "Encounter"
* ^context[+].type = #element
* ^context[=].expression = "DeviceRequest"
* ^context[+].type = #element
* ^context[=].expression = "MedicationRequest"
* ^context[+].type = #element
* ^context[=].expression = "NutritionOrder"
* ^context[+].type = #element
* ^context[=].expression = "QuestionnaireResponse"
* ^context[+].type = #element
* ^context[=].expression = "ServiceRequest"
* ^context[+].type = #element
* ^context[=].expression = "VisionPrescription"
* obeys crd-ci-q1 and crd-ci-q2 and crd-ci-q3 and crd-ci-q4 and crd-ci-q5 and crd-ci-q6 and crd-ci-q7 and crd-ci-q8
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
  * ^comment = "This will always be a link to a Coverage resource on the CRD client's system - typically accessed via prefetch or direct query using the CDS-Hooks token.  If no coverage instance is available, the coverage-information extension cannot be returned."
  * value[x] 1..1
  * value[x] only Reference(CRDCoverage)
* extension[covered] only Extension
  * ^short = "covered | not-covered | conditional"
  * ^definition = "Indicates whether the ordered/requested service is covered under patient's plan.  This includes checking whether the proposed service is a benefit under the patient's plan.  It **MAY** also involve checking whether the patient has reached their limits under the current plan period but is not required to."
  * ^comment = "Details on why coverage does not exist would be conveyed in the 'reason' element."
  * value[x] 1..1
  * value[x] only code
  * value[x] from CRDCoveredInfo (required)
* extension[pa-needed] only Extension
  * ^short = "no-auth | auth-needed | satisfied | performpa | conditional"
  * ^definition = "Indicates whether prior auth will be needed for coverage to be provided"
  * ^condition[+] = crd-ci-q2
  * ^condition[+] = crd-ci-q5
  * value[x] 1..1
  * value[x] only code
  * value[x] from CRDCoveragePaDetail (required)
* extension[doc-needed] only Extension
  * ^short = "clinical | admin | patient | conditional"
  * ^definition = "Indicates whether additional documentation needs to be captured (purpose in next element)"
  * ^comment = "See additional guidance in the [notes](StructureDefinition-ext-coverage-information.html#doc-needed-vs-info-needed)"
  * value[x] 1..1
  * value[x] only code
  * value[x] from CRDAdditionalDoc (required)
* extension[doc-purpose] only Extension
  * ^short = "withpa | withclaim | withorder | retain-doc | OTH"
  * ^definition = "Indicates the reason(s) for the additional documentation that needs to be captured"
  * ^requirements = "Knowing what the information will be used for may influence who will fill out the form(s) and how quickly the organization will get around to filling them out"
  * ^condition[+] = crd-ci-q4
  * value[x] 1..1
  * value[x] only code
  * value[x] from CRDDocReason (required)
* extension[info-needed] only Extension
  * ^short = "performer | location | timeframe | contract-window | detail-code | OTH"
  * ^definition = "Indicates whether information about the performer, location, and/or performance date is needed to determine coverage information"
  * ^comment = "See additional guidance in the [notes](StructureDefinition-ext-coverage-information.html#doc-needed-vs-info-needed)\nIf this element is set to OTH, then there must be at least one detail element the explains the nature of the additional information needed to determine coverage, prior authorization, and/or documentation requirements.  There **SHOULD** also be a doc-needed element indicating that DTR can be used to gather additional information."
  * ^condition[+] = crd-ci-q3
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
  * ^comment = "This can be used whenever the reason may not be obvious to the practitioner.  E.g. prior authorization is waived because the provider is gold-carded; patient is no longer a minor and has not been registered as an adult dependent; patient has reached their limit for this type of service this year; etc.  Additional standard reason codes may be introduced in the future.  If no standard code applies, use text."
  * ^condition[+] = crd-ci-q7
  * ^condition[+] = crd-ci-q8
  * value[x] 1..1
  * value[x] only CodeableConcept
  * value[x] from CRDCoverageAssertionReasons (extensible)
  * ^condition[+] = crd-ci-q6
* extension[detail] only Extension
  * ^short = "detail for assertion"
  * ^definition = "Indicates the 'detail' for the coverage assertion"
  * ^comment = "Additional information that qualifies, describes, or provides additional guidance about coverage or documentation requirements."
  * extension contains
      category 1..1 and
      code 1..1 and
      value 1..1 and
      qualification 0..1
  * extension[category] only Extension
    * ^short = "Type of detail"
    * ^definition = "Indicates the nature of the detail, which in turn provides guidance for when it should be displayed."
    * ^comment = "CRD clients **SHOULD** make both limitation and decisional details available to clinical users."
    * value[x] only code
    * value[x] from CRDCoverageDetailCategories (required)
  * extension[code] only Extension
    * ^short = "Name of name-value pair"
    * ^definition = "The type of detail or qualification expressed."
    * ^comment = "The binding to the old temporary code system is retained for now for backward compatibility"
    * value[x] only CodeableConcept
    * valueCodeableConcept from CRDCoverageDetailCodesNew (extensible)
    * valueCodeableConcept
      * ^binding.extension.url = $additional-binding
      * ^binding.extension.extension[0].url = "key"
      * ^binding.extension.extension[=].valueId = "ci-detailold"
      * ^binding.extension.extension[+].url = "purpose"
      * ^binding.extension.extension[=].valueCode = #extensible
      * ^binding.extension.extension[+].url = "valueSet"
      * ^binding.extension.extension[=].valueCanonical = Canonical(CRDCoverageDetailCodes)
  * extension[value] only Extension
    * ^short = "Value of name-value pair"
    * ^definition = "The detail or qualification that applies to this coverage assertion."
    * value[x] only boolean or string or url or SimpleQuantity or Period
  * extension[qualification] only Extension
    * ^short = "Additional info about detail"
    * ^definition = "Additional text that qualifies/expands on the computable detail.  E.g. 'Provided coverage is renewed' or 'Does not account for deductible'"
    * value[x] only string
* extension[dependency] only Extension
  * ^short = "Resources that impact this assertion"
  * ^definition = "If present, indicates that the determination represented here is dependent on the content, determination, and possibly execution of the referenced order(s)"
  * ^requirements = "For example, the authorization decision on a request for post-surgical physiotherapy might be dependent on the order for the surgery itself.  If coverage for the surgery is not approved or the order for the surgery is cancelled, that might impact the decision on covering the physiotherapy."
  * value[x] only Reference(CRDAppointmentWithOrder or CRDAppointmentNoOrder or CRDCommunicationRequest or CRDDeviceRequest or CRDMedicationRequest or CRDNutritionOrder or CRDServiceRequest)
* extension[questionnaire] only Extension
  * ^short = "Questionnaire to complete"
  * ^definition = "A form to be filled out to gather more information."
  * ^comment = "If using DTR, this will be used by DTR to determine the Questionnaire packages to be returned.  If empty, DTR will determine the questionnaire packages itself.  If not using DTR, providing a Questionnaire url is the only way to indicate what form to complete."
  * ^condition[+] = "crd-ci-q1"
  * value[x] only canonical
    * ^type.targetProfile = "http://hl7.org/fhir/StructureDefinition/Questionnaire"
* extension[date] only Extension
  * ^short = "Assertion date"
  * ^definition = "Date on which assertion was made."
  * value[x] 1..1
  * value[x] only date
* extension[coverage-assertion-id] only Extension
  * ^short = "Coverage assertion trace number"
  * ^definition = "Trace identifier to allow tracking the guidance in source system.  This identifier can also be used to re-establish cached context information when subsequently launching DTR."
  * value[x] 1..1
  * value[x] only string
* extension[satisfied-pa-id] only Extension
  * ^short = "Satisfied prior auth number"
  * ^definition = "An identifier indicating that prior authorization requirements have been met"
  * ^comment = "When operating under the CMS enforcement discretion, this element is a prior authorization number and can be submitted in the corresponding X12 element when submitting an eventual claim"
  * ^condition = crd-ci-q5
  * value[x] only string
* extension[contact] only Extension
  * ^short = "Contact information"
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
Description: "Questionnaire is only allowed when doc-needed exists"
Severity: #error
Expression: "extension.where(url='questionnaire').exists() implies extension.where(url = 'doc-needed').exists()"

Invariant: crd-ci-q2
Description: "If covered is set to 'not-covered', then 'pa-needed' must not exist."
Severity: #error
Expression: "extension.where(url = 'covered' and value = 'not-covered').exists() implies extension.where(url = 'pa-needed').exists().not()"

Invariant: crd-ci-q3
Description: "'info-needed' SHALL exist if and only if at least one of 'covered', 'pa-needed', or 'doc-needed' is set to 'conditional'."
Severity: #error
Expression: "extension.where((url = 'covered' or url = 'pa-needed' or url = 'doc-needed') and value = 'conditional').count() >= 1 implies extension.where(url = 'info-needed').exists()"

Invariant: crd-ci-q4
Description: "If 'pa-needed' is 'satisfied', 'noauth', or 'not-covered', then 'Doc-purpose' cannot be 'withpa'."
Severity: #error
Expression: "extension.where(url = 'pa-needed' and (value = 'satisfied' or value = 'noauth' or value = 'not-covered')) and extension.where(url = 'doc-purpose').exists() implies extension.where(url = 'doc-purpose').all(value != 'withpa')"

Invariant: crd-ci-q5
Description: "'satisfied-pa-id' must exist if and only if 'pa-needed' is set to 'satisfied'."
Severity: #error
Expression: "extension.where(url = 'pa-needed' and value = 'satisfied').exists() = extension.where(url = 'satisfied-pa-id').exists()"

Invariant: crd-ci-q6
Description: "If 'info-needed' is OTH, then reason must be specified"
Severity: #error
Expression: "extension.where(url = 'info-needed' and value = 'OTH').exists() implies extension.where(url = 'reason').exists()"

Invariant: crd-ci-q7
Description: "If reason.coding is present and is not from the extensible value set, then reason.text must be present"
Severity: #error
Expression: "extension.where(url = 'reason').empty() or extension.where(url = 'reason').value.text.exists() or extension.where(url = 'reason').value.memberOf('http://hl7.org/fhir/us/davinci-crd/ValueSet/coverageAssertionReasons')"

Invariant: crd-ci-q8
Description: "If doc-purpose is present with a value other than 'conditional', then reason must be present"
Severity: #error
Expression: "extension.where(url = 'doc-purpose' and value != 'conditional').exists() implies extension.where(url = 'reason').exists()"