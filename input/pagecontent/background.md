### Underlying Technologies
This guide is based on the [HL7 FHIR]({{site.data.fhir.path}}index.html) standard, as well as the [CDS Hooks]({{site.data.fhir.ver.cdshooks}}) and [SMART on FHIR](http://hl7.org/fhir/smart-app-launch/index.html) specifications, which build additional capabilities on top of FHIR. This architecture is intended to maximize the number of provider systems that conform to this guide, as well as to allow for easy growth and extensibility of system capabilities in the future.

Implementers of this specification therefore need to understand some basic information about these referenced specifications.

#### FHIR

This implementation guide uses terminology, notations and design principles that are specific to FHIR. Before reading this implementation guide, it is important to be familiar with some of the basic principles of FHIR as well as general guidance on how to read FHIR specifications. Readers who are unfamiliar with FHIR are encouraged to read (or at least skim) the following prior to reading the rest of this implementation guide.

* [FHIR Overview]({{site.data.fhir.path}}overview.html)
* [Developer's Introduction]({{site.data.fhir.path}}overview-dev.html) (or [Clinical Introduction]({{site.data.fhir.path}}overview-clinical.html))
* [FHIR Data Types]({{site.data.fhir.path}}datatypes.html)
* [Using Codes]({{site.data.fhir.path}}terminologies.html)
* [References Between Resources]({{site.data.fhir.path}}references.html)
* [How to Read Resource & Profile Definitions]({{site.data.fhir.path}}formats.html) and additional [IG reading guidance](https://build.fhir.org/ig/FHIR/ig-guidance/readingIgs.html)
* [Base Resource]({{site.data.fhir.path}}resource.html)

This implementation guide supports the [R4]({{site.data.fhir.path}}index.html) version of the FHIR standard and builds on the US Core [3.1 (USCDI v1)]({{site.data.fhir.ver.uscore3}}), [6.1 (USCDI v3)]({{site.data.fhir.ver.uscore6}}) and [7.0 (USCDI v4)]({{site.data.fhir.ver.uscore7}}) implementation guides and implementers need to familiarize themselves with the profiles in those guides. The profiles in this IG conform with all three releases of US Core.

This IG also draws on content from the [Davinci Health Record Exchange (HRex)]({{site.data.fhir.ver.hrex}}) and [Structured Data Capture (SDC)]({{site.data.fhir.ver.sdc}}) implementation guides.

Implementers should also familiarize themselves with the FHIR resources used within the guide:

<table vlass="grid">
  <thead>
    <tr>
      <th>Resource</th>
      <th>Relevance</th>
    </tr>
  </thead>
  <tbody>
    <tr><td><a href="http://hl7.org/fhir/r5/actordefinion.html">ActorDefinition</a></td><td>Used to help identify the entities that are subject to conformance expectations (pre-adopted from R5)</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}appointment.html">Appointment</a></td><td>One of the resources that can trigger payer decision support</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}binary.html">Binary</a></td><td>Used to represent example instances of CDS Hooks JSON structures</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}bundle.html">Bundle</a></td><td>Used when delivering collections of resources in a CDS Hooks call, also used for queries</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}capabilitystatement.html">CapabilityStatement</a></td><td>Used to define conformance expectations for this guide</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}codesystem.html">CodeSystem</a></td><td>Used to define custom codes specific to this guide</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}conceptmap.html">ConceptMap</a></td><td>Used to map location codes between terminologies</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}coverage.html">Coverage</a></td><td>Used to identify the member and the relevant insurance coverage to a payer</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}communicationrequest.html">CommunicationRequest</a></td><td>One of the resources that can trigger payer decision support</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}device.html">Device</a></td><td>Supporting information for device requests</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}devicerequest.html">DeviceRequest</a></td><td>One of the resources that can trigger payer decision support</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}encounter.html">Encounter</a></td><td>Oner of the resources that can trigger payer decision support, and also provides context for other resources</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}location.html">Location</a></td><td>Supporting information for encounters and request resources</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}organization.html">Organization</a></td><td>Used when identifying providers in Encounters, Tasks, and all requests</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}medication.html">Medication</a></td><td>Supporting information for medication requests</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}medicationrequest.html">MedicationRequest</a></td><td>One of the resources that can trigger payer decision support</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}nutritionorder.html">NutritionOrder</a></td><td>One of the resources that can trigger payer decision support</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}patient.html">Patient</a></td><td>Demographic information relevant to all requests</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}practitioner.html">Practitioner</a></td><td>Used when identifying providers in Encounters, Tasks, and all requests</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}practitionerrole.html">PractitionerRole</a></td><td>Used when identifying providers in Encounters, Tasks, and all requests</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}questionnaire.html">Questionnaire</a></td><td>Used to support the capture of additional information not covered by DTR</td></tr>
    <tr><td><a href="http://hl7.org/fhir/r5/requirements.html">Requirements</a></td><td>Provides a computable listing of the text-based conformance expectations of the guide (pre-adopted from R5)</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}servicerequest.html">ServiceRequest</a></td><td>One of the resources that can trigger payer decision support</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}structuredefinition.html">StructureDefinition</a></td><td>Used when profiling resources, defining extensions, and defining profiles and extensions on CDS Hooks models</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}task.html">Task</a></td><td>Used to manage dispatching orders to performing providers or locations</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}valueset.html">ValueSet</a></td><td>Used to define collections of codes used by CRD profiles</td></tr>
    <tr><td><a href="{{site.data.fhir.path}}visionprescription.html">VisionPrescription</a></td><td>One of the resources that can trigger payer decision support</td></tr>
  </tbody>
</table>

#### CDS Hooks
Provider systems will use the specification and workflows defined by [CDS Hooks 2.0]({{site.data.fhir.ver.cdshooks}}) to initiate Coverage Requirements Discovery with the payers. Implementers must be familiar with all aspects of this specification.

#### SMART on FHIR
SMART on FHIR is expected to be used in two principal ways:

##### *Ad Hoc* Coverage Requirements Discovery
CDS Hooks provides a mechanism for payers to advise clinicians on coverage requirements as part of their regular workflow: when ordering medications, making referrals, scheduling appointments, discharging patients, etc. However, sometimes clinicians may be interested in learning about coverage requirements without going through the workflow steps within their CRD client. In this case, they do not want to actually create a referral, they just want to ask the question "what would the requirements or recommendations be if I *wanted* to create a referral?

Such recommendations might be from decision support (such as ImmunizationRecommendation or a CarePlan with an intent of 'proposed') or from standard protocols (e.g. "this patient is due for a pap smear").  In such cases, the EHR can support automated generation of 'draft' requests (such as MedicationRequest or ServiceRequest) based on the decision support or protocol resources and use them when invoking CRD.  Alternatively, the EHR might support launching a SMART on FHIR app that would capture the key information needed to drive a CRD response.

Discussion of how a SMART on FHIR app can be used to trigger CDS Hooks from within an CRD client to perform such what-if scenarios can be found [here](foundation.html#what-if-hook-invocation).

##### Apps for Decision Support
Payers may recommend the launch of SMART apps that are relevant to the activity the user is performing. For example, an app might help guide order creation for specialized patient needs, help evaluate alternative therapies, determine whether complementary therapy is necessary/appropriate, etc. These might have clinical or administrative purposes. Recommendations for such apps would be returned by the [SMART app response type](cards.html#launch-smart-application-response-type).

### Architectural Approach
The approach taken to meet the requirements of the CRD use-case was selected after evaluating the various interoperability choices provided by FHIR. Specifically, the project team evaluated the possible architectural approaches as described in the HRex specification's [Approaches to Exchanging FHIR Data]({{site.data.fhir.ver.hrex}}/exchanging.html) guide. The following bullets describe the path choices driven by use-case requirements:

* *Direct connection?* - Yes - it was presumed that CRD client systems could connect directly either with the payer or with a payer-provided service.
* *Consumer initiates?* - Yes - the provider system needing decision support would trigger the support, because only the provider system would know when support was needed.
* *Human intervention?* - No - there was no expectation that a human would need to be involved on the data source (payer) side to determine what guidance should be provided. The requirement was for real-time guidance, which meant any guidance provided had to be automatic.
* *Is data pre-existing?* - No - in decision support, we are generating context-specific guidance that did not previously exist, even if some of the resources pointed to might have been pre-existing.
* *CDS Hooks?* - Yes - CDS Hooks were a good fit for the workflow we needed. There was no need to define custom operations or messages to meet our use cases.

NOTE: Because of the sensitivity around disclosure of clinical information to payer-controlled systems during the clinical workflow process, this IG imposes a number of safeguards around the use of the selected CDS Hooks technology to help ensure that providers and their systems have an appropriate degree of control over disclosure and that information cannot be used in inappropriate ways.