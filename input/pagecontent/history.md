This page describes the primary releases of the specification and summarizes the content for each:

<div markdown="1" class="new-content">

### Release 1.1.0
Added a number of enhancements and some changes to approach.  Key differences are:

* [Clarified](background.html#users) that CRD results can be returned to non-clinical users
* Highlighted the [challenges](background.html#impact-on-payer-processes) of CRD data coming in a different form and set of codes than payers have traditionally dealt with
* Explicit expectations with respect to [performance](hooks.html#performance) and [accuracy](hooks.html#accuracy) of CRD Servers
* Expectations around client ability to [flag sensitive orders](hooks.html#appropriate-use-of-hooks)
* Specified a starter set of codes for [configuration options](hooks.html#configuration-options-extension) and mandated the appearance of those codes in cards in a new [card-topic](hooks.html#general-guidance) element
* Made support for a [minimal set of configuration options](hooks.html#configuration-options-extension) mandatory
* Added an extension to [link cards to requests](hooks.html#linking-cards-to-requests)
* Introduced the new [order-dispatch](hooks.html#order-dispatch) hook
* Added the [Annotate](hooks.html#annotate) and [Pre-emptive prior authorization](hooks.html#pre-emptive-prior-authorization) card types
* Revamped how [Prefetch](hooks.html#prefetch) handles retrieving a patient's coverage information
* Provided explicit guidance around [deferring card actions](hooks.html#deferring-card-actions)
* Added a section on [registering DTR apps with CRD](hooks.html#registering-dtr-apps-with-crd)
* Updated to support CRD 2.0, which included changes to the 'topic' element within cards
* Added support for system actions and made their use mandatory for updates to orders and coverage
* Added a definition of [mustSupport](hooks.html#mustsupport) for this guide
* Acknowledged that CRD clients can be made up of [multiple systems](hooks.html#systems)
* Removed constraint prohibiting [ServiceRequest.doNotPerform])(StructureDefinition-profile-servicerequest.html#profile)
* Added guidance on [enabling a CRD server](hooks.html#enabling-a-crd-server)
* Added guidances on [crd access tokens](hooks.html#crd-access-tokens)
* Clarified expectations about [controlling hook invocation](hooks.html#controlling-hook-invocation)
* Provided guidance on [external references](hooks.html#external-reference)
* 

As well there were various other adjustments to specification language, profiles, and examples to align with these changes and to correct minor typos or improve wording.

</div>

### Release 1.0
Initial release of the CRD specification.