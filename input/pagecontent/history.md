This page describes the primary releases of the specification and summarizes the content for each:

### Release 2.2.0

**Breaking changes**:
* [FHIR-49801](https://jira.hl7.org/browse/FHIR-49801) - Update appointment prefetch to include ServiceRequest
* [FHIR-50276](https://jira.hl7.org/browse/FHIR-50276) - Moved codes out of the tmporary code system to their permanent home
* [FHIR-49637](https://jira.hl7.org/browse/FHIR-49637) - Added standard reason codes for member not found and reason not found
* [FHIR-49754	
](https://jira.hl7.org/browse/FHIR-49754	
) - Moved info-needed code from 'reason' to 'info-needed' element
* [FHIR-49792](https://jira.hl7.org/browse/FHIR-49792) - Added a 'category' element to coverage-information.detail; merged instructions-clinical and instructions-admin detail codes into 'instructions'
* [FHIR-49827](https://jira.hl7.org/browse/FHIR-49827) - Revised crd-ci-q4 constraint to add noauth and not-covered as relevant prior auth decisions
* [FHIR-49829](https://jira.hl7.org/browse/FHIR-49829) - Added constraint: If doc-purpose is present with a value other than 'conditional', then doc-reason must be present.
* [FHIR-50492](https://jira.hl7.org/browse/FHIR-50492), [FHIR-50494](https://jira.hl7.org/browse/FHIR-50494), [FHIR-50495](https://jira.hl7.org/browse/FHIR-50495), [FHIR-50496](https://jira.hl7.org/browse/FHIR-50496) - Enforce that US Core profiles are enforced for CommunicationRequest, DeviceRequest and ServiceRequest reason, as well as Encounter.diagnosis and procedure
* [FHIR-49983](https://jira.hl7.org/browse/FHIR-49983) - Allow communicating 'possible billing codes' as part of order codes
* [FHIR-49794](https://jira.hl7.org/browse/FHIR-49794) - Prohibit Questionnaire Tasks from having a 'focus' element
* [FHIR-50269](https://jira.hl7.org/browse/FHIR-50269) - Remove 'after completion' input from Questionnaire Task
* [FHIR-49894](https://jira.hl7.org/browse/FHIR-49894) - Add rule that info-needed of OTH requires detail
* [FHIR-49830](https://jira.hl7.org/browse/FHIR-49830) - Explicitly require giving clinician a chance to launch DTR if info-needed=patient
* [FHIR-50102](https://jira.hl7.org/browse/FHIR-50102) - Require payers to not make changes to resources when adding coverage-information extension
* [FHIR-49128](https://jira.hl7.org/browse/FHIR-49128) - Tighten expectations on prefetch processing
* [FHIR-49742](https://jira.hl7.org/browse/FHIR-49742) - Make clear that having an access token is reqiured
* [FHIR-49909](https://jira.hl7.org/browse/FHIR-49909) - Tighten requirements about ignoring unexpected elements
* [FHIR-50051](https://jira.hl7.org/browse/FHIR-50051) - Update to current version of CDS Hooks
* [FHIR-49897](https://jira.hl7.org/browse/FHIR-49897) - Add expectations around patient-pay
* [FHIR-50318](https://jira.hl7.org/browse/FHIR-50318) - Added expectation to put coverage-expectation extension on ServiceRequest for appointments based on ServiceRequest (clarification) [link](cards.html#FHIR-50318)
* [FHIR-49637](https://jira.hl7.org/browse/FHIR-49637) - Defined explicit codes for 'no-member-found' and 'no-active-coverage', and required their use (enhancement)
* [FHIR-50206](https://jira.hl7.org/browse/FHIR-50206) - Removed patient as an allowed type of Coverage payer
* *Coverage Information Extension*
  * [FHIR-49827](https://jira.hl7.org/browse/FHIR-49827) - Update crd-ci-q4 contraint on coverage-information to say 'noauth' and 'not-covered' in addition to 'satisfied' as reasons why you can't have a doc purpose of with-pa (correction)
  * [FHIR-49829](https://jira.hl7.org/browse/FHIR-49829) - Enforce that if doc-purpose is present with a value other than 'conditional', doc-reason must be present (correction)


**Substative changes**

**Non-substantive changes**:
* [FHIR-49153](https://jira.hl7.org/browse/FHIR-49153), [FHIR-51036](https://jira.hl7.org/browse/FHIR-51036), [FHIR-49094](https://jira.hl7.org/browse/FHIR-49094) - Corrected names and descriptions of CDS Hooks request and response examples (correction)
* [FHIR-49711](https://jira.hl7.org/browse/FHIR-49711) - Fixed short description for 'info-needed' component of coverage-information extension

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