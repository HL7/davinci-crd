{% raw %}
{% endraw %}
<blockquote class="stu-note">
<p>
This specification is a Standard for Trial Use.  It is expected to continue to evolve and improve through connectathon testing and feedback from early adopters.
</p>
<p>
Feedback is welcome and may be submitted through the <a href="http://hl7.org/fhir-issues">FHIR change tracker</a> indicating "US Da Vinci CRD" as the specification.
</p>
<p>
This implementation guide is dependent on other specifications.  Please submit any comments you have on these base specifications as follows:
</p>
<ul>
  <li>Feedback on CDS Hooks should be posted to the CDS Hooks <a href="https://github.com/cds-hooks/docs/issues">GitHub Issue List</a></li>
  <li>Feedback on the FHIR core specification should be submitted to the <a href="http://hl7.org/fhir-issues">FHIR change tracker</a> with "FHIR Core" as the specification.</li>
  <li>Feedback on the US core profiles should be submitted to the <a href="http://hl7.org/fhir-issues">FHIR change tracker</a> with "US Core" as the specification.</li>
</ul>
<p>
Individuals interested in participating in the Coverage Requirements Discovery or  other HL7 Da Vinci projects can find information about Da Vinci [here](http://www.hl7.org/about/davinci).
</p>
</blockquote>


### Overview
The process of managing billing for patient insurance is a significant source of complexity and cost in the United States.  Healthcare providers work with a range of different health insurers and payers who cover the services the providers supply to patients.  Different payers and plans provide different levels of coverage for healthcare services with different processes for determining whether services are necessary or are appropriate.  Different processess have different requirements for documentation, prior authorization or other approvals.  Providers who fail to adhere to payer or coverage expectations may find that costs for a given service are not covered or are only partially covered.  The outcome of this failure to conform to payer requirements can be: increased out of pocket costs for patients, additional visits, changes to ordered therapy and increased costs for both patients and providers.

This Coverage Requirements Discovery (CRD) implementation guide defines a workflow to allow payers to provide information about coverage requirements to healthcare providers through their clinical systems at the time treatment decisions are being made.  This will ensure that clinicians and administrative staff have the capability to make informed decisions and meet the requirements of the patient's insurance coverage.

This implementation guide supports both Protected Health Information (PHI)-specific and non-PHI mechanisms for CRD to meet the needs and privileges of different payer organizations.  These mechanisms will allow payers to share a wide variety of information with providers in a context-sensitive manner including:

* updates to coverage information
* alternative preferred/first-line/lower-cost services or products
* documentation requirements and rules related to coverage
* forms and templates to complete
* indications of whether prior authorization is required

The implementation guide is designed to allow for initial support of basic capabilities and to subsequently build new features over time.


### Content and organization
The implementation guide is organized into the following sections:

* [Use Cases and Overview](usecases.html) describes the intent of the implementation guide, gives examples of its use and provides a high-level overview of expected process flow
* [Technical Background](background.html) identifies related specifications that this implementation guide builds upon and that developers should read and understand prior to implementing this specification
* [Formal Specification](hooks.html) covers the detailed implementation requirements and conformance expectation
* [Artifacts](allartifacts.html) introduces and provides links to the profiles, search parameters and other FHIR artifacts used in this implementation guide
* [Downloads](downloads.html) allows download of this and other specifications as well as other useful files
* [Credits](credits.html) identifies the individuals and organizations involved in developing this implementation guide

### Dependencies
This implementation guide relies on the following other specifications:
* **[FHIR R4]({{site.data.fhir.path}})** - The 'current' official version of FHIR as of the time this implementation guide was published.  See the [background page](background.html#fhir) for key pieces of this specification implementers should be familiar with.
* **[US Core STU3]({{site.data.fhir.ver.uscore}})** - The version of US Core based on FHIR R4.
* **[CDS Hooks CI Build](https://cds-hooks.org/specification/current/)** - The community release that defines the hooks used by this implementation guide
* **[CDS Hooks 1.0](https://cds-hooks.hl7.org/1.0)** - The official standard for trial use publication of CDS Hooks that defines the CDS Hooks protocol and interfaces used by this implementation guide
* **[SMART on FHIR](http://hl7.org/fhir/smart-app-launch)** - The specification provides a reliable, secure authorization protocol for SMART apps launched from a clinical system to support coverage requirements discovery (e.g. what-if scenarios).


This implementation guide defines additional constraints and usage expectations above and beyond the information found in these base specifications.
