### Da Vinci
Da Vinci is an HL7-sponsored project that brings together the U.S. payer, providers, and technology suppliers (including EHR vendors)  to help payers and providers to positively impact clinical, quality, cost, and care management outcomes using FHIR-related technologies. The project organizes meetings (face-to-face and conference calls), as well as connectathons, to find ways to leverage FHIR technologies to support and integrate value-based care (VBC) data exchange across communities. Da Vinci identifies value-based care use cases of interest to its members and to the broader community.

The process that Da Vinci has adopted includes:
1. identify business, clinical, technical, and testing requirements,
2. develop and ballot a FHIR based implementation guide (IG),
3. develop a reference implementation (RI) that is used to demonstrate that the concepts in the IG are possible to implement,
4. pilot the standard
5. support the production use of the IG to enable exchange of data to support interoperability for value-based care.

Additional information about Da Vinci, its members, the use cases, and the implementation guides being developed can all be found on the [HL7 website](http://www.hl7.org/about/davinci). Meeting minutes and other materials can be found on the [Da Vinci Confluence page](https://confluence.hl7.org/display/DVP).

{% include burdenReduction.md %}


### Systems
The CRD implementation guide defines the responsibilities of the two types of systems involved in a CRD solution:

**CRD Clients** are typically systems that healthcare providers use at the point of care including electronic medical records systems, pharmacy systems and other provider and administrative systems used for ordering, documenting, and executing patient-related services.  Users of these systems have a need for coverage requirements information to support care planning.

**CRD Services** (or servers) are systems that act on behalf of payer organizations to share information with healthcare providers about rules and requirements related to healthcare products and services covered by a patient's payer.  A CRD Service will provide coverage information related to one or possibly more insurance plans.

<div markdown="1" class="new-content">

### Users
The 'CDS' in 'CDS Hooks' stands for 'Clinical Decision Support'. However, the mechanism actually supports a variety of types of decision support and the responsible HL7 work group has confirmed that conveying guidance that isn't strictly clinical, and providing guidance to non-clinical users (receptionists, back-end schedulers, etc.) is appropriate. Because all decision support provided by a CRD service is fully automated, there will be no human intervention on the payer side. If an automated system doesn't have enough information to provide guidance without human input, then no guidance will be provided.

</div>

### Underlying technologies

This guide is based on the [HL7 FHIR]({{site.data.fhir.path}}index.html) standard, as well as the [CDS Hooks](https://cds-hooks.hl7.org) and [SMART on FHIR](http://hl7.org/fhir/smart-app-launch/index.html) specifications, which build additional capabilities on top of FHIR.  This architecture is intended to maximize the number of provider systems that conform to this guide as well as to allow for easy growth and extensibility of system capabilities in the future.

Implementers of this specification therefore need to understand some basic information about these specifications.


#### FHIR

This implementation guide uses terminology, notations and design principles that are specific to FHIR.  Before reading this implementation guide, it's important to be familiar with some of the basic principles of FHIR as well as general guidance on how to read FHIR specifications.  Readers who are unfamiliar with FHIR are encouraged to read (or at least skim) the following prior to reading the rest of this implementation guide.

* [FHIR overview]({{site.data.fhir.path}}overview.html)
* [Developer's introduction]({{site.data.fhir.path}}overview-dev.html) (or [Clinical introduction]({{site.data.fhir.path}}overview-clinical.html))
* [FHIR data types]({{site.data.fhir.path}}datatypes.html)
* [Using codes]({{site.data.fhir.path}}terminologies.html)
* [References between resources]({{site.data.fhir.path}}references.html)
* [How to read resource & profile definitions]({{site.data.fhir.path}}formats.html)
* [Base resource]({{site.data.fhir.path}}resource.html)

This implementation guide supports the [R4]({{site.data.fhir.path}}index.html) version of the FHIR standard and builds on the [US Core Implementation Guide]({{site.data.fhir.ver.uscore}}) and implementers need to familiarize themselves with the profiles in that guide.  It also draws on content from the [Davinci Health Record Exchange (HRex)]({{site.data.fhir.ver.hrex}}) and [Structured Data Capture (SDC)]({{site.data.fhir.ver.sdc}}) implementation guides.

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
    </td>
</table>

#### CDS Hooks
Provider systems will use the specification and workflows defined by [CDS Hooks](https://cds-hooks.hl7.org) to initiate Coverage Requirements Discovery with the payers. Implementers must be familiar with all aspects of this specification.

#### SMART on FHIR
SMART on FHIR is expected to be used in two principal ways:

##### Ad-hoc Coverage Requirements Discovery
CDS Hooks provides a mechanism for payers to advise clinicians on coverage requirements as part of their regular workflow - when ordering medications, making referrals, scheduling appointments, discharging patients, etc.  However, sometimes clinicians may be interested in learning about coverage requirements without going through the workflow steps within their EMR.  I.e. they don't want to actually create a referral, they just want to ask the question "what would the requirements be if I *wanted* to create a referral?

Discussion of how a SMART on FHIR app can be used to trigger CDS Hooks from within an EMR to perform such what-if scenarios is [here](hooks.html#smart-on-fhir-hook-invocation).  EMRs can use the general open-source SMART app.  Payers might also choose to develop their own using the open-source SMART app as a base to inform their own development.  This might be an appropriate option if there's a need for additional elements to be included in certain resources to determine full coverage requirements.

##### Hook actions
When a server responds to a CDS hook, one of the possible actions is to allow the user to [invoke a SMART App](https://cds-hooks.hl7.org/2.0/#link).  Support for this option by payer systems is optional.  Doing so allows the payer to provide a custom user interface to complete forms, navigate through decision support, review subsets of EHR and/or payer data, etc.  The Da Vinci [Documentation Templates and Rules](http://www.hl7.org/fhir/us/davinci-dtr) implementation guide provides additional guidance and expectations on the use of CDS Hook cards to launch SMART Apps and how payer-provided SMART Apps should function.

### Architectural approach
The approach taken to meet the requirements of the Coverage Requirements Discovery use-case was selected after evaluating the various interoperability choices provided by FHIR.  Specifically, the project team evaluated the possible architectural approaches as described in the HRex specification's [Approaches to Exchanging FHIR Data]({{site.data.fhir.ver.hrex}}/exchanging.html) guide.  The following bullets describe the path choices driven by use-case requirements:

* *Direct Connection* - Yes, it was presumed that EHR systems could connect directly either with the payer or with a payer-provided service
* *Consumer initiates?* - Yes - the provider system needing decision support would trigger the support, because only the provider system would know when support was needed.
* *Human intervention?* - No - there was no expectation that a human would need to be involved on the data source (payer) side to determine what guidance should be provided back.  The requirement was for real-time guidance, which meant any guidance provided had to be automatic.
* *Is data pre-existing?* - No - in decision support, we're generating context-specific guidance that didn't previously exist, even if some of the resources pointed to might have been pre-existing
* *CDS-hooks?* - Yes - CDS hooks was a good fit for the workflow we needed.  There was no need to define custom operations or messages to meet our use-cases

<div markdown="1" class="new-content">

NOTE: Because of the sensitivity around disclosure of clinical information to payer-controlled systems during the clinical workflow process, this IG imposes a number of safeguards around the use of the selected CDS Hooks technology to help ensure that providers and their systems have an appropriate degree of control over disclosure and that information can't be used in inappropriate ways.

#### Impact on payer processes

Information passed to the CRD service will typically contain clinical terminologies, might not contain billing terminologies, and will certainly not include billing modifier codes or similar information typically included in prior authorization requests.  CRD services will need to support these clinical terminologies or map them to internally used billing terminologies when determining decision support results - such as whether a therapy is covered or requires prior authorization.  In some cases, mappings may not be fully deterministic and may impact the ability respond with useful decision support.  Services will also need to consider that the mapping they perform between clinical terminologies and billing codes may be different than the bill coding process performed by the client system when claims are eventually submitted.  This may mean that assertions about coverage or prior authorization requirements will need to be expressed conditionally.  E.g. "Provided this service is billed as X, Y or Z, then prior authorization is not needed".

It is more efficient if mappings can be shared across payers and providers.  This implementation guide encourages industry participants to cooperate on the development of shared mappings and/or to work with terminology developers (e.g. AMA for CPT codes) to develop shared mappings as part of their code maintenance process.

</div>