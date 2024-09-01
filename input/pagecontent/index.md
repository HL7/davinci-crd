{% raw %}
{% endraw %}
<blockquote class="stu-note">
<p>
This release of the specification reflects several changes based on implementer feedback about the CRD specification arising from detailed review, connectathons and implementation experience.  Significant changes to the specification are highlighted in green.  "STU notes" call out additional key considerations where feedback is desired.
</p>
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
  <li>Feedback on the FHIR Core specification should be submitted to the <a href="http://hl7.org/fhir-issues">FHIR change tracker</a> with "FHIR Core" as the specification.</li>
  <li>Feedback on the US Core profiles should be submitted to the <a href="http://hl7.org/fhir-issues">FHIR change tracker</a> with "US Core" as the specification.</li>
</ul>
<p>
Individuals interested in participating in the Coverage Requirements Discovery or other HL7 Da Vinci projects can find information about Da Vinci [here](http://www.hl7.org/about/davinci).
</p>
<p>
A summary of the major changes from the previous release can be found <a href="history.html">here</a>.
</p>
</blockquote>


### Overview
The process of managing billing for patient insurance is a significant source of complexity and cost in the United States.  Healthcare providers work with a range of different health insurers and payers who cover services the providers supply to patients.  Different payers and plans provide different levels of coverage for healthcare services with different processes for determining whether services are necessary or appropriate.  These processes have different requirements for documentation, prior authorization, or other approvals.  Claims submitted for payment that do not meet payer coverage or documentation requirements will typically be initially denied and may result in delays due to resubmission, appeals, and/or financial impact to the patient.

This Coverage Requirements Discovery (CRD) implementation guide defines a workflow to allow payers to provide information about coverage requirements to healthcare providers through their provider systems at the time treatment decisions are being made.  This will ensure that clinicians and administrative staff have the capability to make informed decisions and meet the requirements of the patient's insurance coverage.

This implementation guide supports both Protected Health Information (PHI)-specific and non-PHI mechanisms for CRD to meet the needs and privileges of different payer organizations.  These mechanisms will allow payers to share a wide variety of information with providers in a context-sensitive manner including:

* updates to coverage information
* alternative (e.g. first-line, lower-cost, etc.) services or products
* documentation requirements and rules related to coverage
* forms and templates to complete
* indications of whether a therapy is covered or prior authorization is required, including propagating this information into the relevant order/appointment

This implementation guide is designed to allow for initial support of basic capabilities and to subsequently build new features over time.


<div class="new-content" markdown="1">
<blockquote class="stu-note" markdown="1">
On Feb 28, 2024, the Office of Burden Reduction and Health Informatics (OBRHI) National Standards Group (NSG) announced an [enforcement discretion](https://www.cms.gov/files/document/discretion-x12-278-enforcement-guidance-letter-remediated-2024-02-28.pdf) that they would not enforce the requirement to use the X12 278 for prior authorization if the covered entities were using the FHIR- based Prior Authorization API as described in the CMS Interoperability and Prior Authorization final rule (CMS-0057-F). This allows payers to return a prior authorization number for use in the X12 837 in coverage extension of the CRD and DTR IGs or as part of the all FHIR exchange of the Prior Authorization Response Bundle in the PAS IG.  For CRD, this specifically means that the satisfied-pa-id in the [Coverage Information extension](StructureDefinition-ext-coverage-information.html) can be used as an X12 prior authorization number.
</blockquote>
</div>

### Systems
This implementation guide sets expectations for two types of systems:

CRD Clients are typically systems that healthcare providers use at the point of care, including electronic medical records systems, pharmacy systems, and other provider and administrative systems used for ordering, documenting, and executing patient-related services. Users of these systems have a need for coverage requirements information to support care planning.

Examples of potential CRD clients include EHRs, EMRs, practice management systems, scheduling systems, patient registration systems, etc.  

The CRD client may actually involve multiple systems. For example, the systems that handle order entry may be different from what is used for appointment booking and different again from the system that exposes information over the FHIR interface. It is possible that a provider environment might use an intermediary to coordinate CRD client calls from multiple systems. Such an architecture is sufficient provided that:

* Calls are triggered from within the system the user is interacting with at the time the 'hook event' (entering an order, booking an appointment, etc.) occurs.
* Cards returned are displayed to the user, or in the event of system actions, user-notifications associated with the system actions occur in the application the user was interacting with.
* The 'access token' and FHIR endpoint exposed to the CRD service has access to all relevant data, independent of which physical data store it resides in.
* The intermediary could take on the responsibility for the FHIR interface, determining appropriate payer to route calls to, etc.

<div class="new-content" markdown="1">
There are two distinct CRD client sets of capabilities, one for [USCDI v1 (US-Core 3.1.1)](CapabilityStatement-crd-client3.1.html) and one for [USCDI v3 (US-Core 6.1.0)](CapabilityStatement-crd-client6.1.html).  Typically a client would support only one or the other based on which US Core release it supports internally.
</div>

<blockquote class="stu-note">
<p>
When CRD clients are made up of multiple systems, there will be orchestration requirements to allow these multiple systems to interact in a way for them to appear as a single monolithic system from the perspective of the CRD server.  This IG provides some discussion of this on the <a href="epa.html">ePA Coordinators page</a>, though it does not (yet) provide any standardization about how system components should interoperate to achieve this monolithic behavior.  If there is industry interest, future releases of this IG may work to standardize some of these "intra-client" interactions.
</p>
</blockquote>

CRD Servers (or servers) are systems that act on behalf of payer organizations to share information with healthcare providers about rules and requirements related to healthcare products and services covered by a patient's payer.  A CRD Server might provide coverage information related to one or more insurance plans. CRD Servers are a type of CDS Service as defined in the [CDS Hooks Specification](https://cds-hooks.hl7.org/2.0).
<div class="new-content" markdown="1">

There are also two distinct CRD server sets of capabilities, one for [USCDI v1 (US-Core 3.1.1)](CapabilityStatement-crd-server3.1.html) and one for [USCDI v3 (US-Core 6.1.0)](CapabilityStatement-crd-server6.1.html).  Ideally payers will be able to handle both, but they are not presently required to.
</div>

### Content and Organization
This implementation guide is organized into the following sections:

* [Use Cases and Overview](usecases.html) describes the intent of the implementation guide, gives examples of its use, and provides a high-level overview of expected process flow
* [Technical Background](background.html) identifies related specifications this implementation guide builds upon that developers should read and understand prior to implementing this specification
* [ePA Coordinators](epa.html) acknowledges that neither the payer nor provider systems involved in CRD are monolithic and shows how the various components of provider and payer systems might interact with "ePA Coordinator" systems to satisfy the requirements of this IG
* [Foundational Guidance](foundation.html) covers the detailed requirements and conformance expectations that apply to all implementations
* [Privacy, Security, and Safety](security.html) covers considerations around data access, protection, and similar concepts that apply to all implementations
* [Deviations and Enhancements](deviations.html) covers detailed implementation requirements and conformance expectations that are independent of particular hooks or cards
* [Supported Hooks](hooks.html) identifies the expectations for support for specific CDS hooks
* [Card Profiles](cards.html) defines patterns for CDS Hook cards that can be returned as part of this specification
* [Implementation Guidance](implementation.html) provides recommendations for implementation that fall outside the technical scope of the specification
* [Artifacts](allartifacts.html) introduces and provides links to the profiles, search parameters and other FHIR artifacts used in this implementation guide
* [Downloads](downloads.html) allows download of this and other specifications, as well as other useful files
* [Credits](credits.html) identifies the individuals and organizations involved in developing this implementation guide

### Dependencies
This guide is based on the [FHIR R4]({{site.data.fhir.path}}) specification that is mandated for use in the U.S. as well as the [CDS Hooks 2.0](https://cds-hooks.hl7.org/2.0) and [CDS Hooks CI Build](https://cds-hooks.org/specification/current/) releases of the CDS hooks specification.  It also leverages the [SMART on FHIR](http://hl7.org/fhir/smart-app-launch) specification for CRD clients that opt to use that approach for "what-if" scenarios.

In addition, this guide also relies on a number of parent implementation guides:

{% include dependency-table-short.xhtml %}

This implementation guide defines additional constraints and usage expectations above and beyond the information found in these base specifications.

### Intellectual Property Considerations
This implementation guide and the underlying FHIR specification are licensed as public domain under the [FHIR license](http://hl7.org/fhir/R4/license.html#license). The license page also describes rules for the use of the FHIR name and logo.

{% include ip-statements.xhtml %}

