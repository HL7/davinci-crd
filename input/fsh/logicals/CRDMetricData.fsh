Logical: CRDMetricData
Id: CRDMetricData
Title: "CRD Metric Data"
Description: "A logical model describing the information that should be captured by CRD implementers about every CRD invocation to support measures evaluating CRD implementation"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* ^extension[$standards-status].valueCode = #informative
* source            1..1 code            "provider-src | payer-src"            "A code to indicate which type of system collected the metric data."
* source    from MetricDataSource      (required)
  * ^comment = "Each hook should have metric data captured by both the initiating provider and the responding payer."
* hookInstance      1..1 string          "Unique hook invocation id"           "The unique id for this specific hook invocation."
  * ^comment = "Used to link the statistics for a given hook call between provider and payer systems."
* hookType          1..1 code            "order-select | order-sign +"         "The type of hook specified in the `hook` element in the CDS hooks request."
* hookType          from CDSHookType   (extensible)
* providerId        1..1 Identifier      "User invoking hook"                  "The NPI number of the user who initiated the hook request."
* providerId.system = "http://hl7.org/fhir/sid/us-npi"
* providerId.value  1..1
* groupId           1..1 Identifier      "Healthcare org of user"              "The NPI of the hospital/clinic/other organization that initiated the hook request."
* groupId.system    = "http://hl7.org/fhir/sid/us-npi"
* groupId.value     1..1
* payerId           1..1 Identifier      "Payer receiving hook"                "The identifier of the payer organization to whom the CRD call was made."
* payerId.system    1..1
* payerId.value     1..1
* requestTime       1..1 instant         "Time hook initiated"                 "For providers, the time the hook call was made.  For payers, the time the hook call was received."
* responseTime      0..1 instant         "Time of hook response"               "For providers, the time the hook response was received.  For payers, the time the hook response was returned."
* httpResponse      1..1 positiveInt     "e.g. 200"                            "What HTTP response code was returned for the hook invocation."
* issue             0..* BackboneElement "OperationOutcome info"               "In the event of an HTTP error, if an OperationOutcome is returned, what were the issues?"
  * code            1..1 code            "Error code"                          "The issue.code value from the OperationOutcome for this issue."
  * code            from IssueType               (required)
  * details         0..1 CodeableConcept "More detailed error code"            "The issue.details value from the OperationOutcome for this issue."
  * details         from OperationOutcomeCodes   (example)
    * ^requirements = "Because these codes are not standardized, they will primarily only be useful for evaluation between communication partners, not for comparison across implementations"
* tokenUse          1..1 code            "used | not-used | rejected"          "Indicates whether the provided access token was used to retrieve additional information.  Rejected indicates that when used, the access failed."
* tokenUse          from MetricTokenUse          (example)
* orderDetail       0..* CodeableConcept "Service or product code(s)"          "The code or codes defining the type of product or service from the focal Request or "
* orderDetail       from MetricOrderDetail       (extensible)
  * ^comment = "Specifically, this corresponds to: Appointment.serviceType, CommunicationRequest.payload.valueCodeableConcept, DeviceRequest.codeCodeableConcept, DeviceRequest.codeReference.resolve().udiCarrier.deviceIdentifier (expressed as a CodeableConcept), Encounter.serviceType, MedicationRequest.medicationCodeableConcept, MedicationRequest.medicationReference.resolve().code, ServiceRequest.code, VisionPrescription.lensSpecification.productType"
* resources         0..* BackboneElement "Resource types accessed"             "Information other than the 'focal' resources (orders, encounter, appointment) for the hook that were accessed by the payer."
  * type            1..1 code            "Kind of resource"                    "What kind of resource was accessed."
  * type            from ResourceType            (required)
  * profile         0..1 canonical       "Solicited profile"                   "Indicates the sub-type of data accessed in situations where multiple US-core profiles could apply (e.g. Observation).  Note: This does not mean that the data received was actually valid against the profile, merely that the search criteria used were intended to retrieve data of this type."
    * ^type.targetProfile = "http://hl7.org/fhir/StructureDefinition/StructureDefinition"
  * count           1..1 positiveInt     "Number retrieved"                    "How many resources of that type were accessed."
  * prefetch        0..1 boolean         "Retrieved by prefetch?"              "Was the data retrieved by prefetch or direct query.  (If some resources of the same type were accessed both with and without prefetch, include two repetitions.)"
* response          0..* BackboneElement "Returned card/system action"         "Summary information about each card or system action returned."
  * type            0..1 code            "Type of CRD card"                    "The CRD code for the card.  Mandatory if the card corresponds to a type defined by CRD, otherwise omit."
  * type            from CRDCardType             (required)
  * focus           0..* code            "Resource tied to card"               "Indicates the type of resource(s) tied to the card."
  * engagement      0..1 code            "ignore | accept | override"          "Indicates if the user engaged with the card as per the CDS Hooks feedback mechanism."
  * coverageInfo    0..* BackboneElement "Coverage information"                "If the card is a coverage-information card, indicates additional information about the information provided in the coverage-information extension."
    * covered       0..1 code            "covered | not-covered | conditional" "Indicates whether the service is covered."
    * covered       from CRDCoveredInfo          (required)
    * paNeeded      0..1 code            "auth-needed | no-auth | satisfied +" "Indicates whether prior authorization is necessary or not, as well as considerations about applying for prior authorization."
    * paNeeded      from CRDCoveragePaDetail     (required)
    * docNeeded     0..1 code            "no-doc | clinical | admin | both +"  "Indicates whether additional information is necessary (for prior auth, claims submission, or some other purpose)."
    * docNeeded     from CRDAdditionalDoc        (required)
    * infoNeeded    0..1 code            "performer | location | timeframe"    "Indicates what additional information is necessary to determine authorization/coverage - which might be available on a later hook invocation."
    * infoNeeded    from CRDInformationNeeded    (required)
    * questionnaire 0..* BackboneElement "Questionnaire(s) returned"           "Information about the Questionnaire(s) returned to gather additional information (e.g. through DTR)."
      * ^requirements = "Allows linking metadata about forms identified 'to be filled out' in CRD with what is actually completed in DTR, and eventually submitted in CDex, PAS or claims"
      * reference   1..1 canonical       "Questionnaire url & version"         "The official identifier of one of the Questionnaires provided to be filled out."
        * ^type.targetProfile = "http://hl7.org/fhir/StructureDefinition/Questionnaire"
      * adaptive    1..1 boolean         "Is questionnaire adaptive?"          "If true, it indicates that the questionnaire is adaptive (i.e. uses the $next-question operation to determine questions)."
      * response    1..1 boolean         "Pre-pop response provided?"          "If true, it indicates that the card included a partially populated QuestionnaireResponse with answers filled by the payer from pre-known data."
    * assertionId   1..1 string          "Id for coverage assertion"           "Corresponds to the coverage-assertion-id from the coverage-information extension."
      * ^requirements = "Used to link the results of CRD to metric information captured for DTR and/or PAS."
    * satisfiedId   0..1 string          "Id if PA is satisfied"               "Corresponds to the satisfied-pa-id from the coverage-information extension."
    * businessLine  0..1 CodeableConcept "E.g. Medicare Advantage"             "A code that indicates which type of insurance this assertion applies to."
// TODO need a binding here, but don't yet have one