{% raw %}
{% endraw %}
<blockquote class="note-to-balloters">
<p>
This ballot release of the specification reflects several changes that reflect implementer feedback about the CRD specification arising from detailed review, connectathons and implementation experience.  Significant changes to the specification are highlighted in green and balloters are invited to focus particular attention on these sections.  "Notes to balloters" and "STU notes" call out additional key considerations where feedback is desired.  However, the whole specification is open to review and the project welcomes all constructive feedback.
</p>
<p>
A summary of the major changes in this release can be found <a href="history.html">here</a>.
</p>
</blockquote>

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
  <li>Feedback on CDS Hooks should be posted to the <a href="http://hl7.org/fhir-issues">FHIR change tracker</a> with "CDS Hooks" as the specification.</li>
  <li>Feedback on the FHIR core specification should be submitted to the <a href="http://hl7.org/fhir-issues">FHIR change tracker</a> with "FHIR Core" as the specification.</li>
  <li>Feedback on the US core profiles should be submitted to the <a href="http://hl7.org/fhir-issues">FHIR change tracker</a> with "US Core" as the specification.</li>
</ul>
<p>
Individuals interested in participating in the Coverage Requirements Discovery or other HL7 Da Vinci projects can find information about Da Vinci [here](http://www.hl7.org/about/davinci).
</p>
</blockquote>


### Overview
The process of managing billing for patient insurance is a significant source of complexity and cost in the United States.  Healthcare providers work with a range of different health insurers and payers who cover the services the providers supply to patients.  Different payers and plans provide different levels of coverage for healthcare services with different processes for determining whether services are necessary or are appropriate.  These processes have different requirements for documentation, prior authorization, or other approvals.  Claims submitted for payment that do not meet payer coverage or documentation requirements will typically be initially denied and may result in delays due to resubmission, appeals, and/or financial impact to the patient.

This Coverage Requirements Discovery (CRD) implementation guide defines a workflow to allow payers to provide information about coverage requirements to healthcare providers through their provider systems at the time treatment decisions are being made.  This will ensure that clinicians and administrative staff have the capability to make informed decisions and meet the requirements of the patient's insurance coverage.

This implementation guide supports both Protected Health Information (PHI)-specific and non-PHI mechanisms for CRD to meet the needs and privileges of different payer organizations.  These mechanisms will allow payers to share a wide variety of information with providers in a context-sensitive manner including:

* updates to coverage information
* alternative (e.g. first-line, lower-cost, etc.) services or products
* documentation requirements and rules related to coverage
* forms and templates to complete
* indications of whether a therapy is covered or prior authorization is required, including propagating this information into the relevant order/appointment

This implementation guide is designed to allow for initial support of basic capabilities and to subsequently build new features over time.


### Systems

This implementation guide sets expectations for two types of systems:

[CRD Clients](CapabilityStatement-crd-client.html) are typically systems that healthcare providers use at the point of care, including electronic medical records systems, pharmacy systems, and other provider and administrative systems used for ordering, documenting, and execution of patient-related services. Users of these systems have a need for coverage requirements information to support care planning.
<div markdown="1" class="new-content">

Examples of potential CRD clients include EHRs, EMRs, practice management systems, scheduling systems, patient registration systems, etc.  In some situations, a CDS Client may be composed of a variety of different subsystems, where the sub-system within a healthcare organization coordinate to satisfy CDS Client functionality (e.g. different data repositories for clinical and administrative data, different software for clinical orders vs. encounter management vs. appointment booking).

The specific architecture of the CRD client and the number of distinct data repositories it uses doesn't matter.  The only requirement is that from a CRD server perspective, the collection of systems behaves as one.  I.e. one endpoint for the CRD server can use to access patient data, one authorization process for registering the server to be used within the provider environment, etc.

<blockquote class="stu-note">
<p>
This specification recognizes that CRD clients may be made up of multiple systems, potentially including components whose specific function is enabling CRD functionality.  In practice, there will be orchestration requirements to allow these multiple systems to interact in a way that allows them to appear as a single monolithic system from the perspective of the CRD server.  This IG does not (yet) provide any guidance or standardization about how system components should interoperate to achieve this monolithic behavior.  If there is industry interest, future releases of this IG may work to standardize some of these "intra-client" interactions.
</p>
</blockquote>

</div>

[CRD Servers](CapabilityStatement-crd-server.html) (or servers) are systems that act on behalf of payer organizations to share information with healthcare providers about rules and requirements related to healthcare products and services covered by a patient's payer.  A CRD Server might provide coverage information related to one or more insurance plans. CRD Servers are a type of CDS Service as defined in the [CDS Hooks Specification](https://cds-hooks.hl7.org/2.0).

<div markdown="1" class="new-content">

Payers may have multiple back-end functions that handle different types of decision support and/or different types of services.  However, for the purpose of CRD conformance, payers **SHALL** have a single endpoint (managed by themselves or a delegate) that can handle responding to all CRD service calls.  CRD servers are free to route the information from those calls to back-end services as needed.  This routing may evolve over time and should have no impact on CRD client calls.

</div>


### Content and Organization
This implementation guide is organized into the following sections:

* [Use Cases and Overview](usecases.html) describes the intent of the implementation guide, gives examples of its use, and provides a high-level overview of expected process flow
* [Technical Background](background.html) identifies related specifications this implementation guide builds upon that developers should read and understand prior to implementing this specification
* [Formal Specification](hooks.html) covers the detailed implementation requirements and conformance expectation
* [Artifacts](allartifacts.html) introduces and provides links to the profiles, search parameters and other FHIR artifacts used in this implementation guide
* [Downloads](downloads.html) allows download of this and other specifications as well as other useful files
* [Credits](credits.html) identifies the individuals and organizations involved in developing this implementation guide

### Dependencies
This implementation guide relies on the following other specifications:
* **[FHIR R4]({{site.data.fhir.path}})** - The 'current' official version of FHIR as of the time this implementation guide was published.  See the [background page](background.html#fhir) for key pieces of this specification implementers should be familiar with.
* **[US Core STU3]({{site.data.fhir.ver.uscore}})** - The version of US Core based on FHIR R4.
* **[CDS Hooks CI Build](https://cds-hooks.org/specification/current/)** - The community release that defines one of the hooks used by this implementation guide.
* **[CDS Hooks 2.0](https://cds-hooks.hl7.org/2.0)** - The official standard for trial use publication of CDS Hooks that defines the CDS Hooks protocol and interfaces used by this implementation guide.
* **[SMART on FHIR](http://hl7.org/fhir/smart-app-launch)** - This specification provides a reliable, secure authorization protocol for SMART apps launched from a provider system to support coverage requirements discovery (e.g. what-if scenarios).


This implementation guide defines additional constraints and usage expectations above and beyond the information found in these base specifications.
