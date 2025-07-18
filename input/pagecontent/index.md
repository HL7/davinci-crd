{% raw %}
{% endraw %}
<blockquote class="stu-note">
<p>
This STU update of the specification reflects several changes based on implementer feedback about the Coverage Requirements Discovery (hereafter,CRD) specification arising from detailed review, connectathons and implementation experience.  "STU notes" call out additional key considerations where feedback is desired.
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
Individuals interested in participating in the Coverage Requirements Discovery implementation guide project or other HL7 Da Vinci projects can find information about Da Vinci [here](http://www.hl7.org/about/davinci).
</p>
<p>
A summary of the major changes from the previous release can be found <a href="history.html">here</a>.
</p>
</blockquote>


### Overview
<a name="FHIR-48553"> </a>
<p class="modified-content">The process of billing a patient's insurance provider is complex and costly, particularly in the United States. Healthcare providers work with a range of payers who provide coverage for the products and clinical services provided to patients. Each payer offers distinct insurance plans for healthcare products and services, and each has its own unique process to determine whether each service is necessary and appropriate. These processes have many different requirements for documentation, prior authorization, or other approval steps. Claims submitted for payment that do not meet payer requirements will typically be denied which may result in service delay, resubmission, or appeal. These delays and additional processes may result in negative health outcomes or financial cost for patients, as well as financial and productivity losses for providers.</p>

This Coverage Requirements Discovery (CRD) implementation guide defines a workflow in which a payer makes coverage requirement information available to a healthcare provider within the provider's software system at the point of care where treatment decisions are made. This will help clinicians and administrative staff make informed recommendations to their patients and meet payer submission requirements. 

This implementation guide supports both Protected Health Information (PHI)-specific and non-PHI mechanisms for CRD to meet the needs and privileges of different payer organizations.  These mechanisms will allow payers to share a wide variety of information with providers in a context-sensitive manner including:

* updates to coverage information
* alternative (e.g. first-line, lower-cost, etc.) services or products
* documentation requirements and rules related to coverage
* forms and templates to complete
* indications of whether a therapy is covered and if prior authorization is required, including propagating this information into the relevant order/appointment

This implementation guide is designed to allow for initial support of basic capabilities and to subsequently build new features over time.

<a name="cmsdiscretion"> </a>
<blockquote class="stu-note" markdown="1">
The scope of this specification has increased to also support prior authorization process earlier in the workflow by allowing prior authorization to be returned during the CRD interaction.  Specifically:

On Feb 28, 2024, the Office of Burden Reduction and Health Informatics (OBRHI) National Standards Group (NSG) announced an [enforcement discretion](https://www.cms.gov/files/document/discretion-x12-278-enforcement-guidance-letter-remediated-2024-02-28.pdf) that they would not enforce the requirement to use the X12 278 for prior authorization if the covered entities were using the FHIR-based Prior Authorization API as described in the CMS Interoperability and Prior Authorization final rule (CMS-0057-F). This allows payers to return a prior authorization number for use in the X12 837 in coverage extension of the CRD and DTR IGs or as part of the all FHIR exchange of the Prior Authorization Response Bundle in the PAS IG.  For CRD, this specifically means that the satisfied-pa-id in the [Coverage Information extension](StructureDefinition-ext-coverage-information.html) can be used as an X12 prior authorization number.
</blockquote>

### Systems
This implementation guide sets expectations for two types of systems:

CRD clients are typically systems that healthcare providers use at the point of care, including electronic medical records systems, pharmacy systems, and other provider and administrative systems used for ordering, documenting, and executing patient-related services. Users of these systems need coverage requirements information to support care planning.

Examples of potential CRD clients include EHRs, EMRs, practice management systems, scheduling systems, patient registration systems, etc.  

The CRD client may actually involve multiple systems. For example, the systems that handle order entry may be different from what is used for appointment booking and different again from the system that exposes information over the FHIR interface. It is possible that a provider environment might use an intermediary to coordinate CRD client calls from multiple systems. Such an architecture is sufficient provided that:

* Calls are triggered from within the system the user is interacting with at the time the 'hook event' (entering an order, booking an appointment, etc.) occurs.
* Cards returned are displayed to the user, or in the event of system actions, user-notifications associated with the system actions are presented to the user within the same application.
* The 'access token' and FHIR endpoint exposed to the CRD service has access to all relevant data, independent of which physical data store it resides in.
* The intermediary could take on the responsibility for the FHIR interface, such as determining which payer should receive a coverage request.

There are three distinct sets of capabilities for CRD clients, one for [USCDI v1 (US-Core 3.1.1)](CapabilityStatement-crd-client3.1.html), one for [USCDI v3 (US-Core 6.1.0)](CapabilityStatement-crd-client6.1.html), and one for [USCDI v4 (US-Core 7.0.0)](CapabilityStatement-crd-client7.0.html).  Typically a client would support only one of these based on which US Core release it supports internally.  There is a single CRD server set of capabilities which must be able to handle data from any of the three supported USCDI versions.

<blockquote class="stu-note">
<p>
When CRD clients are made up of multiple systems, there will be orchestration requirements to allow each system to interact in a way that together they appear as a single monolithic system from the perspective of the CRD server. This IG provides some discussion of this on the ePA Coordinators page, though it does not yet provide any standardization about how components should interoperate to achieve the intended monolithic behavior. If there is industry interest, future releases of this IG may work to standardize some of these "intra-client" interactions.
</p>
</blockquote>

CRD servers (or servers) are systems that act on behalf of payer organizations to share information with healthcare providers about rules and requirements related to healthcare products and services covered by a patient's health plan. A CRD server will provide coverage information related to one or more insurance plans. CRD servers are a type of CDS service as defined in the CDS Hooks Specification.

There are is a single [set of capabilities for CRD servers](CapabilityStatement-crd-server.html) that spans USCDI v1 (US-Core 3.1.1) USCDI v3 (US-Core 6.1.0), and USCDI v4 (US-Core 7.0.0) expectations.  Payers will need to be handle content from any of the releases, as CRD clients will be transitioning support for the versions at different times - and in some cases may provide content that spans a mixture of versions.

### Content and Organization
This implementation guide (and the menu for it) is organized into the following sections:

* *Background* - Supporting informative pages that do not set conformance expectations
  * [Reading this IG](background.html) points to key pages in the FHIR spec and other source specifications that must be understood in order to understand this guide
  * [Use Cases](usecases.html) describes the intent of the implementation guide, gives examples of its use, and provides a high-level overview of expected process flow
  * [Project and Participants](credits.html) gives a high-level overview of Da Vinci and identifies the individuals and organizations involved in developing this implementation guide
  * [Burden Reduction](burden.html) identifies related specifications this implementation guide builds upon that developers should read and understand prior to implementing this specification
  * [ePA Coordinators](epa.html) acknowledges that neither the payer nor provider systems involved in CRD are monolithic and shows how the various components of provider and payer systems might interact with "ePA Coordinator" systems to satisfy the requirements of this IG
* *Specification* - Pages that set conformance expectations
  * [Conformance Expectations](conformance.html) defines base language and expectations for declaring conformance with the guide
  * [Privacy, Safety, and Security](security.html) covers considerations around data access, protection, and similar concepts that apply to all implementations
  * [Foundational Guidance](foundation.html) covers high-level conofmrance expectations  that apply to all implementations
  * [Deviations and Enhancements](deviations.html) covers detailed implementation requirements and conformance expectations that are independent of particular hooks or cards
  * [Supported Hooks](hooks.html) identifies the expectations for support for specific CDS hooks
  * [Hook Response Profiles](cards.html) defines patterns for CDS Hook cards and system actions that can be returned as part of this specification
  * [Implementation Guidance](implementation.html) provides recommendations for implementation that fall outside the technical scope of the specification
  * [CRD Metrics](metrics.html) provides a logical model describing how to capture data that may be relevant to measuring or reporting on CRD use
* *FHIR Artifacts*
  * [Artifacts Overview](allartifacts.html) introduces and provides links to the profiles, search parameters and other FHIR artifacts used in this implementation guide
  * Additional links point to complete lists of all artifacts defined in this guides as well as ancestor guides
* *Base Specifications* - Quick links to the various specifications this guide derives from
* *Support* - Links to help with use of this guide
  * *Discussion Forum* is a place to ask questions about the guide, discuss potential issues, and search through prior discussions
  * *Project Home* includes information about project calls, agendas, past minutes, and instructions for how to participate
  * *Implementer Support* provides information about reference implementations, resources for testing, known errata, regulatory considerations, and practical implementation pathways
  * *Project Dashboard* shows new and historical issues that have been logged against the specification, proposed dispositions, unapplied changes, etc.
  * *Propose a Change* allows formal submission of requests for change to the specification.  (Consider raising on the discussion forum first.)
  * [Downloads](downloads.html) allows download of this and other specifications, as well as other useful files

### Dependencies
This guide is based on the [FHIR R4]({{site.data.fhir.path}}) specification that is mandated for use in the U.S. as well as the [CDS Hooks 2.0](https://cds-hooks.hl7.org/2.0) and [CDS Hooks CI Build](https://cds-hooks.org/specification/current/) releases of the CDS Hooks specification.  It also leverages the [SMART on FHIR](http://hl7.org/fhir/smart-app-launch) specification for CRD clients that opt to use that approach for "what-if" scenarios.

In addition, this guide also relies on a number of parent implementation guides:

{% include dependency-table-nontech.xhtml %}

This implementation guide defines additional constraints and usage expectations above and beyond the information found in these base specifications.

### Intellectual Property Considerations
This implementation guide and the underlying FHIR specification are licensed as public domain under the [FHIR license](http://hl7.org/fhir/R4/license.html#license). The license page also describes rules for the use of the FHIR name and logo.

{% include ip-statements.xhtml %}
