Each CDS Hook corresponds to a point in the workflow/business process within a CRD Client system where a specific type of decision support is relevant.  For example, the `order-select` hook **SHOULD** be fired whenever a user of a CRD Client creates a new order or referral.  In many CRD Clients, the same hook might fire in multiple different workflows.  (For example, a CRD client might have different screens for ordering regular medications vs. vaccinations vs. chemotherapy, not to mention distinct screens for lab orders, imaging orders and referrals.  An order-select hook might be initiated from any or all of these screens/workflows.)

Within this implementation guide, CDS Hooks are used by CRD Clients to perform coverage requirements discovery from CRD Servers used by patients' payers.  Six hooks are identified that cover the main situations where coverage requirements discovery is likely to be needed: [appointment-book](#appointment-book), [encounter-start](#encounter-start), [encounter-discharge](#encounter-discharge), [order-dispatch](#order-dispatch), [order-select](#order-select), and [order-sign](#order-sign).  Payers and respective CRD Servers will vary between patients.  CRD Clients conforming to this implementation guide **SHALL** be able to determine the correct payer CRD Service to use for each request.

<p class="modified-content" markdown="1"><a name="FHIR-49974"> </a>
Not all CRD Clients will support all hook types or order resource types.  For example, community CRD client systems will not likely support `encounter-discharge`.  Community pharmacy systems would not likely support `appointment-book`.  Some EHRs might not support VisionPrescription when using order-sign.  CRD Clients conforming to this implementation guide **SHALL** support at least one of the hooks and (for order-centric hooks), at least one of the order resource types listed below, and **SHOULD** support all that apply to the context of their system.  Future releases of this specification may increase expectations to support additional hooks.  For systems that support ordering products or services covered by one of the CRD-supported request types, such clients **SHALL** support the order-sign hook for the order types they support.</p>

Similarly, not all payers will necessarily provide coverage that is relevant to all hook types or order resource types.  For example, a payer that only provides drug coverage would be unlikely to have coverage information to return for an `encounter-discharge` event or a VisionPrescription order.  CRD Servers conforming to this implementation guide **SHALL** provide a service for all hooks and order resource types required of CRD clients by this implementation guide unless the server has determined that the hook will not be reasonably useful in determining coverage or documentation expectations for the types of coverage provided.

CRD Clients and CRD Servers **MAY** choose to support additional hooks available in the registry on the [CDS Hooks continuous integration build](https://cds-hooks.org) or custom hooks defined elsewhere.  In these cases, systems **SHOULD** adhere to the conformance expectations defined in this specification for any hooks listed here.

In the absence of guidance from the CDS Hooks specification, CRD Servers are expected to conform to the following rules when responding to requests from a CRD Client:

<div class="modified-content" markdown="1"><a name="FHIR-52062"> </a>
* If the CRD Server encounters an error when processing the request, the system **SHALL** return an appropriate error HTTP Response Code, starting with the digit "4" or "5", indicating that there was an error.
* <span ><a name="FHIR-52535"> </a>If an issue is identified at a layer of the CRD Server that is FHIR aware (e.g. not a "wrong endpoint" or "not authorized" issue), the server **SHALL** provide an OperationOutcome for internal issue tracking by the client system.
* The CRD Client **MAY** display to the user that the Coverage Requirements Discovery Service is unavailable.  If additional information (e.g. number to call) is available, it **MAY** also be included in the message to the user.
* While any 4xx or 5xx response code could be raised, the CRD Server **SHALL** use the 400 and 422 codes in a manner consistent with the FHIR RESTful Create Action, specifically:
    * 400 - Bad Request - The request is not parsable as JSON or the content fails validation against FHIR core or CDS Hooks specification rules.  Also used if a CRD service receives a call where the primary Coverage (either provided by prefetch or queried by the payer) does not have a payer.identifier that identifies a payer that is handled by that CRD service endpoint, the server SHALL return a 400 error and SHOULD provide an OperationOutcome.  This includes situations where no Coverage is accessible, multiple Coverages are accessible, or the provided Coverage does not have a payer.identifier at all.
    * 422 - Unprocessable Entity - The request is valid JSON and meets FHIR and CDS Hook validation rules, but fails to adhere to constraints imposed by this specification.
* If a system's validation process does not differentiate between validation issues stemming from the JSON syntax validation, FHIR core validation, CDS Hooks validation, and CRD-specific validation, it **MAY** treat all validation rules as 400 errors.
* A CRD client MAY opt to re-invoke a CRD hook either due to manual user intervention or automatically in the background if there is a reason to believe that a substantive change in the patient's record and/or coverage might produce a different CRD response.  If such workflows are invoked without first calling an X12 271, there should be business processes in place to ensure that CRD is invoked with the correct/current patient coverage.
</div>
    
<p class="new-content">A profile defining the general expectations of a CRD CDS Hooks request can be found <a href="StructureDefinition-CRDHooksRequest.html">here</a>.</p>


### Hook Categories
The hooks supported by this guide can be categorized into two types: 'primary' hooks and 'supporting' hooks.

The 'primary' hooks are [Appointment Book](#appointment-book), [Orders Sign](#order-sign), and [Order Dispatch](#order-dispatch).  CRD Servers **SHALL**, at minimum, return a [Coverage Information](StructureDefinition-ext-coverage-information.html) system action for these hooks, even if the response indicates that further information is needed or that the level of detail provided is insufficient to determine coverage.

The 'secondary' hooks are [Orders Select](#order-select), [Encounter Start](#encounter-start), and [Encounter Discharge](#encounter-discharge).  These hooks **MAY** return cards or system actions, but are not expected to, and CRD clients are free to ignore any cards or actions returned.  (CRD clients **SHOULD** use the [configuration options](deviations.html#new-hook-configuration-mechanism) to instruct CRD servers to not even try to return cards if they do not intend to display/process them.)  If Coverage Information is returned for these hooks, it **SHALL NOT** include messages indicating a need for [clinical](ValueSet-AdditionalDocumentation.html) or [administrative](ValueSet-AdditionalDocumentation.html) information, as such information is expected to be made available later in the process and therefore such guidance is not useful.

The following sections describe the hooks covered by this implementation guide as well as any constraints, profiles, and resources expected to be supported by conformant implementations.

The hooks listed on the CDS hooks website are subject to update by the community at any time until they go through the ballot process.  However, all substantive changes are noted in the *Change Log* section at the bottom of the page describing each hook.  For each hook listed below, this specification identifies a specific version.  For the sake of interoperability, implementers are expected to adhere to the interface defined in the specified version of each hook, though compatible changes from future versions can also be supported.  CRD Servers **SHALL** handle unrecognized context elements by ignoring them.

Below is a summary diagram that outlines all the hooks, indicating when responses are mandatory or optional, and provides insights into what contributes to caching and attribution.

<p class="modified-content" markdown="1"><a name="FHIR-52537"> </a>Note: As a side effect, CRD calls can be used by a payer to 'attribute' a patient to an organization, which may allow the clinical organization to query patient clinical data via [Payer Data Exchange (PDex)] or other mechanisms to be considered as part of patient care delivery.  The diagram below identifies two hooks as particularly appropriate to this use.  Any hook can theoretically be used to assert a relationship from a member attribution perspective.   The two hooks highlighted are the most appropriate ones as they could theoretically allow information to flow from the payer as part of the 'current' care delivery.  Hooks later in the workflow would typically be too late to allow data to flow in a way that would allow that information to be taken into account in the current care event.</p>

{::options parse_block_html="false" /}
<figure>
  <img height="800px" src="hooks.png" alt="Hooks Diagram"/>
  <figcaption><b>    Figure 2: Hooks Summary Diagram</b></figcaption>
  <p></p>
</figure>
{::options parse_block_html="true" /}

### appointment-book
This hook is described in the CDS Hooks specification [here]({{site.data.fhir.ver.hooks}}/appointment-book.html).  This version of the CRD implementation guide refers to version 1.0 of the hook.

This hook would be triggered when the user of a CRD Client books a future appointment for a patient with themselves, with someone else within their organization, or with another organization.  Note that whether the CRD Client will create an appointment (triggering the `appointment-book` hook) or a ServiceRequest (triggering an `order-select` or `order-sign` hook) can vary depending on the service being booked and the organizations involved.

Potentially relevant CRD advice related to this hook might include:

* Requirements related to the intended location and/or participants (e.g. warnings about out-of-network)

* Requirements related to the service being booked (e.g. Is prior authorization needed? Is the service covered? Is the indication appropriate? Is special documentation required?)

* Requirements related to the timing of the service (e.g. is the coverage still expected to be in effect? is the service too soon since the last service of that type?)

* Reminders about additional services that are recommended to be scheduled or booked for the same patient - either as part of the scheduled encounter or as part of additional appointments that could be created at the same time

While this hook supports userIds of Patient and RelatedPerson, for CRD purposes it is enough to support Practitioner and PractitionerRole.  Support for Patient and RelatedPerson as users is optional.  (Note that Practitioner and PractitionerRole include both licensed healthcare professionals as well as administrative staff.)

The profiles expected to be used for the resources resolved to by the userId, patientId and encounterId and in the `appointments` context elements are as follows:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>HRex &amp; US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td><a href="StructureDefinition-profile-appointment-with-order.html">profile-appointment-with-order</a> or <a href="StructureDefinition-profile-appointment-no-order.html">profile-appointment-no-order</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-encounter.html">profile-encounter</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-patient.html">profile-patient</a></td>
    <td/>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.uscore7}}/StructureDefinition-us-core-practitioner.html">US Core practitioner</a></td>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.hrex}}/StructureDefinition-hrex-practitionerrole.html">hrex-practitionerrole</a></td>
  </tr>
</table>

Notes: 
* CRD Servers **MAY** use this hook as a basis for associating a patient with a particular practitioner from a payer attribution perspective.
* CRD clients and servers **SHALL**, at minimum, support returning and processing the [Coverage Information](StructureDefinition-ext-coverage-information.html) system action for all invocations of this hook.

### encounter-start
This hook is described in the CDS Hooks specification [here]({{site.data.fhir.ver.hooks}}/encounter-start.html).  This version of the CRD implementation guide refers to version 1.0 of the hook.

This hook would be triggered when a patient is admitted, a patient arrives for an out-patient visit, and/or when a provider first engages with a patient during an encounter.  The `encounter-start` hook serves a similar purpose to the [appointment-book](#appointment-book) hook, though it provides less lead time to react to recommendations. If the purpose of the appointment is to perform a service that requires a 2-week prior authorization process, it is more efficient to identify prior-authorization requirements proactively through the use of the appointment-book hook to prevent the patient from showing up for an appointment that will need to be canceled and rescheduled.  

The advice returned for this hook would include the same sorts of advice as provided for using [appointment-book](#appointment-book).  However, the hook is still necessary because not all encounters will be the result of appointments, not all systems that schedule appointments will necessarily have checked for coverage requirements, and the patient's circumstances and/or coverage as well as the payer's guidelines could have evolved since the appointment was scheduled.

Note that Practitioner and PractitionerRole include both licensed healthcare professionals, as well as administrative staff.

The profiles expected to be used for the resources resolved to by the userId, patientId, and encounterId context references are as follows:


<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>HRex &amp; US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td><a href="StructureDefinition-profile-encounter.html">profile-encounter</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-patient.html">profile-patient</a></td>
    <td/>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.uscore7}}/StructureDefinition-us-core-practitioner.html">US Core practitioner</a></td>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.hrex}}/StructureDefinition-hrex-practitionerrole.html">hrex-practitionerrole</a></td>
  </tr>
</table>

Notes: 
* CRD Servers **MAY** use this hook as a basis for associating a patient with a particular practitioner from a payer attribution perspective.

### encounter-discharge
This hook is described in the CDS Hooks specification [here]({{site.data.fhir.ver.hooks}}/encounter-discharge.html).  This version of the CRD implementation guide refers to version 1.0 of the hook.

This hook would generally be specific to an in-patient encounter and would be fired when a provider is performing the discharge process within the CRD Client.

Potentially relevant CRD advice related to this hook might include:

* Verifying that documentation requirements for the services performed have been met to ensure the services provided can be reimbursed

* Ensuring that required follow-up planning is complete and appropriate transfer of care has been arranged, particularly for accountable care models

The profiles expected to be used for the resources resolved to by the userId, patientId, and encounterId context references are as follows:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>HRex &amp; US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td><a href="StructureDefinition-profile-encounter.html">profile-encounter</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-patient.html">profile-patient</a></td>
    <td/>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.uscore7}}/StructureDefinition-us-core-practitioner.html">US Core practitioner</a></td>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.hrex}}/StructureDefinition-hrex-practitionerrole.html">hrex-practitionerrole</a></td>
  </tr>
</table>

### order-dispatch
This hook is described in the CDS Hooks specification [here]({{site.data.fhir.ver.hooks}}/order-dispatch.html).  This version of the CRD implementation guide refers to version 1.0 of the hook.

This is a new hook that allows for decision support to be provided when the intended performer of a service is not chosen when the order is written, but instead at some later time-point, quite frequently by someone other than the practitioner who wrote the order.  Because knowing 'who' will perform the service is often relevant when determining coverage and prior authorization requirements, and because it is also a useful point for providing guidance such as suggesting alternative "in-network" providers, this is a useful point in client workflow to provide decision support.

This hook will fire at some point after (possibly well after) the [order-sign](#order-sign) hook fires.  It only passes the patient id, order id, performer, and (optionally) the Task that describes the fulfillment request as part of the context.  This specification does not require use of the Task resource.

This hook allows multiple resource types to be present. Resources provided could all be the same type or be a mixture of types.  Coverage requirements **SHOULD** be limited only to those resources that are included in the `dispatchedOrders` context, though the content of other resources **SHOULD** also be considered before making recommendations about what additional actions are necessary.  (I.e. don't recommend an action if there's already an order to perform that action.)  

The different relevant resource types are as follows (support can vary between clients):

<a name="FHIR-52582"> </a>
* **CommunicationRequest**: Used when a provider requests that another provider transfer patient records or other supporting information to another organization or agency.
* **DeviceRequest**: Used for durable medical equipment orders, such as wheelchairs, prosthetics, diabetic supplies, etc.  It can also be used to order glasses and other vision-correction devices.
* **MedicationRequest**: Used to order inpatient and outpatient medications.<sup>*</sup>  Can also be used to order vaccinations.
* **ServiceRequest**: Used to order a referral, lab tests, diagnostic imaging, and sometimes to schedule a future appointment (also see [appointment-book](#appointment-book)).
* **NutritionOrder**: Used to order the preparation of specific meal types.  Generally used for in-patient care, but potentially also relevant for homecare.

<div class="new-content"><a name="FHIR-49805a"> </a>
* ** **Vision Prescription**: Used to order eyeglasses, contacts, and similar vision-related prosthetics.
</div>

<sup>*</sup> - Note: in the medication space, regulations may mandate alternate standards for some of the functionality covered by CRD for certain classes of medications.  E.g. NCPDP Script


CRD responses might include:

* Information about preauthorization and clinical documentation requirements, including forms to be completed

* Alternative performers (e.g. in-network providers)


There are no constraints or special rules related to this hook beyond the profiles expected to be used for the resources resolved to by the `patientId` or `encounterId` or in the `dispatchedOrders` context element:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>HRex &amp; US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td><a href="StructureDefinition-profile-devicerequest.html">profile-devicerequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-encounter.html">profile-encounter</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-medicationrequest.html">profile-medicationrequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-nutritionorder.html">profile-nutritionorder</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-patient.html">profile-patient</a></td>
    <td/>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.uscore7}}/StructureDefinition-us-core-practitioner.html">US Core practitioner</a></td>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.hrex}}/StructureDefinition-hrex-practitionerrole.html">hrex-practitionerrole<sup>†</sup></a></td>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-servicerequest.html">profile-servicerequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-task-dispatch.html">profile-task-dispatch</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-visionprescription.html">profile-visionprescription</a></td>
    <td/>
  </tr>
</table>

<sup>†</sup> While this hook does not explicitly list PractitionerRole as an expected resource type for userId, it is not prohibited and is included to allow linking the user to a Practitioner in a specific role acting on behalf of a specific Organization.



Notes: 
* CRD Servers **MAY** use this hook as a basis for associating a patient with a particular practitioner from a payer attribution perspective.
* CRD clients and servers **SHALL**, at minimum, support returning and processing the [Coverage Information](StructureDefinition-ext-coverage-information.html) system action for all invocations of this hook.


### order-select
This hook is described in the CDS Hooks specification [here]({{site.data.fhir.ver.hooks}}order-select.html).  This version of the CRD implementation guide refers to version 1.0 of the hook.

Support for this hook is optional, as not all information will necessarily be available when this hook is invoked.  Therefore, the [Order Sign](#order-sign) and [Order Dispatch](#order-dispatch) hooks are more critical to implement because they fire when information is required to be more complete and also represent the 'end' of the user engagement in their respective processes.  That said, the "Order Select" hook is still quite useful.

First, because it fires earlier in the user's system interactions, it provides an opportunity for CRD services to initiate back-end queries that might take time to complete so that relevant information is already retrieved and cached before Order Sign is reached.  This increases performance and makes it easier for CRD services to respond in the required timeframe.

Second, when a CRD service can provide guidance to providers earlier in the process (e.g. upon selection of a service but before entering detailed instructions), it can help to make the provider's experience more efficient.  (If a provider knows up-front that a service won't be paid for, but an alternative would be, they might be happier if they can save the time on entering full details before finding this out.)  Not all providers or EHRs will necessarily want to receive 'proactive' decision support during the order entry process.  EHRs can be configured as to what types of cards they're interested in receiving back for this hook, including no cards at all if the hook is invoked solely for performance or caching reasons.

This hook allows multiple resource types to be present. Resources provided could all be the same type or be a mixture of types.  Coverage requirements **SHOULD** be limited only to those resources that are included in the `selections` context, though the content of other resources **SHOULD** also be considered before making recommendations about what additional actions are necessary.  (I.e. don't recommend an action if there's already a draft order to perform that action.)  

The different relevant resource types are as follows (support can vary between clients):

**CommunicationRequest**: Used when a provider requests that another provider transfer patient records or other supporting information to another organization or agency.

**DeviceRequest**: Used for durable medical equipment orders, such as wheelchairs, prosthetics, diabetic supplies, etc.  It can also be used to order glasses and other vision-correction devices.

**MedicationRequest**: Used to order inpatient and outpatient medications.<sup>*</sup>  Can also be used to order vaccinations.

**ServiceRequest**: Used to order a referral, lab tests, diagnostic imaging, and sometimes to schedule a future appointment (also see [appointment-book](#appointment-book)).

**NutritionOrder**: Used to order the preparation of specific meal types.  Generally used for in-patient care, but potentially also relevant for homecare.
<a name="FHIR-49805b"> </a>
<p class="new-content"><b>Vision Prescription</b>: Used to order eyeglasses, contacts, and similar vision-related prosthetics.</p>

<sup>*</sup> - Note: in the medication space, regulations may mandate alternate standards for some of the functionality covered by CRD for certain classes of medications.  E.g. NCPDP Script


CRD responses might include:

* Information about preauthorization and clinical documentation requirements, including forms to be completed

* Alternative therapies that are covered or required first-line therapies

* Potential drug-drug interactions based on existing payer knowledge

* Recommendations about in-network vs. out-of-network providers for referrals


There are no constraints or special rules related to this hook beyond the profiles expected to be used for the resources resolved to by the `patientId` or `encounterId` or in the `draftOrders` context element:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>HRex &amp; US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td><a href="StructureDefinition-profile-devicerequest.html">profile-devicerequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-encounter.html">profile-encounter</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-medicationrequest.html">profile-medicationrequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-nutritionorder.html">profile-nutritionorder</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-patient.html">profile-patient</a></td>
    <td/>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.uscore7}}/StructureDefinition-us-core-practitioner.html">US Core practitioner</a></td>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.hrex}}/StructureDefinition-hrex-practitionerrole.html">hrex-practitionerrole<sup>†</sup></a></td>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-servicerequest.html">profile-servicerequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-visionprescription.html">profile-visionprescription</a></td>
    <td/>
  </tr>
</table>

<sup>†</sup> While this hook does not explicitly list PractitionerRole as an expected resource type for userId, it is not prohibited and is included to allow linking the user to a Practitioner in a specific role acting on behalf of a specific Organization.

Notes: 
* While this hook is defined for use when ordering, it is still relevant when proposing (e.g. as part of a consult note) or planning (e.g. as part of a care plan) the use of an intervention.  All the 'Request' resources support differentiation between plans, proposals, and orders.  Where CRD Clients have an appropriate workflow and data capture mechanism, this hook **MAY** be used in scenarios that don't involve creating a true order.


### order-sign
This hook is described in the CDS Hooks specification [here](https://cds-hooks.org/hooks/order-sign/).  This version of the CRD implementation guide refers to version 1.1 of the hook which, at the time of publication, was not available as a snapshot.  Therefore, the preceding link refers to the CDS hooks current build.

This hook serves a very similar purpose to [order-select](#order-select).  The main difference is that all the listed draft orders are considered 'complete'.  That means that it's appropriate to provide warnings if there is insufficient information to determine coverage requirements.  Also, all `draftOrders` are appropriate to comment on when using order-sign as the `selections` field found in in order-select is not used in order-sign.

Use and profiles for [order-select](#order-select) also apply to `order-sign`.

Notes: 
* CRD Servers **MAY** use this hook as a basis for associating a patient with a particular practitioner from a payer attribution perspective.
* CRD clients and servers **SHALL**, at minimum, support returning and processing the [Coverage Information](StructureDefinition-ext-coverage-information.html) system action for all invocations of this hook.