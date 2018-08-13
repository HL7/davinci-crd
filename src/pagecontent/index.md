### Overview
Process of managing billing against patient insurance is a source of significant complexity and cost in the United States.  Different insurance providers - and different plans within the same providers have varying expectations around documentation requirements, the determination of whether a particular treatment or service is necessary or appropriate, whether prior authorizations or other approvals are necessary, etc.  Healthcare providers who fail to adhere to payer expectations may find that costs are not fully covered or not covered at all, resulting in increased costs for patients and/or additional visits to change ordered therapy, resulting in increased costs for everyone.

This implementation guide defines a mechanism for insurance payers to share coverage requirements with EHRs and other clinical systems at the time decisions around treatment are being made.  This ensures that clinicians and administrative staff can make informed decisions and can meet the requirements of the insurance coverage the patient has.

The implementation guide provides both Personal Healthcare Information (PHI)-specific and non-PHI mechanisms as suited to the needs/privileges of the payer organization.  It allows to payers to share a wide variety of information with providers in a context-sensitive manner - including:

* updated coverage information
* alternative preferred/first-line/lower-cost services/products
* documents and rules related to coverage
* forms and templates
* indications of whether prior atuthorization is required

The implementation guide is designed to allow for initial support of basic capabilities and to subsequently build new features over time.

<blockquote class="stu-note">
<p>
This specification is currently undergoing ballot and connectathon testing.  It is expected to evolve, possibly significantly, as part of that process.
</p>
<p>
Feedback is welcome and may be submitted through the <a href="http://gforge.hl7.org/gf/project/fhir/tracker/?action=TrackerItemAdd&amp;tracker_id=677">FHIR gForge tracker</a>
</p>

</blockquote>

### Content and organization

The implementation guide is organized into the following sections:

* [Background and use-cases](background.html) describes the intent of this implementation guide and provides examples of how this specification can be used by payors
* [Specification](hooks.html) provides the technical conformance details for the specification
* [STU3 Artifacts](stu3/artifacts.html) and [R4 Artifacts](artifacts.html) define the profiles, search parameters and other FHIR artifacts used in this implementation guide as well as examples
* [Credits](credits.html) identifies the individuals and organizations involved in developing this implementation guide

The complete content of this implementation guide can be downloaded [here](full-ig.zip).