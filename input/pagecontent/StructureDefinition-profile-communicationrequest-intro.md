<!--- Text entered into this file will appear at the top of the profiles page before the Formal Views of the profile content. -->

### Usage
<br/>
CRD Clients SHALL use this profile to [resolve references](hooks.html#additional-data-retrieval) to CommunicationRequest resources passed to CRD Services (e.g. `selections` context references) and to populate `draftOrders` context objects when invoking the when invoking the following CDS Hooks:
* [order-select](hooks.html#order-select)
* [order-sign](hooks.html#order-sign)

Information provided in [Must Support]({{site.data.fhir.path}}profiling.html#mustsupport) elements will commonly be required for CRD Services to perform coverage requirements discovery.

The insurance extension ([ext-insurance](StructureDefinition-ext-insurance.html)) allows relevant coverage information to be conveyed with selections and/or draft orders.  A [search parameter](SearchParameter-communicationrequest-insurance.html) is defined in this guide to enable the [prefetch](hooks.html#prefetch) of coverage information when invoking hooks.
<br/>
