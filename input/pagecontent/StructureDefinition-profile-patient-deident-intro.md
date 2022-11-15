<!--- Text entered into this file will appear at the top of the profiles page before the Formal Views of the profile content. -->

### Usage
<br/>
CRD Clients will use this profile to [resolve references](hooks.html#additional-data-retrieval) to Patient resources passed to CRD Servers, including `patientId` context references when invoking the following CDS Hooks without patient-identifiable protected health information (PHI):
* [appointment-book](hooks.html#appointment-book)
* [encounter-start](hooks.html#encounter-start)
* [encounter-discharge](hooks.html#encounter-discharge)
* [order-select](hooks.html#order-select)
* [order-sign](hooks.html#order-sign)

Refer to the section on [PHI and Hook Invocation](hooks.html#phi-and-hook-invocation) in the formal specification for more information.
<br/>
