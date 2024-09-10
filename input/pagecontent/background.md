### Da Vinci
Da Vinci is an HL7-sponsored project that brings together U.S. payers, providers, and technology suppliers (including CRD client vendors) to help payers and providers improve clinical, quality, cost, and care management outcomes using FHIR-related technologies. The project organizes meetings (face-to-face and conference calls) and connectathons to find ways to leverage FHIR technologies to support and integrate value-based care (VBC) data exchange across communities. Da Vinci identifies value-based care use cases of interest to its members and to the broader community.

The process that Da Vinci has adopted includes:
1. identifying business, clinical, technical, and testing requirements
2. developing and balloting a FHIR-based implementation guide (IG)
3. developing reference implementations (RIs) to demonstrate that the concepts in the IG are possible to implement
4. piloting the standard
5. supporting the production use of the IG to enable exchange of data to support interoperability for value-based care

Additional information about Da Vinci, its members, the use cases, and the implementation guides being developed can all be found on the [HL7 website](http://www.hl7.org/about/davinci). Meeting minutes and other materials can be found on the [Da Vinci Confluence page](https://confluence.hl7.org/display/DVP).

{% include burdenReduction.md %}

### Systems
The CRD implementation guide defines the responsibilities of the two types of systems involved in a CRD solution:

**CRD clients** are typically systems that healthcare providers use at the point of care including electronic medical records systems, pharmacy systems, and other provider and administrative systems used for ordering, documenting, and executing patient-related services. Users of these systems need coverage requirements information to support care planning.

**CRD servers** (or servers) are systems that act on behalf of payer organizations to share information with healthcare providers about rules and requirements related to healthcare products and services covered by a patient's health plan. A CRD server will provide coverage information related to one or more insurance plans. CRD servers are a type of CDS service as defined in the CDS Hooks Specification.

### Users
The 'CDS' in 'CDS Hooks' stands for 'Clinical Decision Support'. However, the mechanism actually supports a variety of types of decision support and the responsible HL7 work group has confirmed that conveying guidance that isn't strictly clinical, and providing guidance to non-clinical users (clerks, schedulers, etc.) is appropriate. Because all decision support provided by a CRD server is fully automated, there will be no human intervention on the payer side. If an automated system doesn't have enough information to provide guidance without human input, then no guidance will be provided.

### Underlying Technologies
This guide is based on the [HL7 FHIR]({{site.data.fhir.path}}index.html) standard, as well as the [CDS Hooks](https://cds-hooks.hl7.org) and [SMART on FHIR](http://hl7.org/fhir/smart-app-launch/index.html) specifications, which build additional capabilities on top of FHIR. This architecture is intended to maximize the number of provider systems that conform to this guide, as well as to allow for easy growth and extensibility of system capabilities in the future.

Implementers of this specification therefore need to understand some basic information about these referenced specifications.

#### FHIR

This implementation guide uses terminology, notations and design principles that are specific to FHIR. Before reading this implementation guide, it's important to be familiar with some of the basic principles of FHIR as well as general guidance on how to read FHIR specifications. Readers who are unfamiliar with FHIR are encouraged to read (or at least skim) the following prior to reading the rest of this implementation guide.

* [FHIR Overview]({{site.data.fhir.path}}overview.html)
* [Developer's Introduction]({{site.data.fhir.path}}overview-dev.html) (or [Clinical Introduction]({{site.data.fhir.path}}overview-clinical.html))
* [FHIR Data Types]({{site.data.fhir.path}}datatypes.html)
* [Using Codes]({{site.data.fhir.path}}terminologies.html)
* [References Between Resources]({{site.data.fhir.path}}references.html)
* [How to Read Resource & Profile Definitions]({{site.data.fhir.path}}formats.html)
* [Base Resource]({{site.data.fhir.path}}resource.html)

<div class="modified-content" markdown="1">
This implementation guide supports the [R4]({{site.data.fhir.path}}index.html) version of the FHIR standard and builds on the US Core [3.1 (USCDI v1)]({{site.data.fhir.ver.uscore3}}), [6.1 (USCDI v3)]({{site.data.fhir.ver.uscore6}}) and [7.0 (USCDI v4)]({{site.data.fhir.ver.uscore7}}) implementation guides and implementers need to familiarize themselves with the profiles in those guides. In most cases, the profiles in this IG conform with both releases of US Core. Where that is not possible (specifically in the case of Encounter), separate profiles have been created for use by CRD clients that support USCDI v1 vs. those that support USCDI v3. CRD clients **SHALL** support one of the two profiles (and versions of US Core). CRD servers **SHALL** be able to handle both.

This IG also draws on content from the [Davinci Health Record Exchange (HRex)]({{site.data.fhir.ver.hrex}}) and [Structured Data Capture (SDC)]({{site.data.fhir.ver.sdc}}) implementation guides.
</div>

Implementers should also familiarize themselves with the FHIR resources used within the guide:

<table>
    <td>
      <a href="{{site.data.fhir.path}}appointment.html">Appointment</a><br/>
      <a href="{{site.data.fhir.path}}claimresponse.html">ClaimResponse</a><br/>
      <a href="{{site.data.fhir.path}}coverage.html">Coverage</a><br/>
      <a href="{{site.data.fhir.path}}communicationrequest.html">CommunicationRequest</a><br/>
      <a href="{{site.data.fhir.path}}device.html">Device</a><br/>
      <a href="{{site.data.fhir.path}}devicerequest.html">DeviceRequest</a><br/>
      <a href="{{site.data.fhir.path}}encounter.html">Encounter</a><br/>
      <a href="{{site.data.fhir.path}}location.html">Location</a><br/>
      <a href="{{site.data.fhir.path}}organization.html">Organization</a><br/>
      <a href="{{site.data.fhir.path}}medication.html">Medication</a><br/>
      <a href="{{site.data.fhir.path}}medicationrequest.html">MedicationRequest</a><br/>
      <a href="{{site.data.fhir.path}}nutritionorder.html">NutritionOrder</a><br/>
      <a href="{{site.data.fhir.path}}patient.html">Patient</a><br/>
      <a href="{{site.data.fhir.path}}practitioner.html">Practitioner</a><br/>
      <a href="{{site.data.fhir.path}}practitionerrole.html">PractitionerRole</a><br/>
      <a href="{{site.data.fhir.path}}questionnaire.html">Questionnaire</a><br/>
      <a href="{{site.data.fhir.path}}servicerequest.html">ServiceRequest</a><br/>
      <a href="{{site.data.fhir.path}}task.html">Task</a><br/>
      <a href="{{site.data.fhir.path}}visionprescription.html">VisionPrescription</a>
    </td>
</table>

#### CDS Hooks
Provider systems will use the specification and workflows defined by [CDS Hooks 2.0](https://cds-hooks.hl7.org/2.0) to initiate Coverage Requirements Discovery with the payers. Implementers must be familiar with all aspects of this specification.

#### SMART on FHIR
SMART on FHIR is expected to be used in two principal ways:

##### *Ad Hoc* Coverage Requirements Discovery
CDS Hooks provides a mechanism for payers to advise clinicians on coverage requirements as part of their regular workflow: when ordering medications, making referrals, scheduling appointments, discharging patients, etc. However, sometimes clinicians may be interested in learning about coverage requirements without going through the workflow steps within their CRD client. In this case, they don't want to actually create a referral, they just want to ask the question "what would the requirements be if I *wanted* to create a referral?

Discussion of how a SMART on FHIR app can be used to trigger CDS Hooks from within an CRD client to perform such what-if scenarios can be found [here](foundation.html#smart-on-fhir-hook-invocation).

<div class="added-content" markdown="1">
##### Apps for Decision Support
Payers may recommend the launch of SMART apps that are relevant to the activity the user is performing. For example, an app might help guide order creation for specialized patient needs, help evaluate alternative therapies, determine whether complementary therapy is necessary/appropriate, etc. These might have clinical or administrative purposes. Recommendations for such apps would be returned by the [SMART app response ype](cards.html#launch-smart-application-response-type).
</div>

### Architectural Approach
The approach taken to meet the requirements of the CRD use-case was selected after evaluating the various interoperability choices provided by FHIR. Specifically, the project team evaluated the possible architectural approaches as described in the HRex specification's [Approaches to Exchanging FHIR Data]({{site.data.fhir.ver.hrex}}/exchanging.html) guide. The following bullets describe the path choices driven by use-case requirements:

* *Direct connection?* - Yes - it was presumed that CRD client systems could connect directly either with the payer or with a payer-provided service.
* *Consumer initiates?* - Yes - the provider system needing decision support would trigger the support, because only the provider system would know when support was needed.
* *Human intervention?* - No - there was no expectation that a human would need to be involved on the data source (payer) side to determine what guidance should be provided. The requirement was for real-time guidance, which meant any guidance provided had to be automatic.
* *Is data pre-existing?* - No - in decision support, we're generating context-specific guidance that didn't previously exist, even if some of the resources pointed to might have been pre-existing.
* *CDS Hooks?* - Yes - CDS Hooks were a good fit for the workflow we needed. There was no need to define custom operations or messages to meet our use cases.

NOTE: Because of the sensitivity around disclosure of clinical information to payer-controlled systems during the clinical workflow process, this IG imposes a number of safeguards around the use of the selected CDS Hooks technology to help ensure that providers and their systems have an appropriate degree of control over disclosure and that information can't be used in inappropriate ways.