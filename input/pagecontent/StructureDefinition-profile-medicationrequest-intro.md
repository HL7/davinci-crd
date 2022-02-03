<!--- Text entered into this file will appear at the top of the profiles page before the Formal Views of the profile content. -->

### Usage
<br/>
CRD Clients SHALL use this profile to [resolve references](hooks.html#additional-data-retrieval) to MedicationRequest resources passed to CRD Services (e.g. `selections` context references) and to populate `draftOrders` context objects when invoking the when invoking the following CDS Hooks:
* [order-select](hooks.html#order-select)
* [order-sign](hooks.html#order-sign)

Information provided in [Must Support]({{site.data.fhir.path}}profiling.html#mustsupport) elements will commonly be required for CRD Services to perform coverage requirements discovery.

NOTE: This profile is not currently based on US Core because US Core accidentally constrained out PractitionerRole.  When a future version of US-Core adds support back in, this profile will be revised to extend the US Core profile
<br/>
