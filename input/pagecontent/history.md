This page describes the primary releases of the specification and summarizes the content for each:

### Release 2.1.0-ballot
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

* [Clarified](background.html#users) that CRD results can be returned to non-clinical users
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
* Added a definition of [mustSupport](foundation.html#mustsupport) for this guide
* Acknowledged that CRD clients can be made up of [multiple systems](index.html#systems)
* Removed constraint prohibiting [ServiceRequest.doNotPerform])(StructureDefinition-profile-servicerequest.html#profile)
* Added guidance on [enabling a CRD server](foundation.html#enabling-a-crd-server)
* Added guidance on [CRD access tokens](foundation.html#crd-access-tokens)
* Clarified expectations about [controlling hook invocation](deviations.html#controlling-hook-invocation)
* Provided guidance on [external references](cards.html#external-reference-response-type)
* Corrected cardType codes to use the IG temporary code system, as it is likely that long-term these codes won't all live as part of the IG
* Added CapabilityStatements describing CRD client and CRD Server responsibilities


As well there were various other adjustments to specification language, profiles, and examples to align with these changes and to correct minor typos or improve wording.


### Release 1.0
Initial release of the CRD specification.