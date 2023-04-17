<!--- Text entered into this file will appear at the top of the profiles page before the Formal Views of the profile content. -->

### Usage
<br/>
CRD Clients **SHALL** use this profile to [resolve references](hooks.html#additional-data-retrieval) to VisionPrescription resources passed to CRD Servers (e.g. `selections` context references) and to populate `draftOrders` context objects when invoking the when invoking the following CDS Hooks:
* [order-select](hooks.html#order-select)
* [order-sign](hooks.html#order-sign)

Information provided in [Must Support]({{site.data.fhir.path}}profiling.html#mustsupport) elements will commonly be required for CRD Servers to perform coverage requirements discovery.

NOTE: This profile is not currently based on US Core because US Core does not yet profile the VisionPrescription resource.  If a future version of US-Core adds support for the resource, this profile will be revised to extend the US Core profile.
<br/>
