<!--- Text entered into this file will appear at the top of the profiles page before the Formal Views of the profile content. -->

### Usage

§prof-2^crd-client^exchange:CRD Clients **SHALL** use either this Appointment without Order and/or the [no-order](StructureDefinition-profile-appointment-no-order.html) to provide `appointments` context objects to CRD Servers when invoking the [appointment-book](hooks.html#appointment-book) hook as well as to [resolve other references](foundation.html#additional-data-retrieval) to Appointment resources.§

This profile conveys the details of the appointment in an associated [ServiceRequest](StructureDefinition-profile-servicerequest.html).

Information provided in [Must Support]({{site.data.fhir.path}}profiling.html#mustsupport) elements will commonly be required for CRD Servers to perform coverage requirements discovery.
<br/>
