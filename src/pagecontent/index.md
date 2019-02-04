{% raw %}
{% endraw %}
<!--ReleaseHeader-->
<p style="background-color: yellow; border: 1px solid maroon; padding: 5px;">
  This is the {{site.data.info.ballotstatus}} version of the {{site.data.fhir.igName}} Implementation Guide,  based on <a href="{{site.data.fhir.path}}">FHIR Version {{site.data.fhir.version}}</a>.  
  See the <a href="{{site.data.fhir.canonical}}/history.html">Directory of published versions</a> for other versions and for a change history.
</p>
<!--EndReleaseHeader-->
<blockquote class="stu-note">
<p>
This specification is currently undergoing ballot and connectathon testing.  It is expected to evolve, possibly significantly, as part of that process.
</p>
<p>
Feedback is welcome and may be submitted through the <a href="http://gforge.hl7.org/gf/project/fhir/tracker/?action=TrackerItemAdd&amp;tracker_id=677">FHIR gForge tracker</a> indicating "US Da Vinci CRD" as the specification.
</p>
<p>
This implementation guide is dependent on other specifications.  Please submit any comments you have on these base specifications as follows:
</p>
<ul>
  <li>Feedback on CDS Hooks should be posted to the CDS Hooks <a href="https://github.com/cds-hooks/docs/issues">GitHub Issue List</a></li>
  <li>Feedback on the FHIR core specification should be submitted to the <a href="http://gforge.hl7.org/gf/project/fhir/tracker/?action=TrackerItemAdd&amp;tracker_id=677">FHIR gForge tracker</a> with "FHIR Core" as the specification.</li>
  <li>Feedback on the US core profiles should be submitted to the <a href="http://gforge.hl7.org/gf/project/fhir/tracker/?action=TrackerItemAdd&amp;tracker_id=677">FHIR gForge tracker</a> with "US Core" as the specification.</li>
</ul>
<p>
Individuals interested in participating in the Coverage Requirements Discovery or  other HL7 Da Vinci projects can find information about Da Vinci [here](http://www.hl7.org/about/davinci).
</p>
<p>
There are a few places in this implementation guide marked as 'ToDo'.  All such areas represent supplementary content such as examples, additional background or context or other non-definitional content (i.e. they do not change any of the conformance expectations on implementers).  Where ToDo appears, such content will be created and included in the implementation guide prior to publication as a Standard for Trial Use.
</p>
</blockquote>


### Overview
The process of managing billing against patient insurance is a source of significant complexity and cost in the United States.  Different insurance payers - and different plans within the same payer have varying expectations around documentation requirements, the determination of whether a treatment or service is necessary or appropriate, whether prior authorizations or other approvals are necessary, etc.  Healthcare providers who fail to adhere to payer expectations may find that costs are not fully covered or not covered at all, resulting in increased costs for patients and/or additional visits to change ordered therapy, resulting in increased costs for everyone.

This implementation guide defines a process that provides coverage requirements to EHRs and other clinical systems at the time decisions around treatment are being made. Coverage information provided by the insurance payer allows clinicians and administrative staff, in conjunction with the patient, to make better informed decisions around the benefits provided, limitations, costs to the patient, and  faster payment turnaround on claimed services.

This implementation guide provides both Personal Healthcare Information (PHI)-specific and non-PHI mechanisms as suited to the needs/privileges of the payer organization.  It allows to payers to share a wide variety of information with providers in a context-sensitive manner - including:

* updated coverage information
* alternative preferred/first-line/lower-cost services/products
* documents and rules related to coverage
* forms and templates
* indications of whether prior atuthorization is required

The implementation guide is designed to allow for initial support of basic capabilities and to subsequently build new features over time.


### Content and organization
The implementation guide is organized into the following sections:

* [Background](background.html) describes the intent of this implementation guide 
* [Specification](hooks.html) provides the technical conformance details for the specification
* [Use Cases](usecases.html) provides examples of how this specification can be used by payers
* [Resources](resources.html) introduces and provides links to the FHIR [STU3](STU3/artifacts.html) and [R4](artifacts.html) profiles, search parameters and other FHIR artifacts used in this implementation guide as well as examples
* [Downloads](downloads.html) allows download of this and other specifications as well as other useful files
* [Credits](credits.html) identifies the individuals and organizations involved in developing this implementation guide