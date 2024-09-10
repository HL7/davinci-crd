This foundational page defines general context, considerations, and core requirements that apply to use of this implementation guide, regardless of which portions of the IG are implemented. It includes base conformance expectations, security and privacy rules, etc.

<!--
defines specific requirements for systems wishing to conform to this Coverage Requirements Discovery implementation guide. The bulk of the section focuses on the implementation of the [CDS Hooks Specification](https://cds-hooks.hl7.org/2.0) to meet CRD use cases. It also describes the use of [SMART on FHIR](http://hl7.org/fhir/smart-app-launch/index.html) and provides guidance on privacy, security, and other implementation requirements.
-->

The requirements and expectations described here are not intended to be exhaustive. The purpose of this implementation guide is to establish a baseline of expected behavior that communication partners can rely on and then build upon. Future versions of this specification will evolve based on implementer feedback. Therefore, CRD servers and CRD clients **MAY** mutually agree to support additional hooks, additional card patterns, additional resources, additional extensions, etc. not found in this specification. Although CRD servers and CRD clients are not required to support any capabilities defined beyond this specification, the intent is to support innovations that extend the specification in a manner that allows payers and providers to adopt those extensions in a mutually agreeable way.

### Context

#### Pre-reading
Before reading this formal specification, implementers are encouraged to first familiarize themselves with two other key portions of this implementation guide:

* The [Use Cases & Overview](usecases.html) page, which provides context for what this formal specification is trying to accomplish and will give a sense of both the business context and general process flow enabled by the formal specification below.

* The [Technical Background](background.html) page, which provides information about the underlying specifications and recommends portions that must be read and understood to have the necessary foundation to understand the constraints and usage guidance described here.

#### Conventions
This implementation guide uses specific terminology to flag statements that have relevance for the evaluation of conformance with the guide:

* **SHALL** indicates requirements that must be met to be conformant with the specification.

* **SHOULD** indicates behaviors that are strongly recommended and which could result in interoperability issues or sub-optimal behavior if not adhered to, but which do not - for this version of the specification - affect the determination of specification conformance.

* **MAY** indicates optional behaviors that implementers are free to consider but where there is no recommendation for or against adoption.

#### MustSupport
Profiles in this implementation guide make use of the [mustSupport]({{site.data.fhir.path}}profiling.html#mustsupport) element.

<div class="modified-content" markdown="1">
For data provided from CRD clients:

* If the CRD client maintains the data element and surfaces it to users, then it **SHALL** be exposed in their FHIR interface when the data exists and privacy constraints permit.

* CRD servers **SHALL** leverage mustSupport elements as available and appropriate to provide decision support.

For responses provided by CRD servers:

* CRD servers **SHALL** populate the element if an appropriate value exists. 

* CRD clients **SHALL** make the data available to the appropriate user (clinical or administrative) or leverage the data within their workflow as necessary to follow the intention of the provided decision support.
</div>

NOTE: These requirements are somewhat different from US Core and HRex because the implementation needs are different. In US Core, there is generally an expectation for clients to modify code and persistence layers to add support for 'mustSupport' elements in profiles. This expectation does not hold for CRD. However, CRD does require surfacing elements in the FHIR interface if the system maintains the element.

#### Profiles
This specification makes significant use of [FHIR profiles]({{site.data.fhir.path}}profiling.html), search parameter definitions, and terminology artifacts to describe the content to be shared as part of CDS Hook calls. The implementation guide supports FHIR [R4]({{site.data.fhir.path}}) with profiles listed for each type of hook.

The full set of profiles defined in this implementation guide can be found by following the links on the [Artifacts](allartifacts.html) page.

#### US Core
This implementation guide also leverages the [US Core 3.1]({{site.data.fhir.ver.uscore3}}), [US Core 6.1]({{site.data.fhir.ver.uscore6}}), and [US Core 7.0]({{site.data.fhir.ver.uscore7}}) set of profiles defined by HL7 for sharing non-veterinary EHR individual health data in the United States. Where US Core profiles exist, this guide either leverages them directly or uses them as a base for any additional constraints needed to support the coverage requirements discovery use case. Where no constraints are needed, this IG does not define additional profiles, as all US Core profiles are deemed to be part of this IG and available for use in CRD communications. For example, the US Core Observation and Condition profiles are likely to be of interest in at least some CRD scenarios and may be used by solutions conformant to this guide.

Where US Core profiles do not yet exist (e.g., for several of the 'Request' resources), profiles have been created that try to align with existing US Core profiles in terms of elements exposed and terminologies used.

Note that, in some cases, the US Core profiles require support for data elements that are not necessarily relevant to the CRD use case. The authors of this IG believe that leveraging existing standard interfaces will promote greater (and quicker) interoperability than would a more finely-tuned custom interface. CRD clients might still choose to restrict what information is exposed to CRD servers based on their internal data access and governance rules.

### Performance
Depending on their location within the workflow, CDS Hooks may be processed in a synchronous manner. This means that the user who is performing the business action that triggers the hook might be blocked from continuing the action until cards have been returned by the CDS service. For example, a CRD client might not allow progress of an 'order sign' business action until decision support has been returned from all order-sign services and the user has had a chance to interact with any cards they deem relevant. The corollary to this is that services must respond to hook invocations quickly to avoid impeding clinician workflow - and turning the intended benefit of CRD into a detriment.

This specification sets a target duration in which CRD services are expected to return their CDS Hooks response after being invoked. CRD services **SHALL** return responses for all supported hooks and **SHALL** respond within the required time 90% of the time. (That is, all [primary](hooks.html#hook-categories) hooks and any [supporting](hooks.html#hook-categories) hooks where they opt to support the hook.) For most hooks, this target time is 5 seconds. It extends to 10 seconds for [Appointment Book](hooks.html#appointment-book) and for [Order Dispatch](hooks.html#order-dispatch) and [Order Sign](hooks.html#order-sign) hooks that are sent at least 24 hours after the last hook invocation for the same order(s) because there is no opportunity to cache data in those cases.

The authors of this IG acknowledge that this may limit the payer from providing full responses to all calls where a response is theoretically possible. Systems should provide the best information they can in a timely fashion and rely on other layers of the payment and adjudication process to catch issues that require longer processing. For example, if a system is able to provide a response on eligibility within the time window, but not on whether prior authorization is needed, it can return cards indicating the service is covered, but that DTR is needed (to determine prior authorization requirements). Where a payer responds with a coverage information extension indicating doc-needed of 'clinical', 'admin', or 'patient' and the payer supports DTR, they **SHOULD** support gathering the additional information via DTR. This expectation is intended to change to **SHALL** in a future release.

<div class="new-content" markdown="1">
The expectation of CRD is that CRD services **SHALL** attempt to query all data necessary to make their coverage determination decisions if that data is available for query in the EHR, irrespective of whether the data is returned in prefetch. It is not acceptable for a service to rely exclusively on DTR as a mechanism to retrieve data. DTR is for data retrieval that requires human intervention or human review. There may be circumstances where time constraints prevent all needed data from being retrieved, in which case DTR retrieval of data that wouldn't typically need human review may be necessary. However, this should never be the design objective. Systems that do not attempt to retrieve needed data via CRD when possible are not conformant.
</div>

CRD services are encouraged to leverage hooks fired earlier in the workflow (even if they do not provide decision support in response to those hooks) as an opportunity to begin caching relevant information for use when providing responses to later hooks. For example, when an 'Encounter Start' hook fires, the CRD service can retrieve and cache the patient's current coverage information and details about their specific plans, limits, etc. When an 'Order Select' fires, the service can cache information about coverage and authorization rules associated with the ordered service. Potentially relevant information such as past labs, prior therapies, or relevant diagnoses can also be retrieved from the EHR. As a result, when an 'Order Sign' or 'Order Dispatch' hook fires, the CRD service should have almost all information needed to render an immediate decision, allowing response times to be met much more easily.

A determination that additional information is needed (e.g., via DTR) is considered to be a valid response. Where a payer responds with a coverage information doc-needed code of 'clinical', 'admin', or 'patient' and the payer supports DTR, they **SHOULD** support gathering the additional information via DTR. This expectation is intended to change to **SHALL** in a future release.

If a CRD service exceeds the allocated time window for a hook (i.e., for those circumstances that fall outside the 90% expectation), CRD clients **SHOULD** establish a time-out process that ensures users are not blocked from proceeding with their business flow. Where a CRD client opts to not block users from proceeding for responses that come back in a period of time shorter than the target time window in this guide (i.e., 5s or 10s), the client must ensure that users are made aware of the information when it is available. For responses that come back in a time period that exceeds this duration, CRD clients **MAY** ignore the resulting cards and/or system actions.

<blockquote class="stu-note">
<p>Payers and healthcare IT system vendors are both encouraged to provide feedback around whether this timing expectation strikes the appropriate balance between allowing appropriate decision support and allowing timely progress of workflow. This evaluation should consider what systems will need to be involved in the decision support process, what external calls might be needed, what caching strategies are viable, etc.
</p></blockquote>

### Accuracy
CDS services **SHALL** ensure that the guidance returned with respect to coverage and prior authorizations (e.g., assertions that a service is covered, or prior authorization is not necessary) is as accurate as guidance that would be provided by other means (e.g., portals, phone calls). Also, such guidance should allow for possible variances in coding and submission. (See [Impact on payer processes](implementation.html#impact-on-payer-processes) on the Implementation Considerations page.)

### Terminology
When invoking CDS Hooks, resources reflecting the clinical/business representation of the order, appointment, encounter, etc. will be transmitted to the CRD server. These data representations will generally make use of codes to describe the type of service or product being ordered, booked, or performed. These codes will draw from the code systems used at this stage of the business process and will typically be clinical codes rather than billing codes. That said, it is always possible to send multiple codings within a CodeableConcept. Where the selected code is not already a billing code and CRD clients are able to automatically determine what the corresponding billing code is, they **SHOULD** send a Coding with the billing code alongside the clinical code to reduce the risk of the receiving payer making a different translation.

### Appropriate use of hooks
CDS Hooks are intended to improve healthcare provider care-planning processes by allowing relevant and useful information to be inserted into provider workflows. At the same time, inserting additional information into a provider's workflow will add cognitive load, even if the information is not acted upon, and therefore must be done judiciously.

Payers and service providers **SHALL** ensure that CDS Hooks return only messages and information relevant and useful to the intended recipient.

<div class="new-content" markdown="1">
### CRD Servers
Payers may have multiple back-end functions that handle different types of decision support and/or different types of services. If a payer supports [endpoint discovery]({{site.data.fhir.ver.hrex}}/endpoint-discovery.html), they **SHALL** have at most a single endpoint for each coverage (e.g., Medicare, Medicaid, or commercial) they provide coverage under. In FHIR, a coverage instance essentially corresponds with the identification information on an insurance card, irrespective of the types of coverages available under that card. If a payer does not support endpoint discovery, they **SHALL** expose only one CRD endpoint capable of handling all coverages. All CRD requests for the patient coverage, irrespective of type of service, will be sent to a single endpoint. CRD servers are free to route the information from their endpoint(s) to back-end services as needed. This routing may evolve over time and should have no impact on CRD client calls.</div>

### Enabling a CRD Server
When a CRD client configures itself to support a payer's CRD service, it will need to identify which payer(s) the service supports. This is needed to ensure that the CRD client only sends CRD calls to services that the patient has current coverage for. The CRD service is responsible for any internal routing based on which processing organization handles the decisions. For this purpose, payer means the organization listed on the member's insurance card.

Provider and EHR vendor organizations **MAY** leverage the [payer registry](http://hl7.org/fhir/us/davinci-pdex-plan-net) developed by PDex (which will eventually fold into the [national directory under FAST](https://confluence.hl7.org/display/FAST/National+Healthcare+Directory)) as a means of determining which endpoints exist for which payers as candidates for configuration. Once plans are in the national directory, CRD clients **SHOULD** include that plan identifier as a way to uniquely identify that plan.

All CRD clients will need to be configured to support communicating to a particular CRD server. This configuration process includes the following:

* Confirming that the CRD server can legitimately act on behalf of one or more payers
* Confirming that the CRD server can be trusted to receive and handle PHI
* Determining which hook(s) to enable for that CRD server
* Determining what scopes to provide the CRD server for access tokens issued to the service

In order to initiate this process, the payer responsible for a given CRD server must communicate with the relevant CRD client software vendor or provider organization and share the following information:

* The URL of their server
* Which hook types it supports
* What scopes it needs to perform its full function (and why)

### CRD Access Tokens
When a CRD client invokes a CRD server via CDS Hooks, it will provide an access token that allows the CRD server to retrieve additional patient information. The base rules for this token are defined in the [CDS Hooks specification](https://cds-hooks.hl7.org/2.0/#passing-the-access-token-to-the-cds-service). This specification imposes some additional constraints:

* The CRD client **SHOULD** limit the scopes provided in their access token to those identified by the CRD service as necessary to perform their decision support.

* Such access tokens **SHOULD** have an expiration time of no longer than 30 seconds which should be sufficient for even 'parallel' decision support with something like 'Order Select' where a user is continuing to work while the decision support call is processing.

### Additional Data Retrieval
The context information provided as part of hook invocation will often not be enough for a CRD server to fully determine coverage requirements. This section of the guide describes a common set of queries that define data that most, if not all, CRD servers will need in order to perform their requirements assessment.

For this release of the IG, conformant CRD clients **SHOULD** support the CDS Hooks [prefetch](https://cds-hooks.hl7.org/2.0/#prefetch-template) capability and be able to perform all the prefetch queries defined here and, where needed, **SHOULD** implement interfaces to [_include]({{site.data.fhir.path}}search.html#include) resources not available in the system's database. That is, if some of the data is stored in a separate system, it should ideally still be retrievable via `_include` in queries executed against the client. However, each payer will define the prefetch requests for their CRD server based on the information they require to provide coverage requirements. They **MAY** include more and/or less than described in this section. Prefetch requests **SHOULD** only include information that is always expected to be needed for each hook invocation. When information is only needed for certain invocations of the hook (e.g., for specific types of medications or services), that information **SHALL** only be retrieved by query using the provided token, never requested universally via prefetch. Not all CRD clients will support all prefetch requests. 

<blockquote class="stu-note">
In future releases of this specification, the requirements in this section might become a **SHALL**. Implementers are encouraged to provide feedback about this possibility based on their initial implementation experience.</blockquote>

The base requirement for these queries, whether based on Encounter or one of the request resources, is to bring back the following associated resources:

*  Patient
*  Relevant Coverage
*  Authoring Practitioner
*  Authoring Organization
*  Requested performing Practitioner (if specified)
*  Requested performing Organization (if specified)
*  Requested Location (if specified)
*  Associated Medication (if any)
*  Associated Device (if any)

Not all these will be relevant for all resource types. Different resources have differently named data elements and search parameters for them. In some cases, support only exists as extensions or does not exist at all. Where necessary, this implementation guide defines additional extensions to support retrieval of these elements. The intention is for both extensions and search parameters to eventually migrate into the core FHIR specification.

There are two possible mechanisms that can be used by the service to gather the information needed: prefetch and querying the CRD client to retrieve additional resources. Both mechanisms are defined as part of the [CDS Hooks specification](https://cds-hooks.hl7.org/2.0/#providing-fhir-resources-to-a-cds-service). In some cases, a mixture of both approaches might be necessary.

#### Prefetch
Prefetch is an optional capability of CDS Hooks that allows the client to perform certain query functions on behalf of the CRD server and provide the results in the initial hook invocation. This allows the client to optimize query performance and can simplify functionality for the CRD server.

In addition to the [base prefetch capabilities](https://cds-hooks.hl7.org/2.0/#prefetch-template) defined in the CDS Hooks specification, systems that support prefetch **SHOULD** support the [additional prefetch capabilities](deviations.html#additional-prefetch-capabilities) defined in this specification. The following table defines the standard prefetch queries for this implementation guide that **SHOULD** be supported for each type of resource. CRD clients **MAY** support only the resources needed to implement the relevant CDS Hooks and order types. Those search parameters with hyperlinks are defined as part of this implementation guide. The remainder are defined within their respective version of the FHIR core specification.

CRD client implementations **SHOULD NOT** expect standardized prefetch key names. CRD clients supporting prefetch **SHALL** inspect the CDS Hooks discovery endpoint to determine exact prefetch key names and queries.

In most cases, payers will require information about a patient’s coverage. In order to reduce the time CRD services spend on member matching, CRD clients **SHOULD** limit the coverages provided to just those relevant to the CRD service. How this happens is up to the CRD client. Coverage prefetch will look like this:

<!-- fragment Binary/CRDServices JSON BASE:services.where(hook='appointment-book') EXCEPT:prefetch.where(key='coverage') -->
{% raw %}
<pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  ...
  "prefetch" : {
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksServices.html#CDSHooksServices.services.prefetch.value">encounter</a>" : "Encounter?_id=&amp;_include=Encounter:service-provider&amp;_include=Encounter:practitioner&amp;_include=Encounter:location",
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksServices.html#CDSHooksServices.services.prefetch.value">coverage</a>" : "Coverage?patient=&amp;status=active",
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksServices.html#CDSHooksServices.services.prefetch.value">appointment</a>" : "Appointment?_id=&amp;_include=Appointment:practitioner:PractitionerRole&amp;_include:iterate=PractitionerRole:organization&amp;_include:iterate=PractitionerRole:practitioner&amp;_include=Appointment:location"
  }
}</code></pre>
{% endraw %}

Other information will need to be retrieved using queries that are more specific to the type of hook being invoked and the resources passed with it:

{% raw %}
<table class="grid">
  <thead>
    <tr>
      <th>Resource</th>
      <th>Query</th>
      <th>Notes</th>
    </tr>
  </thead>
  <tr>
    <td>Appointment</td>
    <td>
      <code>Appointment?_id={{context.appointments.Appointment.id}}<br/>
      &_include=Appointment:patient<br/>
      &_include=Appointment:practitioner:PractitionerRole<br/>
      &_include:iterate=PractitionerRole:organization<br/>
      &_include:iterate=PractitionerRole:practitioner<br/>
      &_include=Appointment:location<br/><br/>
      Coverage?patient={{context.patient}}</code>
    </td>
    <td>No requester</td>
  </tr>
  <tr>
    <td>DeviceRequest</td>
    <td>
      <code>DeviceRequest?_id={{context.draftOrders.DeviceRequest.id}}<br/>
      &_include=DeviceRequest:patient<br/>
      &_include=DeviceRequest:performer<br/>
      &_include=DeviceRequest:requester<br/>
      &_include=DeviceRequest:device<br/>
      &_include:iterate=PractitionerRole:organization<br/>
      &_include:iterate=PractitionerRole:practitioner<br/><br/>
      Coverage?patient={{context.patient}}</code>
    </td>
    <td>No performing location</td>
  </tr>
  <tr>
    <td>Encounter</td>
    <td>
      <code>Encounter?_id={{context.encounterId}}<br/>
      &_include=Encounter:patient<br/>
      &_include=Encounter:service-provider<sup>†</sup><br/>
      &_include=Encounter:practitioner<br/>
      &_include=Encounter:location<br/><br/>
      Coverage?patient={{context.patient}}</code>
    </td>
    <td>No requester</td>
  </tr>
  <tr>
    <td>MedicationRequest</td>
    <td>
      <code>MedicationRequest?_id={{context.draftOrders.MedicationRequest.id}}<br/>
      &_include=MedicationRequest:patient<br/>
      &_include=MedicationRequest:intended-dispenser<br/>
      &_include=MedicationRequest:requester:PractitionerRole<br/>
      &_include=MedicationRequest:medication<br/>
      &_include:iterate=PractitionerRole:organization<br/>
      &_include:iterate=PractitionerRole:practitioner</br>
      Coverage?patient={{context.patient}}</code>
    </td>
    <td>No performing location</td>
  </tr>
  <tr>
    <td>NutritionOrder</td>
    <td>
      <code>NutritionOrder?_id={{context.draftOrders.NutritionOrder.id}}<br/>
      &_include=NutritionOrder:patient<br/>
      &_include=NutritionOrder:provider<br/>
      &_include=NutritionOrder:requester<br/>
      &_include:iterate=PractitionerRole:organization<br/>
      &_include:iterate=PractitionerRole:practitioner<br/>
      &_include=NutritionOrder:encounter<br/>
      &_include:iterate=Encounter:location<br/>
      Coverage?patient={{context.patient}}</code>
    </td>
    <td>Location only through request encounter</td>
  </tr>
  <tr>
    <td>ServiceRequest</td>
    <td>
      <code>ServiceRequest?_id={{context.draftOrders.ServiceRequest.id}}<br/>
      &_include=ServiceRequest:patient<br/>
      &_include=ServiceRequest:performer<br/>
      &_include=ServiceRequest:requester<br/>
      &_include:iterate=PractitionerRole:organization<br/>
      &_include:iterate=PractitionerRole:practitioner</br>
      Coverage?patient={{context.patient}}</code>
    </td>
    <td>No performer location</td>
  </tr>
</table>
<p class="new-content" markdown="1">
<sup>†</sup> The service-provider search type is only relevant if the CRD client supports the 'serviceProvider' element, which is not 'mustSupport'.
</p>
{% endraw %}

#### FHIR Resource Access
If information needed is not provided by prefetch, the CRD server can query the client directly using the [FHIR resource access](https://cds-hooks.hl7.org/2.0/#fhir-resource-access) mechanism defined in the CDS Hooks specification.

This can be done either by using individual queries or by invoking a batch of separate queries. In either case, the HTTP call that performs the query or executes the batch must pass the `fhirAuthorization.accessToken` in the authorization header as defined in the [OAuth specification](https://www.oauth.com/oauth2-servers/accessing-data/making-api-requests).

The following two examples show a batch query that could retrieve all CRD-relevant resources as well as the structure of the corresponding batch response.

**Query Batch Request**<br/>
This query presumes that an `order-sign` hook has been invoked and the following information has been passed in as context:

<!-- fragment Binary/CRDServiceRequest JSON BASE:context -->
{% raw %}
<pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHookOrderSignContext.html#CDSHookOrderSignContext.userId">userId</a>" : "Practitioner/ABC",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHookOrderSignContext.html#CDSHookOrderSignContext.patientId">patientId</a>" : "123",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHookOrderSignContext.html#CDSHookOrderSignContext.encounterId">encounterId</a>" : "987",
  "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle">draftOrders</a>" : {
    "<a href="http://hl7.org/fhir/R4/bundle.html">resourceType</a>" : "Bundle",
    "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.type">type</a>" : "collection",
    "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry">entry</a>" : [
      {
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.fullUrl">fullUrl</a>" : "http://example.org/someEHR/fhir/ServiceRequest/1357",
        "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest">resource</a>" : {
          "<a href="http://hl7.org/fhir/R4/servicerequest.html">resourceType</a>" : "ServiceRequest",
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.id">id</a>" : "1357",
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.text">text</a>" : {
            "<a href="http://hl7.org/fhir/R4/datatypes.html#Narrative#Narrative.status">status</a>" : "generated",
            "<a href="http://hl7.org/fhir/R4/datatypes.html#Narrative#Narrative.div">div</a>" : "&lt;div xmlns=\&quot;http://www.w3.org/1999/xhtml\&quot;&gt;Contrast enhanced spectral mammography (Procedure) for Amy V. Baxter&lt;br/&gt;Requested by Dr. Jones, Feb 15, 2019&lt;/div&gt;"
          },
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.status">status</a>" : "draft",
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.intent">intent</a>" : "original-order",
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.code">code</a>" : {
            "<a href="http://hl7.org/fhir/R4/datatypes.html#CodeableConcept#CodeableConcept.coding">coding</a>" : [
              {
                "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.system">system</a>" : "http://snomed.info/sct",
                "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.code">code</a>" : "726551006",
                "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.display">display</a>" : "Contrast enhanced spectral mammography (Procedure)"
              }
            ]
          },
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.subject">subject</a>" : {
            "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.reference">reference</a>" : "http://example.org/fhir/Patient/123"
          },
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.encounter">encounter</a>" : {
            "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.reference">reference</a>" : "http://example.org/fhir/Encounter/987"
          },
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.authoredOn">authoredOn</a>" : "2019-02-15",
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.requester">requester</a>" : {
            "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.reference">reference</a>" : "http://example.org/fhir/PractitionerRole/ABC",
            "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.display">display</a>" : "Dr. Jones"
          }
        }
      },
      {
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.fullUrl">fullUrl</a>" : "http://example.org/someEHR/fhir/ServiceRequest/2468",
        "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest">resource</a>" : {
          "<a href="http://hl7.org/fhir/R4/servicerequest.html">resourceType</a>" : "ServiceRequest",
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.id">id</a>" : "2468",
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.text">text</a>" : {
            "<a href="http://hl7.org/fhir/R4/datatypes.html#Narrative#Narrative.status">status</a>" : "generated",
            "<a href="http://hl7.org/fhir/R4/datatypes.html#Narrative#Narrative.div">div</a>" : "&lt;div xmlns=\&quot;http://www.w3.org/1999/xhtml\&quot;&gt;Portable gaseous oxygen system, rental; includes portable container, regulator, flowmeter, humidifier, cannula or mask, and tubing for Amy V. Baxter&lt;br/&gt;Requested by Dr. Jones, Feb 15, 2019&lt;/div&gt;"
          },
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.status">status</a>" : "draft",
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.intent">intent</a>" : "original-order",
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.code">code</a>" : {
            "<a href="http://hl7.org/fhir/R4/datatypes.html#CodeableConcept#CodeableConcept.coding">coding</a>" : [
              {
                "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.system">system</a>" : "https://www.cms.gov/Medicare/Coding/HCPCSReleaseCodeSets",
                "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.code">code</a>" : "E0431",
                "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.display">display</a>" : "Portable gaseous oxygen system, rental; includes portable container, regulator, flowmeter, humidifier, cannula or mask, and tubing"
              }
            ]
          },
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.subject">subject</a>" : {
            "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.reference">reference</a>" : "http://example.org/fhir/Patient/123"
          },
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.encounter">encounter</a>" : {
            "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.reference">reference</a>" : "http://example.org/fhir/Encounter/987"
          },
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.authoredOn">authoredOn</a>" : "2019-02-15",
          "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.requester">requester</a>" : {
            "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.reference">reference</a>" : "http://example.org/fhir/PractitionerRole/ABC",
            "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.display">display</a>" : "Dr. Jones"
          }
        }
      }
    ]
  }
}</code></pre>
{% endraw %}

As well, the `draftOrders` Bundle from the context includes `MedicationRequests` that reference 2 formulary medications (MED1, MED2), to be fulfilled by one pharmacy Organization (456) and are ordered by the same `PractitionerRole` with id `ABC`. Most importantly, they are all tied to the same Coverage record with id `DEF`.

Note: This query also presumes that all this information would be relevant to the CRD server. In practice, the service would only query the information needed to determine coverage requirements. Also, the service will only be able to query data where the scopes made available in the `fhirAuthorization.scope` permit the desired queries.

The bundle uses a mixture of read and search operations to retrieve the relevant resources.

**Query Batch Response**<br/>
The response is a batch response Bundle, with each entry containing either a single resource (in response to a read) or a search response Bundle with the results of the previous search. Each entry in the response bundle corresponds to the GET entry in the request Bundle.

<!-- fragment Bundle/search-response JSON EXCEPT:id BASE:entry.resource.where(($this is Bundle).not()) | entry.resource.entry.resource -->
{% raw %}
<pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle">resourceType</a>" : "Bundle",
  "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.id">id</a>" : "search-response",
  "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.type">type</a>" : "batch-response",
  "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry">entry</a>" : [
    {
      "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.fullUrl">fullUrl</a>" : "http://example.org/someEHR/fhir/Patient/123",
      "<a href="http://hl7.org/fhir/R4/patient.html#Patient">resource</a>" : {
        "<a href="http://hl7.org/fhir/R4/patient.html">resourceType</a>" : "Patient",
        "<a href="http://hl7.org/fhir/R4/patient.html#Patient.id">id</a>" : "123",
        ...
      },
      "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.response">response</a>" : {
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.response.status">status</a>" : "200",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.response.lastModified">lastModified</a>" : "2019-03-15T15:38:13.028Z"
      }
    },
    {
      "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.fullUrl">fullUrl</a>" : "urn:uuid:f95e9abf-1c8f-4873-ad15-f6f016334568",
      "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle">resource</a>" : {
        "<a href="http://hl7.org/fhir/R4/bundle.html">resourceType</a>" : "Bundle",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.id">id</a>" : "f95e9abf-1c8f-4873-ad15-f6f016334568",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.type">type</a>" : "searchset",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.total">total</a>" : 1,
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.link">link</a>" : [
          {
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.link.relation">relation</a>" : "self",
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.link.url">url</a>" : "Encounter?_id=987&amp;_include=Encounter:service-provider&amp;_include=Encounter:practitioner&amp;_include=Encounter:location"
          }
        ],
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry">entry</a>" : [
          {
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.fullUrl">fullUrl</a>" : "http://example.org/someEHR/fhir/Encounter/987",
            "<a href="http://hl7.org/fhir/R4/encounter.html#Encounter">resource</a>" : {
              "<a href="http://hl7.org/fhir/R4/encounter.html">resourceType</a>" : "Encounter",
              "<a href="http://hl7.org/fhir/R4/encounter.html#Encounter.id">id</a>" : "987",
              ...
            },
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.search">search</a>" : {
              "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.search.mode">mode</a>" : "match"
            }
          },
          {
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.fullUrl">fullUrl</a>" : "http://example.org/someEHR/fhir/Location/hospital",
            "<a href="http://hl7.org/fhir/R4/location.html#Location">resource</a>" : {
              "<a href="http://hl7.org/fhir/R4/location.html">resourceType</a>" : "Location",
              "<a href="http://hl7.org/fhir/R4/location.html#Location.id">id</a>" : "hospital",
              ...
            },
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.search">search</a>" : {
              "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.search.mode">mode</a>" : "include"
            }
          }
        ]
      },
      "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.response">response</a>" : {
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.response.status">status</a>" : "200",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.response.lastModified">lastModified</a>" : "2019-03-15T15:38:13.028Z"
      }
    },
    {
      "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.fullUrl">fullUrl</a>" : "urn:uuid:c81d99b6-caf9-4e01-8eda-0550a837def3",
      "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle">resource</a>" : {
        "<a href="http://hl7.org/fhir/R4/bundle.html">resourceType</a>" : "Bundle",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.id">id</a>" : "c81d99b6-caf9-4e01-8eda-0550a837def3",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.type">type</a>" : "searchset",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.total">total</a>" : 1,
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.link">link</a>" : [
          {
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.link.relation">relation</a>" : "self",
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.link.url">url</a>" : "http://example.org/someEHR/fhir/r4/Coverage?patient=123&amp;status=active"
          }
        ],
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry">entry</a>" : [
          {
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.fullUrl">fullUrl</a>" : "http://example.org/someEHR/fhir/Coverage/COV1",
            "<a href="http://hl7.org/fhir/R4/coverage.html#Coverage">resource</a>" : {
              "<a href="http://hl7.org/fhir/R4/coverage.html">resourceType</a>" : "Coverage",
              "<a href="http://hl7.org/fhir/R4/coverage.html#Coverage.id">id</a>" : "COV1",
              ...
            },
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.search">search</a>" : {
              "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.search.mode">mode</a>" : "match"
            }
          }
        ]
      },
      "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.response">response</a>" : {
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.response.status">status</a>" : "200",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.response.lastModified">lastModified</a>" : "2019-03-15T15:38:13.028Z"
      }
    },
    {
      "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.fullUrl">fullUrl</a>" : "urn:uuid:dc616366-2f3f-4cca-b02c-0f80981770db",
      "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle">resource</a>" : {
        "<a href="http://hl7.org/fhir/R4/bundle.html">resourceType</a>" : "Bundle",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.id">id</a>" : "dc616366-2f3f-4cca-b02c-0f80981770db",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.type">type</a>" : "searchset",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.total">total</a>" : 2,
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.link">link</a>" : [
          {
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.link.relation">relation</a>" : "self",
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.link.url">url</a>" : "http://example.org/someEHR/fhir/r4/Medication?_id=MED1,MED2&amp;_sort=_id"
          }
        ],
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry">entry</a>" : [
          {
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.fullUrl">fullUrl</a>" : "http://example.org/someEHR/fhir/Mediation/MED1",
            "<a href="http://hl7.org/fhir/R4/medication.html#Medication">resource</a>" : {
              "<a href="http://hl7.org/fhir/R4/medication.html">resourceType</a>" : "Medication",
              "<a href="http://hl7.org/fhir/R4/medication.html#Medication.id">id</a>" : "MED1",
              ...
            },
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.search">search</a>" : {
              "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.search.mode">mode</a>" : "match"
            }
          },
          {
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.fullUrl">fullUrl</a>" : "http://example.org/someEHR/fhir/Mediation/MED2",
            "<a href="http://hl7.org/fhir/R4/medication.html#Medication">resource</a>" : {
              "<a href="http://hl7.org/fhir/R4/medication.html">resourceType</a>" : "Medication",
              "<a href="http://hl7.org/fhir/R4/medication.html#Medication.id">id</a>" : "MED2",
              ...
            },
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.search">search</a>" : {
              "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.search.mode">mode</a>" : "match"
            }
          }
        ]
      },
      "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.response">response</a>" : {
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.response.status">status</a>" : "200",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.response.lastModified">lastModified</a>" : "2019-03-15T15:38:13.037Z"
      }
    },
    {
      "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.fullUrl">fullUrl</a>" : "urn:uuid:ee0d8bb2-f7a1-4b53-bfff-902dd4513b07",
      "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle">resource</a>" : {
        "<a href="http://hl7.org/fhir/R4/bundle.html">resourceType</a>" : "Bundle",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.id">id</a>" : "ee0d8bb2-f7a1-4b53-bfff-902dd4513b07",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.type">type</a>" : "searchset",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.total">total</a>" : 1,
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.link">link</a>" : [
          {
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.link.relation">relation</a>" : "self",
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.link.url">url</a>" : "http://example.org/someEHR/fhir/r4/PractitionerRole?_id=123&amp;_include=PractitionerRole:organization&amp;_include=PractitionerRole:practitioner&amp;_sort=_id"
          }
        ],
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry">entry</a>" : [
          {
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.fullUrl">fullUrl</a>" : "http://example.org/someEHR/fhir/PractitionerRole/ABC",
            "<a href="http://hl7.org/fhir/R4/practitionerrole.html#PractitionerRole">resource</a>" : {
              "<a href="http://hl7.org/fhir/R4/practitionerrole.html">resourceType</a>" : "PractitionerRole",
              "<a href="http://hl7.org/fhir/R4/practitionerrole.html#PractitionerRole.id">id</a>" : "ABC",
              ...
            },
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.search">search</a>" : {
              "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.search.mode">mode</a>" : "match"
            }
          },
          {
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.fullUrl">fullUrl</a>" : "http://example.org/someEHR/fhir/Practitioner/DEF",
            "<a href="http://hl7.org/fhir/R4/practitioner.html#Practitioner">resource</a>" : {
              "<a href="http://hl7.org/fhir/R4/practitioner.html">resourceType</a>" : "Practitioner",
              "<a href="http://hl7.org/fhir/R4/practitioner.html#Practitioner.id">id</a>" : "DEF",
              ...
            },
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.search">search</a>" : {
              "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.search.mode">mode</a>" : "include"
            }
          },
          {
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.fullUrl">fullUrl</a>" : "http://example.org/someEHR/fhir/Organization/GHI",
            "<a href="http://hl7.org/fhir/R4/organization.html#Organization">resource</a>" : {
              "<a href="http://hl7.org/fhir/R4/organization.html">resourceType</a>" : "Organization",
              "<a href="http://hl7.org/fhir/R4/organization.html#Organization.id">id</a>" : "GHI",
              ...
            },
            "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.search">search</a>" : {
              "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.search.mode">mode</a>" : "include"
            }
          }
        ]
      },
      "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.response">response</a>" : {
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.response.status">status</a>" : "200",
        "<a href="http://hl7.org/fhir/R4/bundle.html#Bundle.entry.response.lastModified">lastModified</a>" : "2019-03-15T15:38:13.011Z"
      }
    }
  ]
}</code></pre>
{% endraw %}


#### Query Notes
*  Conformant CRD clients **SHOULD** be able to perform all the queries defined here and, where needed, **SHOULD** implement interfaces to [_include]({{site.data.fhir.path}}search.html#include) resources not available in the client's database.

* Executing these queries in either batch or prefetch will bring back some redundant information such as information that was already known to the CRD client and included in the request. Examples of this redundant information include returning the original request, returning Encounter and Appointment resources found in the hook contexts, and returning Patient, Practitioner, Organization, and Coverage resources that are common for different request types for the order-sign hook. This redundancy is the cost of using the prefetch mechanism or batch mechanism. Payers seeking greater efficiency can perform direct queries that are more tuned at the cost of needing to make multiple service calls.

* Queries use the defined search parameter names from the respective FHIR specification versions. If parties processing these queries have varied from these standard search parameter names (as indicated by navigating their CapabilityStatements), the CRD server will be responsible for translating the parameters into the CRD client's local names. For example, if a particular CRD client's CapabilityStatement indicates that the parameter name (that corresponds to HL7's Encounter search criteria) is named 'visit' on the client's server, the service will have to construct its search URL accordingly.

* When full prefetch as defined here is not supported, CRD clients **SHOULD**, at minimum, support the batch query syntax shown [above](#fhir-resource-access). CRD servers **MAY** choose to support the batch query mechanism, perform client-specific queries as necessary, or return no results when a client does not support its prefetch requirements.

* While these queries attempt to bring back all the potentially relevant information, not all information will necessarily exist for all requests or events, particularly at the time the hook is called. CRD servers **SHALL** provide what coverage requirements they can based on the information available.

* When processing data from query responses, always check the 'self' link to ensure that the server executed what was requested and processed the data as necessary - or try querying by a different mechanism (e.g. multiple queries rather than relying on `_include`).

### SMART on FHIR Hook Invocation
In addition to the real-time decision support provided by CDS Hooks, providers will sometimes need to seek coverage requirements information without invoking the workflow of their provider system to actively create an order, appointment, encounter, etc. A few real-world examples where hooks may be invoked this way include exploring a "what if" scenario, answering a patient question related to whether a service would be covered, and retrieving a guidance document they had seen in a previous card.

The solution to this need to perform coverage discovery at any time is the use of a SMART on FHIR app. Many CRD clients already support SMART on FHIR. That standard allows independently-developed applications to be launched from within the CRD client (possibly within the user interface) and to interact with its data. Clients may choose to use SMART on FHIR apps to invoke coverage requirements discovery from CRD servers for "what if" scenarios, using a CRD client's existing SMART on FHIR interface. Alternatively, they can develop such functionality internally.

CRD clients conforming with this specification **SHALL** support the SMART on FHIR interface, **SHALL** allow launching of SMART apps from within their application, and **SHALL** be capable of providing the SMART app access to information it exposes to CRD servers using the CDS Hooks interface.

NOTES:

* The use of SMART to explore "what if" scenarios is distinct from the use of SMART envisioned in CDS Hooks:
    * Rather than launching a SMART app based on a returned card, a SMART app is used here to invoke a CDS hook to artificially simulate a workflow in the CRD client that would normally trigger a hook.
    * When a SMART app is launched, draft orders within a CRD client will not typically be available to the app to submit to the CRD server. Information for consideration in the "what if" scenario will need to be entered into the app directly.
    * When a CRD server returns cards, any instructions associated with the cards will be displayed in the app, but it may not be able to execute the instructions within the cards.
* Exploration of "what if" scenarios using the app is intended to work for all the hooks. This might be accomplished using separate SMART apps for different types of orders or processes (e.g., distinct what if apps for ordering drugs, ordering labs, doing referrals, scheduling appointments) or a single SMART app that prompts the user to identify the scenario they are interested in exploring prior to invoking the hook.
* The app/CRD client **MAY** choose to use configuration options to control what types of calls are available.

In the specific case of order-based hooks, "what if" **SHOULD** use the Order Sign hook, but **SHALL** use the configuration option that prevents the return of an unsolicited determination and **MAY** use configuration options to prevent the return of other irrelevant types of cards (e.g., duplicate therapy).

### Additional Considerations
1. When CRD clients pass resources to a CRD server as part of context, the resources **SHALL** have an ID and that ID **SHALL** be usable as a target for references in resources manipulated by CDS Hook actions and/or by SMART apps. This does not mean that the IDs passed to CRD server must persist, but rather that the CRD client must handle adjustments to any references made to them (or provide necessary redirects) ensuring that any references made to the in-memory resource will remain valid. This also means that CRD clients will need to support the creation or updating of resources that include references to resources that might, at the time, only exist in memory and not yet be available as persistent entities.

2. The receipt of coverage requirements (be it "no requirements" or specific requirements or recommendations) has financial implications for both healthcare providers and payers. If a provider receives a message of "no requirements" and subsequently has a claim denied because of unmet requirements, it will be necessary for both sides to be able to confirm whether a "no requirements" response was sent and what information was in the hook invocation that led to that response. Therefore, in addition to any logging performed for security purposes, both CRD clients and CRD servers **SHALL** retain logs of all CRD-related hook invocations and their responses for access in the event of a dispute. All `Card.suggestion` elements **SHALL** populate the `Suggestion.uuid` element to aid in log reconciliation. Organizations **SHALL** have processes to ensure logs can be accessed by appropriate authorized users to help resolve discrepancies or issues in a timely manner.

NOTE: Because the information in these logs will often contain PHI, access to the logs themselves will need to be restricted and logged for security purposes.

3. CRD clients that invoke CDS hooks multiple times during the creation, editing, and review phase are responsible for managing the resulting cards and determining what to display to the user. CRD clients **SHOULD** ensure that multiple cards with the same advice are handled in a way that will not create a burden on the user.

4. Most implementation guides provide JSON, XML, and Turtle representations of artifacts. However, because this guide is primarily using CDS Hooks (which only supports JSON) and SMART on FHIR (which primarily uses JSON), this implementation guide only publishes the JSON version of artifacts.

5. The examples in this guide use whitespace for readability. Conformance systems **SHOULD** omit non-significant whitespace for performance reasons.

6. Examples provided within this specification strive to be realistic, but might not reflect accurate/current coverage requirements.