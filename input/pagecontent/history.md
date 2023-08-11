This page describes the primary releases of the specification and summarizes the content for each:

<div markdown="1" class="new-content">

### Release 1.2.0
A number of additional changes enhancements.  Key differences are:
* Renamed the 'Annotate' card to [Coverage Information](cards.html#coverage-information) and made it a system action rather than a card
* Removed the Unsolicited determiniation card type
* Added system action as an optional feature of the [form completion](cards.html#request-form-completion) and [update coverage information](cards.html#create-or-update-coverage-information) cards
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
* Added the Annotate and Unsolicited Determiniation card types
* Revamped how [Prefetch](foundation.html#prefetch) handles retrieving a patient's coverage information
* Provided explicit guidance around deferring card actions
* Added a section on registering DTR apps with CRD
* Updated to support CRD 2.0, which included changes to the 'topic' element within cards
* Added support for system actions and made their use mandatory for updates to orders and coverage
* Added a definition of [mustSupport](foundation.html#mustsupport) for this guide
* Acknowledged that CRD clients can be made up of [multiple systems](index.html#systems)
* Removed constraint prohibiting [ServiceRequest.doNotPerform])(StructureDefinition-profile-servicerequest.html#profile)
* Added guidance on [enabling a CRD server](foundation.html#enabling-a-crd-server)
* Added guidances on [crd access tokens](foundation.html#crd-access-tokens)
* Clarified expectations about [controlling hook invocation](deviations.html#controlling-hook-invocation)
* Provided guidance on [external references](cards.html#external-reference)
* Corrected cardType codes to use the IG temporary code system, as it is likely that long-term these codes won't all live as part of the IG
* Added CapabilityStatements describing [CRD client](CapabilityStatement-crd-client.html) and [CRD Server](CapabilityStatement-crd-server.html) responsibilities


As well there were various other adjustments to specification language, profiles, and examples to align with these changes and to correct minor typos or improve wording.

</div>

### Release 1.0
Initial release of the CRD specification.