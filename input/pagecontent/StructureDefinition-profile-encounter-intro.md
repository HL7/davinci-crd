<!--- Text entered into this file will appear at the top of the profiles page before the Formal Views of the profile content. -->

### Usage
<br/>
CRD Clients **SHALL** use this profile to [resolve references](foundation.html#additional-data-retrieval) to Encounter resources passed to CRD Servers, including `encounterId` context references when invoking the following CDS Hooks:
* [appointment-book](hooks.html#appointment-book)
* [encounter-start](hooks.html#encounter-start)
* [encounter-discharge](hooks.html#encounter-discharge)
* [order-select](hooks.html#order-select)
* [order-sign](hooks.html#order-sign)
* [order-dispatch](hooks.html#order-dispatch)

Information provided in [Must Support]({{site.data.fhir.path}}profiling.html#mustsupport) elements will commonly be required for CRD Servers to perform coverage requirements discovery.
<br/>
