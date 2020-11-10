<!--- Text entered into this file will appear at the top of the profiles page before the Formal Views of the profile content. -->

### Usage
<br/>
CRD Clients SHALL use this profile to provide `appointments` context objects to CRD Services when invoking the [appointment-book](hooks.html#appointment-book) hook as well as to [resolve other references](hooks.html#additional-data-retrieval) to Appointment resources.

Information provided in [Must Support]({{site.data.fhir.path}}profiling.html#mustsupport) elements will commonly be required for CRD Services to perform coverage requirements discovery.

The insurance extension ([ext-insurance](StructureDefinition-ext-insurance.html)) allows relevant coverage information to be conveyed with a proposed Appointment.  A [search parameter](SearchParameter-appointment-insurance.html) is defined in this guide to enable the [prefetch](hooks.html#prefetch) of coverage information when invoking hooks.
<br/>
