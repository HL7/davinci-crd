<!--- Text entered into this file will appear at the top of the profiles page before the Formal Views of the profile content. -->

### Usage
<br/>
<div class="modified-content" markdown="1">
CRD Clients **SHALL** use either this profile and/or the [with-order](StructureDefinition-profile-appointment-with-order.html) to provide `appointments` context objects to CRD Servers when invoking the [appointment-book](hooks.html#appointment-book) hook as well as to [resolve other references](foundation.html#additional-data-retrieval) to Appointment resources.

This profile conveys the details of the appointment within the resource itself and doesn't make reference to a ServiceRequest.
</div>

Information provided in [Must Support]({{site.data.fhir.path}}profiling.html#mustsupport) elements will commonly be required for CRD Servers to perform coverage requirements discovery.
<br/>
