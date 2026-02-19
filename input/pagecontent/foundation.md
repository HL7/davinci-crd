This foundational page defines general context, considerations, and core requirements that apply to use of this implementation guide, regardless of which portions of the IG are implemented. It includes base conformance expectations, security and privacy rules, etc.

<!--
defines specific requirements for systems wishing to conform to this Coverage Requirements Discovery implementation guide. The bulk of the section focuses on the implementation of the [CDS Hooks Specification]({{site.data.fhir.ver.cdshooks}}) to meet CRD use cases. It also describes the use of [SMART on FHIR](http://hl7.org/fhir/smart-app-launch/index.html) and provides guidance on privacy, security, and other implementation requirements.
-->

The requirements and expectations described here are not intended to be exhaustive. The purpose of this implementation guide is to establish a baseline of expected behavior that communication partners can rely on and then build upon. Future versions of this specification will evolve based on implementer feedback. Therefore, §found-1^crd-client,crd-server^exchange:CRD servers and CRD clients **MAY** mutually agree to support additional hooks, additional card patterns, additional resources, additional extensions, etc.§ not found in this specification. Although CRD servers and CRD clients are not required to support any capabilities defined beyond this specification, the intent is to support innovations that extend the specification in a manner that allows payers and providers to adopt those extensions in a mutually agreeable way.

### Pre-reading
Before reading this formal specification, implementers are encouraged to first familiarize themselves with some of the key background portions of this implementation guide:

* The [Reading this IG](background.html) page, which provides guidance for those who may be new to FHIR, reading FHIR IGs, or understanding some of the other key technologies used in this guide.

* The [Use Cases](usecases.html) page, which provides context for what this formal specification is trying to accomplish and will give a sense of both the business context and general process flow enabled by the formal specification below.

* The [Burden Reduction](burden.html) page, which provides information about how this guide works together with other Da Vinci guides in the burden reduction space.

### Performance
Depending on their location within the workflow, CDS Hooks may be processed in a synchronous manner. This means that the user who is performing the business action that triggers the hook might be blocked from continuing the action until cards have been returned by the CRD server. For example, a CRD client might not allow progress of an 'order sign' business action until the decision support has been returned from all order-sign services and the user has had a chance to interact with any cards they deem relevant. The corollary to this is that services must respond to hook invocations quickly to avoid impeding clinician workflow - and turning the intended benefit of CRD into a detriment.

This specification sets a target duration in which CRD servers are expected to return their CDS Hooks response after being invoked. §found-2^crd-server^processing:CRD servers **SHALL** return responses for all supported hooks and **SHALL** respond within the required time 90% of the time.§ (That is, all [primary](hooks.html#hook-categories) hooks and any [supporting](hooks.html#hook-categories) hooks where they opt to support the hook.) For most hooks, this target time is 5 seconds. It extends to 10 seconds for [Appointment Book](hooks.html#appointment-book) and for [Order Dispatch](hooks.html#order-dispatch) and [Order Sign](hooks.html#order-sign) hooks that are sent at least 24 hours after the last hook invocation for the same <span class="modified-content" markdown="1"><a name="FHIR-52447"> </a>patient and ordering organization</span> because there is no opportunity to cache data in those cases.  <span class="modified-content" markdown="1"><a name="FHIR-52314"></a>§found-3?^crd-client^processing:If a CRD client does not receive a response within the 5 or 10-second window, it **MAY** either abandon the call or process the response asynchronously.§</span>

The authors of this IG acknowledge that this may limit the payer from providing full responses to all calls where a response is theoretically possible. Systems should provide the best information they can in a timely fashion and rely on other layers of the payment and adjudication process to catch issues that require longer processing. For example, if a system is able to provide a response on eligibility within the time window, but not on whether prior authorization is needed, it can return cards indicating the service is covered, but that DTR is needed (to determine prior authorization requirements). A determination that additional information is needed (e.g., via DTR) is considered to be a valid response. §found-4?^crd-server-org^business:Where a CRD server responds with a coverage information extension indicating `doc-needed` of 'clinical', 'admin', or 'patient' and the payer supports DTR, the responsible organization **SHOULD** support gathering the additional information via DTR.§ This expectation is intended to change to 'SHALL' in a future release.

The expectation of CRD is that §found-5?^crd-server^exchange:CRD servers **SHOULD** query all data necessary to make their coverage determination decisions if that data is available for query in the EHR and that data is not returned in prefetch.§  Coverage determination decisions are whether the service is covered, whether prior authorization is required, and whether additional information needs to be gathered.  It is not acceptable for a CRD server to rely exclusively on DTR as a mechanism to retrieve data.  DTR is for data retrieval that requires human intervention or review.  There may be circumstances where time constraints prevent all needed data from being retrieved, in which case DTR retrieval of data that would not typically need human review may be necessary.  However, this should never be the design objective.  This query requirement may be tightened to 'SHALL' in a future release.

CRD servers are encouraged to leverage hooks fired earlier in the workflow (even if they do not provide decision support in response to those hooks) as an opportunity to begin caching relevant information for use when providing responses to later hooks. For example, when an 'Encounter Start' hook fires, the CRD server can retrieve and cache the patient's current coverage information and details about their specific plans, limits, etc. When an 'Order Select' fires, the service can cache information about coverage and authorization rules associated with the ordered service. Potentially relevant information such as past labs, prior therapies, or relevant diagnoses can also be retrieved from the EHR. As a result, when an 'Order Sign' or 'Order Dispatch' hook fires, the CRD server should have almost all information needed to render an immediate decision, allowing response times to be met much more easily.

§found-6^crd-client^ui:CRD clients **SHALL** provide a mechanism for providers to bypass a CRD process that is taking longer than the aforementioned time limit to ensure users are not blocked from proceeding with their business flow.§ Where a CRD client opts to not block users from proceeding for responses that come back in a period of time <span class="modified-content" markdown="1"><a name="FHIR-53607"> </a>longer</span> than the target time window in this guide (i.e., 5s or 10s), the client must ensure that users are made aware of the information when it is available. §found-7?^crd-client^exchange:For responses that come back in a time period that exceeds the time maximm duration specifd in this guide, CRD clients **MAY** ignore the resulting cards and/or system actions.§

<blockquote class="stu-note" markdown="1">
Payers and healthcare IT system vendors are both encouraged to provide feedback around whether this timing expectation strikes the appropriate balance between allowing appropriate decision support and allowing timely progress of workflow. This evaluation should consider what systems will need to be involved in the decision support process, what external calls might be needed, what caching strategies are viable, etc.
</blockquote>

### Accuracy
§found-8^crd-server^processing:CRD servers **SHALL** ensure that the guidance returned with respect to coverage and prior authorizations (e.g., assertions that a service is covered, or prior authorization is not necessary) is as accurate as guidance that would be provided by other means (e.g., portals, phone calls).§ §found-9^crd-server^exchange:Also, coverage and authorization guidance **SHOULD** allow for possible variances in coding and submission.§ (See [Impact on payer processes](implementation.html#impact-on-payer-processes) on the Implementation Considerations page.)

<div class="new-content" markdown="1"><a name="FHIR-52326"> </a>
§found-10^crd-server^storage,processing:CRD servers **SHALL** retain all coverage guidance provided and take into account answers provided via CRD (and DTR) when subsequently adjudicating claims.§  Contractual rules and/or regulations may require payers to adhere to (non-expired) assertions made in CRD unless the change is outside of payer control (e.g. change to patient coverage).  Also see the [CRD operational recommendations](operational.html) section.
</div>

### Terminology
When invoking CDS Hooks, resources reflecting the clinical/business representation of the order, appointment, encounter, etc. will be transmitted to the CRD server. These data representations will generally make use of codes to describe the type of service or product being ordered, booked, or performed. These codes will draw from the code systems used at this stage of the business process and will typically be clinical codes rather than billing codes. That said, it is always possible to send multiple codings within a CodeableConcept. §found-11?^crd-client^exchange:Where the selected code is not already a billing code and CRD clients are able to automatically determine what the corresponding billing code is, they **SHOULD** send a Coding with the billing code alongside the clinical code to reduce the risk of the receiving payer making a different translation.§

### Appropriate use of hooks
CDS Hooks are intended to improve healthcare provider care-planning processes by allowing relevant and useful information to be inserted into provider workflows. At the same time, inserting additional information into a provider's workflow will add cognitive load, even if the information is not acted upon, and therefore must be done judiciously.

§found-12^crd-server^processing:CRD servers **SHALL** ensure that CDS Hooks return only messages and information relevant and useful to the intended recipient.§

### CRD Servers
Payers may have multiple back-end functions that handle different types of decision support and/or different types of services. §found-13?^crd-server^exchange:If a CRD server supports [endpoint discovery]({{site.data.fhir.ver.hrex}}/endpoint-discovery.html), they **SHALL** have at most a single endpoint for each coverage (e.g., Medicare, Medicaid, or commercial) they provide coverage under.§ In FHIR, a coverage instance essentially corresponds with the identification information on an insurance card, irrespective of the types of coverage available under that card. §found-14?^crd-server^exchange:If a CRD server does not support endpoint discovery, they **SHALL** expose only one CRD endpoint capable of handling all coverages.§ All CRD requests for patient coverage, irrespective of type of service, will be sent to a single endpoint. CRD servers are free to route the information from their endpoint(s) to back-end services as needed. This routing may evolve over time and should have no impact on CRD client calls.

Initial setup of connectivity between client and payer will have a manual component to establish security credentials and a trust relationship (unless both parties are part of a shared trust network).  Dynamic endpoint discovery allows for the potential for the use of different endpoints for different coverages and/or evolution of what endpoints are used for different coverage over time without changing security credential or legal agreement expectations.

<a name="FHIR-49753"> </a>
<div class="new-content" markdown="1">
In the early stages of CRD adoption, CRD clients and services are likely to manually coordinate the rollout of new features.  However, the long-term goal is that, through QHINs or other trust networks, and/or certification, manual coordination will not be necessary.

§found-15^crd-client^processing:When the connection between a particular client and server has evolved to an automated configuration approach, CRD Clients **SHOULD** perform the discovery process on the CRD server at least once per day to detect any changes to supported hooks, prefetch requirements, and/or configuration options.§  §found-16?^crd-client^processing:If a CRD client encounters an error when invoking a hook, they **SHOULD** re-run the discovery process before failing.§  NOTE: Changes to CRD server capabilities will not necessarily be taken advantage of dynamically by the CRD client - i.e. manual steps might be necessary.
</div>

### Enabling a CRD Server
When a CRD client configures itself to support a payer's CRD server, it will need to identify which payer(s) the service supports. This is needed to ensure that the CRD client only sends CRD calls to services that the patient has current coverage for. The CRD server is responsible for any internal routing based on which processing organization handles the decisions. For this purpose, 'payer' means the organization listed on the member's insurance card.

§found-17^crd-client,crd-server^processing:CRD clients and servers **MAY** leverage the [payer registry](http://hl7.org/fhir/us/davinci-pdex-plan-net) developed by PDex (which will eventually fold into the [national directory under FAST](https://confluence.hl7.org/display/FAST/National+Healthcare+Directory)) as a means of determining which endpoints exist for which payers as candidates for configuration.§ §found-18?^crd-client^exchange:Once plans are in the national directory, CRD clients **SHOULD** include that plan identifier to uniquely identify a plan.§

All CRD clients will need to be configured to support communicating with a particular CRD server. This configuration process includes the following:

* Confirming that the CRD server can legitimately act on behalf of one or more payers
* Confirming that the CRD server can be trusted to receive and handle PHI
* Determining which hook(s) to enable for that CRD server
* Determining what scopes to provide the CRD server for access tokens issued to the service

To initiate this process, the payer responsible for a given CRD server must communicate with the relevant CRD client software vendor or provider organization and share the following information:

* The URL of their server
* Which hook types it supports
* What scopes it needs to perform its full function (and why)

<div class="new-content" markdown="1"><a name="FHIR-52326b"> </a>
Also, see the [Operational Recommendations](operational.html) section.
</div>

### CRD Access Tokens
<a name="FHIR-49742"> </a>
<p class="modified-content" markdown="1">§found-19^crd-client^exchange:When a CRD client invokes a CRD server via CDS Hooks, it **SHALL** provide an access token that allows the CRD server to retrieve additional patient information.§ The base rules for this token are defined in the [CDS Hooks specification]({{site.data.fhir.ver.cdshooks}}/index.html#passing-the-access-token-to-the-cds-service). This specification imposes some additional constraints:</p>

* §found-20^crd-client^processing:The CRD client **SHALL** limit the scopes provided in their access token as narrowly as feasible to reflect the data requirements identified by the CRD server as necessary to perform their decision support.§

* §found-21^crd-client^processing:Such access tokens **SHOULD** have an expiration time of no longer than 30 seconds which should be sufficient for even 'parallel' decision support with something like 'Order Select' where a user continues to work while the decision support call is processing.§

### Additional Data Retrieval
The context information provided as part of hook invocation will often not be enough for a CRD server to fully determine coverage requirements.
<p class="modified-content" markdown="1"><a name="FHIR-52784b"> </a>
There are two possible mechanisms that can be used by the service to gather additional information needed: 'prefetch' and querying the CRD client's FHIR API to retrieve additional resources. Both mechanisms are defined as part of the [CDS Hooks specification]({{site.data.fhir.ver.cdshooks}}/index.html#providing-fhir-resources-to-a-cds-service).
Expectations for support of both of these mechanisms are detailed in the subsections below.  Additional subsections cover error handling in situations where data access mechanisms do not work as required and general guidance for constructing queries.
</p>

#### Prefetch
<p class="new-content" markdown="1">
[Prefetch]({{site.data.fhir.ver.cdshooks}}/index.html#prefetch-template) is a mechanism CDS Hooks uses to allow a server to solicit a client to *always* provide certain information when they invoke a hook on the grounds that that information will *always* be relevant to the decision-support provided.  Prefetch reduces the amount of querying a server needs to perform and also reduces load on the client by allowing them to send information they often already have in memory rather than needing to respond to separate query calls.</p>

CRD relies on enhanced prefetch capabilities newly introduced in the ballot version of CDS Hooks on which this guide depends.  This enhanced mechanism allows the inclusion of a limitted set of FHIRPath in a manner similar to the [x-fhir-query](https://hl7.org/fhir/R5/fhir-xquery.html) syntax.  The details of how it works can be found in the CDS specification [here]({{site.data.fhir.ver.hooks}}/index.html#prefetch-tokens-containing-simpler-fhirpath).  <a name="FHIR-49128"> </a><a name="FHIR-52784c"> </a>
<span class="modified-content" markdown="1">§found-28^crd-client^processing:CRD Clients **SHALL** be able to parse and execute prefetches that use the simple FHIRPath approach and not fail if that syntax is present.§</span>

<div class="modified-content" markdown="1">
This specification identifies a set of key resources related to the hook context that will be needed by most CRD servers to provide mandated decision support.  These are:
*  Patient
*  Relevant Coverage
*  The request resource (if not included in the hook context)
*  Authoring Practitioner
*  Authoring Organization
*  Requested performing Practitioner (if specified)
*  Requested performing Organization (if specified)
*  Requested Location (if specified)
*  Associated Medication (if any)
*  Associated Device (if any)

Not all these will be relevant for all resource types and in some cases, may not be relevant for a given payer's decision support needs.  How these various concepts are represented and accessed varies by resource. Different resources have differently named data elements and search parameters for them. In some cases, support only exists as extensions or does not exist at all. Where necessary, this implementation guide defines additional extensions to support retrieval of these elements. The intention is for IG-defined extensions and search parameters to eventually migrate into the core FHIR specification.

Most of these resources are directly related to the request resource or encounter associated with the hook invocation.  The exception is the 'relevant coverage'.  While coverage can be filtered by patient and status, as mentioned in [Controlling Hook Invocation](deviations.html#controlling-hook-invocation), <a name="FHIR-48797"> </a><a name="FHIR-52784d"> </a>Coverage included in prefetch must be limited to a single instance reflecting the coverage relevant to the requests or encounter associated with the hook invocation.  How this happens is up to the CRD client.

<a name="FHIR-52444"> </a>§found-22^crd-client,crd-server^exchange:For this release of the IG, conformant CRD clients and servers **SHALL** support the CDS Hooks prefetch capability.§  <a name="FHIR-48771a"> </a><a name="FHIR-52784a"> </a>§found-23^crd-client^exchange:Clients **SHALL** be able to supply the information listed in the bullets above via prefetch for the request resources they support when data exists using the search parameters and FHIRPath expressions covered in the [standard prefetch](#standard-prefetch) section below.§

Each CRD server will define the prefetch requests for their CRD server based on the information they require to provide coverage requirements. §found-25^crd-server^exchange:They **MAY** include more and/or less prefetch requests than described in 'standard' prefetch section below, based on which data is desired.§ §found-26^crd-server^exchange:Prefetch requests **SHOULD** only include information that is always expected to be needed for each hook invocation.§ §found-27?^crd-server^exchange:When information is only needed for certain invocations of the hook (e.g., for specific types of medications or services), that information **SHOULD** only be retrieved by query using the provided token, not requested universally via prefetch.§ Not all CRD clients will support prefetch requests that go beyond the standard set of prefetches listed below.

##### Standard Prefetch
The prefetch instance below shows the set of prefetch queries necessary to retrieve the related resources that need to be supported by CRD clients as discussed in the conformance statements above.  It covers all hooks and all CRD-supported resource types and thus is more comprehensive than what will necessarily be requested by a given CRD service.  §found-24?^crd-server^exchange:Servers **SHALL** use prefetch expressions in the manner described if those data elements are relevant to their coverage determination or other decision support.§  §found-29^crd-client^processing:CRD client implementations **SHOULD NOT** depend on standardized prefetch key names.§ §found-30^crd-client^processing:CRD clients supporting prefetch **SHALL** inspect the CDS Hooks discovery endpoint to determine exact prefetch key names and queries.§

NOTE: Some of the prefetch queries are quite long.  The set of places where relevant practitioners could be found is quite large.  However, for a given order, the number that will actually be relevant will be small and in many cases, the same practitioner will be referenced in more than one place, further reducing the amount of data actually returned.

###### Appointment Book Prefetch
<p>
  <button class="btn btn-info " type="button" title="Click to Show or hide Prefetch JSON" data-toggle="collapse" data-target="#appointment-book-prefetch-json" aria-expanded="false" aria-controls="collapseExample">
    Click to Show or hide Prefetch JSON
  </button>
</p>
<div class="collapse" id="appointment-book-prefetch-json">
{% raw %}
{% fragment Binary/CRDServices JSON EXCEPT: services.where(hook='appointment-book') EXCEPT: hook | prefetch BASE: services %}
{% endraw %}
</div>

###### Encounter Start Prefetch
<p>
  <button class="btn btn-info " type="button" title="Click to Show or hide Prefetch JSON" data-toggle="collapse" data-target="#encounter-start-prefetch-json" aria-expanded="false" aria-controls="collapseExample">
    Click to Show or hide Prefetch JSON
  </button>
</p>
<div class="collapse" id="encounter-start-prefetch-json">
{% raw %}
{% fragment Binary/CRDServices JSON EXCEPT: services.where(hook='encounter-start') EXCEPT: hook | prefetch BASE: services %}
{% endraw %}
</div>

###### Encounter Discharge Prefetch
<p>
  <button class="btn btn-info " type="button" title="Click to Show or hide Prefetch JSON" data-toggle="collapse" data-target="#encounter-discharge-prefetch-json" aria-expanded="false" aria-controls="collapseExample">
    Click to Show or hide Prefetch JSON
  </button>
</p>
<div class="collapse" id="encounter-discharge-prefetch-json">
{% raw %}
{% fragment Binary/CRDServices JSON EXCEPT: services.where(hook='encounter-discharge') EXCEPT: hook | prefetch BASE: services %}
{% endraw %}
</div>

###### Order Dispatch Prefetch
<p>
  <button class="btn btn-info " type="button" title="Click to Show or hide Prefetch JSON" data-toggle="collapse" data-target="#order-dispatch-prefetch-json" aria-expanded="false" aria-controls="collapseExample">
    Click to Show or hide Prefetch JSON
  </button>
</p>
<div class="collapse" id="order-dispatch-prefetch-json">
{% raw %}
{% fragment Binary/CRDServices JSON EXCEPT: services.where(hook='order-dispatch') EXCEPT: hook | prefetch BASE: services %}
{% endraw %}
</div>

###### Order Select Prefetch
<p>
  <button class="btn btn-info " type="button" title="Click to Show or hide Prefetch JSON" data-toggle="collapse" data-target="#order-select-prefetch-json" aria-expanded="false" aria-controls="collapseExample">
    Click to Show or hide Prefetch JSON
  </button>
</p>
<div class="collapse" id="order-select-prefetch-json">
{% raw %}
{% fragment Binary/CRDServices JSON EXCEPT: services.where(hook='order-select') EXCEPT: hook | prefetch BASE: services %}
{% endraw %}
</div>

###### Order Sign Prefetch
<p>
  <button class="btn btn-info " type="button" title="Click to Show or hide Prefetch JSON" data-toggle="collapse" data-target="#order-sign-prefetch-json" aria-expanded="false" aria-controls="collapseExample">
    Click to Show or hide Prefetch JSON
  </button>
</p>
<div class="collapse" id="order-sign-prefetch-json">
{% raw %}
{% fragment Binary/CRDServices JSON EXCEPT: services.where(hook='order-sign') EXCEPT: hook | prefetch BASE: services %}
{% endraw %}
</div>

NOTE: support for access to resources and using the search parameters listed above as part of prefetch does NOT necessarily mean the CRD client will support those same search capabilities via their RESTful API.  RESTful API expectations are set by US Core, not this IG.
</div>

#### FHIR Resource Access
If information needed is not provided by prefetch, the CRD server can query the client directly using the [FHIR resource access]({{site.data.fhir.ver.cdshooks}}/index.html#fhir-resource-access) mechanism defined in the CDS Hooks specification.

This can be done either by using individual queries or by invoking a batch of separate queries. In either case, the HTTP call that performs the query or executes the batch must pass the `fhirAuthorization.access_token` in the authorization header as defined in the [CDS Hooks specification]({{site.data.fhir.ver.cdshooks}}/index.html#fhir-resource-access).  (Note that if the CRD client does not support _include, it may be necessary to perform separate queries in sequence to retrieve related resources.)

#### Error Handling
The use of an HTTP 412 response to the CDS Hooks invocation is for situations where the requested prefetch was not provided and the CRD server was unable to invoke the queries itself.  §found-32^crd-server^processing:HTTP 412 responses **SHALL NOT** be used in situations where the prefetch was provided or the query was successfully performed but the record in question did not have all the data the payer might have needed/desired.§  Indicating additional information through DTR is the preferred approach when managing situations where the needed information is not queryable from the EHR.  Similarly, HTTP 4xx or 5xx responses are only appropriate if there was an internal failure of the service, not if the payer business rules for "needed data" were not met.  Error codes indicate that there is a technical issue that should be fixed.

<a name="FHIR-49909"> </a>
<p class="new-content" markdown="1">New versions of CDS Hooks may introduce additional data elements into any of the CRD request and response structures.  In addition, CDS Hooks allows the definition of arbitrary extension elements in several locations within its data structures.  It is possible that some parties to a CRD exchange may migrate to a newer CDS Hooks version and/or include extensions intended for use by other consumers and that there may therefore be elements present in an instance that are unexpected.  §found-33^crd-client,crd-server^exchange:CRD clients and servers **SHALL** ignore unexpected elements when processing instances.§</p>

#### Query Notes

* <span class="modified-content" markdown="1"><a name="FHIR-49833"> </a>Executing queries using the _include mechanism will bring back some redundant information such as information that was already known to the CRD client and included in the request. For example, if retrieving conditions and allergies, the same Practitioners might be included in both sets of queries.  This redundancy is the cost of using the _include mechanism. CRD servers seeking greater efficiency can perform direct queries that are more tuned at the cost of needing to make multiple service calls.</span>

* Queries use the defined search parameter names from the respective FHIR specification versions. If parties processing these queries have varied from these standard search parameter names (as indicated by navigating their CapabilityStatements), the CRD server will be responsible for translating the parameters into the CRD client's local names. For example, if a particular CRD client's CapabilityStatement indicates that the parameter name (that corresponds to HL7's Encounter search criteria) is named 'visit' on the client's server, the service will have to construct its search URL accordingly.

* While CRD server-initiated queries attempt to bring back all the potentially relevant information, not all information will necessarily exist for all requests or events, particularly at the time the hook is called. §found-34^crd-server^processing:CRD servers **SHALL** provide what coverage requirements they can based on the information available.§

* When processing data from query responses, always check the 'self' link to ensure that the server executed what was requested and processed the data as necessary - or try querying by a different mechanism (e.g. multiple queries rather than relying on `_include`).

<div class="modified-content" markdown="1"><a name="FHIR-52739"> </a>
### What-if Hook Invocation
In addition to the real-time decision support provided by CDS Hooks, providers will sometimes need to seek coverage requirements information without invoking the workflow of their provider system to actively create an order, appointment, encounter, etc. A few real-world examples where hooks may be invoked this way include exploring a "what if" scenario, answering a patient question related to whether a service would be covered, and retrieving a guidance document they had seen in a previous card.

The only difference between a 'regular' hook invocation and a 'what if' hook invocation is the limitations on the types of responses the client wants back.  For example, it would typically be inappropriate to receive an authorization number.  §found-35^crd-client^exchange:In the specific case of order-based hooks, "what if" **SHOULD** use the Order Sign hook but **SHALL** use the configuration option that prevents the return of an unsolicited determination and **MAY** use configuration options to prevent the return of other irrelevant types of cards (e.g., duplicate therapy).§
</div>

### Additional Considerations
1. §found-36^crd-client^exchange:When CRD clients pass resources to a CRD server as part of context, the resources **SHALL** have an 'id' and that 'id' **SHALL** be usable as a target for references in resources manipulated by CDS Hooks actions and/or by SMART apps.§ This does not mean that the IDs passed to CRD server must persist, but rather that the CRD client must handle adjustments to any references made to them (or provide necessary redirects) ensuring that any references made to the in-memory resource will remain valid. This also means that CRD clients will need to support the creation or updating of resources that include references to resources that might, at the time, only exist in memory and not yet be available as persistent entities.

2. The receipt of coverage requirements (be it "no requirements" or specific requirements or recommendations) has financial implications for both healthcare providers and payers. If a provider receives a message of "no requirements" and subsequently has a claim denied because of unmet requirements, it will be necessary for both sides to be able to confirm whether a "no requirements" response was sent and what information was in the hook invocation that led to that response. §found-37^crd-client,crd-server^storage:Therefore, in addition to any logging performed for security purposes, both CRD clients and CRD servers **SHALL** retain logs of all CRD-related hook invocations and their responses for access in the event of a dispute.§ Systems can use the `suggestion.uuid` element to aid in log reconciliation. §found-38^crd-client-org,crd-server-org^business:Organizations **SHALL** have processes to ensure logs can be accessed by appropriate authorized users to help resolve discrepancies or issues in a timely manner.<br/><br/>NOTE: Because the information in these logs will often contain PHI, access to the logs themselves will need to be restricted and logged for security purposes.§

3. CRD clients that invoke CDS hooks multiple times during the creation, editing, and review phase are responsible for managing the resulting cards and determining what to display to the user. §found-39^crd-client^ui:CRD clients **SHOULD** ensure that multiple cards with the same advice are handled in a way that will not create a burden on the user.§

4. Most implementation guides provide JSON, XML, and Turtle representations of artifacts. However, because this guide is primarily using CDS Hooks (which only supports JSON) and SMART on FHIR (which primarily uses JSON), this implementation guide only publishes the JSON version of artifacts.

5. The examples in this guide use whitespace for readability. §found-40^crd-client,crd-server^exchange:Conformant systems **SHOULD** omit non-significant whitespace in transmitted instances for performance reasons.§

6. Examples provided within this specification strive to be realistic but might not reflect accurate/current coverage requirements.
