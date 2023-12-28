Alias: $profileElement = http://hl7.org/fhir/StructureDefinition/elementdefinition-profile-element

Profile: CRDCDSHooksResponseBase
Id: CRDCDSHooksResponseBase
Parent: http://hl7.org/fhir/tools/StructureDefinition/CDSHooksResponse
Title: "Base CRD CDSHooks Response (Logical Definition)"
Description: "Defines common constraints that hold for all CRD CDS hooks responses"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* ^extension[$standards-status].valueCode = #trial-use
* ^abstract = true
* cards MS
  * summary MS
  * detail MS
  * indicator MS
  * source MS
    * label MS
    * topic 1..1 MS
    * topic from CRDCardType (extensible)

Profile: CRDCDSHooksExternalRefResponse
Id: CRDCDSHooksExternalRefResponse
Parent: CRDCDSHooksResponseBase
Title: "CRD External Reference CDSHooks Response (Logical Definition)"
Description: "Defines expectations for the CRD External Reference card type"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* ^extension[$standards-status].valueCode = #trial-use
* ^abstract = true
* cards MS
  * suggestions 0..0
  * selectionBehavior 0..0
  * links 1..* MS
    * type = #absolute

Profile: CRDCDSHooksInstructionsResponse
Id: CRDCDSHooksInstructionsResponse
Parent: http://hl7.org/fhir/tools/StructureDefinition/CDSHooksResponse
Title: "CRD Instructions CDSHooks Response (Logical Definition)"
Description: "Defines expectations for the CRD Instructions card type"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* ^extension[$standards-status].valueCode = #trial-use
* ^abstract = true
* cards MS
  * suggestions 0..0
  * selectionBehavior 0..0
  * links 0..0 MS

Profile: CRDCDSHooksAlternateResponse
Id: CRDCDSHooksAlternateResponse
Parent: http://hl7.org/fhir/tools/StructureDefinition/CDSHooksResponse
Title: "CRD Alternate Request CDSHooks Response (Logical Definition)"
Description: "Defines expectations for the CRD Alternate Request card type"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* ^extension[$standards-status].valueCode = #trial-use
* ^abstract = true
* cards MS
  * suggestions 1..1 MS
    * actions 2..2 MS
    * actions ^slicing.discriminator.type = #value
    * actions ^slicing.discriminator.path = "type"
    * actions ^slicing.rules = #closed
    * actions contains delete 1..1 and create 1..1
    * actions[delete]
      * type = #delete
      * resource 0..0
      * resourceId 1..1 MS
    * actions[create]
      * type = #create
      * resource 1..1 MS
      * resourceId 0..0
  * links 0..0 MS
// todo invariant that action.where(type='delete').resourceId.select(substring(0,$this.indexOf('/')))=action.where(type='create').resource.type().name

Profile: CRDCDSHooksAdditionalResponse
Id: CRDCDSHooksAdditionalResponse
Parent: http://hl7.org/fhir/tools/StructureDefinition/CDSHooksResponse
Title: "CRD Additional Orders CDSHooks Response (Logical Definition)"
Description: "Defines expectations for the CRD Additional Orders card type"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* ^extension[$standards-status].valueCode = #trial-use
* ^abstract = true
* cards MS
  * suggestions 1..* MS
    * actions 1..* MS
      * type = #create
      * resource 1..1 MS
      * resourceId 0..0

Profile: CRDCDSHooksFormResponse
Id: CRDCDSHooksFormResponse
Parent: http://hl7.org/fhir/tools/StructureDefinition/CDSHooksResponse
Title: "CRD Form Completion CDSHooks Response (Logical Definition)"
Description: "Defines expectations for the CRD Form Completion card type"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* ^extension[$standards-status].valueCode = #trial-use
* ^abstract = true
* cards MS
  * suggestions 1..1 MS
    * actions 1..2 MS
      * type = #create
      * resource 1..1 MS
      * resourceId 0..0
    * actions ^slicing.discriminator.type = #type
    * actions ^slicing.discriminator.path = "resource"
    * actions ^slicing.rules = #closed
    * actions contains questionnaire 0..1 and task 1..1
    * actions[questionnaire].resource only Questionnaire
    * actions[task].resource only SDCTaskQuestionnaire

Profile: CRDCDSHooksInsuranceResponse
Id: CRDCDSHooksInsuranceResponse
Parent: http://hl7.org/fhir/tools/StructureDefinition/CDSHooksResponse
Title: "CRD Create or Update Coverage CDSHooks Response (Logical Definition)"
Description: "Defines expectations for the CRD Create or Update Coverage card type"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* ^extension[$standards-status].valueCode = #trial-use
* ^abstract = true
* cards MS
  * suggestions 1..* MS
    * actions 1..1 MS
      * type from CRDCreateOrUpdateAction
      * resource 1..1 MS
      * resource only Coverage
      * resourceId 0..0

Profile: CRDCDSHooksSMARTResponse
Id: CRDCDSHooksSMARTResponse
Parent: http://hl7.org/fhir/tools/StructureDefinition/CDSHooksResponse
Title: "CRD SMART App CDSHooks Response (Logical Definition)"
Description: "Defines expectations for the CRD SMART App card type"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* ^extension[$standards-status].valueCode = #trial-use
* ^abstract = true
* cards MS
  * suggestions 0..0
  * selectionBehavior 0..0
  * links 1..1 MS
    * type = #smart


Profile: CRDCDSHooksCoverageResponse
Id: CRDCDSHooksCoverageResponse
Parent: CRDCDSHooksResponseBase
Title: "CRD Coverage Information CDSHooks Response (Logical Definition)"
Description: "Defines expectations for the CRD Coverage Information system action"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* ^extension[$standards-status].valueCode = #trial-use
* ^abstract = true
* systemActions MS
  * type = #update
  * resource MS
  * resource only Appointment
               or CommunicationRequest
               or DeviceRequest
               or MedicationRequest
               or NutritionOrder
               or ServiceRequest
               or VisionPrescription
// Todo invariant that resource.extension(...coverage-info).exists()

Profile: CRDCDSHooksAutoFormResponse
Id: CRDCDSHooksAutoFormResponse
Parent: CRDCDSHooksResponseBase
Title: "CRD Form Completion System Action CDSHooks Response (Logical Definition)"
Description: "Defines expectations for the CRD Form Completion system action"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* ^extension[$standards-status].valueCode = #trial-use
* ^abstract = true
* systemActions 1..2 MS
  * type = #create
  * resource 1..1 MS
  * resourceId 0..0
* systemActions ^slicing.discriminator.type = #type
* systemActions ^slicing.discriminator.path = "resource"
* systemActions ^slicing.rules = #closed
* systemActions contains questionnaire 0..1 and task 1..1
* systemActions[questionnaire].resource only Questionnaire
* systemActions[task].resource only SDCTaskQuestionnaire

ValueSet: CRDCreateOrUpdateAction
Id: CRDCreateOrUpdateAction
Title: "CDS Hooks Card Suggestion Create or Update Action Types Value Set"
Description: "Codes allowed for creating or updating a resource as an action in a CDS Hooks suggestion"
* ^status = #active
* ^experimental = false
* $restful-interaction#create
* $restful-interaction#update

Profile: CRDCDSHooksAutoInsuranceResponse
Id: CRDCDSHooksAutoInsuranceResponse
Parent: CRDCDSHooksResponseBase
Title: "CRD Create/Update Coverage System Action CDSHooks Response (Logical Definition)"
Description: "Defines expectations for the CRD Create/Update Coverage system action"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* ^extension[$standards-status].valueCode = #trial-use
* ^abstract = true
* systemActions MS
  * type from CRDCreateOrUpdateAction
  * resource 1..1 MS
  * resource only Coverage
  * resourceId 0..0


Profile: CRDCDSHooksResponse
Id: CRDCDSHooksResponse
Parent: CRDCDSHooksResponseBase
Title: "CRD CDSHooks Response (Logical Definition)"
Description: "Defines expectations for the CRD CDS Hooks responses"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* ^extension[$standards-status].valueCode = #trial-use
* ^abstract = true
* cards
* cards ^slicing.discriminator.type = #profile
* cards ^slicing.discriminator.path = "$this"
* cards ^slicing.rules = #open
* cards contains
  externalRefCard 0..* and
  instructionsCard 0..* and
  alternateCard 0..* and
  additionalCard 0..* and
  formCard 0..* and
  insuranceCard 0..* and
  smartCard 0..*
* cards[externalRefCard]
  * ^type.profile = CRDCDSHooksExternalRefResponse
//  * ^type.profile.extension[$profileElement].valueString = "CDSHooksResponse.cards"
* cards[instructionsCard]
  * ^type.profile = CRDCDSHooksInstructionsResponse
//  * ^type.profile.extension[$profileElement].valueString = "CDSHooksResponse.cards"
* cards[alternateCard]
  * ^type.profile = CRDCDSHooksAlternateResponse
//  * ^type.profile.extension[$profileElement].valueString = "CDSHooksResponse.cards"
* cards[additionalCard]
  * ^type.profile = CRDCDSHooksAdditionalResponse
//  * ^type.profile.extension[$profileElement].valueString = "CDSHooksResponse.cards"
* cards[formCard]
  * ^type.profile = CRDCDSHooksFormResponse
//  * ^type.profile.extension[$profileElement].valueString = "CDSHooksResponse.cards"
* cards[insuranceCard]
  * ^type.profile = CRDCDSHooksInsuranceResponse
//  * ^type.profile.extension[$profileElement].valueString = "CDSHooksResponse.cards"
* cards[smartCard]
  * ^type.profile = CRDCDSHooksSMARTResponse
//  * ^type.profile.extension[$profileElement].valueString = "CDSHooksResponse.cards"
* systemActions
* systemActions ^slicing.discriminator.type = #profile
* systemActions ^slicing.discriminator.path = "$this"
* systemActions ^slicing.rules = #open
* systemActions contains 
  coverageAction 0..* and
  formAction 0..* and
  insuranceAction 0..*
/*
* systemActions[coverageAction]
  * ^type.profile = CRDCDSHooksCoverageResponse
//  * ^type.profile.extension[$profileElement].valueString = "CDSHooksResponse.systemActions"
* systemActions[formAction]
  * ^type.profile = CRDCDSHooksAutoFormResponse
//  * ^type.profile.extension[$profileElement].valueString = "CDSHooksResponse.systemActions"
* systemActions[insuranceAction]
  * ^type.profile = CRDCDSHooksAutoInsuranceResponse
//  * ^type.profile.extension[$profileElement].valueString = "CDSHooksResponse.systemActions"
*/