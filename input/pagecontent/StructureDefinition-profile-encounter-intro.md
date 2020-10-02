<!--- Text entered into this file will appear at the top of the profiles page before the Formal Views of the profile content. -->

### Usage
<br/>
CRD Clients SHALL use this profile to [resolve references](hooks.html#additional-data-retrieval) to Encounter resources passed to CRD Services, including `encounterId` context references when invoking the following CDS Hooks:
* [appointment-book](hooks.html#appointment-book)
* [encounter-start](hooks.html#encounter-start)
* [encounter-discharge](hooks.html#encounter-discharge)
* [order-select](hooks.html#order-select)
* [order-sign](hooks.html#order-sign)

Information provided in [Must Support]({{site.data.fhir.path}}profiling.html#mustsupport) elements will commonly be required for CRD Services to perform coverage requirements discovery.

The insurance extension ([ext-insurance](StructureDefinition-ext-insurance.html)) allows relevant coverage information to be conveyed with the current Encounter.  A [search parameter](SearchParameter-encounter-insurance.html) is defined in this guide to enable the [pre-fetch](hooks.html#pre-fetch) of coverage information when invoking hooks.
<br/>