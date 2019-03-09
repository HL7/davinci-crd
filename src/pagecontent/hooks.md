This section of the implementation guide defines the specific conformance requirements for systems wishing to conform to this Coverage Requirements Discovery implementation guide.  The bulk of it focuses on the implementation of  the [CDS Hooks Specification](https://cds-hooks.hl7.org/specification/1.0) to meet CRD use-cases.  It also describes the use of [SMART on FHIR](http://hl7.org/fhir/smart-app-launch) and provides guidance on privacy, security and other implementation requirements.


### Context

#### Pre-reading
Before reading this formal specification, implementers should first familiarize themselves with two other key portions of the specification:

* The [Use Cases & Overview](usecases.html) page provides context for what this formal specification is trying to accomplish and will give a sense of both the business context and general process flow enabled by the formal specification below.

* The [Technical Background](background.html) page provides information about the underlying specifications and indicates what portions of them should be read and understood to have necessary foundation to understand the constraints and usage guidance described here.


#### Conventions
This implementation guide uses specific terminology to flag statements that have relevance for the evaluation of conformance with the guide:

* **SHALL** indicates requirements that must be met to be conformant with the specification.

* **SHOULD** indicates behaviors that are strongly recommended (and which may result in interoperability issues or sub-optimal behavior if not adhered to) but which do not, for this verion of the specification, affect the determination of specification conformance.

* **MAY** describes optional behaviors that are free to consider but where the is no recommendation for or against adoption.


#### Systems

This implementation guide sets expectations for two types of systems:

* **Client** systems are electronic medical records, pharmacy systems and other clinical and administrative systems responsible for the ordering and execution of patient-related services.  These are systems whose users have a need for coverage requirements information
* **Payer** systems are systems run by insurers, clearing houses and other organizations that make or enforce the rules around insurance coverage and can provide coverage information related to one or more insurance plans with respect to proposed healthcare products and services

The requirements and expectations described here are not intended to be exhaustive.  Payers and clients could potentially support additional hooks, additional card patterns, additional resources, additional extensions, etc.  The purpose of this implementation guide is to establish a baseline of expected behavior that communication partners can rely on and then build from.  Future versions of this specification will evolve based on implementer feedback.


#### Profiles
This specification makes significant use of [FHIR profiles]({{site.data.fhir.path}}profiling.html), search parameter definitions and terminology artifacts to describe the content to be shared as part of CDS Hook calls.  The implementation guide supports two versions of FHIR: [STU3](http://hl7.org/fhir/STU3) and [R4]({{site.data.fhir.path}}) and profiles for both are listed for each type of hook.  This version of the specification does not (yet) provide guidance for DSTU2 resources.

The full set of profiles defined in this implementation guide can be found by following the links on the [Artifacts](allartifacts.html) page.


#### US Core
This implementation guide also leverages the [US Core](http://hl7.org/fhir/us/core) set of profiles defined by HL7 for sharing non-veterinary EMR individual health data in the U.S.  Where US Core profiles exist, this Guide either leverages them directly or uses them as a base for any additional constraints needed to support the coverage requirements discovery use-case for STU3 profiles.  If no constraints are needed, this IG doesn't define any profiles.  However, all US Core profiles are deemed to be part of this IG and available for use in CRD communications.  For example, the Observation and Condition profiles, which are likely to be of interest in at least some CRD scenarios.

Where US Core profiles do not yet exist (e.g. for several of the 'Request' resources), profiles have been created that try to align with existing US Core profiles in terms of elements exposed and terminologies used.  The US Core implementation guide for R4 is not yet finalized.  However, the draft R4 profiles have been referenced where appropriate.

There is one exception to the use of or alignment with US Core profiles.  The [non-PHI](#non-phi-hook-invocation) interfaces are not based on US Core because the US Core profiles expect support for and sometimes demand the sharing of patient-identifying information.

Note that in some cases the US Core profiles require the support of data elements that may not be relevant to the coverage requirements discovery use-case.  It was felt that leveraging existing standard interfaces would promote greater (and quicker) interoperability than a more tuned custom interface.  EMR systems may still choose to restrict what information is exposed to payer systems based on their internal data access and governance rules.


### CDS Hooks

#### CDS Hooks Customization
CDS Hooks is a relatively new technology and, at the time this version of the implementation guide was written, has not yet been officially published as a first release.  It is considered a "Standard for Trial Use" (STU), meaning that it will continue to evolve based on implementer feedback and may change in ways that are not compatible with the current draft.  As well, the initial version of the CDS Hooks specification has focused on the core architecture and a relatively simple set of capabilities.  Additional capabilities will be introduced in future versions.

To meet requirements identified by Da Vinci project participants, it is necessary to introduce additional capabilities above and beyond what is currently found in the CDS Hooks specification.  This section of the CRD implementation guide describes those additional capabilities and the mechanism the implementation guide proposes to implement them.  The purpose of these customizations is to enable testing at connectathons and to support feedback into the CDS Hooks design process.

Each capability listed here has been proposed to the CDS Hooks community and may become part of the official specification in a future release.  However, there is a significant likelihood that the manner in which the requirements are met may vary from a syntax or even an architectural approach.  Future versions of this implementation guide will be updated to align with how these requirements are addressed in future versions of the CDS Hook specification.  Until the both the CDS Hooks content and the FHIR and US Core content underlying this specification is *Normative* (locked into backward compatibility mode), the CRD implementation guide will remain as STU.

This implementation guide extends/customizes CDS Hooks in 4 ways: additional hook resources, a hook configuration mechanism, additional pre-fetch capabilities and additional response capabilities.  Each are described below:


##### Hook resources
Two of the hooks used by this specification (_order-select_ and _order-sign_) identify specific "order" resources that can be passed as part of the hook invocation.  CRD has use-cases for additional resource types to be passed to this hook.  Specifically:

* [DeviceRequest]({{site.data.fhir.path}}devicerequest.html) - Needed to trigger CRD when ordering prosthetics, wheelchairs, CPAP devices and other types of durable medical equipment

* [CommunicationRequest]({{site.data.fhir.path}}communicationrequest.html) - providers often impose charges to transfer patient data to external organizations and agencies.  Some of these charges can be covered by a patient's insurance and be subject to coverage requirements

* [Task]({{site.data.fhir.path}}task.html) - Task is used to seek fulfillment of orders from particular service providers.  Because coverage can be influenced by who is asked to perform an order, coverage requirements can be relevant here.  As well, task is used to request changes to existing therapies (e.g. stopping a medication, suspending a therapy, etc.) and changes to therapy can also have impacts on coverage requirements.

The proposal to add these resources to the existing hook definitions [can be found]() on the CDS hooks [issue tracker]().


##### Configuration
Each CDS Hook service provided by a payer might support multiple different types of coverage requirements checking.  For example, a payer might return information about:

*  Is prior authorization required?
*  Are there recommended alternative therapies?
*  Are there best practices associated with this therapy that are expected to be adhered to?
*  Are there documentation requirements?
*  Are there forms required for inclusion with prior authorization?
*  Are there forms required for inclusion with claims submission?

Not all cards will be relevant to all users. It might be possible to configure a service to withhold certain card types from certain practitioner roles, the servicing provider, or specific users.  However, doing so will create process challenges to manage such customization requests and would place a considerable configuration burden on payer software. An alternative would be for the payer to host a distinct service for every single card type it is able to return, but this could result in the payer receiving 10+ service calls each time the hook fired and performing considerable redundant processing in each service. Ideally, each specific hook invocation would indicate what subset of response types were wanted. The client system could then dynamically configure the response types based on user type, individual user, location within the workflow where the hook was being fired, whether the hook had previously been fired, etc.

At this time, it is not clear whether this capability will be of interest to EHR systems or other types of decision support services. Therefore, rather than proposing a change to the base CDS Hook specification, this IG will leverage the CDS Hook extension mechanism.  Connectathon and implementation experience may support requesting these changes or some variant of them in a future version of the CDS Hook specification.

Extensions will be enabled in two places:

1.  On the [CDS Service Discovery Response](https://cds-hooks.org/specification/1.0/#response) object describing the service's capabilities will be an extension that describes what "configuration options" can be set
2.  On the hook's [HTTP Request](https://cds-hooks.org/specification/1.0/#http-request_1) object passing specific configuration settings as part of the hook invocation


###### Configuration options
The extension here will be called `davinci-crd.configuration-options`.  It will be a configuration object that will contain an array of available options.  Each option will include four mandatory elements:

*  A `code` that will be used when setting configuration during hook invocation
*  A data `type` for the parameter.  At present, allowed values are "boolean" and "integer" (NOTE: These are the JSON data types and not the FHIR data types.)
*  A display `name` for the configuration option to appear in the client's user interface when performing configuration
*  A `description` providing a 1-2 sentence description of the effect of the configuration option

For example, a [CDS Service](https://cds-hooks.hl7.org/specification/1.0/#response) within a Discovery Response might look like this:

{% raw %}
    {
      "hook": "order-select",
      "title": "Payer XYZ Order Selection Requirements",
      "description": "Indicates coverage requirements associated with draft orders, including expectations for prior authorization, recommended therapy alternatives, etc.",
      "id": "order-select-crd",
      "prefetch": {
        "patient": "Patient/{{context.patientId}}",
        "medications": "MedicationOrder?patient={{context.patientId}}"
      },
      "extension": {
        "davinci-crd.configuration-options": [
          {
            "code": "priorauth",
            "type": "boolean",
            "name": "Prior authorization",
            "description": "Provides indications of whether prior authorization is required for the proposed order"
          },
          {
            "code": "prior-auth-form",
            "type": "boolean",
            "name": "Prior Authorization Forms",
            "description": "Indicates any forms that should be completed as part of a prior authorization process"
          },
          {
            "code": "alt-drug",
            "type": "boolean",
            "name": "Alternative therapy",
            "description": "Provides recommendations for alternative therapy with equivalent/similar clinical effect for which the patient has better coverage, that will incur lesser cost"
          },
          {
            "code": "first-line",
            "type": "boolean",
            "name": "First-line therapy",
            "description": "Provides alternative therapies that must be tried prior to the selected medication to receive coverage for the selected medication"
          },
          {
            "code": "max-cards",
            "type": "integer",
            "name": "Maximum cards",
            "description": "Indicates the maximum number of cards to be returned from the service.  The services will prioritize cards such as highest priority ones are delivered"
          }
        ]
      }
    }
{% endraw %}

Notes: 

*  This version of the implementation guide is not proposing to standardize the codes, names, types or descriptions for payer response types.  This is something that could be considered for future implementation guides once it is clear what groupings of response types are useful to enable/disable together - and which response types should be configurable at all.

*  There is no mechanism to express co-occurrence rules amongst configuration options.  Guidance can be given about allowed combinations in descriptions, but payer services **SHALL** gracefully handle disallowed/nonsensical combinations.  I.e. the payer system should:

**  allow for the possibility that EHR systems might not adhere to their co-occurrence rules,

**  include explicit checks of inbound data for adherence to rules; and

**  indicate that CRD checking could not be done and log appropriate information to allow engagement with EHR systems to address any payer-specific needs.

*  No default values are declared as the default might vary by client or other contextual information based on server configuration

*  Codes **SHALL** be valid JSON property names

*  Codes, names and descriptions **SHALL** be unique within a [CDS Service](https://cds-hooks.hl7.org/specification/1.0/#response) definition.  They **SHOULD** be consistent across different hooks supported by the same payer when dealing with the same types of configuration options.

Payer services providing more than one type of coverage requirement information/guidance **SHOULD** expose configuration options allowing clients to dynamically control what information is returned by the service.


###### Hook configuration
When invoking a hook, the client system can convey any supported configuration options as part of the invocation of the hook.  This will be done using the davinci-crd.configuration extension.  It will be a single object whose properties will be drawn from the `code` values from configuration options and whose values will be of the `type` defined for that option.

For example, the hook [HTTP Request](https://cds-hooks.hl7.org/specification/1.0/#http-request_1) would look like this:

    {
       ...
       "hook" : "order-select",
       ...
       "extension" : {
         "davinci-crd.configuration" : {
           "prior-auth": true,
           "alt-drug": false,
           "max-cards": 5
         }
       }
    }

Notes:

*  This specification provides no guidance on exactly when/how hook clients should manage hook configuration.  This could be done at the level of practitioner roles, individual practitioners, location from which the hook is invoked or other means.  Clients can experiment and determine what types of configuration make the most sense and at what levels they can support managing/persisting configuration information.

*  Inclusion of configuration information in a hook call **SHALL** be optional (i.e. no hook invocation is permitted to fail because configuration information was not included).

*  Payer systems may receive configuration information that they do not support.  In this case, the payer system **SHALL** ignore the unsupported configuration information.


EMR client systems **SHOULD** provide an ability to leverage the dynamic configuration capabilities of payer services based on practitioner role, individual practitioner and/or hook invocation location as best meets the needs of their providers.


##### Additional Pre-fetch capabilities
One of the options supported in CDS Hooks is the ability for a service to request that certain data be [prefetched](https://cds-hooks.hl7.org/specification/1.0/#prefetch-template) for efficiency reasons and to simplify processing for the server.  However, there is a limit in that in the current CDS Hooks specification, prefetch can only use hook context information that is expressed as a simple key value.  It cannot leverage context information passed as resources.

A [proposal](https://github.com/cds-hooks/docs/issues/377) has been submitted suggesting how to address this issue.  This ballot version of the implementation guide pre-adopts that proposal.

Specifically, where a hook defines a context element that consists of a resource or collection of resources (e.g. [order-select.draftOrders](https://cds-hooks.hl7.org/hooks/order-select/#context) or [order-sign.draftOrders](https://cds-hooks.hl7.org/hooks/order-sign/#context)), systems **SHALL** recognize context tokens of the form `context.<context property>.<FHIR resource name>.id` in prefetch queries.  Those tokens **SHALL** evaluate to a comma-separated list of the identifiers of all resources of the specified type within that context key.

Note: Recognizing these tokens doesn't mean the client must support prefetch or the requested prefetch query, only that it recognizes the token, doesn't treat it as an error and - if it supports the query - substitutes the token correctly.

For example, a prefetch for `order-select` might look like this:

{% raw %}
    "prefetch": {
      "ins-sr": "ServiceRequest?_id={{context.draftOrders.ServiceRequest.id}}&_include=ServiceRequest:insurance"
    }
{% endraw %}

This might result in an executed query that looks like this: `ServiceRequest?_id=2347,10948,5881&_include=ServiceRequest:insurance`

BALLOT NOTE: This proposed pre-adoption is not CDS Hooks conformant.  It is possible that the CDS Hooks community will adopt an alternative solution or may even choose not to make any changes.  Community discussion about this proposal can be found on the CDS Hooks issue list [here](https://github.com/cds-hooks/docs/issues/377).  This implementation guide will be updated to align with the decision of the community and may, if necessary, fall back to the use of extensions if CDS Hooks does not choose to support prefetch based on context resources and the payer community determines that prefetch is still required.

In addition to this preadoption, this implementation guide presumes support for prefetch query capabilities more sophisticated than the recommended [prefetch query restrictions](https://cds-hooks.hl7.org/specification/1.0/#prefetch-query-restrictions) in the CDS Hooks specification.  Specifically, the use of [_include]({{site.data.fhir.path}}search.html#include), as seen in the example above.


##### Additional response capabilities
CDS Hooks supports suggestions that involve multiple actions.  Coverage requirements discovery uses this in two situations where additional capabilities will be needed:

*  Creating a Task to complete a Questionnaire
*  Updating the proposed order to point to a "new" prior authorization (ClaimResponse instance) - one the payer was aware of that the EMR was not.

In the first case, the creation of the Questionnaire needs to be conditional - it should only occur if that specific Questionnaire version doesn't already exist.  In the second case, the order will need to be updated to point to the "id" assigned by the EMR to the newly persisted ClaimResponse instance.  Both of these capabilities are supported in FHIR's [transaction]({{site.data.fhir.path}}http.html#transaction)  functionality.  However, not all the capabilities/guidance included there has been incorporated into CDS Hooks 'suggestions', in part to keep the specification simpler.

For this release of the implementation guide, these requirements will be handled as follows:

###### if-none-exist
The `suggestion.action` object will use an extension to carry the if-none-exist query as per FHIR's [conditional create]({{site.data.fhir.path}}http.html#ccreate) functionality.  The extension property will be `davinci-crd.if-none-exist`.  

For example, this [CDS Hook Suggestion](https://cds-hooks.hl7.org/specification/1.0/#suggestion) contains two [Actions](https://cds-hooks.hl7.org/specification/1.0/#action) - one referencing an HL7 [Questionnaire]({{site.data.fhir.path}}questionnaire.html) and the other the [Task]({{site.data.fhir.path}}task.html) to complete the Questionnaire.  The Questionnaire will only be created if it didn't already exist:

    "suggestions": [
      {
        "label": "Add 'completion of the XYZ form' to your task list (possibly for reassignment)",
        "actions": [{
          "type": "create",
          "description": "Add version 2 of the XYZ form to the EMR's repository (if it doesn't already exist)",
          "resource": {
            "resourceType": "Questionnaire",
            "url": "http://example.org/Questionnaire/XYZ",
            "version": "2",
            ...
            },
          },
          "extension" : {
            "davinci-crd.if-none-exist" : "url=http://example.org/Questionnaire/XYZ&version=2"
          }
        },{
          "type": "create",
          "description": "Add 'Complete XYZ form' to the task list",
          "resource": {
            "resourceType": "Task",
            "instantiatesCanonical": "http://example.org/Questionnaire/XYZ|2",
            "basedOn": "MedicationRequest/5"
            "status": "ready",
            "intent": "order",
            "code": {
              "coding": [{
                "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/task-type",
                "code": "complete-questionnaire"
              }]
            },
            "description": "Complete XYZ form for inclusion in prior authorization",
            "for": {
              "reference": "Patient/some-patient-id"
            },
            "authoredOn": "2018-08-09",
            "reasonCode": {
              "coding": [{
                "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/task-reason",
                "code": "prior-auth",
                "display": "Needed for prior authorization"
              }]
            }
          }
        }]
      }
    ]

###### Linkage between created resources
The linkage between resources by identifier in different Actions within a single Suggestion doesn't require any extension to CDS Hooks, but it does require additional guidance.  For the purposes of this implementation guide, the inclusion of the `id` element in 'created' resources and references in created and updated resources within multi-action suggestions **SHALL** be handled as per FHIR's [transaction processing rules]({{site.data.fhir.path}}http.html#trules), treating each requested action as being an entry in a FHIR transaction bundle where the base URL is the base URL of the EMR server.  POST corresponds to an `action.type` of 'create' and PUT corresponds to an action.type of 'update'.  Specifically, this means that if a FHIR Reference points to the resource type and identifier of a resource of another 'create' Action in the same Suggestion, then the reference to that resource **SHALL** be updated by the server to point to the identifier assigned by the client when performing the create.  Clients **SHALL** perform creates in an order that ensures that referenced resources are created prior to referencing resources.

For example, the following [CDS Hook Suggestion](https://cds-hooks.hl7.org/specification/1.0/#suggestion) will cause the FHIR [MedicationRequest]({{site.data.fhir.path}}medicationrequest.html) to be updated to point to the prior authorization ([ClaimResponse]({{site.data.fhir.path}}claimresponse.html) resource) being created.  The ClaimResponse would be created before the MedicationRequest would be updated:

    "suggestions": [
      {
        "label": "Update prescription to point to pre-existing prior authorization",
        "actions": [{
          "type": "update",
          "description": "Revise the prescription to include the prior authorization",
          "resource": {
            "resourceType": "MedicationRequest",
            ...
            "insurance": [{
              "reference": "ClaimResponse/cr1"
            }],
            ...
          },
        },{
          "type": "create",
          "description": "Record the pre-existing prior authorization in the EMR",
          "resource": {
            "resourceType": "ClaimResponse",
            "id": "cr1",
            "status": "active",
            "type": {
              "coding": [{
                "system": "http://terminology.hl7.org/CodeSystem/claim-type",
                "code": "pharmacy"
              }]
            }
          },
          "use": "preauthorization",
          "patient": {
            "reference": "Patient/some-patient-d"
          },
          "outcome": "complete",
          "preAuthRef": ["ABCDE"]
        }]
      }
    ]

Note: Sending existing prior authorizations is not in scope for this version of the IG.


#### CDS Hooks
Each CDS Hook defines a workflow/business process location within the client system where a specific type of decision support is relevant.  For example, the `order-select`  
hook fires whenever a user is in the process of creating new orders or referrals.  In many clients, the same hook might fire in multiple locations.  For example, an EMR might have different screens for ordering regular medications vs. vaccinations vs. chemotherapy, not to mention distinct screens for lab orders, imaging orders and referrals.  The same hook might be initiated from all these locations.

This version of the implementation guide has identified five hooks that cover the main situations where coverage requirements discovery is likely to be needed: [appointment-book](#appointment-book), [encounter-start](#encounter-start), [encounter-discharge](#encounter-discharge), [order-select](#order-select), and [order-sign](order-sign).

Not all client systems will support all hook types.  For example, community EMR systems will not likely support `encounter-discharge`.  Community pharmacy systems would not likely support `appointment-book`.  Client systems conforming to this implementation guide **SHALL** support at least one of the hooks listed below and **SHOULD** support all that apply to the context of their system.

Similarly, not all payers will necessarily provide coverage that is relevant to all hook types.  For example, a payer that only provides drug coverage would never have coverage information to return on an `encounter-discharge` event.  Payer systems conforming to this implementation guide **SHALL** provide a service for at least one of the hook types listed below and **SHOULD** support all hooks relevant to the types of coverage they provide.

Clients and payers **MAY** choose to support additional hooks that are relevant to Coverage Requirements Discovery as well - both hooks appearing in the registry on the [CDS Hooks website](https://cds-hooks.org) and custom hooks defined elsewhere.  If this occurs, they **SHOULD** adhere to the same expectations as defined in this specification for those hooks listed here.

In the absence of guidance from the CDS Hooks specification, the Server systems are expected to conform to the following rules when responding to requests from a client system:

* If the Server system encounters a error when processing the request, the system **SHALL** return an appropriate error HTTP Response Code, starting with the digit "4" or "5", indicating that there was an error. 
* The payer **SHOULD** provide an OperationOutcome for internal issue tracking by the client system. 
* The client **SHOULD** display to the user that the Server Coverage Requirements Discovery Service is unavailable.
* While any 4xx or 5xx response code could be raised, the Server **SHALL** use the 400 and 422 codes in a manner consistent with the FHIR RESTful Create Action, specifically:
    * 400 - Bad Request - The request is not parsable as JSON
    * 422 - Unprocessable Entity - The request is valid JSON, but is not conformant to CDS Hooks, FHIR Resources or required profiles

The following sections describe the hooks covered by this implementation guide and describes any constraints, profiles and R4 resources expected to be supported by conformant implementations.

The hooks listed on the CDS hooks website are subject to update by the community at any time until they go through the ballot process.  However, all substantive changes are noted in the _changes_ section at the bottom of each hook.  For each hook listed below, this specification identifies a specific version.  For the sake of interoperability, implementers are expected to adhere to the interface defined in the specified version of each hook, though compatible changes from future versions can also be supported.  Servers **SHALL** handle unrecognized context elements by ignoring them.

##### appointment-book
This hook is described in the CDS Hook specification [here](https://cds-hooks.hl7.org/hooks/appointment-book).  This version of the CRD implementation guide refers to version 1.0.

This hook would be triggered when a provider books a future appointment for the patient with themselves or their own organization as well as when they book an appointment for a patient with someone else.  (Whether the workflow will be one of creating an appointment or creating a ServiceRequest - and triggering the 'order' hooks - may vary depending on both the service and the organizations involved.)

Potentially relevant CRD advice related to this hook might include:

* Requirements related to the intended location and/or participants (e.g. warnings about out-of-network)

* Requirements related to the service being booked (e.g. is prior authorization needed?, is the service covered?, is the indication appropriate?, is special documantation required?)

* Requirements related to the timing of the service (e.g. is the coverage still expected to be in effect? is the service too soon since the last service of that type?

* Reminders about additional services that should be scheduled or booked for the same patient - either as part of the scheduled encounter or as part of additional appointments that could be created at the same time.

While this hook supports useIds of Patient and RelatedPerson, for CRD purposes it is sufficient to support Practitioner and PractitionerRole.  Support for Patient and RelatedPerson as users is optional.  (Note that Practitioner includes both licensed healthcare professionals as well as administrative staff.)

The profiles expected to be used for the resources resolved to by the userId, patientId and encounterId and in the `appointments` context elements are as follows:
<table class="grid">
  <thead>
    <tr>
      <th>STU3 Profile</th>
      <th>R4 Profile</th>
    </tr>
  </thead>
  <tr>
    <td><a href="STU3/profile-appointment-stu3.html">profile-appointment-stu3</a></td>
    <td><a href="profile-appointment-r4.html">profile-appointment-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-encounter-stu3.html">profile-encounter-stu3</a></td>
    <td><a href="profile-encounter-r4.html">profile-encounter-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-patient-stu3.html">profile-patient-stu3</a></td>
    <td><a href="profile-patient-r4.html">profile-patient-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-practitioner-stu3.html">profile-practitioner-stu3</a></td>
    <td><a href="profile-practitioner-r4.html">profile-practitioner-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-practitionerrole-stu3.html">profile-practitionerrole-stu3</a></td>
    <td><a href="profile-practitionerrole-r4.html">profile-practitionerrole-r4</a></td>
  </tr>
</table>


##### encounter-start
This hook is described in the CDS Hook specification [here](https://cds-hooks.hl7.org/hooks/encounter-start).  This version of the CRD implementation guide refers to version 1.0.

This hook would be triggered when a patient is admitted, a patient arrives for an out-patient visit and/or when a provider first engages with a patient during an encounter.  It serves a similar purpose to [appointment-book](#appointment-book), though it provides less lead time to react to recommendations.  If the purpose of the appointment is to perform a service that requires a 2-week prior authorization process, it's a bit late, though it still might be better to cancel the appointment and re-schedule for later.

The advice returned for this hook would include the same sorts of advice as provided for [appointement-book](#appointment-book).  However, the hook is still necessary because not all encounters will be the result of appointments, not all systems that schedule appointments will necessarily have checked for coverage requirements and the patient's circumstances and/or coverage as well as the payer's guidelines may have evolved since the appointment was scheduled.

Note that when Practitioner and PractitionerRole are used to identify the user, they may represent licensed healthcare professionals as well as administrative staff.

The profiles expected to be used for the resources resolved to by the userId, patientId and encounterId context references are as follows:


<table class="grid">
  <thead>
    <tr>
      <th>STU3 Profile</th>
      <th>R4 Profile</th>
    </tr>
  </thead>
  <tr>
    <td><a href="STU3/profile-encounter-stu3.html">profile-encounter-stu3</a></td>
    <td><a href="profile-encounter-r4.html">profile-encounter-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-patient-stu3.html">profile-patient-stu3</a></td>
    <td><a href="profile-patient-r4.html">profile-patient-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-practitioner-stu3.html">profile-practitioner-stu3</a></td>
    <td><a href="profile-practitioner-r4.html">profile-practitioner-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-practitionerrole-stu3.html">profile-practitionerrole-stu3</a></td>
    <td><a href="profile-practitionerrole-r4.html">profile-practitionerrole-r4</a></td>
  </tr>
</table>


##### encounter-discharge
This hook is described in the CDS Hook specification [here](https://cds-hooks.hl7.org/hooks/encounter-discharge).  This version of the CRD implementation guide refers to version 1.0.

This hook would generally be in-patient specific and would fire when a provider is performing the discharge process within their EMR.

Potentially relevant CRD advice related to this hook might include:

* Verifying that documentation requirements for the services performed have been applied to ensure they can be reimbursed

* Ensuring that required follow-on planning is complete and appropriate transfer of care has been arranged, particularly for accountable care models


The profiles expected to be used for the resources resolved to by the userId, patientId and encounterId and in the `appointments` context elements are as follows:
<table class="grid">
  <thead>
    <tr>
      <th>STU3 Profile</th>
      <th>R4 Profile</th>
    </tr>
  </thead>
  <tr>
    <td><a href="STU3/profile-encounter-stu3.html">profile-encounter-stu3</a></td>
    <td><a href="profile-encounter-r4.html">profile-encounter-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-patient-stu3.html">profile-patient-stu3</a></td>
    <td><a href="profile-patient-r4.html">profile-patient-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-practitioner-stu3.html">profile-practitioner-stu3</a></td>
    <td><a href="profile-practitioner-r4.html">profile-practitioner-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-practitionerrole-stu3.html">profile-practitionerrole-stu3</a></td>
    <td><a href="profile-practitionerrole-r4.html">profile-practitionerrole-r4</a></td>
  </tr>
</table>

##### order-select
This hook is described in the CDS Hook specification [here](https://cds-hooks.hl7.org/hooks/order-select).  This version of the CRD implementation guide refers to version 1.0.

This is probably the most important of the hooks for CRD and will be the most widely used as it is fired while orders are being created and decisions are being made about what medications, devices, services, etc. are going to be provided.  This hook may be fired multiple times as additional information is gathered.  Services **SHALL NOT** return warnings indicating that insufficient information is available to determine coverage when returning coverage requirement cards.  It is to be expected that not all information will be available initially.  If the user decides that the order is 'complete' when not enough information is available, that will be caught by the [order-sign](#order-sign) hook.

While it might be possible to not support this hook and only use the order-sign hook, this hook has the benefit that it allows altering the provider's behavior before they've gone too far.  It's much less aggravation for the provider if they're prompted to change an ordered drug when they've just picked the drug and haven't filled in all of the dosage instructions than when everything is complete and they're just about to sign.

This hook allows multiple resource types to be present.  Depending on the EMR, all provided resources might be of the same type or there might be a mixture of types.  Coverage requirements should be limited only to those resources that are included in the `selected` context, though the content of other resources should be taken into account before making recommendations about what additional actions are necessary.  (I.e. don't recommend an action if there's already a draft order to perform that action.)  The different types are relevant as follows:

**DeviceRequest**: Used for all type of durable medical equipment orders, such as wheelchairs, prosthetics, diabetic supplies, etc.  It can also be used to order glasses and other vision-correction devices

**VisionPrescription**: Used in STU3 to order glasses, contacts, etc.

**MedicationRequest**: Used to order inpatient and outpatient medications.  Can also be used to order vaccinations

**ProcedureRequest**: Used in STU3 to order lab tests, imaging studies, other assessments, surgery, transfusions, physiotherapy, councelling, education, etc.  Can also be used to order changes to the patient's environment (e.g. installation of a ramp, low-barrier tub, etc.)

**ReferralRequest**: Used in STU3 to solicit advice from or transfer of care to another service provider

**ServiceRequest**: Used in R4 to cover the use cases of both ProcedureRequest and ReferralRequest

**NutritionOrder**: Used to order the preparation of specific meal types.  Generally for in-patient care, but potentially also relevant for home-care.

**SupplyRequest**: Allows the bulk order of healthcare-related supplies on a non-patient-specific basis.


Coverage requirement responses might include:

* Information about pre authorization and clinical documentation requirements, including forms to be completed

* Alternative therapies that are covered or required first-line therapies

* Potential drug-drug interactions based on exiting payer knowledge

* Recommendations about in-network vs. out-of-network providers for referrals


There are no constraints or special rules related to this hook beyond the profiles expected to be used for the resources resolved to by the patientId or encounterId or in the `draft-orders` context element:
<table class="grid">
  <thead>
    <tr>
      <th>STU3 Profile</th>
      <th>R4 Profile</th>
    </tr>
  </thead>
  <tr>
    <td><a href="STU3/profile-devicerequest-stu3.html">profile-devicerequest-stu3</a></td>
    <td rowspan="2"><a href="profile-devicerequest-r4.html">profile-devicerequest-r4</a><sup>†</sup></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-visionprescription-stu3.html">profile-visionprescription-stu3</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-encounter-stu3.html">profile-encounter-stu3</a></td>
    <td><a href="profile-encounter-r4.html">profile-encounter-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-medicationrequest-stu3.html">profile-medicationrequest-stu3</a></td>
    <td><a href="profile-medicationrequest-r4.html">profile-medicationrequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-nutritionorder-stu3.html">profile-nutritionorder-stu3</a></td>
    <td><a href="profile-nutritionorder-r4.html">profile-nutritionorder-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-patient-stu3.html">profile-patient-stu3</a></td>
    <td><a href="profile-patient-r4.html">profile-patient-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-practitioner-stu3.html">profile-practitioner-stu3</a></td>
    <td><a href="profile-practitioner-r4.html">profile-practitioner-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-practitionerrole-stu3.html">profile-practitionerrole-stu3</a><sup>‡</sup></td>
    <td><a href="profile-practitionerrole-r4.html">profile-practitionerrole-r4</a><sup>‡</sup></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-procedurerequest-stu3.html">profile-procedurerequest-stu3</a></td>
    <td rowspan="2"><a href="profile-servicerequest-r4.html">profile-servicerequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-referralrequest-stu3.html">profile-referralrequest-stu3</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-supplyrequest-stu3.html">profile-supplyrequest-stu3</a><sup>†</sup></td>
    <td><a href="profile-supplyrequest-r4.html">profile-supplyrequest-r4</a><sup>†</sup></td>
  </tr>
</table>

<sup>†</sup> DeviceRequest and SupplyRequest are not currently supported by the order-select and order-sign hooks.  A [proposal]() has been submitted to add them.  CRD implementers **SHALL NOT** treat the presence of these resources in the `draftOrders` Bundle as an error and **SHOULD** support these resource types if relevant to their operations.

<sup>‡</sup> While this hook does not explicitly list PractitionerRole as an expected resource type for userId, it is not prohibited and is included to allow linking the user to a Practitioner in a specific role acting on behalf of a specific Organization.

Note: While this hook is defined for use when ordering, it is still relevant when proposing (e.g. as part of a consult note) or planning (e.g. as part of a care plan) the use of an intervention.  All of the 'Request' resources support differentiating between plans, proposal and orders.  Where EMRs have an appropriate workflow and data capture mechanism, this hook could be used in scenarios that don't involve creating a true order.


##### order-sign
This hook is described in the CDS Hook specification [here](https://cds-hooks.hl7.org/hooks/order-sign).  This version of the CRD implementation guide refers to version 1.0.

This hook serves a very similar purpose to [order-select](#order-select).  The main difference is that all of the listed draft orders are considered to be 'complete'.  That means that it's appropriate to provide warnings if there is insufficient information to determine coverage requirements.  As well, all of the `draftOrders` are appropriate to comment on as there is no `selected` filter.

The same use cases and profiles apply here as for the preceding hook.


#### Cards
[Cards](https://cds-hooks.hl7.org/specification/1.0/#card-array) are the mechanism used to return coverage requirements from the payer to the client system.

##### General guidance
In addition to the [guidance provided in the CDS Hooks specification](https://cds-hooks.hl7.org/specification/1.0/#card-attributes), the following recommendations should be adhered to by payer systems when constructing cards:

*  The `Card.indicator` should be populated from the perspective of the clinical decision maker, not the payer.  While failure to procure a pre-authorization might be 'critical' from the perspective of payment, it would be - at best - a 'warning' from the perspective of clinical care.  'critical' should be reserved for reporting life or death or serious clinical outcomes.  Issues where the proposed course of action will negatively affect the ability of the payer or patient to be reimbursed would generally be a 'warning'.  Most Coverage Requirements should be marked as 'info'.

*  The `Card.source` should be a name that the user and patient will recognize.  If coverage recommendations are being returned by a benefits manager or intermediary, the source should still be identified as the insurer listed on the patient's insurance card.  If an insurer is providing recommendations from another authority (e.g. a clinical society), the society's name and logo might be displayed, though usually only with the permission of that organization.

*  Users are busy.  Time spent reading a payer-returned card is inevitably time not spent reviewing other information or interacting with the patient.  If not useful or relevant, user will quickly learn to ignore - or even demand the disabling of payer-provided alerts.  Therefore, information should be delivered efficiently and be tuned to provide maximum relevance.  Specifically:

    *  `Card.summary` should provide actionable information.  "Coverage alert" would not be very helpful. "Drug not covered.  Covered alternatives available" or "Pre-authorization required" would be better.

    *  `Card.detail` and/or external links should only be provided when coverage recommendations can't be clearly provided in the 140-character limit of `Card.summary`.

    *  `Card.detail` should provide graduated information with critical information being provided in the first paragraph and less critical information towards the end of the page.

    *  Detail should always provide enough context that a user can determine whether its worth the precious seconds to launch an app or external link - and should ideally have a sense of where to look/how to use whatever link/app they do launch in the specific context of the order they're making at the time.

    *  Keep the number of cards manageable.  Consider whether user workflow will be faster with separate cards for each link or a single card having multiple links.  Typically using the smallest number of cards that still support descriptive actionable summaries is best.

    *  When providing links, don't send the user to the first page of an 80+ page PDF.  Keep document size short and/or provide linking directly to the section that is relevant for the context.

    *  While links are permitted in the markdown content of `Card.detail`, support for this is not universal, so links should always also be provided in `Card.link`.  This also provides a consistent place for users to access all relevant links.

    *  Because not all client systems will support all card capabilities, card options should provide enough information that a user can perform record changes manually if automated support isn't possible.


##### Potential CRD Response Types
This section describes the different types of card responses that can be used when returning coverage requirements and defines expectations for how that information should be represented.  It's possible that some payers and clients might support additional card response patterns than those listed here, but such behavior is outside the scope of this specification.  Future versions of this specification may standardize additional response types.

Of the card types here, conformant client systems **SHALL** support the [External reference](#external-reference) and [Instructions](#instructions) responses.  They **SHOULD** support the remainder.  Payer servers **SHALL** support at least one of these response type and **MAY** support as many as necessary to convey the requirements of the types of coverage they support.

Response types are listed from least sophisticated to most sophisticated - and potentially more useful/powerful.  As a rule, the more a card can automate and the more context-specific behavior, the more useful the decision support will be to the clinician and the more likely it will be used.

NOTE: Client systems will provide resources, such as MedicationRequest, in the CDS Hook request context object. These resources may be ephemeral in the client system, such as when a medication order is being reviewed. In this case, the client system must maintain a stable identifier for these ephemeral resources in order to allow CRD responses to refer to them in CDS Hook Actions. 

Note: Hook responses will frequently contain multiple cards and those cards may draw from a variety of response types.  For example, providing links, textual guidance as well as suggestions for alternative orders.

Additional Note: The Response Types listed here are *not* the same as the types specified above in [Configuration Options](#configuration-options).  The same response type could correspond to multiple configuration types.  For example, [External Reference](#external-reference) could cover clinical practice guidelines, pre-authorization requirements, claims attachment requirements and other things.  Similarly, one configuration type could be satisfied with multiple response types.  For example, forms requirements might be expressed through a mixture of [External References](#external-reference) and explicit [Request Form Completion](#request-form-completion) responses.


###### External Reference
This provides one or more links to external web pages, PDFs or other resources that provide relevant coverage information.  These might provide clinical guidelines, pre-authorization requirements, printable forms, etc. Typically, these references would be links to information available from the payer's website, though pointers to other authoritative sources are possible too.  The card will have at least one `Card.link`.  The `Link.type` will have a type of "absolute".

For example, this CDS Hooks [Card](https://cds-hooks.hl7.org/specification/1.0/#card-attributes) contains two [Links](https://cds-hooks.hl7.org/specification/1.0/#link) - a standard and a printer-friendly version.

{% raw %}
    {
      "summary": "CMS Home Oxygen Therapy Coverage Requirements",
      "indicator": "info",
      "detail": " Learn about covered oxygen items and equipment for home use; coverage requirements; criteria you must meet to furnish oxygen items and equipment for home use; Advance Beneficiary Notice of Noncoverage; oxygen equipment, items, and services that are not covered; and payments for oxygen items and equipment and billing and coding guidelines.",
      "source": {
        "label": "Centers for Medicare & Medicaid Services",
        "url": "https://cms.gov"
      },
      "links": [
        {
          "label": "Home Oxygen Therapy Guidelines",
          "url": "https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/Home-Oxygen-Therapy-ICN908804.pdf",
          "type": "absolute"
        },
        {
          "label": "Home Oxygen Therapy Guidelines (printer-friendly)",
          "url": "https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/Home-Oxygen-Therapy-Text-Only.pdf",
          "type": "absolute"
        },
      ]
    }
{% endraw %}

###### Instructions
This card can be generated in a more sophisticated context for the payer, but be simple to consume for the provider because it more easily allows returned information to be tuned to the specific context of the order/encounter that triggered the hook.  In some cases, the text returned might be generated uniquely each time a response is fired.  It displays textual guidance to the user making the decisions.  This text might provide clinical guidelines, suggested changes, rules around pre-authorization, or even something as simple as "No special coverage requirements".  

This example CDS Hook [Card](https://cds-hooks.hl7.org/specification/1.0/#card-attributes) just contains a message:

{% raw %}
    {
      "summary": "Pre-authorization required",
      "indicator": "warning",
      "detail": "All prescriptions for _Drug X_ with a dose higher than 100mg/day require pre-authorization.  Forms and instructions can be found [here](http://example.org/pre-auth.pdf).",
      "source": {
        "label": "You're Covered Insurance",
        "url": "https://example.com",
        "icon": "https://example.com/img/icon-100px.png"
      }
    }
{% endraw %}


###### Propose alternate request
This type of response allows the payer to suggest alternatives to the current proposed therapy.  This might be updating the order to change certain information or proposing completely replacing the order with one or more alternatives.  This might be used to propose a change to a first-line treatment, to alter therapy frequency or drug dosage to be consistent with coverage guidelines, to propose covered products or services as substitutes for a non-covered service and/or to propose therapeutically equivalent treatments that will have a lower cost to the patient.

Multiple alternatives can be proposed by providing multiple suggestions.  Each suggestion should contain either a single "update" action to revise the existing proposed order; or both a "delete" action for the current proposed order and a "create" action for the new proposed order.  In some cases, additional "create" actions might be needed if there's a need to convey a non-[contained]({{site.data.fhir.path}}references.html#contained) Medication, Device or other resource.  The "delete" action resource element is not expected to adhere to any profile as it is only expected to contain the "id" property of the resource being replaced.  Any other elements will be ignored.

The choice of "update" vs. "delete + create" should be based on how significant the change is - and how relevant other decision support on the original request will still be.  If cards returned by other service providers might still be relevant (e.g. because there was just a small change in dose or frequency), then performing an 'update' will allow updates from other decision support cards to also be applied.  If the change is significant enough that other decision support will not be relevant, a delete + create will allow the client to suppress decision support cards that no longer apply.

When using this response type, the proposed orders (and any associated resources) **SHALL** comply with the following profiles:

<table class="grid">
  <thead>
    <tr>
      <th>STU3 Profile</th>
      <th>R4 Profile</th>
      <th>Comments</th>
    </tr>
  </thead>
  <tr>
    <td><a href="STU3/profile-device-stu3.html">profile-device-stu3</a></td>
    <td><a href="profile-device-r4.html">profile-device-r4</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="STU3/profile-devicerequest-stu3.html">profile-devicerequest-stu3</a></td>
    <td rowspan="2"><a href="profile-devicerequest-r4.html">profile-devicerequest-r4</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="STU3/profile-visionprescription-stu3.html">profile-visionprescription-stu3</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="STU3/profile-encounter-stu3.html">profile-encounter-stu3</a></td>
    <td><a href="profile-encounter-r4.html">profile-encounter-r4</a></td>
    <td>Only if updating an Encounter - e.g. to add a note</td>
  </tr>
  <tr>
    <td><a href="http://hl7.org/fhir/us/core/StructureDefinition-us-core-medication.html">us-core-medication</a></td>
    <td><a href="profile-medication-r4.html">profile-medication-r4</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="STU3/profile-medicationrequest-stu3.html">profile-medicationrequest-stu3</a></td>
    <td><a href="profile-medicationrequest-r4.html">profile-medicationrequest-r4</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="STU3/profile-nutritionorder-stu3.html">profile-nutritionorder-stu3</a></td>
    <td><a href="profile-nutritionorder-r4.html">profile-nutritionorder-r4</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="STU3/profile-procedurerequest-stu3.html">profile-procedurerequest-stu3</a></td>
    <td rowspan="2"><a href="profile-servicerequest-r4.html">profile-servicerequest-r4</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="STU3/profile-referralrequest-stu3.html">profile-referralrequest-stu3</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="STU3/profile-supplyrequest-stu3.html">profile-supplyrequest-stu3</a></td>
    <td><a href="profile-supplyrequest-r4.html">profile-supplyrequest-r4</a></td>
    <td/>
  </tr>
</table>

For example, this FHIR R4 card proposes replacing the draft prescription for a brand-name drug (shown only as the 'resourceType' and 'id' from the `draftOrders` entry) and instead creating an equivalent prescription with a generic medication.
<pre>
    "suggestions": [
      {
        "label": "Change to generic (name brand not covered)",
        "actions": [{
          "type": "delete",
          "description": "Remove name-brand prescription",
          "resource": {
            "resourceType": "MedicationRequest",
            "id": "draftrx1"
          }
        }, {
          "type": "create",
          "description": "Add equivalent generic prescription",
          "resource": {
            "resourceType": "MedicationRequest",
            "status": "draft",
            "intent": "initial-order",
            "medicationCodeableConcept":{
              "coding":{
                "system": "http://www.nlm.nih.gov/research/umls/rxnorm",
                "code": "392151",
                "display": "Amoxicillin 200 MG Oral Tablet"
              }
            },
            "subject":{
              "reference": "Patient/123",
              "display": "Jane Smith"
            },
            "encounter": {
              "reference": "Encounter/ABC"
            },
            "authoredOn": "2019-02-15",
            "performer": {
              "reference": "PractitionerRole/987",
              "display": "Dr. Jones"
            },
            "dosageInstruction":{
              "text": "1 tablet ever 8 hours for 10 days.  Take for full 10 days, even if symptoms improve",
              "timing":{
                "repeat":{
                  "boundsDuration":{
                    "value": 10,
                    "unit": "days",
                    "code": "d",
                    "system": "http://unitsofmeasure.org"
                  },
                  "frequency": 1,
                  "period": 8,
                  "periodUnit": "h"
                }
              },
              "doseAndRate"{
                "doseQuantity"{
                  "value": 1,
                  "unit": "tablet"
                }
              }
            },
            "dispenseRequest":{
              "quantity":{
                "value": 30,
                "unit": "tablets"
              }
            }
          }
        }]
      }
    ]
</pre>


###### Identify additional orders as companions/pre-requisites for current order
In this case, rather than proposing a change to the current proposed order [Propose Alternate Request](#propose-alternate-request), the service recommends the introduction of additional orders.  For example, ensuring that lab tests are ordered along with a medication known to affect liver function.  This will normally involve additional "create" actions.  The fact there is no "delete" for the original order conveys that these are supplemental actions rather than replacement actions.  As with the previous response type, in some cases multiple resources will need to be created to convey the full suggestion (e.g. Medication, Device, etc.)

When using this response type, the proposed orders (and any associated resources) **SHALL** comply with the following profiles:

<table class="grid">
  <thead>
    <tr>
      <th>STU3 Profile</th>
      <th>R4 Profile</th>
    </tr>
  </thead>
  <tr>
    <td><a href="STU3/profile-communicationreq-stu3.html">profile-communicationreq-stu3</a></td>
    <td><a href="profile-communicationrequest-r4.html">profile-communicationrequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-device-stu3.html">profile-device-stu3</a></td>
    <td><a href="profile-device-r4.html">profile-device-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-devicerequest-stu3.html">profile-devicerequest-stu3</a></td>
    <td rowspan="2"><a href="profile-devicerequest-r4.html">profile-devicerequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-visionprescription-stu3.html">profile-visionprescription-stu3</a></td>
  </tr>
  <tr>
    <td><a href="http://hl7.org/fhir/us/core/StructureDefinition-us-core-medication.html">us-core-medication</a></td>
    <td><a href="profile-medication-r4.html">profile-medication-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-medicationrequest-stu3.html">profile-medicationrequest-stu3</a></td>
    <td><a href="profile-medicationrequest-r4.html">profile-medicationrequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-nutritionorder-stu3.html">profile-nutritionorder-stu3</a></td>
    <td><a href="profile-nutritionorder-r4.html">profile-nutritionorder-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-procedurerequest-stu3.html">profile-procedurerequest-stu3</a></td>
    <td rowspan="2"><a href="profile-servicerequest-r4.html">profile-servicerequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-referralrequest-stu3.html">profile-referralrequest-stu3</a></td>
  </tr>
  <tr>
    <td><a href="STU3/profile-supplyrequest-stu3.html">profile-supplyrequest-stu3</a></td>
    <td><a href="profile-supplyrequest-r4.html">profile-supplyrequest-r4</a></td>
  </tr>
</table>

This R4 example proposes adding a monthly test to check liver function
<pre>
    "suggestions": [
      {
        "label": "Add monthly AST test for 1st 3 months",
        "actions": [{
          "type": "create",
          "description": "Add order for AST test",
          "resource": {
            "resourceType": "ServiceRequest",
            "status": "draft",
            "intent": "initial-order",
            "category":{
              "coding":{
                "system": "http://snomed.info/sct",
                "code": "108252007",
                "display": "Laboratory procedure"
              }
            },
            "code":{
              "coding":{
                "system": "htp://loinc.org",
                "code": "1916-6",
                "display": "AST/Alanine aminotransferase [Catalytic ratio]"
              }
            },
            "subject":{
              "reference": "Patient/123",
              "display": "Jane Smith"
            },
            "encounter":{
              "reference": "Encounter/ABC"
            },
            "occurrence":{
              "boundsDuration":{
                "value": 3,
                "unit": "months",
                "code": "mo",
                "system": "http://unitsofmeasure.org"
              },
              "frequency": 1,
              "period": 1,
              "periodUnit": "mo"
            }
            "authoredOn": "2019-02-15",
            "requester": {
              "reference": "PractitionerRole/987",
              "display": "Dr. Jones"
            }
          }
        }]
      }
    ]
</pre>


###### Request form completion
A common type of response is to indicate forms that need completion.  These might be forms needed for pre-authorization or as attachments for claims submission.  They might also just be for internal use to retain as proof of following clinical need protocols and to have available in the event of audit.  While forms can be expressed as static or active PDFs referenced by [External References](#external-reference), this response type provides the form definition as a FHIR Questionnaire and creates a Task within the EMR allowing the completion of the form to be appropriately scheduled and/or delegated.  Alternatively, the Practitioner could choose to execute the task and fill out the form immediately if that makes more sense from a clinical workflow perspective.

This suggestion will always include a "create" action for the Task.  The Task will point to the questionnaire to be completed using the `Task.input` property with a `Task.input.name` of "questionnaire".  That Questionnaire might be included with a separate conditional "create" action or might be excluded with the presumption it will already be available or retrievable by the client via its canonical URL from the original source or from a local registry.  The `Task.code` will always include the CRD-specific `complete-questionnaire` code.  The reason for completion will be conveyed in `Task.reasonCode`.

When using this response type, the proposed orders (and any associated resources) **SHALL** comply with the following profiles:

<table class="grid">
  <thead>
    <tr>
      <th>STU3 Profile</th>
      <th>R4 Profile</th>
    </tr>
  </thead>
  <tr>
    <td><a href="STU3/profile-taskquestionnaire-stu3.html">profile-taskquestionnaire-stu3</a></td>
    <td><a href="profile-taskquestionnaire-r4.html">profile-taskquestionnaire-r4</a></td>
  </tr>
</table>
  
No profile is provided for the Questionnaires pointed to by the Task.  Payers **SHOULD** use questionnaires that are compliant with either the [Argonaut Questionnaire profiles](https://github.com/argonautproject/questionnaire) (for forms to be completed within the EMR) or the [Structured Data Capture profiles](http://hl7.org/fhir/us/sdc) (for more sophisticated forms to be created within a SMART on FHIR app or through an external service).

The following is an example CDS Hook [Suggestion](https://cds-hooks.hl7.org/specification/1.0/#suggestion) where the specified questionnaire is either expected to be available within the client system or available for retrieval through its canonical URL.  As such, the [Action](https://cds-hooks.hl7.org/specification/1.0/#action) only contains the FHIR [Task]({{site.data.fhir.path}}task.html) resource.  An example showing inclusion of both the Task and the referenced Questionnaire can be found [above](#if-none-exist).

<pre>
    "suggestions": [
      {
        "label": "Add 'completion of the ABC form' to your task list (possibly for reassignment)",
        "actions": [{
          "type": "create",
          "description": "Add 'Complete ABC form' to the task list",
          "resource": {
            "resourceType": "Task",
            "instantiatesCanonical": "http://example.org/Questionnaire/ABC|1",
            "basedOn": "Appointment/27"
            "status": "ready",
            "intent": "order",
            "code": {
              "coding": [{
                "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/task-type",
                "code": "complete-questionnaire"
              }]
            },
            "description": "Complete XYZ form for inclusion in prior authorization",
            "for": {
              "reference": "Patient/some-patient-id"
            },
            "authoredOn": "2018-08-09",
            "reasonCode": {
              "coding": [{
                "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/task-reason",
                "code": "prior-auth",
                "display": "Needed for prior authorization"
              }]
            }
          }
        }]
      }
    ]
</pre>

###### Create or update Coverage information
This response is used when the payer is aware of additional coverage that is relevant to the current/proposed activity or has updates/corrections to make to the information held by the client system.  For example, the client system might be aware that a patient has coverage with a provider, but not know the plan number, member identifier or other relevant information.  This response allows the payer to convey that information to the client system and link it to the current/proposed action.  In theory, this type of response could also be used to convey corrected/additional pre-authorization information the payer was aware of, however that functionality is out-of-scope for this release of the implementation guide.

This response will contain a single suggestion.  The primary action within it will either be an "update" of an existing client Coverage instance (if the client already has one) or a "create" of a new Coverage instance if the payer is aware of Coverage that the client system is not.  In addition, the suggestion **MAY** include updates on all relevant Request resources to add or remove links to Coverage instances, reflecting which Coverages are relevant to which types of requests.

For example, this CDS Hook [Card](https://cds-hooks.hl7.org/specification/1.0/#card-attributes) includes a single [Suggestion](https://cds-hooks.hl7.org/specification/1.0/#suggestion) with two [Actions](https://cds-hooks.hl7.org/specification/1.0/#action) - one is to update the FHIR [Coverage]({{site.data.fhir.path}}coverage.html) and the second is to update the draft order [MedicationRequest]({{site.data.fhir.path}}medicationrequest.html) to reference the existing Coverage.

    {
      "summary": "EMR coverage information is incomplete",
      "indicator": "info",
      "source": {
        "label": "Some Payer",
        "url": "https://example.com",
        "icon": "https://example.com/img/icon-100px.png"
      },
      "suggestions": [
        {
          "label": "Update coverage information to be current",
          "uuid": "1207df9d-9ff6-4042-985b-b8dec21038c2",
          "actions": [{
            "type": "update",
            "description": "Update current coverage record",
            "resource": {
              "resourceType": "Coverage",
              "id": "1234",
              "subscriberId": "192837",
              "class": {
                "type": "group",
                "value": "A1"
              }
            }
          }]
        },
        {
          "label": "Link coverage to existing Drug X prescription",
          "uuid": "9309cc18-fea1-4939-ab0c-ecb15bedf043",
          "actions": [{
            "type": "update",
            "description": "Update prescription to include coverage",
            "resource": {
              "resourceType": "MedicationRequest",
              "id": "5678",
              ...
              "insurance": {
                "reference": "Coverage/1234"
              }
            }
          }]
        }
      ]
    }


###### Launch SMART application
SMART apps allow more sophisticated interaction between payers and practitioners.  They provide full control over user interface, workflow, etc.  With permission, they can also access patient clinical data to help guide the interactive experience and minimize data entry.  Apps can provide a wide variety of functions, including eligibility checking, guiding users through form entry, providing education, etc.

All such apps will need to go through the approval processes for the client's provider organization and typically also the associated software vendor.  This response type can cue the launching of such apps to occur in the context in which they are relevant to patient care and/or to payment-related decision-making.

This type of response is just a modified version of the [External Reference](#external-reference) response type.  However, the `Link.type` will be "smart" instead of "absolute".  The `Link.appContext` will typically also be present.  For example, this [Card](https://cds-hooks.hl7.org/specification/1.0/#card-attributes) contains a SMART App [Link](https://cds-hooks.hl7.org/specification/1.0/#link) to perform an opioid assessment.

    {
      "summary": "Launch opioid XYZ-assessment",
      "indicator": "info",
      "detail": "This is an example card.",
      "source": {
        "label": "Some Payer",
        "url": "https://example.com",
        "icon": "https://example.com/img/icon-100px.png"
      },
      "links": [
        {
          "label": "Opioid XYZ-assessment",
          "url": "https://example.org/opioid-assessment",
          "type": "smart"
        }
      ]
    }


#### Prefetch
Prefetch is an optional capability of CDS Hooks that allows the client to perform certain query functions on behalf of the server and provide the results in the initial hook invocation.  This allows the client to optimize query performance and can simplify functionality for the server.

In the CRD implementation guide, there's a common set of queries that define data that most, if not all, payers will need to perform their requirements assessment.  This section defines those queries.

For this release of the implementation guide, conformant clients **SHOULD** support the CDS Hooks prefetch capability and be able to perform all the prefetch queries defined here.  However, each payer will define the prefetch requests for their service based on what information they need to provide coverage requirements.  They may include more and/or less than described in this section.  Prefetch requests **SHOULD** only include information that is always expected to be needed for each hook information as information should not be accessed that is not necessary to perform the coverage requirements function.  Information relevant to the context of a specific hook invocation **SHOULD** always be queried using the provided token, not included in prefetch.  Payers should recognize that not all clients will support all prefetch requests.

<blockquote class="stu-note">
In future releases of this specification, this requirement may become a 'SHALL'.  Implementers are encouraged to provide feedback about this possibility as part of their ballot feedback.
</blockquote>

The base requirement for each query, whether based on Encounter or one of the request resources is to bring back the following associated resources:

*  Patient
*  Relevant Coverage
*  Authoring Practitioner
*  Authoring Organization
*  Requested performing Practitioner (if specified)
*  Requested performing Organization (if specified)
*  Requested Location (if specified)
*  associated Medication (if any)
*  associated Device (if any)

Not all of these will be relevant for all resource types.  And different resources have differently named data elements and search parameters for them.  In some cases, support only exists as extensions or does not exist at all.  Where necessary, this implementation guide defines additional extensions and/or SearchParameter instances to support retrieval of these elements.  The intention is for both extensions and search parameters to eventually migrate into the core FHIR specification.

##### Queries
The context information provided as part of hook invocation will often not be sufficient for a CRD service to fully determine coverage requirements.  There are two possible mechanisms that can be used by the service to gather the information needed: Pre-fetch and query against the EMR.  Both of these mechanisms are defined as part of the [CDS Hooks specification](https://cds-hooks.org/specification/1.0/#providing-fhir-resources-to-a-cds-service).  In some cases, a mixture of both approaches may be necessary.

###### Pre-fetch
In addition to the [base pre-fetch capabilities](https://cds-hooks.org/specification/1.0/#prefetch-template) defined in the CDS Hooks specification, systems that support pre-fetch **SHOULD** support the additional pre-fetch capabilities [defined earlier in this spec.](Additional_Pre-fetch_capabilities).  The following table defines the 'standard' prefetch queries for this implementation guide that **SHOULD** be supported for each type of resource are shown in the table below.  Those search parameters with hyperlinks are defined as part of this implementation guide.  The remainder are defined within their respective version of the FHIR core specification.

EMR implementations should not expect standardized prefetch key names.  EMRs supporting prefetch **SHALL** inspect the CDS Hooks Discovery Endpoint to determine exact prefetch key names and queries.

{% raw %}
<table class="grid">
  <thead>
    <tr>
      <th>Resource</th>
      <th>Version</th>
      <th>Query</th>
      <th>Notes</th>
    </tr>
  </thead>
  <tr>
    <td>Appointment</td>
    <td>STU3</td>
    <td>
      <code>Appointment?_id={{context.appointments.Appointment.id}}<br/>
      &_include=Appointment:patient, Appointment:practitioner<br/>
      &_include=Appointment:location<br/>
      &_include=Appointment:<a href="STU3/appointment-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No requester, no performer organization</td>
  </tr>
  <tr>
    <td>Appointment</td>
    <td>R4</td>
    <td>
      <code>Appointment?_id={{context.appointments.Appointment.id}}<br/>
      &_include=Appointment:patient<br/>
      &_include=Appointment:practitioner:PractitionerRole<br/>
      &_include=PractitionerRole:organization<br/>
      &_include=PractitionerRole:practitioner<br/>
      &_include=Appointment:location<br/>
      &_include=Appointment:<a href="appointment-insurance-r4.html">insurance</a>:Coverage</code>
    </td>
    <td>No requester</td>
  </tr>
  <tr>
    <td>DeviceRequest</td>
    <td>STU3</td>
    <td>
      <code>DeviceRequest?_id={{context.draftOrders.DeviceRequest.id}}<br/>
      &_include=DeviceRequest:patient<br/>
      &_include=DeviceRequest:performer<br/>
      &_include=DeviceRequest:requester<br/>
      &_include=DeviceRequest:device<br/>
      &_include=DeviceRequest:<a href="STU3/devicerequest-onbehalfof-stu3.html">on-behalf</a><br/>
      &_include=DeviceRequest:<a href="STU3/devicerequest-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No performing location</td>
  </tr>
  <tr>
    <td>DeviceRequest</td>
    <td>R4</td>
    <td>
      <code>DeviceRequest?_id={{context.draftOrders.DeviceRequest.id}}<br/>
      &_include=DeviceRequest:patient<br/>
      &_include=DeviceRequest:performer<br/>
      &_include=DeviceRequest:requester<br/>
      &_include=DeviceRequest:device<br/>
      &_include=PractitionerRole:organization<br/>
      &_include=PractitionerRole:practitioner<br/>
      &_include=DeviceRequest:insurance:Coverage</code>
    </td>
    <td>No performing location</td>
  </tr>
  <tr>
    <td>Encounter</td>
    <td>STU3</td>
    <td>
      <code>Encounter?_id={{context.encounterId}}<br/>
      &_include=Encounter:patient<br/>
      &_include=Encounter:service-provider<br/>
      &_include=Encounter:practitioner<br/>
      &_include=Encounter:location<br/>
      &_include=Encounter:<a href="STU3/encounter-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No requester</td>
  </tr>
  <tr>
    <td>Encounter</td>
    <td>R4</td>
    <td>
      <code>Encounter?_id={{context.encounterId}}<br/>
      &_include=Encounter:patient&_include=Encounter:service-provider<br/>
      &_include=Encounter:practitioner<br/>
      &_include=Encounter:location<br/>
      &_include=Encounter:<a href="encounter-insurance-r4.html">insurance</a>:Coverage</code>
    </td>
    <td>No requester</td>
  </tr>
  <tr>
    <td>MedicationRequest</td>
    <td>STU3</td>
    <td>
      <code>MedicationRequest?_id={{context.medications.MedicationRequest.id}}<br/>
      &_include=MedicationRequest:patient<br/>
      &_include=MedicationRequest:intended-dispenser<br/>
      &_include=MedicationRequest:requester:Practitioner<br/>
      &_include=MedicationRequest:medication<br/>
      &_include=MedicationRequest:<a href="STU3/medicationrequest-onbehalfof-stu3.html">on-behalf</a><br/>
      &_include=MedicationRequest:<a href="STU3/medicationrequest-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No performing location</td>
  </tr>
  <tr>
    <td>MedicationRequest</td>
    <td>R4</td>
    <td>
      <code>MedicationRequest?_id={{context.medications.MedicationRequest.id}}<br/>
      &_include=MedicationRequest:patient<br/>
      &_include=MedicationRequest:intended-dispenser<br/>
      &_include=MedicationRequest:requester:PractitionerRole<br/>
      &_include=MedicationRequest:medication<br/>
      &_include=PractitionerRole:organization<br/>
      &_include=PractitionerRole:practitioner<br/>
      &_include=MedicationRequest:<a href="medicationrequest-insurance-r4.html">insurance</a>:Coverage</code>
    </td>
    <td>No performing location</td>
  </tr>
  <tr>
    <td>MedicationRequest</td>
    <td>STU3</td>
    <td>
      <code>MedicationRequest?_id={{context.draftOrders.MedicationRequest.id}}<br/>
      &_include=MedicationRequest:patient<br/>
      &_include=MedicationRequest:intended-dispenser<br/>
      &_include=MedicationRequest:requester:Practitioner<br/>
      &_include=MedicationRequest:medication<br/>
      &_include=MedicationRequest:<a href="STU3/medicationrequest-onbehalfof-stu3.html">on-behalf</a><br/>
      &_include=MedicationRequest:<a href="STU3/medicationrequest-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No performing location</td>
  </tr>
  <tr>
    <td>MedicationRequest</td>
    <td>R4</td>
    <td>
      <code>MedicationRequest?_id={{context.draftOrders.MedicationRequest.id}}<br/>
      &_include=MedicationRequest:patient<br/>
      &_include=MedicationRequest:intended-dispenser<br/>
      &_include=MedicationRequest:requester:PractitionerRole<br/>
      &_include=MedicationRequest:medication<br/>
      &_include=PractitionerRole:organization<br/>
      &_include=PractitionerRole:practitioner<br/>
      &_include=MedicationRequest:<a href="medicationrequest-insurance-r4.html">insurance</a>:Coverage</code>
    </td>
    <td>No performing location</td>
  </tr>
  <tr>
    <td>NutritionOrder</td>
    <td>STU3</td>
    <td>
      <code>NutritionOrder?_id={{context.draftOrders.NutritionOrder.id}}<br/>
      &_include=NutritionOrder:patient<br/>
      &_include=NutritionOrder:provider<br/>
      &_include=NutritionOrder:requester<br/>
      &_include=NutritionOrder:encounter<br/>
      &_include=Enconuter:location<br/>
      &_include=NutritionOrder:<a href="STU3/nutritionorder-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No organization, location only through request encounter</td>
  </tr>
  <tr>
    <td>NutritionOrder</td>
    <td>R4</td>
    <td>
      <code>NutritionOrder?_id={{context.draftOrders.NutritionOrder.id}}<br/>
      &_include=NutritionOrder:patient<br/>
      &_include=NutritionOrder:provider<br/>
      &_include=NutritionOrder:requester<br/>
      &_include=PractitionerRole:organization<br/>
      &_include=PractitionerRole:practitioner<br/>
      &_include=NutritionOrder:encounter<br/>
      &_include=Encounter:location<br/>
      &_include=NutritionOrder:<a href="nutritionorder-insurance-r4.html">insurance</a>:Coverage</code>
    </td>
    <td>Location only through request encounter</td>
  </tr>
  <tr>
    <td>ProcedureRequest</td>
    <td>STU3</td>
    <td>
      <code>ProcedureRequest?_id={{context.draftOrders.ProcedureRequest.id}}<br/>
      &_include=ProcedureRequest:patient<br/>
      &_include=ProcedureRequest:performer<br/>
      &_include=ProcedureRequest:requester<br/>
      &_include=ProcedureRequest:<a href="STU3/procedurerequest-onbehalfof-stu3.html">on-behalf</a><br/>
      &_include=ProcedureRequest:<a href="STU3/procedurerequest-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No performer location</td>
  </tr>
  <tr>
    <td>ReferralRequest</td>
    <td>STU3</td>
    <td>
      <code>ReferralRequest?_id={{context.draftOrders.ReferralRequest.id}}<br/>
      &_include=ReferralRequest:patient<br/>
      &_include=ReferralRequest:recipient<br/>
      &_include=ReferralRequest:requester<br/>
      &_include=ReferralRequest:<a href="STU3/referralrequest-onbehalfof-stu3.html">on-behalf</a><br/>
      &_include=ReferralRequest:<a href="STU3/referralrequest-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No performer location</td>
  </tr>
  <tr>
    <td>ServiceRequest</td>
    <td>R4</td>
    <td>
      <code>ServiceRequest?_id={{context.draftOrders.ServiceRequest.id}}<br/>
      &_include=ServiceRequest:patient<br/>
      &_include=ServiceRequest:performer<br/>
      &_include=ServiceRequest:requester<br/>
      &_include=PractitionerRole:organization<br/>
      &_include=PractitionerRole:practitioner<br/>
      &_include=ServiceRequest:<a href="servicerequest-insurance-r4.html">insurance</a>:Coverage</code>
    </td>
    <td>No performer location</td>
  </tr>
  <tr>
    <td>SupplyRequest</td>
    <td>STU3</td>
    <td>
      <code>SupplyRequest?_id={{context.draftOrders.SupplyRequest.id}}<br/>
      &_include=SupplyRequest:<a href="STU3/supplyrequest-patient-stu3.html">patient</a><br/>
      &_include=SupplyRequest:supplier:Organization<br/>
      &_include=SupplyRequest:requester:Practitioner<br/>
      &_include=SupplyRequest:requester:Organization<br/>
      &_include=SupplyRequest:<a href="STU3/supplyrequest-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No performer location</td>
  </tr>
  <tr>
    <td>SupplyRequest</td>
    <td>R4</td>
    <td>
      <code>SupplyRequest?_id={{context.draftOrders.SupplyRequest.id}}&<br/>
      _include=SupplyRequest:<a href="supplyrequest-patient-r4.html">patient</a><br/>
      &_include=SupplyRequest:supplier:Organization<br/>
      &_include=SupplyRequest:requester:Practitioner<br/>
      &_include=SupplyRequest:requester:Organization<br/>
      &_include=SupplyRequest:Requester:PractitionerRole<br/>
      &_include=PractitionerRole:organization<br/>
      &_include=PractitionerRole:practitioner<br/>
      &_include=SupplyRequest:<a href="supplyrequest-insurance-r4.html">insurance</a>:Coverage</code>
    </td>
    <td>No performer location</td>
  </tr>
  <tr>
    <td>Task</td>
    <td>STU3</td>
    <td>
      <code>Task?_id={{context.draftOrders.Task.id}}&<br/>
      _include=Task:patient<br/>
      &_include=Task:requester:Practitioner<br/>
      &_include=Task:requester:Organization<br/>
      &_include=Task:owner:Practitioner<br/>
      &_include=Task:owner:Organization<br/>
      &_include=Task:location<br/>
      &_include=PractitionerRole:organization<br/>
      &_include=PractitionerRole:practitioner<br/>
      &_include=Task:insurance<a href="task-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No support for location</td>
  </tr>
  <tr>
    <td>Task</td>
    <td>R4</td>
    <td>
      <code>Task?_id={{context.draftOrders.Task.id}}&<br/>
      _include=Task:patient<br/>
      &_include=Task:requester:Practitioner<br/>
      &_include=Task:requester:Organization<br/>
      &_include=Task:requester:PractitionerRole<br/>
      &_include=Task:owner:Practitioner<br/>
      &_include=Task:owner:Organization<br/>
      &_include=Task:owner:PractitionerRole<br/>
      &_include=Task:location<br/>
      &_include=PractitionerRole:organization<br/>
      &_include=PractitionerRole:practitioner<br/>
      &_include=Task:insurance<a href="task-insurance-r4.html">insurance</a>:Coverage</code>
    </td>
    <td></td>
  </tr>
  <tr>
    <td>VisionPrescription</td>
    <td>STU3</td>
    <td>
      <code>VisionPrescription?_id={{context.draftOrders.VisionPrescription.id}}<br/>
      &_include=VisionPrescription:patient<br/>
      &_include=VisionPrescription:prescriber<br/>
      &_include=VisionPrescription:<a href="STU3/visionprescription-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No performer, organization or location</td>
  </tr>
</table>
{% endraw %}

###### FHIR Resource Access
If information needed is not provided by pre-fetch, the server can query it directly using the [FHIR resource access](https://cds-hooks.org/specification/1.0/#fhir-resource-access) mechanism defined in the CDS Hooks specification.

This can be done either by using individual queries or by invoking a batch of separate queries.  In either case, the HTTP call that performs the query or executes the batch must pass the `fhirAuthorization.accessToken` in the Authorization header as defined in the [OAuth specification](https://www.oauth.com/oauth2-servers/accessing-data/making-api-requests).

The following two examples show a batch query that could retrieve all CRD-relevant resources as well as the structure of the corresponding batch response.

**Query Batch Request**<br/>
This query presumes that a hook has been invoked and the following information has been passed in as context:
<code>
  "userId": "PractitionerRole":"ABC",
  "patientId": "123",
  "encounterId": "987"
</code>

As well, the `draftOrders` Bundle includes MedicationRequests that reference 2 formulary medications (in addition to just pointing to medications by RxNorm code), ask for fulfillment by one pharmacy Organization (456) and are all ordered by the same PractitionerRole ABC.  Most importantly, they are all tied to the same Coverage record DEF.

Note: This query also presumes that all of this information would be relevant to the CRD service.  In practice, the service would only query the information actually needed to determine coverage requirements.  Also, the server will only be able to query data where the scopes made available in the `fhirAuthorization.scope` actually allow the desired queries.

The bundle uses a mixture of 'read' and 'search' operations to retrieve the relevant resources.  The fragments shown are generic and should work with both STU3 and R4.

<pre>
{
  "resourceType": "Bundle",
  "type": "batch",
  "entry": [{
    "request":{
      "method": "GET",
      "url": "PractitionerRole?_id=123&_include=PractitionerRole:organization&_include=PractitionerRole:practitioner"
    }
  },{
    "request":{
      "method": "GET",
      "url": "Patient/123"
    }
  },{
    "request":{
      "method": "GET",
      "url": "Encounter/987"
    }
  },{
    "request":{
      "method": "GET",
      "url": "Medication?_id=MED1,MED2"
    }
  },{
    "request":{
      "method": "GET",
      "url": "Organization/456"
    }
  },{
    "request":{
      "method": "GET",
      "url": "Coverage/DEF"
    }
  }]
}
</pre>

**Query Batch Response**<br/>
The response is a batch-response Bundle, each containing a query response Bundle with the results of the previous query with each entry in the response Bundle corresponding to the query in the request Bundle.

<pre>
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
      "link": [
        {
          "relation": "self",
          "url": "http://someemr.org/fhir/r4/PractitionerRole??_id=123&_include=PractitionerRole:organization&_include=PractitionerRole:practitioner&_sort=_id"
        }
      ],
      "entry": [{
        "resource": {
          "resourceType": "PractitionerRole",
          "id": "123",
          "meta": {
            "lastUpdated": "2016-02-29T23:52:32.387Z"
          },
          "practitioner":"Practitioner/DEF",
          "organization":"Organization/GHI",
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
    "resource":{
      "resourceType": "Bundle",
      "id": "dc616366-2f3f-4cca-b02c-0f80981770db",
      "meta": {
        "lastUpdated": "2019-03-15T15:38:13.037Z"
      },
      "type": "searchset",
      "total": 2,
      "link": [
        {
          "relation": "self",
          "url": "http://someemr.org/fhir/r4/Medication?_id=MED1,MED2&_sort=_id"
        }
      ],
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
    }
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
</pre>


###### Query Notes
*  Executing these queries in either batch or pre-fetch will bring back a degree of redundant information: repeating the request, Encounter and Appointment resources found in the hook contexts and repeating Patient, Practitioner, Organization and Coverage resources that are common for different request types for the `order-review` hook.  This redundancy is the cost of using the prefetch mechanism or batch mechanism.  Payers seeking greater efficiency can perform direct queries that are more tuned at the cost of needing to make multiple service calls.

* The queries use the defined search parameter names from the respective FHIR specification versions. If parties processing these queries have varied from these 'standard' search parameter names, they will be responsible for translating the parameters into their local names.

* When full prefetch as defined here is not supported, client systems **SHALL**, at minimum, support the batch query syntax shown above.  Payer systems may choose to support the batch query mechanism, perform client-specific queries as necessary or return no results when a client does not support its prefetch requirements.

* While these queries attempt to bring back all the potentially relevant information, not all information will necessarily exist for all requests or events, particularly at the time the hook is called.  Services **SHOULD** provide what coverage requirements they can based on the information available.

* When processing data from query responses, always check the 'self' link to ensure that the server actually executed what was requested and process the data as necessary- or try querying by a different mechanism (e.g. multiple queries rather than relying on _include).


### SMART on FHIR Hook Invocation
In addition to the real-time decision support provided by CDS Hooks, practitioners will sometimes need to seek coverage requirements information without invoking the workflow of their clinical system to actively create an order, appointment, encounter, etc.  For example, if exploring a "what if" scenario, when answering a patient question or when needing to retrieve a guidance document they had seen in a previous card and now need to review/dig deeper.

The solution to this need to perform coverage discovery "any time" is the use of a SMART on FHIR app.  Many EMR systems provide support for SMART on FHIR.  That standard allows independently developed applications to be launched from within the EMR (possibly within the EMR's user interface) and to interact with the EMR's data repository.  As part of its scope, this project will, through the Da Vinci organization, develop an open source SMART on FHIR application that allows a user to invoke solicit coverage requirements from payer systems "at will".  The SMART on FHIR app will interact with the payer systems using the existing SMART on FHIR interface.

Note that this use of SMART is distinct from the use of SMART envisioned in CDS Hooks.  This isn't launching a SMART app based on a returned card, it's instead using SMART to invoke a CDS hook in place of the EHR to artificially simulate being in a workflow that would normally trigger a hook.

Clients conforming with this application **SHALL** support the SMART on FHIR interface, allow launching of SMART apps from within their application and be capable of providing the SMART app access to the same resources it exposes to payer systems using the CDS Hooks interface.

The Da Vinci CRD SMART app has not yet been developed.  Once it exists, a link will be provided beneath the [CRD Confluence page](https://confluence.hl7.org/display/DVP/Coverage+Requirements+Discovery).


### Privacy, Security and Safety

Guidance and conformance expectations around privacy and security are provided by all three specifications this implementation guide relies on.  Implementers **SHALL** be familiar with and adhere to any security and privacy rules defined by:

* FHIR core: [Security & Privacy module]({{site.data.fhir.path}}secpriv-module.html), [Security Principles]({{site.data.fhir.path}}security.html) and [Implementer's Checklist]({{site.data.fhir.path}}safety.html)
* CDS Hooks: [Security & Safety](https://cds-hooks.hl7.org/specification/1.0/#security-and-safety)
* SMART on FHIR: [SMART App Launch](http://www.hl7.org/fhir/smart-app-launch)

In addition to these, this implementation guide imposes the following additional rules:

* Communications between providers and payers **SHOULD** use mutually authenticated TLS. Some payers may require mutually authenticated TLS.
    * This specification does not provide guidance on certificate management between clinical and payer systems, though it has been proposed that Direct certificates could be used for this purpose
* Client systems **SHALL** support running applications that adhere to the SMART on FHIR [public app](http://www.hl7.org/fhir/smart-app-launch#support-for-public-and-confidential-apps) profile
* Payer systems that wish to receive Hook invocations that contain PHI **SHALL** demonstrate at time of registration/configuration that their user agreements give them permission to receive such data in a coverage requirement context.
* Payer systems **SHALL** use information received solely for coverage determination purposes and **SHALL NOT** retain received over the CRD interfaces for any purpose other than audit
* Client systems are the final arbiters of what data can be shared with payer systems.  They **MAY** filter or withhold any resources or data elements necessary to support their obligations as health data custodians, including legal, policy and patient consent-based restrictions.  However, client systems withholding information take on the responsibility of ensuring coverage requirements are met, even if discovery is no longer possible through the interfaces provided by this implementation guide.
* Client systems **SHALL** ensure that the resource identifiers exposed over the CRD interface are distinct from and have no determinable relationship with any business identifiers associated with those records.  E.g. the Patient.id element cannot be the same as or contain in some fashion a patient's social security number or medical record number.


#### Non-PHI Hook Invocation
Some payers may not have legal permission to view patient-identifiable healthcare information (PHI) for coverage requirements discovery purposes.  EMR systems **SHALL** support filtering exposed FHIR resources to be a non-PHI "redacted" view.  This view **SHALL** ensure that all resources exposed through the CDS Hooks and SMART on FHIR interfaces are filtered as follows:

* The Patient resource adheres to the [STU3 de-identified patient profile](STU3/profile-patient-deident-stu3.html) or [R4 de-identified profile](profile-patient-deident-r4.html), depending on the version supported
* The Coverage resources adhere to the [STU3 de-identified coverage profile](STU3/profile-coverage-deident-stu3.html) or [R4 de-identified profile](profile-coverage-deident-r4.html), depending on the version supported
* All resource narratives are removed
* All markdown elements and all string elements that could potentially support free-text (e.g. 'text', 'display', 'comment' and similar elements) are removed
* All extensions other than those explicitly mentioned in the profiles in this implementation guide are removed

Client systems **SHALL** determine whether a payer system should receive the PHI or non-PHI version of the CRD interface at the time the payer is configured to have access to their system.

NOTES: 
* The non-PHI information exchanged is considered "de-identified, but potentially re-identifiable".  As such, when retaining this information for audit purposes, access to the information **SHALL** be restricted and itself audited as would access to PHI log information.
* For the purposes of non-PHI interactions, this specification does not consider the Patient resource id as PHI. If organizational policy requires the Patient.id to be treated as PHI, implementers will need to anonymize the id and support query of the patient's related resources by the anonymized id.

### Additional Considerations

1. Practitioners will rely on the information provided by the Coverage Requirements Discovery process to determine if there are any special steps they need to take such as requesting prior authorization.  As a result, it's important to them to know definitively whether requirements exist or not.  While potentially noisy, payers **SHALL** provide a message that says "No coverage requirements for [ABC]" if it is definitively known that there are no requirements for the proposed action or "Unable to determine coverage requirements for [ABC] - please review [XYZ]" or some equivalent when processing errors (e.g. unrecognized service code) prevent the payer from determining coverage requirements.

2. The receipt of coverage requirements (be it "no requirements" or specific requirements/recommendations) has financial implications for both practitioners and payers.  If a practitioner receives a message of "no requirements" and subsequently has a claim denied because of unmet requirements, it will be necessary for both sides to be able to confirm whether a "no requirements" response was sent and what information was in the hook invocation that led to that request.  Therefore, in addition to any logging performed for security purposes both clients and servers **SHALL** retain logs of all CRD-related hook invocations and their responses that can be accessed in the event of a dispute by authorized personnel.  As well, all `Card.suggestion` elements **SHALL** populate the `Suggestion.uuid` element to aid in logging.

    NOTE: Because the information in these logs will often contain PHI, access to the logs themselves will need to be logged for security purposes.

3. Client systems may fire these hooks multiple times during the creation/editing/review phase.  It is therefore the client's responsibility to manage resulting cards and determining whether to display the same cards repeatedly or to somehow manage them such that the end user isn't overwhelmed by seeing the same advice multiple times.

4. Most implementation guides provide JSON, XML and Turtle representations of artifacts.  However, because this guide is primarily using CDS Hooks (which only supports JSON) and SMART on FHIR (which primarily uses JSON), this implementation guide only publishes the JSON version of artifacts.

5. The examples in this guide use whitespace for readability.  Conformance systems **SHOULD** omit non-significant whitespace for performance reasons

6. Examples provided within this specification strive to be realistic, but may not reflect accurate/current coverage requirements
