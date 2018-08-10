This implementation guide relies on the [CDS Hooks Specification](https://cds-hooks.org/specification/1.0).  It uses [hooks](https://cds-hooks.org/hooks/) to define the workflow locations within an EHR where solicitation of coverage requirements is useful/appropriate and then returns CDS Hook [cards](https://cds-hooks.org/specification/1.0/#cds-service-response) to provide coverage requirements back from the payer organization.  Implementers are expected to familiarize themselves with the CDS Hooks specification and comply with it in implementing the features declared here.

### Customization
CDS Hooks is a relatively new technology and, at the time this version of the implementation guide was written, has not yet been officially published as a first release.  It is considered a "Standard for Trial Use", meaning that it will continue to evolve based on implementer feedback and may change in ways that are not compatible with the current draft.  As well, the initial version of the specification has focused on the core architecture and a relatively simple set of capabilities.  Additional capabilities will be introduced in future versions.

To meet requirements identified by Da Vinci project participants, it is necessary to introduce some additional capabilities above and beyond what is currently found in the CDS Hooks specification.  This section of the CRD implementation guide describes those additional capabilities and the mechanism the implementation guide proposes to implement them.  The purpose of these customizations is to enable testing at connectathons and to support feedback into the CDS Hooks design process.

Each capability listed here has been proposed to the CDS Hooks community and may well become part of the official specification either in the initial release or in some future release.  However, there is a significant likelihood that the manner in which the requirements are met may vary somewhat from a syntax or even an architectural approach.  Future versions of this implementation guide will be updated to align with how these requirements are addressed in future versions of the CDS Hook specification.  This implementation guide will not be able to be *Normative* (locked into backward compatibility mode) until the underlying CDS Hooks content is also *normative*.

This implementation guide extends/customizes CDS Hooks in 5 ways: support for R4, new hooks, a hook configuration mechanism, additional pre-fetch capabilities and additional response capabilities.  Each are described below:


#### Support for R4
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

*  Is preauthorization required?
*  Are there recommended alternative therapies?
*  Are there best practices associated with this therapy that are expected to be adhered to?
*  Are there internal documentation requirements?
*  Are there forms required for inclusion with preauth?
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
      "description": "Indicates coverage requirements associated with draft medication orders, including expectations for preauthorization, recommended therapy alternatives, etc.",
      "id": "medication-cdr",
      "prefetch": {
        "patient": "Patient/{{context.patientId}}",
        "medications": "MedicationOrder?patient={{context.patientId}}"
      }
      "extension": {
        "davinci-crd.configuration-options": [
          {
            "code": "preauth",
            "type": "boolean",
            "name": "Preauthorization",
            "description": "Provides indications of whether preauthorization is required for the proposed order"
          },
          {
            "code": "preauth-form",
            "type": "boolean",
            "name": "Preauthorization Forms",
            "description": "Indicates any forms that should be completed as part of a preauthorization process"
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
           "preauth": true,
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

In addition to this preadoption, this implementation guide presumes support for prefetch query capabilities more sophisticated than the recommended [prefetch query restrictions](https://cds-hooks.org/specification/1.0/#prefetch-query-restrictions) in the CDS Hooks specification.  Specifically, the use of [_include](http://hl7.org/fhir/search.html#include), such as seen in the example above.


#### Additional response capabilities
CDS Hooks supports suggestions that involve multiple actions.  Coverage requirements discovery is likely to use this in two situations where additional capabilities will be needed:

*  Creating a Task to complete a Questionnaire
*  Updating the proposed order to point to a "new" preauthorization (ClaimResponse instance) - one the payer was aware of the EMR was not.

In the first case, the creation of the Questionnaire needs to be conditional - it should only occur if that particular Questionnaire version doesn't already exist.  In the second case, the order will need to be updated to point to the "id" assigned by the EHR to the newly persisted ClaimResponse instance.  Both of these capabilities are supported in FHIR's [transaction](http://hl7.org/fhir/http.html#transaction) functionality.  However, not all of the capabilities/guidance included there has been incorporated into CDS Hooks 'suggestions', in part to keep the specification simpler.

For this release of the specification, these requirements will be handled as follows:

##### if-none-exist
The `suggestion.action` object will use an extension to carry the if-none-exist query as per FHIR's [conditional create](http://build.fhir.org/http.html#ccreate) functionality.  The extension property will be `davinci-crd.if-none-exist`.  For example:

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
            "description": "Complete XYZ form for inclusion in preauthorization",
            "for": {
              "reference": "Patient/some-patient-id"
            },
            "authoredOn": "2018-08-09",
            "reasonCode": {
              "coding": [{
                "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/task-reason",
                "code": "preauth",
                "display": "Needed for preauthorization"
              }]
            }
          }
        }]
      }
    ]

##### Linkage between created resources
The linkage between resources by identifier in different Actions within a single Suggestion doesn't actually require any extension to CDS Hooks, but it does require additional guidance.  For the purposes of this implementation guide, the inclusion of the `id` element in 'created' resources and references in created and updated resources within multi-action suggestions SHALL be handled as per FHIR's [transaction processing rules](http://build.fhir.org/http.html#trules).  POST corresponds to an action.type of 'create' and PUT corresponds to an action.type of 'update'.  Specifically, this means that if a FHIR Reference points to the resource type and identifier of a resource of another 'create' Action in the same Suggestion, then the reference to that resource SHALL be updated by the server to point to the identifier assigned by the client when performing the create.  Clients SHALL perform creates in an order that ensures that referenced resources are created prior to referencing resources.

For example, the following suggestion will cause the MedicationRequest to be updated to point to the preauthorization (ClaimResponse) being created.  The ClaimResponse would be created before the MedicationRequest would be updated:

    "suggestions": [
      {
        "label": "Update prescription to point to pre-existing preauthorization",
        "actions": [{
          "type": "update",
          "description": "Revise the prescription to include the preauthorization",
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
          "description": "Record the pre-existing preauthorization in the EHR",
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
          "insurance": [{
            "preAuthRef": ["ABCDE"]
          }]
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
    <td><a href="profile-Patient-stu3.html">profile-Patient-stu3</a></td>
    <td><a href="profile-Patient-r4.html">profile-Patient-r4</a></td>
  </tr>
  <tr>
    <td><a href="profile-Encounter-stu3.html">profile-Encounter-stu3</a></td>
    <td><a href="profile-Encounter-r4.html">profile-Encounter-r4</a></td>
  </tr>
  <tr>
    <td><a href="profile-MedicationRequest-stu3.html">profile-MedicationRequest-stu3</a></td>
    <td><a href="profile-MedicationRequest-r4.html">profile-MedicationRequest-r4</a></td>
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
    <td><a href="profile-Patient-stu3.html">profile-Patient-stu3</a></td>
    <td><a href="profile-Patient-r4.html">profile-Patient-r4</a></td>
  </tr>
  <tr>
    <td><a href="profile-Encounter-stu3.html">profile-Encounter-stu3</a></td>
    <td><a href="profile-Encounter-r4.html">profile-Encounter-r4</a></td>
  </tr>
  <tr>
    <td><a href="profile-MedicationRequest-stu3.html">profile-MedicationRequest-stu3</a></td>
    <td><a href="profile-MedicationRequest-r4.html">profile-MedicationRequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="profile-ReferralRequest-stu3.html">profile-ReferralRequest-stu3</a></td>
    <td rowspan="2"><a href="profile-ServiceRequest-r4.html">profile-ServiceRequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="profile-ProcedureRequest-stu3.html">profile-ProcedureRequest-stu3</a></td>
  </tr>
  <tr>
    <td><a href="profile-NutritionOrder-stu3.html">profile-NutritionOrder-stu3</a></td>
    <td><a href="profile-NutritionOrder-r4.html">profile-NutritionOrder-r4</a></td>
  </tr>
  <tr>
    <td><a href="profile-DeviceRequest-stu3.html">profile-DeviceRequest-stu3</a></td>
    <td rowspan="2"><a href="profile-DeviceRequest-r4.html">profile-DeviceRequest-r4</a></td>
  </tr>
  <tr>
    <td><a href="profile-VisionPrescription-stu3.html">profile-VisionPrescription-stu3</a></td>
  </tr>
  <tr>
    <td><a href="profile-SupplyRequest-stu3.html">profile-SupplyRequest-stu3</a></td>
    <td><a href="profile-SupplyRequest-r4.html">profile-SupplyRequest-r4</a></td>
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
    <td><a href="profile-Patient-stu3.html">profile-Patient-stu3</a></td>
    <td><a href="profile-Patient-r4.html">profile-Patient-r4</a></td>
  </tr>
  <tr>
    <td><a href="profile-Encounter-stu3.html">profile-Encounter-stu3</a></td>
    <td><a href="profile-Encounter-r4.html">profile-Encounter-r4</a></td>
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
    <td><a href="profile-Patient-stu3.html">profile-Patient-stu3</a></td>
    <td><a href="profile-Patient-r4.html">profile-Patient-r4</a></td>
  </tr>
  <tr>
    <td><a href="profile-Encounter-stu3.html">profile-Encounter-stu3</a></td>
    <td><a href="profile-Encounter-r4.html">profile-Encounter-r4</a></td>
  </tr>
  <tr>
    <td><a href="profile-Appointment-stu3.html">profile-Appointment-stu3</a></td>
    <td><a href="profile-Appointement-r4.html">profile-Appointment-r4</a></td>
  </tr>
</table>


### Cards
Cards are the mechanism used to return coverage requirements from the payer to the client system.  This section describes the different types of card responses that can be used when returning coverage requirements and defines expectations for how that information should be represented.  It's possible that some payers and clients might support additional card response patterns than those listed here, but such behavior is outside the scope of this specification.  Future versions of this specification may standardize additional response types.

Of the card types here, conformant client systems SHALL support the [Instructions](#instructions) and [External reference](#external_reference) responses.  They SHOULD support the remainder.  Payer servers SHALL support at least one of these response type and MAY support as many as necessary to convey the requirements of the types of coverage they support.

#### Instructions

#### External Reference

#### Propose alternate request

#### Identify additional orders as companions/pre-requisites for current order

#### Request form completion

#### Create or update Coverage information

#### Launch SMART application


### Pre-fetch
TODO: descibe expectations for prefetch support and list queries that should be supported

### Additional Considerations
What to do if there's a failure - insufficient information to process, unrecognized code, etc.

Frequency of invocation

FHIR versions

Privacy & Security

Anonymous access

SMART on FHIR App

