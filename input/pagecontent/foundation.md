This foundational page defines general context, considerations, and core requirements that apply to implementations of this implementation guide, regardless
of which portions of the IG are implemented.  It includes base conformance expectations, security and privacy rules, etc.

<!--
defines specific requirements for systems wishing to conform to this Coverage Requirements Discovery implementation guide.  The bulk of the section focuses on the implementation of the [CDS Hooks Specification](https://cds-hooks.hl7.org/2.0) to meet CRD use-cases.  It also describes the use of [SMART on FHIR](http://hl7.org/fhir/smart-app-launch/index.html) and provides guidance on privacy, security, and other implementation requirements.
-->

The requirements and expectations described here are not intended to be exhaustive. The purpose of this implementation guide is to establish a baseline of expected behavior that communication partners can rely on and then build upon. Future versions of this specification will evolve based on implementer feedback. Therefore, CRD Servers and CRD Clients **MAY** mutually agree to support additional hooks, additional card patterns, additional resources, additional extensions, etc. not in this specification.  Although CRD Servers and CRD Clients are not required to support any capabilities defined beyond this specification, the intent is to support innovations that extend the specification in a manner that allows payers and providers to adopt those extensions in a mutually agreeable way.

### Context

#### Pre-reading
Before reading this formal specification, implementers are encouraged to first familiarize themselves with two other key portions of this implementation guide:

* The [Use Cases & Overview](usecases.html) page, which provides context for what this formal specification is trying to accomplish and will give a sense of both the business context and general process flow enabled by the formal specification below.

* The [Technical Background](background.html) page, which provides information about the underlying specifications and recommends portions that must be read and understood to have the necessary foundation to understand the constraints and usage guidance described here.


#### Conventions
This implementation guide uses specific terminology to flag statements that have relevance for the evaluation of conformance with the guide:

* **SHALL** indicates requirements that must be met to be conformant with the specification.

* **SHOULD** indicates behaviors that are strongly recommended (and which could result in interoperability issues or sub-optimal behavior if not adhered to), but which do not, for this version of the specification, affect the determination of specification conformance.

* **MAY** describes optional behaviors that implementers are free to consider but where there is no recommendation for or against adoption.

<div markdown="1" class="new-content">

#### MustSupport
Profiles in this implementation guide make use of the [mustSupport]({{site.data.fhir.path}}profiling.html#mustsupport) element.

For CRD clients, if the client maintains the data element and surfaces it to users, then it **SHALL** be exposed in their FHIR interface when the data exists and privacy constraints permit.

For CRD servers, the server **SHALL** leverage mustSupport elements as available and appropriate to provide decision support.

NOTE: These requirements are somewhat different from US-Core and HRex because the implementation needs are different.  In US-Core, there is generally an expectation for clients to modify code and persistence layers to add support mustSupport elements for supported profiles.  This expectation does not hold for CRD.  However, CRD does require surfacing elements in the FHIR interface if the system maintains the element.

</div>


#### Profiles
This specification makes significant use of [FHIR profiles]({{site.data.fhir.path}}profiling.html), search parameter definitions, and terminology artifacts to describe the content to be shared as part of CDS Hook calls.  The implementation guide supports FHIR [R4]({{site.data.fhir.path}}) with profiles listed for each type of hook.

The full set of profiles defined in this implementation guide can be found by following the links on the [Artifacts](allartifacts.html) page.


#### US Core
This implementation guide also leverages the [US Core]({{site.data.fhir.ver.uscore}}) set of profiles defined by HL7 for sharing non-veterinary EHR individual health data in the U.S. Where US Core profiles exist, this guide either leverages them directly or uses them as a base for any additional constraints needed to support the coverage requirements discovery use-case. Where no constraints are needed, this IG doesn't define additional profiles, as all US Core profiles are deemed to be part of this IG and available for use in CRD communications. For example, the US Core Observation and Condition profiles are likely to be of interest in at least some CRD scenarios and may be used by solutions conformant to this guide.

Where US Core profiles do not yet exist (e.g. for several of the 'Request' resources), profiles have been created that try to align with existing US Core profiles in terms of elements exposed and terminologies used.

Note that, in some cases, the US Core profiles require support for data elements that are not necessarily relevant to the coverage requirements discovery use-case.  It was felt that leveraging existing standard interfaces would promote greater (and quicker) interoperability than a more tuned custom interface.  CRD Clients might still choose to restrict what information is exposed to CRD Servers based on their internal data access and governance rules.


<div markdown="1" class="new-content">

### Performance

Depending on their location within the workflow, CDS Hooks may be processed in a synchronous manner.  This means that the user who is performing the business action that triggers the hook might be 'blocked' from continuing the action until cards have been returned by the CDS service.  E.g. an CRD client might not allow progress of an 'order sign' business action until decision support has been returned from all order-sign services and the user has had a chance to interact with any cards they deem relevant.  The corollary to this is that services must respond to hook invocations quickly to avoid impeding clinician workflow - and turning the intended benefit CRD is intended to provide into a detriment.

This specification sets a target duration in which CRD Services are expected to return their CDS Hooks response after being invoked.  CRD services SHALL return responses for all supported hooks and SHALL respond within the required duration 90% of the time.  (I.e. all [primary](hooks.html#hook-categories) hooks and any [supporting](hooks.html#hook-categories) hooks where they opt to support the hook.)  For most hooks, this target time is 5 seconds.  It extends to 10 seconds for [Appointment Book](hooks.html#appointment-book) and for [Order Dispatch](hooks.html#order-dispatch) and [Order Sign](hooks.html#order-sign) hooks that are sent at least 24 hours after the last hook invocation for the same order(s) because there is no opportunity to cache data in those cases.

It is recognized that this may limit the payer from providing full responses to all calls where a response is 'theoretically' possible.  Systems should provide the best information they can in a timely fashion and rely on other layers of the payment and adjudication process to catch issues that require longer processing.  For example, if a system is able to provide a response on eligibility within the time window, but not on whether prior authorization is needed, it can return cards indicating the service is covered, but that DTR is needed (to determine prior authorization requirements). Where a payer responds with a "coverage information" code of 'clinical' or 'admin' and the payer supports DTR, they SHOULD support gathering the additional information via DTR.  This expectation is intended to change to SHALL in a future release.

CRD services are encouraged to leverage hooks fired earlier in the workflow (even if they do not provide decision support in response to those hooks) as an opportunity to begin 'caching' relevant information for use when providing responses to later hooks.  For example, when an Encounter Start hook fires, the CRD service can retrieve and 'cache' the patient's current coverage information and details about their specific plans, limits, etc.  When an Order Select fires, the service can cache information about coverage and authorization rules associated with the ordered service.  Potentially relevant information such as past labs, prior therapies, relevant diagnoses, etc. can also be retrieved from the EHR.  As a result, when an Order Sign or Order Dispatch hook fires, the CRD service should have almost all information needed to render an immediate decision, allowing response times to be met much more easily.

A determination that additional information is needed (e.g. via DTR) is considered to be a valid response. Where a payer responds with a "coverage information" code of 'clinical' or 'admin' and the payer supports DTR, they SHOULD support gathering the additional information via DTR.  This expectation is intended to change to SHALL in a future release.

If a CRD service exceeds the allocated time window for a hook (i.e. for those circumstances that fall outside the 90% expectation), CRD clients SHOULD establish a time-out process that ensures users are not blocked from proceeding with their business flow.  Where a CRD client opts to not block users from proceeding for responses that come back in a period of time shorter than the target time window in this guide (i.e. 5/10 seconds), the client must ensure that users are made aware of the information when it is available.  For responses that come back in a time period that exceeds this duration, CRD clients MAY ignore the resulting cards and/or system actions.

<blockquote class="note-to-balloters">
<p>
Payers and Healthcare IT system vendors are both encouraged to provide feedback around whether this timing expectation strikes the appropriate balance between allowing appropriate decision support and allowing timely progress of workflow.  This evaluation should consider what systems will need to be involved in the decision support process, what external calls might be needed, what caching strategies are viable, etc.
</p>
</blockquote>

### Accuracy

CDS services **SHALL** ensure that the guidance returned with respect to coverage and prior authorizations (e.g. assertions that a service is covered, or prior authorization is not necessary) is as accurate as guidance that would be provided by other means (e.g. portals, phone calls).  Also, such guidance should allow for possible variances in coding and submission.  (See [Impact on payer processes](background.html#impact-on-payer-processes) on the Background page.)

### Terminology
When invoking CDS Hooks, resources reflecting the clinical/business representation of the order, appointment, encounter, etc. will be transmitted to the CRD Server.  These data representations will generally make use of codes to describe the type of service/product being ordered/booked/performed.  These codes will draw from the code systems used at this stage of the business process and will typically be "clinical" codes rather than "billing" codes.  That said, it is always possible to send multiple codings within a CodeableConcept.  Where the selected code is not already a 'billing' code and CRD clients are able to automatically determine what the corresponding billing code is, they **SHOULD** send a Coding with the billing code alongside the clinical code to reduce the risk of the receiving payer making a differing translation.

</div>

### Appropriate use of hooks
CDS Hooks are intended to improve healthcare provider care planning processes by allowing relevant and useful information to be inserted into provider workflows.  At the same time, inserting additional information into a provider's workflow will induce additional mental load, even if the information is not acted upon, and therefore must be done judiciously.

Payers and service providers **SHALL** ensure that CDS Hooks return only messages and information relevant and useful to the intended recipient.

<div markdown="1" class="new-content">

### Enabling a CRD Server
When an CRD client configures itself to support a payer's CRD service, it will need to identify which payer(s) the service supports.  This is needed to ensure that the CRD client only sends CRD calls to services that the patient has current coverage for.  The CRD service is responsible for any internal routing based on which processing organization handles the decisions.  For this purpose, payer means 'The organization listed on the member's insurance card'.

Provider and EHR Vendor organizations **MAY** leverage the [payer registry](http://hl7.org/fhir/us/davinci-pdex-plan-net) developed by PDex (which will eventually fold into the [national directory under FAST](https://confluence.hl7.org/display/FAST/National+Healthcare+Directory)) as a means of determining which endpoints exist for which payers as candidates for configuration.  Once plans are in the national directory, CRD Clients **SHOULD** include that plan identifier as way to uniquely identify that plan.

All CRD clients will need to be configured to support communicating to a particular CRD server.  This configuration process includes the following:

* Confirming that the CRD Server can legitimately act on behalf of one or more payers

* Confirming that the CRD Server can be trusted to receive and handle PHI

* Determining which hook(s) to enable for that CRD Server

* Determining what scopes to provide the CRD server with access to for access tokens issued to the service

In order to initiate this process, the payer responsible for a given CRD Server must communicate with the relevant CRD client software vendor or provider organization and share the following information:

* The URL of their server

* Which hook types it supports

* What scopes it needs to perform its full function (and why)

### CRD Access Tokens

When a CRD client invokes a CRD server via CDS Hooks, it will provide an access token that allows the CRD server to retrieve additional patient information.  The base rules for this token are defined in the [CDS Hooks specification](https://cds-hooks.hl7.org/2.0/#passing-the-access-token-to-the-cds-service).  This specification imposes some additional constraints:

* The CRD client **SHOULD** limit the scopes provided in their access token to those identifed by the CRD service as necessary to perform their decision support.

* Such access tokens **SHOULD** have an expiration time of no longer than 30 seconds (which is more than enough for even 'parallel' decision support with something like *Order Select* where a user is continuing to work while the decision support call is processing.)

</div>



### Additional Data Retrieval
The context information provided as part of hook invocation will often not be enough for a CRD Server to fully determine coverage requirements.  This section of the guide describes a common set of queries that define data that most, if not all, CRD Servers will need to perform their requirements assessment.

For this release of the implementation guide, conformant CRD Clients **SHOULD** support the CDS Hooks [prefetch](https://cds-hooks.hl7.org/2.0/#prefetch-template) capability and be able to perform all the prefetch queries defined here and, where needed, **SHOULD** implement interfaces to [_include]({{site.data.fhir.path}}search.html#include) resources not available in the system's database.  (I.e. if some of the data is stored in a separate system, it should ideally still be retrievable via `_include` in queries executed against the client.)  However, each payer will define the prefetch requests for their CRD Server based on the information they require to provide coverage requirements.  They might include more and/or less than described in this section.  Prefetch requests **SHOULD** only include information that is always expected to be needed for each hook invocation.  When information is only needed for certain invocations of the hook (e.g. for specific types of medications or services), that information **SHALL** only be retrieved by query using the provided token, never requested universally via prefetch.  Not all CRD Clients will support all prefetch requests.  

<blockquote class="stu-note">
In future releases of this specification, the requirements in this section might become a **SHALL**.  Implementers are encouraged to provide feedback about this possibility based on their initial implementation experience.
</blockquote>

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

Not all these will be relevant for all resource types.  Different resources have differently named data elements and search parameters for them.  In some cases, support only exists as extensions or does not exist at all.  Where necessary, this implementation guide defines additional extensions to support retrieval of these elements.  The intention is for both extensions and search parameters to eventually migrate into the core FHIR specification.

There are two possible mechanisms that can be used by the service to gather the information needed: prefetch and querying against the CRD client to retrieve additional resources.  Both mechanisms are defined as part of the [CDS Hooks specification](https://cds-hooks.hl7.org/2.0/#providing-fhir-resources-to-a-cds-service).  In some cases, a mixture of both approaches might be necessary.

#### Prefetch
Prefetch is an optional capability of CDS Hooks that allows the client to perform certain query functions on behalf of the CRD Server and provide the results in the initial hook invocation.  This allows the client to optimize query performance and can simplify functionality for the CRD Server.

In addition to the [base prefetch capabilities](https://cds-hooks.hl7.org/2.0/#prefetch-template) defined in the CDS Hooks specification, systems that support prefetch **SHOULD** support the [additional prefetch capabilities](deviations.html#additional-prefetch-capabilities) defined in this specification.  The following table defines the 'standard' prefetch queries for this implementation guide that **SHOULD** be supported for each type of resource.  CRD Clients **MAY** support only the resources needed to implement the relevant CDS Hooks and order types.  Those search parameters with hyperlinks are defined as part of this implementation guide.  The remainder are defined within their respective version of the FHIR core specification.

CRD client implementations **SHOULD NOT** expect standardized prefetch key names.  CRD clients supporting prefetch **SHALL** inspect the CDS Hooks Discovery Endpoint to determine exact prefetch key names and queries.

<div markdown="1" class="new-content">

In most cases, payers will require information about a patient’s coverage. In order to reduce the time CRD services spend on member matching, CRD clients **SHOULD** limit the coverages provided to just those relevant to the CRD service. How this happens is up to the CRD client.  Coverage prefetch will look like this:

{% raw %}
```
"prefetch": {
  "coverage": "Coverage?patient={{context.patient}}&amp;status=active",
  ...
},
{% endraw %}
```

<blockquote class="note-to-balloters">
<p>
This represents a change to how coverage information will be retrieved.  All active coverage for the patient is now retrieved (though typically only the coverage related to a payer will actually flow to the CRD Server due to limits on information disclosure).  There are no longer extensions or special search parameters to support capturing insurance information in a request-specific, encounter-specific, or other context-specific manner.
</p>
</blockquote>

Other information will need to be retrieved using queries that are more specific to the type of hook being invoked - and the resources passed with it:
</div>

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
      &_include=Encounter:service-provider<br/>
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
{% endraw %}

#### FHIR Resource Access
If information needed is not provided by prefetch, the CRD Server can query the client directly using the [FHIR resource access](https://cds-hooks.hl7.org/2.0/#fhir-resource-access) mechanism defined in the CDS Hooks specification.

This can be done either by using individual queries or by invoking a batch of separate queries.  In either case, the HTTP call that performs the query or executes the batch must pass the `fhirAuthorization.accessToken` in the Authorization header as defined in the [OAuth specification](https://www.oauth.com/oauth2-servers/accessing-data/making-api-requests).

The following two examples show a batch query that could retrieve all CRD-relevant resources as well as the structure of the corresponding batch response.

**Query Batch Request**<br/>
This query presumes that a hook has been invoked and the following information has been passed in as context:

```
"userId": "PractitionerRole/ABC",
"patientId": "123",
"encounterId": "987"
```

As well, the `draftOrders` Bundle includes MedicationRequests that reference 2 formulary medications (MED1, MED2), to be fulfilled by one pharmacy Organization (456) and are ordered by the same PractitionerRole with id 'ABC'.  Most importantly, they are all tied to the same Coverage record with id 'DEF'.

Note: This query also presumes that all this information would be relevant to the CRD Server.  In practice, the service would only query the information needed to determine coverage requirements.  Also, the service will only be able to query data where the scopes made available in the `fhirAuthorization.scope` permit the desired queries.

The bundle uses a mixture of 'read' and 'search' operations to retrieve the relevant resources.

```
{
  "resourceType": "Bundle",
  "type": "batch",
  "entry": [{
    "request": {
      "method": "GET",
      "url": "PractitionerRole?_id=ABC&_include=PractitionerRole:organization&_include=PractitionerRole:practitioner"
    }
  },{
    "request": {
      "method": "GET",
      "url": "Patient/123"
    }
  },{
    "request": {
      "method": "GET",
      "url": "Encounter/987"
    }
  },{
    "request": {
      "method": "GET",
      "url": "Medication?_id=MED1,MED2"
    }
  },{
    "request": {
      "method": "GET",
      "url": "Organization/456"
    }
  },{
    "request": {
      "method": "GET",
      "url": "Coverage/DEF"
    }
  }]
}
```

**Query Batch Response**<br/>
The response is a batch-response Bundle, with each entry containing either a single resource (in response to a read) or a search response Bundle with the results of the previous search.  Each entry in the response Bundle corresponds to the GET entry in the request Bundle.

```
{
  "resourceType": "Bundle",
  "type": "batch-response",
  "entry": [{
    "resource": {
      "resourceType": "Bundle",
      "id": "ee0d8bb2-f7a1-4b53-bfff-902dd4513b07",
      "meta": {
        "lastUpdated": "2019-03-15T15:38:13.011Z"
      },
      "type": "searchset",
      "total": 1,
      "link": [{
        "relation": "self",
        "url": "http://someemr.org/fhir/r4/PractitionerRole??_id=123&_include=PractitionerRole:organization&_include=PractitionerRole:practitioner&_sort=_id"
      }],
      "entry": [{
        "resource": {
          "resourceType": "PractitionerRole",
          "id": "123",
          "meta": {
            "lastUpdated": "2016-02-29T23:52:32.387Z"
          },
          "practitioner": "Practitioner/DEF",
          "organization": "Organization/GHI",
          ...
        },
        "search": {
          "mode": "match"
        }
      },{
        "resource": {
          "resourceType": "Practitioner",
          "id": "DEF",
          ...
        },
        "search": {
          "mode": "include"
        }
      },{
        "resource": {
          "resourceType": "Organization",
          "id": "GHI",
          ...
        },
        "search": {
          "mode": "include"
        }
      }]
    },
    "response": {
      "status": "200",
      "lastModified": "2019-03-15T15:38:13.011Z"
    }
  },{
    "resource": {
      "resourceType": "Patient",
      "id": "123",
      ...
    },
    "response": {
      "status": "200",
      "lastModified": "2019-03-15T15:38:13.028Z"
    }
  },{
    "resource": {
      "resourceType": "Encounter",
      "id": "987",
      ...
    },
    "response": {
      "status": "200",
      "lastModified": "2019-03-15T15:38:13.028Z"
    }
  },{
    "resource": {
      "resourceType": "Bundle",
      "id": "dc616366-2f3f-4cca-b02c-0f80981770db",
      "meta": {
        "lastUpdated": "2019-03-15T15:38:13.037Z"
      },
      "type": "searchset",
      "total": 2,
      "link": [{
        "relation": "self",
        "url": "http://someemr.org/fhir/r4/Medication?_id=MED1,MED2&_sort=_id"
      }],
      "entry": [{
        "resource": {
          "resourceType": "Medication",
          "id": "MED1",
          ...
        },
        "search": {
          "mode": "match"
        }
      },{
        "resource": {
          "resourceType": "Medication",
          "id": "MED2",
          ...
        },
        "search": {
          "mode": "match"
        }
      }]
    },
    "response": {
      "status": "200",
      "lastModified": "2019-03-15T15:38:13.037Z"
    }
  },{
    .
    .
    .
  }]
}
```


#### Query Notes
*  Conformant CRD Clients **SHOULD** be able to perform all the queries defined here and, where needed, **SHOULD** implement interfaces to [_include]({{site.data.fhir.path}}search.html#include) resources not available in the client's database.

* Executing these queries in either batch or prefetch will bring back some redundant information (e.g.  information that was already known to the CRD Client and included in the request). Examples of this redundant information include returning the original request, returning Encounter and Appointment resources found in the hook contexts, and returning Patient, Practitioner, Organization and Coverage resources that are common for different request types for the order-sign hook. This redundancy is the cost of using the prefetch mechanism or batch mechanism. Payers seeking greater efficiency can perform direct queries that are more tuned at the cost of needing to make multiple service calls.

* The queries use the defined search parameter names from the respective FHIR specification versions. If parties processing these queries have varied from these 'standard' search parameter names (as indicated by navigating their CapabilityStatements), the CRD Server will be responsible for translating the parameters into the CRD client's local names. For example, if a particular CRD client's CapabilityStatement indicates that the parameter name (that corresponds to HL7's 'encounter' search criteria) is named 'visit' on the client's server, the Service will have to construct its search URL accordingly.

* When full prefetch as defined here is not supported, CRD Clients **SHOULD**, at minimum, support the batch query syntax shown [above](#fhir-resource-access).  CRD Servers **MAY** choose to support the batch query mechanism, perform client-specific queries as necessary, or return no results when a client does not support its prefetch requirements.

* While these queries attempt to bring back all the potentially relevant information, not all information will necessarily exist for all requests or events, particularly at the time the hook is called.  CRD Servers **SHALL** provide what coverage requirements they can based on the information available.

* When processing data from query responses, always check the 'self' link to ensure that the server executed what was requested and processed the data as necessary - or try querying by a different mechanism (e.g. multiple queries rather than relying on `_include`).


### SMART on FHIR Hook Invocation
In addition to the real-time decision support provided by CDS Hooks, providers will sometimes need to seek coverage requirements information without invoking the workflow of their provider system to actively create an order, appointment, encounter, etc.  A few real-world examples where hooks may be invoked this way include exploring a "what-if" scenario, answering a patient question related to whether a service would be covered, and retrieving a guidance document they had seen in a previous card.

The solution to this need to perform coverage discovery "any time" is the use of a SMART on FHIR app.  Many CRD Clients already support SMART on FHIR.  That standard allows independently developed applications to be launched from within the CRD Client (possibly within the user interface) and to interact with its data.  As part of its scope, the Da Vinci organization will develop an open-source SMART on FHIR application to allow users of CRD Clients to invoke coverage requirements discovery from CRD Servers for "what-if" scenarios, using a CRD Client's existing SMART on FHIR interface.  CRD implementers **MAY** choose to use this app directly or as the basis for their own app development.  Note that CRD Clients will have their own registration process for all such apps.

CRD Clients conforming with this specification **SHALL** support the SMART on FHIR interface, **SHALL** allow launching of SMART apps from within their application, and **SHALL** be capable of providing the SMART app access to information it exposes to CRD Servers using the CDS Hooks interface.

The Da Vinci CRD SMART app has not yet been developed.  Once it exists, a link will be provided beneath the [CRD Confluence page](https://confluence.hl7.org/display/DVP/Coverage+Requirements+Discovery+(CRD)).  

NOTES:

* The use of SMART to explore "what-if" scenarios is distinct from the use of SMART envisioned in CDS Hooks:
    * Rather than launching a SMART app based on a returned card, a SMART app is used here to invoke a CDS hook to artificially simulate a workflow in the CRD Client that would normally trigger a hook.
    * When a SMART app is launched, draft orders within a CRD Client will not typically be available to the app to submit to the CRD Server.  Information for consideration in the "what-if" scenario will need to be entered into the app directly.
    * When a CRD Server returns cards, any instructions associated with the cards will be displayed in the app, but it may not be able to execute the instructions within the cards.
* Exploration of "what-if" scenarios using the app is intended to work for all the hooks. This might be accomplished using separate SMART apps for different types of orders/processes (e.g. distinct what-if apps for ordering drugs, ordering labs, doing referrals, scheduling appointments, etc.) or a single SMART app that prompts the user to identify the scenario they are interested in exploring prior to invoking the hook.

<div markdown="1" class="new-content">
* The app/CRD client **MAY** choose to use configuration options to control what types of cares are of interest

In the specific case of order-based hooks, "What if" **SHOULD** use the Order Sign hook, but **SHALL** use the configuration option that prevents the return of an unsolicited determination and **MAY** use configuration options to prevent the return of other irrelevant types of cards (e.g. duplicate therapy, etc.)

### Registering DTR Apps with CRD

If a payer supports both CRD and [DTR](http://hl7.org/fhir/us/davinci-dtr) and the CRD client intends to enable DTR in addition to CRD, then at the time the CRD Server is enabled within the CRD client, the service must be configured with the URL of the SMART app that is to be used within that CRD client.  For configuration purposes either zero or one SMART app **SHALL** be configured.  The SMART app selected must be one that supports all the Questionnaire data types, extensions, and other options that will be used by the payer - potentially including adaptive forms.

**NOTE:** The URL selected **MAY** be a 'logical' URL that corresponds to an CRD client internal function rather than a registered SMART app.

A CRD client, on receipt of a CDS Hook card with a SMART app launch of the specified DTR URL **MAY** choose to substitute that URL with the URL of an alternate SMART app, or with a card that allows launch of an internal function.  (Note: There is no standard mechanism for launching internal CRD client functionality from a CDS Hook card yet, so this will need to be an CRD client-proprietary mechanism.).  CRD clients performing such substitution might do so based on the user, organization, order type, or any other configuration option.  All responsibility for selection of which app to use rests with the CRD client.  The card-provided URL **SHALL** be the same for all DTR launch cards returned by the payer.

Any substituted app (or internal CRD client functionality) would need to support the DTR standard launch context expectations and would also need to ensure the alternate app or internal function likewise supports the necessary Questionnaire capabilities used by the payer.  The CRD client **SHALL** also notify the payer that they are performing app substitution so that the payer can notify the CRD client if the payer's Questionnaire requirements will be changing.

</div>

### Additional Considerations

1. When CRD clients pass resources to a CRD as part of context, the resources **SHALL** have an id and that id **SHALL** be usable as a target for references in resources manipulated by CDS Hook actions and/or by SMART apps launched by CRD.  This does not mean that the ids passed to CRD must persist, but rather that the CRD client must handle adjustments to any references made to them (or provide necessary redirects) ensuring that any references made to the in-memory resource will remain valid.  This also means that CRD clients will need to support the creation or updating of resources that include references to resources that might, at the time, only exist in memory and not yet be available as persistent entities.

2. Healthcare providers will rely on the information provided by the Coverage Requirements Discovery process to determine if there are any special steps they need to take such as requesting prior authorization.  As a result, it's important to them to know whether requirements exist or not.  CRD Servers **SHALL** respond with an empty JSON object when there is no action to be taken by the provider (the CDS Hooks mechanism for representing no guidance – which is not shown to the user) which allows a computer to distinguish between "no requirements" and a textual requirement.

3. The receipt of coverage requirements (be it "no requirements" or specific requirements/recommendations) has financial implications for both healthcare providers and payers.  If a provider receives a message of "no requirements" and subsequently has a claim denied because of unmet requirements, it will be necessary for both sides to be able to confirm whether a "no requirements" response was sent and what information was in the hook invocation that led to that response.  Therefore, in addition to any logging performed for security purposes, both CRD Clients and CRD Servers **SHALL** retain logs of all CRD-related hook invocations and their responses for access in the event of a dispute.  All `Card.suggestion` elements **SHALL** populate the `Suggestion.uuid` element to aid in log reconciliation.  Organizations **SHALL** have processes to ensure logs can be accessed by appropriate authorized users to help resolve discrepancies or issues in a timely manner.


NOTE: Because the information in these logs will often contain PHI, access to the logs themselves will need to be restricted and logged for security purposes.

3. CRD Clients that fire CDS hooks multiple times during the creation/editing/review phase are responsible for managing the resulting cards and determining what to display to the user.  CRD Clients **SHOULD** ensure that multiple cards with the same "advice" are handled in a way that will not create a burden on the user.

4. Most implementation guides provide JSON, XML and Turtle representations of artifacts.  However, because this guide is primarily using CDS Hooks (which only supports JSON) and SMART on FHIR (which primarily uses JSON), this implementation guide only publishes the JSON version of artifacts.

5. The examples in this guide use whitespace for readability.  Conformance systems **SHOULD** omit non-significant whitespace for performance reasons.

6. Examples provided within this specification strive to be realistic, but might not reflect accurate/current coverage requirements.
