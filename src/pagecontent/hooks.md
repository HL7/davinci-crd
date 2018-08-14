This section of the implementation guide defines the specific conformance requirements for systems wishing to conform to this Coverage Requirements Discovery implementation guide.  The bulk of it focuses on the implementation of  the [CDS Hooks Specification](https://cds-hooks.org/specification/1.0) to meet CRD use-cases.  It also describes the use of [SMART on FHIR](http://docs.smarthealthit.org) and provides guidance on privacy, security and other implementation requirements.

This implementation guide sets expectations for two types of systems:

* **Client** systems are electronic medical records, pharmacy systems and other clinical and administrative systems responsible for the ordering and execution of patient-related services.  These are systems whose users have a need for coverage requirements information
* **Payer** systems are systems run by insurers, clearing houses and other organizations that make or enforce the rules around insurance coverage and are capable of providing coverage information related to one or more insurance plans with respect to proposed healthcare products and services

### CDS Hooks Customization
CDS Hooks is a relatively new technology and, at the time this version of the implementation guide was written, has not yet been officially published as a first release.  It is considered a "Standard for Trial Use", meaning that it will continue to evolve based on implementer feedback and may change in ways that are not compatible with the current draft.  As well, the initial version of the specification has focused on the core architecture and a relatively simple set of capabilities.  Additional capabilities will be introduced in future versions.

To meet requirements identified by Da Vinci project participants, it is necessary to introduce some additional capabilities above and beyond what is currently found in the CDS Hooks specification.  This section of the CRD implementation guide describes those additional capabilities and the mechanism the implementation guide proposes to implement them.  The purpose of these customizations is to enable testing at connectathons and to support feedback into the CDS Hooks design process.

Each capability listed here has been proposed to the CDS Hooks community and may well become part of the official specification either in the initial release or in some future release.  However, there is a significant likelihood that the manner in which the requirements are met may vary somewhat from a syntax or even an architectural approach.  Future versions of this implementation guide will be updated to align with how these requirements are addressed in future versions of the CDS Hook specification.  This implementation guide will not be able to be *Normative* (locked into backward compatibility mode) until the underlying CDS Hooks content is also *normative*.

This implementation guide extends/customizes CDS Hooks in 5 ways: support for R4, new hooks, a hook configuration mechanism, additional pre-fetch capabilities and additional response capabilities.  Each are described below:


#### Support for FHIR R4
The hooks published in the CDS Hooks specification provide a list of context resources for the DSTU2 and STU3 versions of FHIR.  The CDS Hook specification won't be updated to include R4 resources until after R4 is finalized.  Because this implementation guide is being written to support FHIR R4 as well STU3, it provides guidance on what R4 resources are relevant for each hook (both pre-existing hooks as well as newly proposed hooks).

It is possible that the actual list of R4 resources provided for the hooks will differ from that proposed in this IG.  Future versions of the implementation guide will adjust accordingly.


#### Additional hooks
The base CDS hooks specification doesn't formally define any hooks, though three sample hooks are provided that were used in the initial testing of the specification.  The expectation is that new hooks will be defined by and eventually formally approved by the community.  The formal process for this proposal and maturity development process is still evolving.  Individuals interested in this process can provide feedback [here](https://github.com/cds-hooks/docs/issues/195).

Defining new hooks is an expected part of the CDS Hooks specification and there is no need for hooks to be officially registered with the community for them to be used.  However, using registered hooks increases the likelihood of broad adoption by the community - which increases the likelihood of broad uptake of this implementation guide.  The project has therefore proposed hooks that we believe have utility beyond just Da Vinci CRD requirements and specified them in a manner to increase the likelihood of wide support.

The additional hooks proposed for use by this project are detailed below:

*  [patient-discharge](#patient-discharge)
*  [booking-appointment](#booking-appointment)

It is possible these hooks will change over the course of the review/approval process, including changes to the names of the hooks, their context parameters or other information.  Future versions of this implementation guide will be updated to align with such changes.

NOTE: Even pre-existing hooks are not yet locked down as normative and similar changes are possible, though perhaps less likely.


#### Configuration
Each CDS Hook service provided by a payer might support multiple different types of coverage requirements checking.  For example, a payer might return information about:

*  Is prior authorization required?
*  Are there recommended alternative therapies?
*  Are there best practices associated with this therapy that are expected to be adhered to?
*  Are there internal documentation requirements?
*  Are there forms required for inclusion with prior authorization?
*  Are there forms required for inclusion with claims submission?

Not all these cards will necessarily be relevant to all users.  While it might be possible (through negotiation between provider and payer) to configure a service to withhold certain card types from certain practitioner roles, this is unlikely to be sufficiently responsive and places a considerable configuration burden on the payer software.  As well, in some cases, preferences about what information to receive could be specific to the user.  An alternative would be for the payer to host a distinct service for every single card type it was able to return, but this could result in the payer receiving 10+ service calls each time the hook fired and performing considerable redundant processing in each service.  It would therefore be nice if a hook could, upon invocation, indicate what subset of response types were wanted - for that particular hook invocation.  The client system could then dynamically configure the response types based on user type, individual user, location within the workflow where the hook was being fired, whether the hook had previously been fired or other factors.

It is not clear whether this capability will be of interest to EHR systems or to other types of decision support services.  Therefore, rather than proposing a change to the base CDS Hook specification, this IG will leverage the CDS Hook extension mechanism.  After connectathon and implementation experience, if this proves to be a useful feature, a change may be requested, and this will become a core portion of the CDS Hook environment.

Extensions will be enabled in two places:

1.  On the `CDS Service` object describing a particular service's capabilities will be an extension that describes what "configuration options" can be set
2.  On the hook's `HTTP Request` object passing specific configuration settings as part of the hook invocation


##### Configuration options
The extension here will be called `davinci-crd.configuration-options`.  It will be a Configuration object that will contain an array of available options.  Each option will include four mandatory elements:

*  A `code` that will be used when setting configuration during hook invocation
*  A data `type` for the parameter.  At present, allowed values are "boolean" and "integer"
*  A display `name` for the configuration option to appear in the client's user interface when performing configuration
*  A `description` providing a 1-2 sentence description of the effect of the configuration option

For example, a CDS Service within a Discovery Response might look like this:

{% raw %}
    {
      "hook": "medication-prescribe",
      "title": "Payer XYZ Medication Coverage Requirements",
      "description": "Indicates coverage requirements associated with draft medication orders, including expectations for prior authorization, recommended therapy alternatives, etc.",
      "id": "medication-cdr",
      "prefetch": {
        "patient": "Patient/{{context.patientId}}",
        "medications": "MedicationOrder?patient={{context.patientId}}"
      }
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

*  There is no mechanism to express co-occurrence rules amongst configuration options.  Guidance can be given about allowed combinations in descriptions, but payer services must gracefully handle disallowed/nonsensical combinations

*  No default values are declared as the default might vary by client or other contextual information based on server configuration

*  Codes SHALL be valid JSON property names

*  Codes, names and descriptions SHALL be unique within a CDS Service definition.  They SHOULD be consistent across different hooks supported by the same payer when dealing with the same types of configuration option.

**Payer services providing more than one type of coverage requirement information/guidance SHOULD expose configuration options allowing clients to dynamically control what information is returned by the service.**


##### Hook configuration
When invoking a hook, the client system can convey any supported configuration options as part of the invocation of the hook.  This will be done using the davinci-crd.configuration extension.  It will be a single object whose properties will be drawn from the `code` values from configuration options and whose values will be of the `type` defined for that option.

For example:

    {
       ...
       "hook" : "medication-prescribe",
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

*  Inclusion of configuration information in a hook call SHALL be optional.  I.e. No hook invocation is permitted to fail because configuration information was not included.


**EHR client systems SHOULD provide an ability to leverage the dynamic configuration capabilities of payer services based on practitioner role, individual practitioner and/or hook invocation location as best meets the needs of their providers.**


#### Additional Pre-fetch capabilities
One of the options supported in CDS Hooks is the ability for a service to request that certain data be [prefetched](https://cds-hooks.org/specification/1.0/#prefetch-template) for efficiency reasons and to simplify processing for the server.  However, there is a limit in that in the current CDS Hooks specification, prefetch can only use hook context information that is expressed as a simple key value.  It cannot leverage context information passed as resources.

A [proposal](https://github.com/cds-hooks/docs/issues/377) has been submitted suggesting how to address this issue.  This ballot version of the implementation guide pre-adopts that proposal.

Specifically, where a hook defines a context element that consists of a resource or collection of resources (e.g. [medication-prescribe.medications](https://cds-hooks.org/hooks/medication-prescribe/#context) or [order-review.orders](https://cds-hooks.org/hooks/order-review/#context)), systems SHALL recognize context tokens of the form `context.<prefetch key>.<FHIR resource name>.id` in prefetch queries.  Those tokens SHALL evaluate to a comma-separated list of the identifiers of all resources of the specified type within that context key.

Note: Recognizing these tokens doesn't mean the client must support prefetch or the requested prefetch query, only that it recognizes the token, not treat it as an error and, if it supports the query, substitute the token correctly.

For example, a prefetch for `order-review` might look like this:

{% raw %}
    "prefetch": {
      "ins-sr": "ServiceRequest?id={{context.orders.ServiceRequest.id}}&_include=ServiceRequest:insurance"
    }
{% endraw %}

This might result in an executed query that looks like this: `ServiceRequest?id=2347,10948,5881&_include=ServiceRequest:insurance`

BALLOT NOTE: This proposal pre-adoption is not CDS Hooks conformant.  It is possible that the CDS Hooks community will adopt an alternative solution or may even choose not to make any changes.  This implementation guide will be updated to align with the decision of the community and may, if necessary, fall back to the use of extensions if CDS Hooks does not choose to support prefetch based on context resources and the payer community determines that prefetch is still required.

In addition to this preadoption, this implementation guide presumes support for prefetch query capabilities more sophisticated than the recommended [prefetch query restrictions](https://cds-hooks.org/specification/1.0/#prefetch-query-restrictions) in the CDS Hooks specification.  Specifically, the use of [_include]({{site.data.fhir.path}}search.html#include), such as seen in the example above.


#### Additional response capabilities
CDS Hooks supports suggestions that involve multiple actions.  Coverage requirements discovery is likely to use this in two situations where additional capabilities will be needed:

*  Creating a Task to complete a Questionnaire
*  Updating the proposed order to point to a "new" prior authorization (ClaimResponse instance) - one the payer was aware of the EMR was not.

In the first case, the creation of the Questionnaire needs to be conditional - it should only occur if that particular Questionnaire version doesn't already exist.  In the second case, the order will need to be updated to point to the "id" assigned by the EHR to the newly persisted ClaimResponse instance.  Both of these capabilities are supported in FHIR's [transaction]({{site.data.fhir.path}}http.html#transaction) functionality.  However, not all of the capabilities/guidance included there has been incorporated into CDS Hooks 'suggestions', in part to keep the specification simpler.

For this release of the specification, these requirements will be handled as follows:

##### if-none-exist
The `suggestion.action` object will use an extension to carry the if-none-exist query as per FHIR's [conditional create]({{site.data.fhir.path}}http.html#ccreate) functionality.  The extension property will be `davinci-crd.if-none-exist`.  For example:

    "suggestions": [
      {
        "label": "Add 'completion of the XYZ form' to your task list (possibly for reassignment)",
        "actions": [{
          "type": "create",
          "description": "Add version 2 of the XYZ form to the EHR's repository (if it doesn't already exist)",
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

##### Linkage between created resources
The linkage between resources by identifier in different Actions within a single Suggestion doesn't actually require any extension to CDS Hooks, but it does require additional guidance.  For the purposes of this implementation guide, the inclusion of the `id` element in 'created' resources and references in created and updated resources within multi-action suggestions SHALL be handled as per FHIR's [transaction processing rules]({{site.data.fhir.path}}http.html#trules).  POST corresponds to an action.type of 'create' and PUT corresponds to an action.type of 'update'.  Specifically, this means that if a FHIR Reference points to the resource type and identifier of a resource of another 'create' Action in the same Suggestion, then the reference to that resource SHALL be updated by the server to point to the identifier assigned by the client when performing the create.  Clients SHALL perform creates in an order that ensures that referenced resources are created prior to referencing resources.

For example, the following suggestion will cause the MedicationRequest to be updated to point to the prior authorization (ClaimResponse) being created.  The ClaimResponse would be created before the MedicationRequest would be updated:

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
              "reference": "ClaimResponse/1"
            }],
            ...
          },
        },{
          "type": "create",
          "description": "Record the pre-existing prior authorization in the EHR",
          "resource": {
            "resourceType": "ClaimResponse",
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


### Hooks
Each CDS Hook defines a workflow/business process location within the client system where a specific type of decision support is relevant.  For example, the `medication-prescribe` hook fires whenever a user is in the process of ordering a medication.  In many clients, the same hook might fire in multiple locations.  For example, an EMR might have different screens for ordering regular medications vs. vaccinations vs. chemotherapy and might also have a screen for care-planning that could include plans for medications.  The same hook might be initiated from all of these locations.

This version of the implementation guide has identified four hooks that cover the main situations where coverage requirements discovery is likely to be needed.  Two of these are "standard" hooks - [medication-prescribe](#medication-prescribe) and [order-review](#order-review).  The other two are new proposed hooks - [patient-discharge](#patient-discharge) and [booking-appointment](#booking-appointment).

Not all client systems will support all hook types.  For example, community EMR systems will not support `patient-discharge`.  Community pharmacy systems would not likely support `booking-appointment`.  **Client systems conforming to this implementation guide SHALL support at least one of the hooks listed below and SHOULD support all that apply to the context of their system.**

Similarly, not all payers will necessarily provide coverage that is relevant to all hook types.  For example, a payer that only provides drug coverage would never have coverage information to return on a `patient-discharge` event.  **Payer systems conforming to this implementation guide SHALL provide a service for at least one of the hook types listed below and SHOULD support all hooks relevant to the types of coverage they provide.**

Clients and payers MAY choose to support additional hooks that are relevant to Coverage Requirements Discovery as well - both standard hooks and custom hooks.  If this occurs, they SHOULD adhere to the same expectations as defined in this specification for standard hooks.

The following sections describe the hooks covered by this implementation guide and describes any constraints, profiles and R4 resources expected to be supported by conformant implementations.

#### Pre-existing hooks
These hooks are defined within the [CDS Hook specification](https://cds-hooks.org/hooks) and have been through multiple connectathons and review by the community.  As such, they are relatively stable, though still potentially subject to change

##### medication-prescribe
This hook is described in the CDS Hook specification [here](https://cds-hooks.org/hooks/medication-prescribe).

There are no constraints or special rules related to this hook beyond the profiles expected to be used for the resources resolved to by the patientId or encounterId or in the `medications` context element:
<table class="grid">
  <thead>
    <tr>
      <th>STU3 Profile</th>
      <th>R4 Profile</th>
    </tr>
  </thead>
  <tr>
    <td><a href="stu3/profile-patient-stu3.html">profile-patient-stu3</a></td>
    <td><a href="profile-patient-r4.html">profile-patient-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-encounter-stu3.html">profile-encounter-stu3</a></td>
    <td><a href="profile-encounter-r4.html">profile-encounter-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-medicationrequest-stu3.html">profile-medicationrequest-stu3</a></td>
    <td><a href="profile-medicationrequest-r4.html">profile-medicationrequest-r4</a></td>
  </tr>
</table>

##### order-review
This hook is described in the CDS Hook specification [here](https://cds-hooks.org/hooks/order-review).

This hook supports multiple resource types.  Servers SHALL ignore resources they don't have associated coverage support for.  Clients and servers SHALL support at least one of the resource types and SHOULD support all resource types that they have corresponding content for in their systems/coverage types.

There are no additional constraints or special rules related to this hook beyond the profiles expected to be used for the resources resolved to by the patientId or encounterId or in the `orders` context element:
<table class="grid">
  <thead>
    <tr>
      <th>STU3 Profile</th>
      <th>R4 Profile</th>
    </tr>
  </thead>
  <tr>
    <td><a href="stu3/profile-devicerequest-stu3.html">profile-devicerequest-stu3</a></td>
    <td rowspan="2"><a href="profile-devicerequest-r4.html">profile-devicerequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-visionprescription-stu3.html">profile-visionprescription-stu3</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-encounter-stu3.html">profile-encounter-stu3</a></td>
    <td><a href="profile-encounter-r4.html">profile-encounter-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-medicationrequest-stu3.html">profile-medicationrequest-stu3</a></td>
    <td><a href="profile-medicationrequest-r4.html">profile-medicationrequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-nutritionorder-stu3.html">profile-nutritionorder-stu3</a></td>
    <td><a href="profile-nutritionorder-r4.html">profile-nutritionorder-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-patient-stu3.html">profile-patient-stu3</a></td>
    <td><a href="profile-patient-r4.html">profile-patient-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-procedurerequest-stu3.html">profile-procedurerequest-stu3</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-referralrequest-stu3.html">profile-referralrequest-stu3</a></td>
    <td rowspan="2"><a href="profile-servicerequest-r4.html">profile-servicerequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-supplyrequest-stu3.html">profile-supplyrequest-stu3</a></td>
    <td><a href="profile-supplyrequest-r4.html">profile-supplyrequest-r4</a></td>
  </tr>
</table>

#### New hooks
These hooks are newly proposed.  The proposals were submitted as part of the DaVinci-CRD project.  However, the hooks have been defined in a generic manner and may be relevant for a variety of use-cases.  Because they have not yet seen use at connectathon or review by the community, they are more vulnerable to change than pre-existing hooks.

##### patient-discharge
This new hook has been proposed [here](todo).  Because the hook description may evolve independently of this implementation guide, a snapshot of the hook proposal is included here to ensure consistent implementation for systems conforming to this version of the implementation guide.

<table class="grid">
  <thead>
    <th>Metadata</th>
    <th>Value</th>
  </thead>
  <tr>
    <td>specificationVersion</td>
    <td>1.0</td>
  </tr>
  <tr>
    <td>hookVersion</td>
    <td>0.1</td>
  </tr>
</table>

###### Workflow
This hook is invoked when the user is completing the discharge process for an encounter where the notion of 'discharge' is relevant - typically an inpatient encounter.  It may be invoked at the start and end of the discharge process or any time between those two points.  It allows hook services to intervene in the decision of whether discharge is appropriate, to verify discharge medications, to check for continuity of care planning, to ensure necessary documentation is present for discharge processing, etc.

###### Context

<table class="grid">
  <thead>
    <th>Field</th>
    <th>Optionality</th>
    <th>Prefetch Token</th>
    <th>Type</th>
    <th>Description</th>
  </thead>
  <tr>
    <td>patientId</td>
    <td>REQUIRED</td>
    <td>Yes</td>
    <td><i>string</i></td>
    <td>The FHIR <code>Patient.id</code> of the Patient being discharged</td>
  </tr>
  <tr>
    <td>encounterId</td>
    <td>REQUIRED</td>
    <td>Yes</td>
    <td><i>string</i></td>
    <td>The FHIR <code>Encounter.id</code> of the Encounter being ended</td>
  </tr>
</table>


There are no additional constraints or special rules related to this hook beyond the profiles expected to be used when retrieving the Patient or Encounter associated with the specified ids:
<table class="grid">
  <thead>
    <tr>
      <th>STU3 Profile</th>
      <th>R4 Profile</th>
    </tr>
  </thead>
  <tr>
    <td><a href="stu3/profile-encounter-stu3.html">profile-encounter-stu3</a></td>
    <td><a href="profile-encounter-r4.html">profile-encounter-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-patient-stu3.html">profile-patient-stu3</a></td>
    <td><a href="profile-patient-r4.html">profile-patient-r4</a></td>
  </tr>
</table>


##### booking-appointment
This new hook has been proposed [here](todo).  Because the hook description may evolve independently of this implementation guide, a snapshot of the hook proposal is included here to ensure consistent implementation for systems conforming to this version of the implementation guide.

<table class="grid">
  <thead>
    <th>Metadata</th>
    <th>Value</th>
  </thead>
  <tr>
    <td>specificationVersion</td>
    <td>1.0</td>
  </tr>
  <tr>
    <td>hookVersion</td>
    <td>0.1</td>
  </tr>
</table>

###### Workflow
This hook is invoked when the user is scheduling one or more future encounters/visits for the patient.  It may be invoked at the start and end of the booking process and/or any time between those two points.  It allows hook services to intervene in the decision of when future appointments should be scheduled, where they should be scheduled, what services should be booked, to identify actions that need to occur prior to scheduled appointments, etc.

###### Context

<table class="grid">
  <thead>
    <th>Field</th>
    <th>Optionality</th>
    <th>Prefetch Token</th>
    <th>Type</th>
    <th>Description</th>
  </thead>
  <tr>
    <td>patientId</td>
    <td>REQUIRED</td>
    <td>Yes</td>
    <td><i>string</i></td>
    <td>The FHIR <code>Patient.id</code> of Patient appointment(s) is/are for</td>
  </tr>
  <tr>
    <td>encounterId</td>
    <td>OPTIONAL</td>
    <td>Yes</td>
    <td><i>string</i></td>
    <td>The FHIR <code>Encounter.id</code> of Encounter where booking was initiated</td>
  </tr>
  <tr>
    <td>appointment</td>
    <td>REQUIRED</td>
    <td>Yes</td>
    <td><i>object</i></td>
    <td>DSTU2/STU3/R4 - FHIR Bundle of Appointments in 'proposed' state</td>
  </tr>
</table>

There are no additional constraints or special rules related to this hook beyond the profiles expected to be used for the resources resolved to by the patientId or encounterId or in the `appointments` context element:
<table class="grid">
  <thead>
    <tr>
      <th>STU3 Profile</th>
      <th>R4 Profile</th>
    </tr>
  </thead>
  <tr>
    <td><a href="stu3/profile-appointment-stu3.html">profile-appointment-stu3</a></td>
    <td><a href="profile-appointment-r4.html">profile-appointment-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-encounter-stu3.html">profile-encounter-stu3</a></td>
    <td><a href="profile-encounter-r4.html">profile-encounter-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-patient-stu3.html">profile-patient-stu3</a></td>
    <td><a href="profile-patient-r4.html">profile-patient-r4</a></td>
  </tr>
</table>


### Cards
[Cards](https://cds-hooks.org/specification/1.0/#card-array) are the mechanism used to return coverage requirements from the payer to the client system.

#### General guidance
In addition to the [guidance provided](https://cds-hooks.org/specification/1.0/#card-attributes) in the CDS Hooks specification, the following recommendations should be adhered to by payer systems when constructing cards:

*  The `Card.indicator` should be populated from the perspective of the clinical decision maker, not the payer.  While failure to procure a pre-authorization might be 'critical' from the perspective of payment, it would be - at best - a 'warning' from the perspective of clinical care.  'critical' should be reserved for reporting life or death or serious clinical outcomes.  Issues where the proposed course of action will negatively affect the ability of the payer or patient to be reimbursed would generally be a 'warning'.  Most Coverage Requirements should be marked as 'info'.

*  The `Card.source` should be a name that the practitioner and patient will recognize.  If coverage recommendations are being returned by a benefits manager or intermediary, the source should still be identified as the insurer listed on the patient's insurance card.  If an insurer is providing recommendations from another authority (e.g. a clinical society), the society's name and logo might be displayed, though usually only with the permission of that organization.

*  Clinicians are busy.  Time spent reading a payer-returned card is inevitably time not spent reviewing other information or interacting with the patient.  If not useful or relevant, practitioners will quickly learn to ignore - or even demand the disabling of payer-provided alerts.  Therefore, information should be delivered efficiently and be tuned to provide maximum relevance.  Specifically:

    *  `Card.summary` should provide actionable information.  "Coverage alert" would not be very helpful "Drug not covered.  Covered alternatives available" or "Pre-authorization required" would be better.

    *  `Card.detail` and/or external links should only be provided when coverage recommendations can't be clearly provided in the 140 character limit of `Card.summary`.

    *  `Card.detail` should provide gradiated information with critical information being provided in the first paragraph and less critical information towards the end of the page.

    *  Detail should always provide sufficient context so a practitioner can determine whether its worth the precious seconds to launch an app or external link - and should ideally have a sense of where to look/how to use whatever link/app they do launch in the specific context of the order they're making at the time.

    *  Keep the number of cards manageable.  Consider whether clinician workflow will be faster with separate cards for each link or a single card having multiple links.  Typically using the smallest number cards that still support descriptive actionable summaries is best.

    *  When providing links, don't send the clinician to the first page of a 80+ page PDF.  Keep document size short and/or provide linking directly to the section that is relevant for the context.

    *  While links are permitted in the markdown content of `Card.detail`, support for this is not universal, so links should always also be provided in `Card.link`.  This also provides a consistent place for practitioners to access all relevant links.

    *  Because not all client systems will support all card capabilities, card options should provide sufficient information that a practitioner can perform record changes manually if automated support isn't possible.


#### Potential CRD Response Types
This section describes the different types of card responses that can be used when returning coverage requirements and defines expectations for how that information should be represented.  It's possible that some payers and clients might support additional card response patterns than those listed here, but such behavior is outside the scope of this specification.  Future versions of this specification may standardize additional response types.

Of the card types here, conformant client systems SHALL support the [External reference](#external-reference) and [Instructions](#instructions) responses.  They SHOULD support the remainder.  Payer servers SHALL support at least one of these response type and MAY support as many as necessary to convey the requirements of the types of coverage they support.

Response types are listed from least sophisticated to most sophisticated - and potentially more useful/powerful.  As a rule, the more a card can automate and the more context-specific behavior, the more useful the deision support will be to the clinician and the more likely it will actually be used.

Note: Hook responses will frequently contain multiple cards and those cards may draw from a variety of response types.  For example, providing links, textual guidance as well as suggestions for alternative orders.

Additional Note: The Response Types listed here are *not* the same as the types specified above in [Configuration Options](#configuration-options).  The same response type could correspond to multiple configuration types.  For example, [External Reference](#external-reference) could cover clinical practice guidelines, pre-authorization requirements, claims attachment requirmenets and other things.  Similarly, one configuration type could be satisfied with multiple response types.  For example, forms requirements might be expressed through a mixture of [External References](#external-reference) and explicit [Request Form Completion](#request-form-completion) responses.


##### External Reference
This provides one or more links to external web pages, PDFs or other resources that provide relevant coverage information.  These might provide clinical guidelines, pre-authorization requirements, printable forms, etc. Typically these references would be links to information available from the payer's website, though pointers to other authoritative sources are possible too.  The card will have at least one `Card.link`.  The `Link.type` will be have a type of "absolute".  E.g.

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

##### Instructions
This can be a more-sophisticated type of card because it more easily allows returned information to be tuned to the specific context of the order/encounter that triggered the hook.  In some cases, the text returned might be generated uniquely each time a response is fired.  It displays textual guidance to the user making the decisions.  This text might provide clinical guidelines, suggested changes, rules around pre-authorization, or even something as simple as "No special coverage requirements".  E.g.

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


##### Propose alternate request
This type of response allows the payer to suggest alternatives to the current proposed therapy.  This might be updating the order to change certain information or proposing completely replacing the order with one or more alternatives.  This might be used to propose a change to a first-line treatment, to alter therapy frequency or drug dosage to be consistent with coverage guidelines, to propose covered products or services as substitutes for a non-covered service and/or to propose therapeutically equivalent treatments that will have a lower cost to the patient.

Multiple alternatives can be proposed by providing multiple suggestions.  Each suggestion should contain either a single "update" action to revise the existing proposed order; or both a "delete" action for the current proposed order and a "create" action for the new proposed order.  In some cases, additional "create" actions might be needed if there's a need to convey a non-[contained]({{site.data.fhir.path}}references.html#contained) Medication, Device or other resource.  The "delete" resource is not expected to adhere to any profile as it is only expected to contain the "id" property.

The choice of "update" vs. "delete + create" should be based on how significant the change is - and how relevant other decision support on the original request will still be.  If cards returned by other service providers might still be relevant (e.g. because there was just a small change in dose or frequency), then performing an 'update' will allow updates from other decision support cards to also be applied.  If the change is significant enough that other decision support will not be relevant, a delete + create will allow the client to suppress decision support cards that no longer apply.

When using this response type, the proposed orders (and any associated resources) SHALL comply with the following profiles:

<table class="grid">
  <thead>
    <tr>
      <th>STU3 Profile</th>
      <th>R4 Profile</th>
      <th>Comments</th>
    </tr>
  </thead>
  <tr>
    <td><a href="stu3/profile-device-stu3.html">profile-device-stu3</a></td>
    <td><a href="profile-device-r4.html">profile-device-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-devicerequest-stu3.html">profile-devicerequest-stu3</a></td>
    <td rowspan="2"><a href="profile-devicerequest-r4.html">profile-devicerequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-visionprescription-stu3.html">profile-visionprescription-stu3</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-encounter-stu3.html">profile-encounter-stu3</a></td>
    <td><a href="profile-encounter-r4.html">profile-encounter-r4</a></td>
    <td>Only if updating an Encounter - e.g. to add a note</td>
  </tr>
  <tr>
    <td><a href="stu3/profile-medication-stu3.html">profile-medication-stu3</a></td>
    <td><a href="profile-medication-r4.html">profile-medication-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-medicationrequest-stu3.html">profile-medicationrequest-stu3</a></td>
    <td><a href="profile-medicationrequest-r4.html">profile-medicationrequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-nutritionorder-stu3.html">profile-nutritionorder-stu3</a></td>
    <td><a href="profile-nutritionorder-r4.html">profile-nutritionorder-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-procedurerequest-stu3.html">profile-procedurerequest-stu3</a></td>
    <td rowspan="2"><a href="profile-servicerequest-r4.html">profile-servicerequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-referralrequest-stu3.html">profile-referralrequest-stu3</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-supplyrequest-stu3.html">profile-supplyrequest-stu3</a></td>
    <td><a href="profile-supplyrequest-r4.html">profile-supplyrequest-r4</a></td>
  </tr>
</table>


TODO: example


##### Identify additional orders as companions/pre-requisites for current order
In this case, rather than proposing a change to the current proposed order.  For example, lab tests that need to be done prior to the order or on an ongoing basis after the order; recommended companion medications, etc.  This will normally involve additional "create" actions.  The fact there is no "delete" for the original order conveys that these are supplemental actions rather than replacement actions.  As with the previous response type, in some cases multiple resources will need to be created to convey the full suggestion (e.g. Medicaiton, Device, etc.)

When using this response type, the proposed orders (and any associated resources) SHALL comply with the following profiles:

<table class="grid">
  <thead>
    <tr>
      <th>STU3 Profile</th>
      <th>R4 Profile</th>
    </tr>
  </thead>
  <tr>
    <td><a href="stu3/profile-communicationrequest-stu3.html">profile-communicationrequest-stu3</a></td>
    <td><a href="profile-communicationrequest-r4.html">profile-communicationrequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-device-stu3.html">profile-device-stu3</a></td>
    <td><a href="profile-device-r4.html">profile-device-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-devicerequest-stu3.html">profile-devicerequest-stu3</a></td>
    <td rowspan="2"><a href="profile-devicerequest-r4.html">profile-devicerequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-visionprescription-stu3.html">profile-visionprescription-stu3</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-medication-stu3.html">profile-medication-stu3</a></td>
    <td><a href="profile-medication-r4.html">profile-medication-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-medicationrequest-stu3.html">profile-medicationrequest-stu3</a></td>
    <td><a href="profile-medicationrequest-r4.html">profile-medicationrequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-nutritionorder-stu3.html">profile-nutritionorder-stu3</a></td>
    <td><a href="profile-nutritionorder-r4.html">profile-nutritionorder-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-procedurerequest-stu3.html">profile-procedurerequest-stu3</a></td>
    <td rowspan="2"><a href="profile-servicerequest-r4.html">profile-servicerequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-referralrequest-stu3.html">profile-referralrequest-stu3</a></td>
  </tr>
  <tr>
    <td><a href="stu3/profile-supplyrequest-stu3.html">profile-supplyrequest-stu3</a></td>
    <td><a href="profile-supplyrequest-r4.html">profile-supplyrequest-r4</a></td>
  </tr>
</table>

TODO: example


##### Request form completion
A common response type of response is to indicate forms that need completion.  These might be forms needed for pre-authorization or as attachments for claims submission.  They might also just be for internal use to retain as proof of following clinical need protocols and to have available in the event of audit.  While forms can be expressed as static or active PDFs referenced by [External References](#external-reference), this response type provides the form definition as a FHIR Questionnaire and creates a Task within the EHR allowing the completion of the form to be appropriately scheduled and/or delegated.  Alternatively, the Practitioner could choose to execute the task and fill out the form immediately if that makes more sense from a clinical workflow perspective.

This suggestion will always include a "create" action for the Task.  The Task will point to the questionnaire to be completed using the `Task.instantiatesUri` property.  That Questionnaire might be included with a separate conditional "create" action, or might be excluded with the presumption it will already be available or retrievable by the client via its canonical URL from the original source or from a local registry.  The `Task.code` will always include the CRD-specific `complete-questionnaire` code.  The reason for completion will be conveyed in `Task.reasonCode`.

When using this response type, the proposed orders (and any associated resources) SHALL comply with the following profiles:

<table class="grid">
  <thead>
    <tr>
      <th>STU3 Profile</th>
      <th>R4 Profile</th>
    </tr>
  </thead>
  <tr>
    <td><a href="stu3/profile-taskquestionnaire-stu3.html">profile-taskquestionnaire-stu3</a></td>
    <td><a href="profile-taskquestionnaire-r4.html">profile-taskquestionnaire-r4</a></td>
  </tr>
</table>
  
No profile is provided for the Questionnaires pointed to by the Task.  Payers SHOULD use questionnaires that are compliant with either the [Argonaut Questionnaire profiles](todo) (for forms to be completed within the EHR) or the [Structured Data Capture profiles](http://hl7.org/fhir/us/sdc) (for more sophisticated forms to be created within a SMART on FHIR app or through an external service).

The following is an example where the specified questionnaire is either expected to be available within the client system or available for retrieval through its canonical URL.  An example showing inclusion of both the Task and the referenced Questionnaire can be found [above](#if-none-exist).

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

##### Create or update Coverage information
This response is used when the payer is aware of addtional coverage that is relevant to the current/proposed activity or has updates/corrections to make to the information held by the client system.  For example, the client system might be aware that a patient has coverage with a particular provider, but not know the plan number, member identifier or other relevant information.  This response allows the payer to convey that information to the client system and also link it to the current/proposed action.  In theory, this type of response could also be used to convey corrected/additional pre-authorization information the payer was aware of, however that functionality is out-of-scope for this release of the implementation guide.

This response will contain a single suggestion.  The primary action within it will either be an "update" of an existing client Coverage instance (if the client already has one) or a "create" of a new Coverage instance if the payer is aware of Coverage that the client system is not.  In addition, the suggestion MAY include updates on all relevant Request resources to add or remove links to Coverate instances, reflecting which Coverages are relevant to which types of requests.

For example:

    {
      "summary": "EHR coverage information is incomplete",
      "indicator": "info",
      "source": {
        "label": "Some Payor",
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
              "subscriberId": "",
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


##### Launch SMART application
SMART apps allow more sophisticated interaction between payers and practitioners.  They provide full control over user interface, workflow, etc.  With permission, they can also access patient clinical data to help guide the interactive experience and minimize data entry.  Apps can provide a wide variety of functions, including eligibility checking, guiding users through form entry, providing education, etc.

All such apps will need to go through the approval processes for the client's provider organization and typically also the associated software vendor.  This response type can cue the launching of such apps to occur in the context in which they are relevant to patient care and/or to payment-related decision-making.

This type of response is just a modified version of the [External Reference](#external-reference) response type.  However, the `Link.type` will be "smart" instead of "absolute".  The `Link.appContext` will typically also be present.  For example:

 {
      "summary": "Launch opiod XYZ-assessment",
      "indicator": "info",
      "detail": "This is an example card.",
      "source": {
        "label": "Some Payor",
        "url": "https://example.com",
        "icon": "https://example.com/img/icon-100px.png"
      },
      "links": [
        {
          "label": "Opiod XYZ-assessment",
          "url": "https://example.org/opiod-assessment",
          "type": "smart"
        }
      ]
    }


### Prefetch
Prefetch is an optional capability of CDS Hooks that allows the client to perform certain query functions on behalf of the server and provide the results in the initial hook invocation.  This allows the client to optimize query performance and can simplify functionality for the server.

In the CRD implementation guide, there's a common set of queries that define data that most, if not all, payers will need to perform their requirements assessment.  This section defines those queries.

For this release of the implementation guide, conformant clients SHOULD support the CDS Hooks prefetch capability and be able to perform all of the prefetch queries defined here.

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

#### Queries

The 'standard' prefetch queries for this implementation guide that SHOULD be supported for each type of resource are shown in the table below.  Those search parameters with hyperlinks are defined as part of this implementation guide.  The remainder are defined within their respective version of the FHIR core specification.  These queries leverage the CDS Hook context extension [described above](#additional-pre-fetch-capabilities)

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
      <code>Appointment?id={{context.orders.Appointment.id}} &_include=Appointment:patient, Appointment:practitioner, Appointment:location, Appointment:<a href="stu3/searchparameter-appointment-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No requester, no performer organization</td>
  </tr>
  <tr>
    <td>Appointment</td>
    <td>R4</td>
    <td>
      <code>Appointment?id={{context.orders.Appointment.id}} &_include=Appointment:patient, Appointment:practitioner:PractitionerRole, PractitionerRole:organization, PractitionerRole:practitioner, Appointment:location, Appointment:<a href="appointment-insurance-r4.html">insurance</a>:Coverage</code>
    </td>
    <td>No requester</td>
  </tr>
  <tr>
    <td>DeviceRequest</td>
    <td>STU3</td>
    <td>
      <code>DeviceRequest?id={{context.orders.DeviceRequest.id}} &_include=DeviceRequest:patient, DeviceRequest:performer, DeviceRequest:requester, DeviceRequest:device, DeviceRequest:<a href="stu3/searchparameter-devicerequest-on-behalf-stu3.html">on-behalf</a>, DeviceRequest:<a href="stu3/searchparameter-devicerequest-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No performing location</td>
  </tr>
  <tr>
    <td>DeviceRequest</td>
    <td>R4</td>
    <td>
      <code>DeviceRequest?id={{context.orders.DeviceRequest.id}} &_include=DeviceRequest:patient, DeviceRequest:performer, DeviceRequest:requester, DeviceRequest:device, PractitionerRole:organization, PractitionerRole:practitioner, DeviceRequest:insurance:Coverage</code>
    </td>
    <td>No performing location</td>
  </tr>
  <tr>
    <td>Encounter</td>
    <td>STU3</td>
    <td>
      <code>Encounter?id={{context.orders.Encounter.id}} &_include=Encounter:patient, Encounter:service-provider, Encounter:practitioner, Encounter:location, Encounter:<a href="stu3/searchparameter-encounter-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
  </tr>
  <tr>
    <td>Encounter</td>
    <td>R4</td>
    <td>
      <code>Encounter?id={{context.orders.Encounter.id}} &_include=Encounter:patient, Encounter:service-provider, Encounter:practitioner, Encounter:location, Encounter:<a href="encounter-insurance-r4.html">insurance</a>:Coverage</code>
    </td>
    <td>No requester</td>
  </tr>
  <tr>
    <td>MedicationRequest</td>
    <td>STU3</td>
    <td>
      <code>MedicationRequest?id={{context.orders.MedicationRequest.id}} &_include=MedicationRequest:patient, MedicationRequest:intended-dispenser, MedicationRequest:requester:Practitioner, MedicationRequest:medication, MedicationRequest:<a href="stu3/searchparameter-medicationrequest-on-behalf-stu3.html">on-behalf</a>, MedicationRequest:<a href="stu3/searchparameter-medicationrequest-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No performing location</td>
  </tr>
  <tr>
    <td>MedicationRequest</td>
    <td>R4</td>
    <td>
      <code>MedicationRequest?id={{context.orders.MedicationRequest.id}} &_include=MedicationRequest:patient, MedicationRequest:intended-dispenser, MedicationRequest:requester:PractitionerRole, MedicationRequest:medication, PractitionerRole:organization, PractitionerRole:practitioner, MedicationRequest:<a href="medicationrequest-insurance-r4.html">insurance</a>:Coverage</code>
    </td>
  </tr>
  <tr>
    <td>NutritionOrder</td>
    <td>STU3</td>
    <td>
      <code>NutritionOrder?id={{context.orders.NutritionOrder.id}} &_include=NutritionOrder:patient, NutritionOrder:provider, NutritionOrder:requester, NutritionOrder:encounter, Enconuter:location, NutritionOrder:<a href="stu3/searchparameter-nutritionorder-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No organization, location only through request encounter</td>
  </tr>
  <tr>
    <td>NutritionOrder</td>
    <td>R4</td>
    <td>
      <code>NutritionOrder?id={{context.orders.NutritionOrder.id}} &_include=NutritionOrder:patient, NutritionOrder:provider, NutritionOrder:requester, PractitionerRole:organization, PractitionerRole:practitioner, NutritionOrder:encounter, Encounter:location, NutritionOrder:<a href="nutritionorder-insurance-r4.html">insurance</a>:Coverage</code>
    </td>
    <td>Location only through request encounter</td>
  </tr>
  <tr>
    <td>ProcedureRequest</td>
    <td>STU3</td>
    <td>
      <code>ProcedureRequest?id={{context.orders.ProcedureRequest.id}} &_include=ProcedureRequest:patient, ProcedureRequest:performer, ProcedureRequest:requester, ProcedureRequest:<a href="stu3/searchparameter-procedurerequest-on-behalf-stu3.html">on-behalf</a>, ProcedureRequest:<a href="stu3/searchparameter-procedurerequest-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No performer location</td>
  </tr>
  <tr>
    <td>ReferralRequest</td>
    <td>STU3</td>
    <td>
      <code>ReferralRequest?id={{context.orders.ReferralRequest.id}} &_include=ReferralRequest:patient, ReferralRequest:recipient, ReferralRequest:requester, ReferralRequest:<a href="stu3/searchparameter-referralrequest-on-behalf-stu3.html">on-behalf</a>, ReferralRequest:<a href="stu3/searchparameter-referralrequest-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No performer location</td>
  </tr>
  <tr>
    <td>ServiceRequest</td>
    <td>R4</td>
    <td>
      <code>ServiceRequest?id={{context.orders.ServiceRequest.id}} &_include=ServiceRequest:patient, ServiceRequest:performer, ServiceRequest:requester, PractitionerRole:organization, PractitionerRole:practitioner, ServiceRequest:<a href="servicerequest-insurance-r4.html">insurance</a>:Coverage</code>
    </td>
    <td>No performer location</td>
  </tr>
  <tr>
    <td>SupplyRequest</td>
    <td>STU3</td>
    <td>
      <code>SupplyRequest?id={{context.orders.SupplyRequest.id}} &_include=SupplyRequest:<a href="stu3/searchparameter-supplyrequest-patient-stu3.html">patient</a>, SupplyRequest:supplier:Organization, SupplyRequest:requester:Practitioner, SupplyRequest:requester:Organization, SupplyRequest:<a href="stu3/searchparameter-supplyrequest-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No performer location</td>
  </tr>
  <tr>
    <td>SupplyRequest</td>
    <td>R4</td>
    <td>
      <code>SupplyRequest?id={{context.orders.SupplyRequest.id}} &_include=SupplyRequest:<a href="supplyrequest-patient-r4.html">patient</a>, SupplyRequest:supplier:Organization, SupplyRequest:requester:Practitioner, SupplyRequest:requester:Organization,, SupplyRequest:Requester:PractitionerRole, PractitionerRole:organization, PractitionerRole:practitioner, SupplyRequest:<a href="supplyrequest-insurance-r4.html">insurance</a>:Coverage</code>
    </td>
    <td>No performer location</td>
  </tr>
  <tr>
    <td>VisionPrescription</td>
    <td>STU3</td>
    <td>
      <code>VisionPrescription?id={{context.orders.VisionPrescription.id}} &_include=VisionPrescription:patient, VisionPrescription:prescriber, VisionPrescription:<a href="stu3/searchparameter-visionprescription-insurance-stu3.html">insurance</a>:Coverage</code>
    </td>
    <td>No performer, organization or location</td>
  </tr>
</table>

#### Notes
*  Executing these queries will bring back a degree of redundant information: repeating the request, Encounter and Appointment resources found in the hook contexts and repeating Patient, Practitioner, Organization and Coverage resources that are common for different request types for the `order-review` hook.  This redundancy is simply the price that must be paid for using the prefetch mechanism and leveraging the benefits of a common standard.  Payers seeking greater efficiency can perform direct queries that are more tuned (e.g. a Batch of queries that search for specific resources by ids based on the context resource information)

* The queries presume that 'standard' the search parameter names are 'standard' - either for the STU 3 or R4 specifications, or for the SearchParameter instances declared in this implementation guide.  Payer systems SHALL construct their `prefetch` templates using these standard names and client systems SHALL convert from these standard names to local names as necessary before executing their queries.

* When full prefetch as defined here is not supported, client systems SHALL, at minimum, support the batch query syntax shown at the end of this section.  Payer systems may choose to support the batch query mechanism, perform client-specific queries as necessary or return no results when a client does not support its prefetch requirements.

* While these queries attempt to bring back all of the potentially relevant information, not all information will necessarily exist for all requests or events, particularly at the time the hook is called.  Services SHOULD provide what coverage requirements they can based on the information available.

#### Examples

TODO

### SMART on FHIR Hook Invocation
In addition to the real-time decision support provided by CDS Hooks, practitioners will sometimes need to seek coverage requirements information without invoking the workflow of their clinical system to actively create an order, appointment, encounter, etc.  For example, if exploring a "what if" scenario, when answering a patient question or when needing to retrieve a guidance document they had seen in a previous card and now need to review/dig deeper.

The solution to this need to perform coverage discovery "any time" is the use of a SMART on FHIR app.  Most EHR systems provide support for SMART on FHIR.  That standard allows independently developed applications to be launched from within the EHR (possibly within the EHR's user interface) and to interact with the EHR's data repository.  As part of its scope, this project will, through the Da Vinci organization, develop an open source SMART on FHIR application that allows a user to invoke solicit coverage requirements from payer systems "at will".  The SMART on FHIR app will interact with the payer systems using the existing SMART on FHIR interface.

Clients conforming with this application SHALL support the SMART on FHIR interface, allow launching of SMART apps from within their application and be capable of providing the SMART app access to the same resources it exposes to payer systems using the CDS Hooks interface.

The current version of the Da Vinci CDR SMART app can be found [TODO](todo).


### Privacy, Security and Safety

Guidance and conformance expectations around privacy and security are provided by all three specifications this implementation guide relies on.  Implementers SHALL be familiar with and adhere to any security and privacy rules defined by:

* FHIR core: [Security & Privacy module]({{site.data.fhir.path}}secpriv-module.html), [Security Principles]({{site.data.fhir.path}}security.html) and [Implementer's Checklist]({{site.data.fhir.path}}safety.html)
* CDS Hooks: [Security & Safety](https://cds-hooks.org/specification/1.0/#security-and-safety)
* SMART on FHIR: [SMART App Launch](http://www.hl7.org/fhir/smart-app-launch)

In addition to these, this implementation guide imposes the following additional rules:

* All communications between Client and Payer systems and between SMART on FHIR apps and Payer systems SHALL be over dual-certificate mutually authenticated TLS connections
    * This specification does not provide guidance on certificate management between clinical and payer systems, though it has been proposed that Direct certificates could be used for this purpose
* Client systems SHALL support running applications that adhere to the SMART on FHIR [public app](http://www.hl7.org/fhir/smart-app-launch#support-for-public-and-confidential-apps) profile
* Payer systems that wish to receive Hook invocations that contain PHI SHALL demonstrate at time of registration/configuration that their user agreements give them permission to receive such data in a coverage requirement context.
* Payer systems SHALL use information received solely for coverage determination purposes and shall not retain received over the CRD interfaces for any purpose other than audit
* Client systems are the final arbiters of what data can be shared with payer systems.  They MAY filter or withhold any resources or data elements necessary to support their obligations as health data custodians, including legal, policy and patient consent-based restrictions.  However, clients systems witholding information take on the responsibility of ensuring coverage requirements are met, even if discovery is no longer possible through the interfaces provided by this implementation guide.
* Client systems SHALL ensure that the resource identifiers exposed over the CRD interface are distinct from and have no determinable relationship with any business identifiers associated with those records.  E.g. the Patient.id element cannot be the same as or contain in some fashion a patient's social security number or medical record number.


#### Non-PHI Hook Invocation
Some payers may not have legal permission to view patient-identifiable healthcare information (PHI) for coverage requirements discovery purposes.  EHR systems SHALL support filtering exposed FHIR resources to be a non-PHI "redacted" view.  This view SHALL ensure that all resources exposed through the CDS Hooks and SMART on FHIR interfaces are filtered as follows:

* The Patient resource adhere's to the [STU3 de-identified patient profile](stu3/profile-patient-deident-stu3.html) or [R4 de-identified profile](profile-patient-deident-r4.html), depending on the version supported
* All resource narratives are removed
* All 'text' and 'display' elements are removed
* All extensions other than those explicitly mentioned in the profiles in this implementation guide are removed

Client systems SHALL determine whether a payer system should receive the PHI or non-PHI version of the CRD interface at the time the payer is configured to have access to their system.


### Additional Considerations

1. Practitioners will rely on the information provided by the Coverage Requirements Discovery process to determine if there are any special steps they need to take such as requesting preathorization.  As a result it's important to them to know definitively whether requirements exist or not.  While potentially noisy, payers SHALL provide a message that says "No coverage requirements for [ABC]" if it is definitively known that there are no requirements for the proposed action or "Unable to determine coverage requirements for [ABC] - please review [XYZ]" some equivalent when processing errors (e.g. unrecognized service code) prevent the payer from determining coverage requirements.

2. The receipt of coverage requirements (be it "no requirements" or specific requirements/recommendations) has financial implications for both practitioners and payers.  If a practitioner receives a message of "no requirements" and subsequently has a claim denied because of unmet requirements, it will be necessary for both sides to be able to confirm whether a "no requirements" response was sent and what information was in the hook invocation that led to that request.  Therefore, in addition to any logging performed for security purposes both clients and servers SHALL retain logs of all CRD-related hook invocations and their responses that can be accessed in the event of a dispute by authorized personnel.  As well, all `Card.suggestion` elements SHALL populate the `Suggestion.uuid` element to aid in logging.

    NOTE: Because the information in these logs will often contain PHI, access to the logs themselves will need to be logged for security purposes.

3. Client systems may fire these hooks multiple times during the creation/editing/review phase.  It is therefore the client's responsibility to manage resulting cards and determining whether to display the same cards repeatedly or to somehow manage them such that the end user isn't overwhelmed by seeing the same advice multiple times.

4. Most implementation guides provide JSON, XML and Turtle representations of artifacts.  However, because this guide is primarily using CDS Hooks (which only supports JSON) and SMART on FHIR (which primarily uses JSON), this implementation guide only publishes the JSON version of artifacts.

5. The examples in this guide use whitespace for readablity.  Conformance systems SHOULD omit non-significant whitespace for performance reasons

6. Examples provided within this specification strive to be realistic, but may not reflect accurate/current coverage requirements
