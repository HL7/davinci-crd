This page describes the primary releases of the specification and summarizes the content for each:

### Release 2.2.0-ballot

**Breaking changes**:
* [FHIR-49801](https://jira.hl7.org/browse/FHIR-49801) - Update appointment prefetch to include ServiceRequest
* [FHIR-50276](https://jira.hl7.org/browse/FHIR-50276) - Moved codes out of the tmporary code system to their permanent home
* [FHIR-49754](https://jira.hl7.org/browse/FHIR-49754) - Moved info-needed code from 'reason' to 'info-needed' element
* [FHIR-50269](https://jira.hl7.org/browse/FHIR-50269) - Remove 'after completion' input from Questionnaire Task

** [FHIR-50318](https://jira.hl7.org/browse/FHIR-50318) - Added expectation to put coverage-expectation extension on ServiceRequest for appointments based on ServiceRequest (clarification) [link](cards.html#FHIR-50318)
* [FHIR-49637](https://jira.hl7.org/browse/FHIR-49637) - Defined explicit codes for 'no-member-found' and 'no-active-coverage', and required their use (enhancement)
* [FHIR-49794](https://jira.hl7.org/browse/FHIR-49794) - In Questionnaire task, prohibit Task.focus and require input[questionnaire] (correction)
* [FHIR-50492](https://jira.hl7.org/browse/FHIR-50492), [FHIR-50494](https://jira.hl7.org/browse/FHIR-50494), [FHIR-50495](https://jira.hl7.org/browse/FHIR-50495), [FHIR-50496](https://jira.hl7.org/browse/FHIR-50496) - Updated CommunicationRequest.reasonReference, DeviceRequest.reasonReference, ServiceRequest.reasonReference, Encounter.diagnosis to force most references (other than Observation) to refer to US Core profiles, and added guidance that US Core Observation profiles should be used when possible. (correction)
* [FHIR-51045](https://jira.hl7.org/browse/FHIR-51045) - Relaxed Location.address to be optional, added guidance expecting propagation of address to fine-grained components (correction)
* [FHIR-49897](https://jira.hl7.org/browse/FHIR-49897) - Clarify that CRD must not be called in 'patient pay' situations (if system is aware) [link](deviations.html#FHIR-49897)
* [FHIR-49909](https://jira.hl7.org/browse/FHIR-49909) - Added expectations for handling unexpected content [link](foundation.html#FHIR-49909)
* [FHIR-50102](https://jira.hl7.org/browse/FHIR-50102) - Make explicit that Coverage Information system actions are prohibited from making changes other than adding or updating the coverage-information extension

* *Coverage Information Extension*
  * [FHIR-49827](https://jira.hl7.org/browse/FHIR-49827) - Update crd-ci-q4 contraint on coverage-information to say 'noauth' and 'not-covered' in addition to 'satisfied' as reasons why you can't have a doc purpose of with-pa (correction)
  * [FHIR-49829](https://jira.hl7.org/browse/FHIR-49829) - Enforce that if doc-purpose is present with a value other than 'conditional', doc-reason must be present (correction)
  * [FHIR-51413](https://jira.hl7.org/browse/FHIR-51413) - Remove the auth-out-network-only code from coverage-information.detail and add auth-out-network to coverage-information.reason.  Also added guidance on when to send multiple coverage information repetitions vs. a single 'conditional' repetition stating the rules.  (correction, clarification) [link](cards.html#FHIR-51413)
  * [FHIR-49792](https://jira.hl7.org/browse/FHIR-49792) - Add coverage-information.detail.category, categorize the standard detail.code values, and advise on expectation to display certain categories to clinical staff (enhancement)
  ** [FHIR-49950](https://jira.hl7.org/browse/FHIR-49950) - Set expectations about coverage-information extension being used in subsequent CRD, DTR and PAS calls to serve as a linking mechanism (clarification) [link](cards.html#FHIR-49950)


**Substative changes**
* [FHIR-49813](https://jira.hl7.org/browse/FHIR-49813) - Allow PractitionerRole as an Encounter.participant (enhancement)
* [FHIR-51420](https://jira.hl7.org/browse/FHIR-51420) - Allow coverage-information ids to be unique for the same coverage within a request resource. (correction)
* [FHIR-51470](https://jira.hl7.org/browse/FHIR-51470), [FHIR-51488](https://jira.hl7.org/browse/FHIR-51488) - Removed expectations and constraints for inclusion of medical record numbers in the Patient profile (correction) [link](StructureDefinition-profile-patient.html)
* [FHIR-49830](https://jira.hl7.org/browse/FHIR-49830) - Clarify that the requirement to provide access to DTR for clinicians is required for patient forms, not just clinical forms (correction) [link](cards.html#FHIR-49830)
* [FHIR-50009](https://jira.hl7.org/browse/FHIR-50009) - Relaxed expectations from SHALL to SHOULD for CRD response types other than coverage-information
* [FHIR-49742](https://jira.hl7.org/browse/FHIR-49742) - Change logical model token 0..1 to 1..1, made expectation to provide a token 'SHALL' instead of 'will' (correction) [link](foundation.html#FHIR-49742)
* [FHIR-49128](https://jira.hl7.org/browse/FHIR-49128) - Clarified (and loosened) conformance language for prefetch syntax (clarification) [link](deviations.html#FHIR-49128) [link](foundation.html#FHIR-49128)
* [FHIR-50051](https://jira.hl7.org/browse/FHIR-50051) - Updated specification to point to current version of CDS Hooks spec and individual hooks (correction) - throughout the spec
* [FHIR-49983](https://jira.hl7.org/browse/FHIR-49983) - Added new 'BillingOptions' extension and allow its use on all Request resources.  (enhancement) [link](StructureDefinition-ext-billing-options.html), many profiles

**Non-substantive changes**:
** [FHIR-49153](https://jira.hl7.org/browse/FHIR-49153), [FHIR-51036](https://jira.hl7.org/browse/FHIR-51036), [FHIR-49094](https://jira.hl7.org/browse/FHIR-49094) - Corrected names and descriptions of CDS Hooks request and response examples (correction) [link](artifacts.html#example-cds-hooks-examples)
** [FHIR-49711](https://jira.hl7.org/browse/FHIR-49711) - Fixed short description for 'info-needed' component of coverage-information extension (correction) [link](StructureDefinition-ext-coverage-information-definitions.html#diff_Extension.extension:info-needed)
** [FHIR-49689](https://jira.hl7.org/browse/FHIR-49689) - Corrected change log hyperlink in menu (correction) all pages
** [FHIR-49003](https://jira.hl7.org/browse/FHIR-49003) - Removed language implying that Task could be a focal request when submitting a CRD request or have coverage-information and provided clearer information about the purpose of CommunicationRequest (correction, clarification) - section no longer exists to link to
** [FHIR-49041](https://jira.hl7.org/browse/FHIR-49041) - Clarified the use-case for CommunicationRequest and added examples (clarification) [link](Binary-CRDServiceRequest3.html), [link](Binary-CRDServiceResponse3.html)
* [FHIR-49894](https://jira.hl7.org/browse/FHIR-49894) - Added more language around when to use doc-needed vs. info-needed, added example of both, made clear that if info-needed of OTH, one of the reasons need to indicate what type of information is needed (clarification) [link](StructureDefinition-ext-coverage-information.html#FHIR-49894)
** [FHIR-49835](https://jira.hl7.org/browse/FHIR-49835) - Removed the "additional hook resources" section of the deviations page (because in the referenced version of the CDS Hooks, it's no longer a deviation).  (correction) Nothing to link to anymore
** [FHIR-49196](https://jira.hl7.org/browse/FHIR-49196) - Clarified that _include may not be supported when using non-prefetch queries. (clarification) [link](foundation.html#FHIR-49196)
** [FHIR-49731](https://jira.hl7.org/browse/FHIR-49731) - Corrected prefetch syntax to be CDS Hooks-conformant (correction) [link](foundation.html#prefetch)
** [FHIR-49753](https://jira.hl7.org/browse/FHIR-49753) - Provided recommendations for when CRD discovery should be called (clarification) [link](foundation.html#FHIR-49753)
** [FHIR-49833](https://jira.hl7.org/browse/FHIR-49833) - Reframed warnings about the _include search mechanism to reflect the fact that it is no longer used in prefetch.  (correction) [link](foundation.html#FHIR-49833)
* [FHIR-49085](https://jira.hl7.org/browse/FHIR-49085) - In diagram, corrected "Payer CDA System" to "Payer CDS System" (correction) [link](hooks.html#hook-categories)
** [FHIR-49762](https://jira.hl7.org/browse/FHIR-49762) - Added VisionPrescription to the list of supported 'Request' resources for order-select and order-dispatch.  (They were already in the technical list, just not the HTML.) (correction) [link](hooks.html#order-dispatch) [link](hooks.html#order-select)
** [FHIR-48553](https://jira.hl7.org/browse/FHIR-48553) - Improved language in first intro paragraph (clarification) [link](index.html#FHIR-48553)
** [FHIR-48625](https://jira.hl7.org/browse/FHIR-48625) - Added guidance on best CRD service available practices (clarification) [link](implementation.html#FHIR-48625)
** [FHIR-50006](https://jira.hl7.org/browse/FHIR-50006) - Added additional examples for non-provided/insufficient information that is not considered an error (clarification) [link](cards.html#FHIR-50006)
** [FHIR-50225](https://jira.hl7.org/browse/FHIR-50225) - Added an introduction to the coverage-information extension providing a detailed overview and ensured all elements had proper descriptions (clarification) [link](StructureDefinition-ext-coverage-information.html#introduction)
** [FHIR-48771](https://jira.hl7.org/browse/FHIR-48771) - Clarified prefetch references (clarification) [link](foundation.html#FHIR-48771a) [link](foundation.html#FHIR-48771b)
** [FHIR-48773](https://jira.hl7.org/browse/FHIR-48773) - Clarified where coverage-information.coverage must exist (clarification) [link](StructureDefinition-ext-coverage-information-definitions.html#diff_Extension.extension:coverage)
** [FHIR-48797](https://jira.hl7.org/browse/FHIR-48797) - Clarified rules on multiple coverages (clarification) [link](foundation.html#FHIR-48797)
** [FHIR-49795](https://jira.hl7.org/browse/FHIR-49795) - Dropped Questionnaire Task reason value set and require inclusion of text (correction) [link](StructureDefinition-profile-taskquestionnaire-definitions.html#diff_Task.reasonCode)
** [FHIR-49805](https://jira.hl7.org/browse/FHIR-49805) - Added CommunicationRequest and VisionPrescription to prefetch and non-prefetch queries (correction) [link](https://build.fhir.org/ig/HL7/davinci-crd/foundation.html#prefetch), [link](Binary-CRDServices.html)
** [FHIR-51187](https://jira.hl7.org/browse/FHIR-51187) - Added links to examples zip files on the downloads page (clarification) [link](downloads.html)
** [FHIR-50206](https://jira.hl7.org/browse/FHIR-50206) - Removed patient as an allowed type of Coverage payer (correction) [link](StructureDefinition-profile-coverage-definitions.html#diff_Coverage.payor)
** [FHIR-49791](https://jira.hl7.org/browse/FHIR-49791) - Fixed odd content in logical model instances (correction) all logical model files and fragments
** [FHIR-49799](https://jira.hl7.org/browse/FHIR-49799) - Corrected appointment profiles to not be abstract (correction) [link](StructureDefinition-profile-appointment-with-order.html), [link](StructureDefinition-profile-appointment-no-order.html)
** [FHIR-49800](https://jira.hl7.org/browse/FHIR-49800) - Fixed bad brackets in CDS Hooks Service Response (correction) [link](Binary-CRDServices.html)

In addition, there have been various miscellaneous non-substantive improvements to formatting, spelling, grammar, etc.


### Release 2.1.0
* [FHIR-47329](https://jira.hl7.org/browse/FHIR-47329), [FHIR-48622](https://jira.hl7.org/browse/FHIR-48622) - Added support for USCDI v4 (US Core 7.0.0) and clarify language about what multi-US-Core release implementation means
* [FHIR-48352](https://jira.hl7.org/browse/FHIR-48352) - Set mustSupport expectations for practitioner, practitionerRole and organization for multi-target relationships
* [FHIR-48430](https://jira.hl7.org/browse/FHIR-48430) - Set clearer expectations for handling failure states
* [FHIR-48559](https://jira.hl7.org/browse/FHIR-48559) - Make ability to bypass CRD services that are running too long a 'SHALL'
* [FHIR-48560](https://jira.hl7.org/browse/FHIR-48560) - Make clear that clients need to constrain scopes provided to what's needed
* [FHIR-48722](https://jira.hl7.org/browse/FHIR-48722) - Collapse the 2 Encounter profiles (USCDI 1, USCDI 3+4) into one

### Release 2.1.0-preview
Significant Coverage Information changes:
* [FHIR-46088](https://jira.hl7.org/browse/FHIR-46088) - Set MS expectations (and general expectations too)
* [FHIR-46460](https://jira.hl7.org/browse/FHIR-46460) - Remove 'response' element
* [FHIR-46089](https://jira.hl7.org/browse/FHIR-46089) - Tightened invariants around info-needed
* [FHIR-44410](https://jira.hl7.org/browse/FHIR-44410) - Add support for policy links and information as qualifiers
* [FHIR-45440](https://jira.hl7.org/browse/FHIR-45440) - Added new configuration option for 'wanting information' ServiceRequest and one not
* [FHIR-44909](https://jira.hl7.org/browse/FHIR-44909) - Added support for additional information from patient

Significant other changes:
* [FHIR-46440](https://jira.hl7.org/browse/FHIR-46640), [FHIR-46603](https://jira.hl7.org/browse/FHIR-46603) - Set expectations for endpoints and endpoint discovery
* [FHIR-45551](https://jira.hl7.org/browse/FHIR-45551) - Removed the CRD Practitioner profile (use HRex instead)
* [FHIR-46254](https://jira.hl7.org/browse/FHIR-46254) - Define a Task profile for order-dispatch hook
* [FHIR-44891](https://jira.hl7.org/browse/FHIR-44891) - Clarified expectations for mandatory hook support
* [FHIR-46006](https://jira.hl7.org/browse/FHIR-46006) - Added PractitionerRole to Appointment profile
* [FHIR-44527](https://jira.hl7.org/browse/FHIR-44527) - Corrected contexts for order-dispatch
* [FHIR-46120](https://jira.hl7.org/browse/FHIR-46120), [FHIR-43435](https://jira.hl7.org/browse/FHIR-43435) - Made Location.type MS and require it to be present in the hierarchy
* [FHIR-46383](https://jira.hl7.org/browse/FHIR-46383) - Prohibit use of CRD to point to portal launch
* [FHIR-43182](https://jira.hl7.org/browse/FHIR-43182) - Add expiration date to Coverage-Information
* [FHIR-45295](https://jira.hl7.org/browse/FHIR-45295) - Relax expections on Request statuses to not have to be 'draft'
* [FHIR-44388](https://jira.hl7.org/browse/FHIR-44388) - Split Appointment profile into two - one pointing to 
* [FHIR-45230](https://jira.hl7.org/browse/FHIR-45230) - Relaxed 'reason' constraints in profiles to align with US Core
* [FHIR-46793](https://jira.hl7.org/browse/FHIR-46793) - Set expectations for CRD clients to query data when possible

A variety of minor corrections and clarifications to wording and examples.


### Release 2.0.1
Corrected the embedded JSON examples to be technically correct and in line with other rules in the specification

### Release 2.0.0
A number of additional changes and enhancements.  Key differences are:
* Renamed the 'Annotate' card to [Coverage Information](cards.html#coverage-information-response-type) and made it a system action rather than a card
* Removed the Unsolicited determination card type
* Added system action as an optional feature of the [form completion](cards.html#request-form-completion-response-type) and [update coverage information](cards.html#create-or-update-coverage-records-response-type) cards
* Removed guidance on deferring card actions (as it's no longer terribly relevant for CRD and SMART now defines a mechanism)
* Added additional properties to the [coverage-information](StructureDefinition-ext-coverage-information.html) extension including the ability to specify questionnaires and draft responses for DTR, authorized billing codes, dependencies on other orders, and other details.
* Removed support for 'de-identified' invocation of CRD
* Corrected ServiceRequest.location to be 0..1 instead of 1..1
* Dropped expectation for coverage information to be conveyed as part of orders
* Changed language to make clear that CRD does not provide prior authorizations
* Tightened general conformance expectations 
* A few additional corrections and numerous clarifications and refinements

### Release 1.1.0
Added a number of enhancements and some changes to approach.  Key differences are:

* [Clarified](burden.html#users) that CRD results can be returned to non-clinical users
* Highlighted the [challenges](implementation.html#impact-on-payer-processes) of CRD data coming in a different form and set of codes than payers have traditionally dealt with
* Explicit expectations with respect to [performance](foundation.html#performance) and [accuracy](foundation.html#accuracy) of CRD Servers
* Expectations around client ability to [flag sensitive orders](foundation.html#appropriate-use-of-hooks)
* Specified a starter set of codes for [configuration options](deviations.html#configuration-options-extension) and mandated the appearance of those codes in cards in a new [topic](cards.html) element
* Made support for a [minimal set of configuration options](deviations.html#configuration-options-extension) mandatory
* Added an extension to [link cards to requests](deviations.html#linking-cards-to-requests)
* Introduced the new [order-dispatch](hooks.html#order-dispatch) hook
* Added the Annotate and Unsolicited Determination card types
* Revamped how [Prefetch](foundation.html#prefetch) handles retrieving a patient's coverage information
* Provided explicit guidance around deferring card actions
* Added a section on registering DTR apps with CRD
* Updated to support CRD 2.0, which included changes to the 'topic' element within cards
* Added support for system actions and made their use mandatory for updates to orders and coverage
* Added a definition of [mustSupport](conformance.html#mustsupport) for this guide
* Acknowledged that CRD clients can be made up of [multiple systems](index.html#systems)
* Removed constraint prohibiting [ServiceRequest.doNotPerform])(StructureDefinition-profile-servicerequest.html#profile)
* Added guidance on [enabling a CRD server](foundation.html#enabling-a-crd-server)
* Added guidance on [CRD access tokens](foundation.html#crd-access-tokens)
* Clarified expectations about [controlling hook invocation](deviations.html#controlling-hook-invocation)
* Provided guidance on [external references](cards.html#external-reference-response-type)
* Corrected cardType codes to use the IG temporary code system, as it is likely that long-term these codes won't all live as part of the IG
* Added CapabilityStatements describing CRD client and CRD Server responsibilities


As well there were various other adjustments to specification language, profiles, and examples to align with these changes and to correct minor typos or improve wording.


### Release 1.0.0
Initial release of the CRD specification.