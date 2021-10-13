This section of the implementation guide defines specific requirements for systems wishing to conform to this Coverage Requirements Discovery implementation guide.  The bulk of the section focuses on the implementation of the [CDS Hooks Specification](https://cds-hooks.hl7.org/1.0) to meet CRD use-cases.  It also describes the use of [SMART on FHIR](http://hl7.org/fhir/smart-app-launch/index.html) and provides guidance on privacy, security and other implementation requirements.

The requirements and expectations described here are not intended to be exhaustive. The purpose of this implementation guide is to establish a baseline of expected behavior that communication partners can rely on and then build upon. Future versions of this specification will evolve based on implementer feedback. Therefore, CRD Services and CRD Clients **MAY** mutually agree to support additional hooks, additional card patterns, additional resources, additional extensions, etc. not in this specification.  Although CRD Services and CRD Clients are not required to support any capabilities defined beyond this specification, the intent is to support innovations that extend the specification in a manner that allows payers and providers to adopt those extensions in a mutually agreeable way.

### Context

#### Pre-reading
Before reading this formal specification, implementers are encouraged to first familiarize themselves with two other key portions of this implementation guide:

* The [Use Cases & Overview](usecases.html) page, which provides context for what this formal specification is trying to accomplish and will give a sense of both the business context and general process flow enabled by the formal specification below.

* The [Technical Background](background.html) page, which provides information about the underlying specifications and recommends portions that must be read and understood to have necessary foundation to understand the constraints and usage guidance described here.


#### Conventions
This implementation guide uses specific terminology to flag statements that have relevance for the evaluation of conformance with the guide:

* **SHALL** indicates requirements that must be met to be conformant with the specification.

* **SHOULD** indicates behaviors that are strongly recommended (and which could result in interoperability issues or sub-optimal behavior if not adhered to), but which do not, for this version of the specification, affect the determination of specification conformance.

* **MAY** describes optional behaviors that implementers are free to consider but where there is no recommendation for or against adoption.


#### Systems

This implementation guide sets expectations for two types of systems:

**CRD Clients** are typically systems that healthcare providers use at the point of care, including electronic medical records systems, pharmacy systems and other clinical and administrative systems used for ordering, documenting and execution of patient-related services. Users of these systems have a need for coverage requirements information to support care planning.  CRD Clients are type of CDS Client as defined in the [CDS Hooks Specification](https://cds-hooks.hl7.org/1.0).

**CRD Services** (or servers) are systems that act on behalf of payer organizations to share information with healthcare providers about rules and requirements related to healthcare products and services covered by a patient's payer.  A CRD Service might provide coverage information related to one or more insurance plans. CRD Services are type of CDS Service as defined in the [CDS Hooks Specification](https://cds-hooks.hl7.org/1.0).

#### Profiles
This specification makes significant use of [FHIR profiles]({{site.data.fhir.path}}profiling.html), search parameter definitions and terminology artifacts to describe the content to be shared as part of CDS Hook calls.  The implementation guide supports FHIR [R4]({{site.data.fhir.path}}) with profiles listed for each type of hook.

The full set of profiles defined in this implementation guide can be found by following the links on the [Artifacts](allartifacts.html) page.


#### US Core
This implementation guide also leverages the [US Core]({{site.data.fhir.ver.uscore}})  set of profiles defined by HL7 for sharing non-veterinary EMR individual health data in the U.S. Where US Core profiles exist, this Guide either leverages them directly or uses them as a base for any additional constraints needed to support the coverage requirements discovery use-case. Where no constraints are needed, this IG doesn't define additional profiles, as all US Core profiles are deemed to be part of this IG and available for use in CRD communications. For example, the US Core Observation and Condition profiles are likely to be of interest in at least some CRD scenarios and may be used by solutions conformant to this guide.

Where US Core profiles do not yet exist (e.g. for several of the 'Request' resources), profiles have been created that try to align with existing US Core profiles in terms of elements exposed and terminologies used.

There is one exception to the use of or alignment with US Core profiles.  The [non-PHI](#phi-and-hook-invocation) interfaces are not based on US Core because the US Core profiles expect support for, and sometimes demand, the sharing of patient-identifying information.

Note that, in some cases, the US Core profiles require support for data elements that are not necessarily relevant to the coverage requirements discovery use-case.  It was felt that leveraging existing standard interfaces would promote greater (and quicker) interoperability than a more tuned custom interface.  CRD Clients might still choose to restrict what information is exposed to CRD Services based on their internal data access and governance rules.


### Privacy, Security and Safety

Guidance and conformance expectations around privacy and security are provided by all three specifications this implementation guide relies on.  Implementers **SHALL** adhere to any security and privacy rules defined by:

* FHIR core: [Security & Privacy module]({{site.data.fhir.path}}secpriv-module.html), [Security Principles]({{site.data.fhir.path}}security.html) and [Implementer's Checklist]({{site.data.fhir.path}}safety.html)
* HRex: [Privacy & Security page]({{site.data.fhir.ver.hrex}}/security.html)
* CDS Hooks: [Security & Safety](https://cds-hooks.hl7.org/1.0/#security-and-safety)
* SMART on FHIR: [SMART App Launch](http://www.hl7.org/fhir/smart-app-launch)

In addition to these, this implementation guide imposes the following additional rules:

* As per the CDS Hook specification, communications between CRD Clients and CRD Services **SHALL** use TLS.  Mutual TLS is not required by this specification but is permitted.  CRD Services and CRD Clients **SHOULD** enforce a minimum version and other TLS configuration requirements based on current best practices.
    * Systems **SHOULD** comply with the most recent set of NIST guidelines and **SHALL** comply with at least the next most recent guidelines.  At the time this IG is written, the current guidelines can be found [here](https://csrc.nist.gov/CSRC/media/Publications/sp/800-52/rev-2/draft/documents/sp800-52r2-draft2.pdf).
    * This specification does not provide guidance on certificate management between systems, though it has been proposed that Direct certificates could be used for this purpose.
* CRD Clients **SHALL** support running applications that adhere to the SMART on FHIR [confidential app](http://www.hl7.org/fhir/smart-app-launch#support-for-public-and-confidential-apps) profile
* CRD Services **SHALL** use information received solely for coverage determination purposes and **SHALL NOT** retain data received over the CRD interfaces for any purpose other than audit
* CRD Clients are the final arbiters of what data can or cannot be shared with CRD Services and **MAY** filter or withhold any resources or data elements necessary to support their obligations as health data custodians, including legal, policy and patient consent-based restrictions.  Withholding information might, however, limit the completeness or accuracy of coverage requirements discovery advice retrieved using the interfaces within this guide.  The inability of a CRD service to provide full advice does not relieve providers of their responsiblity for ensuring that payer coverage requirements are met.
* CRD Clients **SHALL** ensure that the resource identifiers exposed over the CRD interface are distinct from and have no determinable relationship with any business identifiers associated with those records.  E.g. the Patient.id element cannot be the same as or contain in some fashion a patient's social security number or medical record number.

#### PHI and Hook Invocation

CRD Clients will typically need to provide patient-identifiable protected health information (PHI) to a CRD Service to perform Coverage Requirements Discovery, either because the information is needed to identify the plan that corresponds to the patient or to evaluate coverage requirements against information that the CRD Service or payer has on file - to ensure accurate guidance and to reduce unnecessary suggestions.  Nevertheless, there are situations where PHI will not be shared with a CRD Service because a patient has withheld consent to share information with the payer, the provider has concerns about sharing sensitive data with the payer or because a payer offers only a single plan with coverage requirements that can be evaluated without the use of PHI.

Therefore, CRD Clients **SHALL** provide support for Coverage Requirements Discovery without PHI using a redacted view where the resources exposed through the CDS Hooks and SMART on FHIR interfaces are filtered as follows:
* The Patient resource adheres to the [de-identified profile](StructureDefinition-profile-patient-deident.html)
* The Coverage resources adhere to the [de-identified profile](StructureDefinition-profile-coverage-deident.html)
* All resource narratives are removed
* All extensions other than those explicitly mentioned in the profiles in this implementation guide are removed
* All markdown elements and all string elements that could potentially support free-text (e.g. 'text', 'display', 'comment' and similar elements) are removed
* Any elements that would be rendered empty due to the above removals are either removed, or if cardinality restrictions would prevent their removal, are populated solely with a [data absent reason]({{site.data.fhir.path}}extension-data-absent-reason.html) extension with a code of 'masked'

CRD Clients **SHALL** determine whether a CRD Service will use the PHI or non-PHI version of the CRD interface at the time the CRD Service is configured to have access to their system.  In situations where PHI will never be required to perform Coverage Requirements Discovery, the redacted view **SHALL** be used.

NOTES:
* The non-PHI information exchanged is considered "de-identified, but potentially re-identifiable".  As such, when retaining this information for audit purposes, access to the information **SHALL** be restricted and itself audited as would access to PHI log information.
* For the purposes of non-PHI interactions, this specification does not consider the Patient resource id as PHI.  If organizational policy requires the Patient.id to be treated as PHI, implementers will need to anonymize the id and support query of the patient's related resources by the anonymized id.

#### Sensitive Orders

CRD Clients that implement the [order-select](#order-select) hook will typically fire the hook multiple times as information is gathered and entered into the system by a practitioner.  In cases where the content of an order is sensitive, it is possible that a patient will elect to pay for a medication, device, service (etc.) themselves instead of sharing the information with a payer.  In these cases, the order in which information is entered and when hooks are fired could determine whether or not information the patient deems sensitive is shared with the CRD Service and payer.

CRD Client workflows, user interfaces and CDS hook triggers **SHALL** be designed in a manner that ensures that practitioner and patient considerations govern whether information is sent to a CRD Service.

### CDS Hooks

#### Appropriate use of hooks
CDS Hooks are intended to improve healthcare provider care planning processes by allowing relevant and useful information to be inserted into provider workflows.  At the same time, inserting additional information into a provider's workflow will induce additional mental load even if the information is not acted upon and therefore must be done judiciously.

Payers and service providers **SHALL** ensure that CDS Hooks return only messages and information relevant and useful to the intended recipient.

#### Proposed Customizations to support CRD
CDS Hooks is a relatively new technology.  It is considered a "Standard for Trial Use" (STU), meaning that it will continue to evolve based on implementer feedback and could change in ways that are not compatible with the current draft.  As well, the initial version of the CDS Hooks specification has focused on the core architecture and a relatively simple set of capabilities.  Additional capabilities will be introduced in future versions.

To meet requirements identified by Da Vinci project participants, it is necessary to introduce additional capabilities above and beyond what is currently found in the CDS Hooks specification.  This section of the CRD implementation guide describes those additional capabilities and the mechanism the implementation guide proposes to implement them.  The purpose of these customizations is to enable testing at connectathons and to support feedback into the CDS Hooks design process.

Each capability listed here has been proposed to the CDS Hooks community and could become part of the official specification in a future release.  However, there is a significant likelihood that the way the requirements are met will vary from the syntax or even the architectural approach proposed in this guide.  Future versions of this implementation guide will be updated to align with how these requirements are addressed in future versions of the CDS Hook specification.  Until the both the CDS Hooks content and the FHIR and US Core content underlying this specification are *Normative* (locked into backward compatibility mode), the CRD implementation guide will remain as STU.

This implementation guide extends/customizes CDS Hooks in 5 ways: additional hook resources, a hook configuration mechanism, additional prefetch capabilities, additional response capabilities, and ability to link hooks to their corresponding request.  Each are described below:


##### Additional Hook resources
Two of the hooks used by this specification (`order-select` and `order-sign`) identify specific "order" resources that can be passed as part of the hook invocation.  CRD has use-cases for additional resource types to be passed to this hook.  Specifically:

* [DeviceRequest]({{site.data.fhir.path}}devicerequest.html) - Needed to trigger CRD when ordering prosthetics, wheelchairs, CPAP devices and other types of durable medical equipment

* [CommunicationRequest]({{site.data.fhir.path}}communicationrequest.html) - Needed to trigger CRD when a provider requests that another provider transfer patient records or other supporting information to another organization or agency.

* [Task]({{site.data.fhir.path}}task.html) - Task is used to seek fulfillment of an order from service providers.  Because coverage can be influenced by who is asked to perform an order, coverage requirements can be relevant here.  As well, task is used to request changes to existing therapies (e.g. stopping a medication, suspending a therapy, etc.) and changes to therapy can also have impacts on coverage requirements.

The proposal to add these resources to the existing hook definitions [can be found](https://github.com/cds-hooks/docs/issues/396) on the CDS hooks [issue tracker](https://github.com/cds-hooks/docs/issues).

##### New hook configuration mechanism
The CRD Services provided by payers will support discovery of different types of coverage requirements that will return different types of information to users on [CDS Cards](https://cds-hooks.hl7.org/1.0/#cds-service-response), such as:

*	Whether authorization is required
*	Recommended alternative therapies
*	Best practices associated with the planned therapy that are expected to be adhered to
*	Forms and documentation for retention within the EHR
*	Forms and documentation that must be provided with a prior authorization request
*	Forms and documentation that must be included with a claim submission

Not all of the coverage information returned by a CRD Service will be relevant to all users of all CRD Clients. It would therefore be useful to be able configure CRD Services to withhold certain card types from certain provider types, user roles, or specific users.  Preferences could potentially be configured within the CRD Service or within the CRD Client.

Managing preferences within a CRD Service would require processes to support communication and management of customization requests as well as additional complexity within the CRD Service software.  Managing preferences within the CRD Client would require it to either request specific information by invoking multiple calls to different services or by invoking a single call to the service indicating the response types desired.

The approach in this implementation guide is designed to allow the users or administrators of CRD Clients to manage and dynamically communicate desired response types to the CRD Service at the time a service is invoked.  At this time, it is not clear whether this capability will be of interest to vendors, users or for other types of CDS Services.  Therefore, rather than proposing a change to the base CDS Hook specification, this IG leverages the CDS Hook extension mechanism to provide an experimental approach to specify and control the types of information returned to users. Connectathon and implementation experience could support requesting that these changes, or some variant of them, be included in a future version of the CDS Hook specification.

Extensions will be enabled in two places:

1.  The [CDS Service Discovery Response](https://cds-hooks.hl7.org/1.0/#response) object that describes the service's capabilities will include an extension that describes what "configuration options" can be set by the CRD Client
2.  The hook's [HTTP Request](https://cds-hooks.hl7.org/1.0/#http-request_1) object will include an extension to pass specific configuration settings as part of the hook invocation


###### Configuration options extension
An extension called `davinci-crd.configuration-options` will define a configuration object with an array of available configurable options within the CDS Service, where:  

*  Each option **SHALL** include four mandatory elements:
    *  A `code` that will be used when setting configuration during hook invocation
    *  A data `type` for the parameter.  At present, allowed values are "boolean" and "integer" (NOTE: These are the JSON data types and not the FHIR data types.)
    *  A display `name` for the configuration option to appear in the client's user interface when performing configuration
    *  A `description` providing a 1-2 sentence description of the effect of the configuration option
*  A `default` value **SHOULD** also be provided to show users what to expect when an override is not specified

For example, a [CDS Service Response](https://cds-hooks.hl7.org/1.0/#response) from a CRD Service might look like this:

{% raw %}
```
  {
    "services": [
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
              "description": "Provides indications of whether prior authorization is required for the proposed order",
              "default": true
            },
            {
              "code": "prior-auth-form",
              "type": "boolean",
              "name": "Prior Authorization Forms",
              "description": "Indicates any forms that should be completed as part of a prior authorization process",
              "default": true
            },
            {
              "code": "alt-drug",
              "type": "boolean",
              "name": "Alternative therapy",
              "description": "Provides recommendations for alternative therapy with equivalent/similar clinical effect for which the patient has better coverage, that will incur lesser cost",
              "default": true
            },
            {
              "code": "first-line",
              "type": "boolean",
              "name": "First-line therapy",
              "description": "Provides alternative therapies that must be tried prior to the selected medication to receive coverage for the selected medication",
              "default": true
            },
            {
              "code": "max-cards",
              "type": "integer",
              "name": "Maximum cards",
              "description": "Indicates the maximum number of cards to be returned from the service.  The services will prioritize cards such as highest priority ones are delivered",
              "default": 10
            }
          ]
        }
      }
    ]
  }
```
{% endraw %}

Notes:

*  This version of the implementation guide is not proposing to standardize the codes, names, types or descriptions for configuration options for CRD Services.  If configurability proves to be useful, future versions of the CRD specification will work towards standardizing configuration options so that there is consistency in behavior across payer services to ease the burden on those performing configuration.

*  There is no mechanism to express co-occurrence rules amongst configuration options.  Guidance can be given about allowed combinations in descriptions, but payer services **SHALL** gracefully handle disallowed/nonsensical combinations.  I.e. the CRD Service must:

    *  allow for the possibility that CRD Clients might not adhere to their co-occurrence rules,

    *  include explicit checks of inbound data for adherence to rules; and

    *  indicate that CRD checking could not be done and log appropriate information to allow engagement with CRD Clients to address any payer-specific needs.

*  Codes **SHALL** be valid JSON property names

*  Codes, names and descriptions **SHALL** be unique within a [CDS Service](https://cds-hooks.hl7.org/1.0/#response) definition.  They **SHOULD** be consistent across different hooks supported by the same payer when dealing with the same types of configuration options.

*  Payer services providing more than one type of coverage requirement information/guidance **SHOULD** expose configuration options allowing clients to dynamically control what information is returned by the service.

###### Hook configuration extension
An extension called `davinci-crd.configuration` will define a second configuration object that will contain an array of codes and values corresponding to the configuration options configured within the CRD Client.

For example, the hook [HTTP Request](https://cds-hooks.hl7.org/1.0/#http-request_1) would look like this:

```
    {
       ...
       "hook": "order-select",
       ...
       "extension": {
         "davinci-crd.configuration": {
           "prior-auth": true,
           "alt-drug": false,
           "max-cards": 5
         }
       }
    }
```

Notes:

*	Where CRD Clients support the optional configuration options, the following requirements apply:
    *	CRD Clients **SHOULD** expose configuration options through a configuration screen to allow users and/or system administrators to control the types of information returned.
    *	CRD Clients **SHALL** convey configuration options when invoking the hook using the davinci-crd.configuration extension. It will be a single object whose properties will be drawn from the code values from configuration options and whose values will be of the type defined for that option.
    *	CRD Clients **SHOULD** provide an ability to leverage the dynamic configuration capabilities of payer services based on provider role, individual provider and/or hook invocation location as best meets the needs of their users.

*	Where CRD Services support the optional configuration options, the following requirements apply:
    *	CRD Services **SHALL** behave in the manner prescribed by any supported configuration information received from the CRD Client.
    *	CRD Services **SHALL NOT** require the inclusion of configuration information in a hook call (i.e. no hook invocation is permitted to fail because configuration information was not included).
    *	CRD Clients **MAY** send configuration information that CRD Services do not support. In this case, the CRD Service **SHALL** ignore the unsupported configuration information.

*  This specification provides no guidance on exactly when/how CRD Clients are expected to manage hook configuration.  This could be done at the level of provider roles, individual providers, location from which the hook is invoked or other means.  CRD Clients can experiment and determine what types of configuration make the most sense and at what levels they can support managing/persisting configuration information.


##### Additional prefetch capabilities
One of the options supported in CDS Hooks is the ability for a service to request that certain data be [prefetched](https://cds-hooks.hl7.org/1.0/#prefetch-template) for efficiency reasons and to simplify processing for the CDS service.  However, there is a limit in that, in the current CDS Hooks specification, prefetch can only use hook context information that is expressed as a simple key value.  It cannot leverage context information passed as resources.

A [proposal](https://github.com/cds-hooks/docs/issues/377) has been submitted suggesting how to address this issue.  This ballot version of the implementation guide pre-adopts that proposal.

Specifically, where a hook defines a context element that consists of a resource or collection of resources (e.g. [order-select.draftOrders](https://cds-hooks.hl7.org/hooks/order-select/2020May/order-select.html#context) or [order-sign.draftOrders](https://cds-hooks.hl7.org/hooks/order-sign/2020May/order-sign#context)), systems **SHALL** recognize context tokens of the form `context.<context property>.<FHIR resource name>.id` in prefetch queries.  Those tokens **SHALL** evaluate to a comma-separated list of the identifiers of all resources of the specified type within that context key.

Note: Recognizing these tokens doesn't mean the client must support prefetch or the requested prefetch query, only that it recognizes the token, doesn't treat it as an error and - if it supports the query - substitutes the token correctly.

For example, a prefetch for `order-select` might look like this:

{% raw %}
    "prefetch": {
      "ins-sr": "ServiceRequest?_id={{context.draftOrders.ServiceRequest.id}}&_include=ServiceRequest:insurance"
    }
{% endraw %}

This might result in an executed query that looks like this: `ServiceRequest?_id=2347,10948,5881&_include=ServiceRequest:insurance`

<blockquote class="stu-note">
<p>
This proposed pre-adoption is not CDS Hooks conformant.  It is possible that the CDS Hooks community will adopt an alternative solution or choose not to make any changes.  Community discussion about this proposal can be found on the CDS Hooks issue list <a href="https://github.com/cds-hooks/docs/issues/377">here</a>.  This implementation guide will be updated to align with the decision of the community and might, if necessary, fall back to the use of extensions if CDS Hooks does not choose to support prefetch based on context resources and the payer community determines that prefetch is still required.
</p>
<p>
In addition to this preadoption, this implementation guide presumes support for prefetch query capabilities more sophisticated than the recommended <a href="https://cds-hooks.hl7.org/1.0/#prefetch-query-restrictions">prefetch query restrictions</a> in the CDS Hooks specification.  Specifically, the use of <a href="{{site.data.fhir.path}}search.html#include">_include</a>, as seen in the example above.
</p>
</blockquote>

##### Additional response capabilities
CDS Hooks supports suggestions that involve multiple actions.  Coverage Requirements Discovery uses this in two situations where additional capabilities will be needed:

*  Creating a Task to complete a Questionnaire; and
*  Updating the proposed order to point to a "new" prior authorization (ClaimResponse instance) - one the CRD Service was aware of that the CRD Client was not.

In the first case, the creation of the Questionnaire needs to be conditional - it **SHOULD** only occur if that specific Questionnaire version doesn't already exist and the payer service **SHALL** query to determine if the client has a copy of the Questionnaire before sending the request.  In the second case, the order **SHOULD** be updated to point to the "id" assigned by the EMR to the newly persisted ClaimResponse instance.  Both  capabilities are supported in FHIR's [transaction]({{site.data.fhir.path}}http.html#transaction)  
functionality.  However, not all the capabilities/guidance included there has been incorporated into CDS Hooks 'suggestions', in part to keep the specification simpler.

For this release of the implementation guide, these requirements will be handled as follows:

###### if-none-exist
The `suggestion.action` object will use an extension to carry the if-none-exist query as per FHIR's [conditional create]({{site.data.fhir.path}}http.html#ccreate) functionality.  The extension property will be `davinci-crd.if-none-exist`.  

For example, this [CDS Hook Suggestion](https://cds-hooks.hl7.org/1.0/#suggestion) contains two [Actions](https://cds-hooks.hl7.org/1.0/#action) - one referencing an HL7 [Questionnaire]({{site.data.fhir.path}}questionnaire.html) and the other the [Task]({{site.data.fhir.path}}task.html) to complete the Questionnaire.  The Questionnaire will only be created if it didn't already exist:

```
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
          "extension": {
            "davinci-crd.if-none-exist": "url=http://example.org/Questionnaire/XYZ&version=2"
          }
        },
        {
          "type": "create",
          "description": "Add 'Complete XYZ form' to the task list",
          "resource": {
            "resourceType": "Task",
            "basedOn": "MedicationRequest/5",
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
            },
            "input": [{
              "type": {
                "text": "questionnaire"
              },
              "valueCanonical": "http://example.org/Questionnaire/XYZ|2"
            },
            {
              "type": {
                "text": "afterCompletion"
              },
              "valueCodeableConcept": {
                "coding": [{
                  "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/after-completion",
                  "code": "prior-auth",
                  "display": "Include in prior authorization"
                }]
              }
            }]
          }
        }]
      }
    ]
```

###### Linkage between created resources
The linkage between resources by identifier in different Actions within a single Suggestion doesn't require any extension to CDS Hooks, but it does require additional guidance.  For the purposes of this implementation guide, the inclusion of the `id` element in 'created' resources and references in created and updated resources within multi-action suggestions **SHALL** be handled as per FHIR's [transaction processing rules]({{site.data.fhir.path}}http.html#trules), treating each requested action as being an entry in a FHIR transaction bundle where the base URL is the base URL of the CRD Client's server.  POST corresponds to an `action.type` of 'create' and PUT corresponds to an action.type of 'update'.  Specifically, this means that if a FHIR Reference points to the resource type and identifier of a resource of another 'create' Action in the same Suggestion, then the reference to that resource **SHALL** be updated by the server to point to the identifier assigned by the client when performing the create.  CRD Clients **SHALL** perform creates in an order that ensures that referenced resources are created prior to referencing resources.

For example, the following [CDS Hook Suggestion](https://cds-hooks.hl7.org/1.0/#suggestion) will cause the FHIR [MedicationRequest]({{site.data.fhir.path}}medicationrequest.html) to be updated to point to the prior authorization ([ClaimResponse]({{site.data.fhir.path}}claimresponse.html) resource) being created.  The ClaimResponse would be created before the MedicationRequest would be updated:

```
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
          }
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
```

Note: Sending existing prior authorizations is not in scope for this version of the IG.

##### Linking cards to requests
Some CDS hooks have a single context.  [encounter-start](#encounter-start) and [encounter-discharge](#encounter-discharge) are tied to their respective encounter and there is no question as to which encounter a returned card is associated with.  However, the [appointment-book](#appointment-book), [order-select](#order-select), and [order-sign](#order-sign) hooks all allow passing in multiple resources as part of the hook invocation.  Each cardsreturned in the hook response might be associated with only one of the referenced appointment or order resources or a subset of them.  An EHR may wish to be able to track *what* resource(s) a card was associated with.  This might be for audit, to how or where the card is rendered on the screen, to allow the card to being directly associated with the triggering resource resource, or to enable various other workflow considerations.

This implementation guide defines a standard extension - `davinci-associated-resource` -  that can appear on any card that provides a local reference to the appointment, order or other context resource to which the card is 'pertinent'.  It is optional and has a value consisting of 1..* local references referring to the resource type and resource id of the resource being linked.

NOTE: If a hook service is invoked on a collection of resources, all cards returned that are specific to only a subset of the resources passed as context SHALL disambiguate in the `detail` element which resources they're associated with in a human-friendly way.  Typically this means using test name, drug name or some other mechanism rather than a bare identifier, as identifiers may not be visible to the end user for resources that are not yet fully 'created'.

{% raw %}
    {
      "extension": {
        "davinci-associated-resource": [
          "ServiceRequest/1",
          "ServiceRequest/7",
          "ServiceRequest/12"
        ]
      },
      "summary": "Prior authorization details",
      "indicator": "warning",
      "detail": "Genomics tests A, B and C are only covered with prior authorization.",
      "source": {
        "label": "You're Covered Insurance",
        "url": "https://example.com",
        "icon": "https://example.com/img/icon-100px.png"
      }
    }
{% endraw %}

##### Controlling hook invocation

The CDS Hook community has considered introducing a process called 'guards' that allow a CDS Service to indicate constraints on when the hook service should be called.  This specification introduces an extension on the `CDS Service` object called `davinci-guard` that is a FHIRPath that must evaluate to 'true' for in order for the service to be invoked.

The FHIRPath may reference any context or pre-fetch elements defined by the service using the context field name or pre-fetch name.  E.g. `%patient` can be used to refer to a pre-fetch by the name of 'patient'.

CRD clients SHALL either support this guard mechanism or provide alternative functionality that ensures that a given payer's service is only invoked for patients that are believed to have active coverage with that payer.

CRD servers SHALL declare a prefetch for their hook services that retrieves a payer's active coverages associated with that payer.  CDS Servers SHALL also declare the 'davinci-guard' extension on their CDS Service objects that, at minimum checks for the existence of a relevant coverage.  For example:

```
   "services": [
  {
    "hook": "order-select",
    ...
    prefetch": {
      ...
      "coverage": "Coverage?beneficiary=context.patientId&status=active&payor.identifier=12345|somesystem.org"
      ...
    },
    "extension": {
      "davinci-guard" : "%coverage.exists()"
	  }
     }
	 ]
```
where 12345|somesystem.org is the identifier for that payer.  (NOTE: a national identifier scheme for U.S. payer organizations is expected to be in place by mid-2022.)

#### CDS Hooks
Each CDS Hook corresponds to a point in the workflow/business process within a CRD Client system (e.g. EMR) where a specific type of decision support is relevant.  For example, the `order-select` hook **SHOULD** fire whenever a user of a CRD Client creates a new order or referral.  In many CRD Clients, the same hook might fire in multiple different workflows.  (For example, an EMR might have different screens for ordering regular medications vs. vaccinations vs. chemotherapy, not to mention distinct screens for lab orders, imaging orders and referrals.  An order-select hook might be initiated from any or all these screens / workflows.)

Within this implementation guide, CDS Hooks are used by CRD Clients to perform coverage requirements discovery from CRD Services used by  patients' payers.  Five hooks are identified that cover the main situations where coverage requirements discovery is likely to be needed: [appointment-book](#appointment-book), [encounter-start](#encounter-start), [encounter-discharge](#encounter-discharge), [order-select](#order-select), and [order-sign](#order-sign).  Payers and respective CRD Services will vary between patients.  CRD Clients conforming to this implementation guide **SHALL** be able to determine the correct payer CRD Service to use for each request.

Not all CRD Clients will support all hook types.  For example, community EMR systems will not likely support `encounter-discharge`.  Community pharmacy systems would not likely support `appointment-book`.  CRD Clients conforming to this implementation guide **SHALL** support at least one of the hooks listed below and **SHOULD** support all that apply to the context of their system.

Similarly, not all payers will necessarily provide coverage that is relevant to all hook types.  For example, a payer that only provides drug coverage would be unlikely to have coverage information to return on an `encounter-discharge` event.  CRD Services conforming to this implementation guide **SHALL** provide a service for at least one of the hook types listed below and **SHOULD** support all hooks that are relevant to the types of coverage provided by any payers associated with that service.

CRD Clients and CRD Services **MAY** choose to support additional hooks available in the registry on the [CDS Hooks continuous integration build](https://cds-hooks.org) or custom hooks defined elsewhere.  In these cases, systems **SHOULD** adhere to the conformance expectations defined in this specification for any hooks listed here.

In the absence of guidance from the CDS Hooks specification, CRD Services are expected to conform to the following rules when responding to requests from a CRD Client:

* If the CRD Service encounters an error when processing the request, the system **SHALL** return an appropriate error HTTP Response Code, starting with the digit "4" or "5", indicating that there was an error.
* The CRD Service **SHOULD** provide an OperationOutcome for internal issue tracking by the client system.
* The CRD Client **MAY** display to the user that the Coverage Requirements Discovery Service is unavailable.  If additional information (e.g. number to call) is available, it **MAY** also be included in the message to the user.
* While any 4xx or 5xx response code could be raised, the CRD Service **SHALL** use the 400 and 422 codes in a manner consistent with the FHIR RESTful Create Action, specifically:
    * 400 - Bad Request - The request is not parsable as JSON
    * 422 - Unprocessable Entity - The request is valid JSON, but is not conformant to CDS Hooks, FHIR Resources or required profiles

The following sections describe the hooks covered by this implementation guide as well as any constraints, profiles and resources expected to be supported by conformant implementations.

The hooks listed on the CDS hooks website are subject to update by the community at any time until they go through the ballot process.  However, all substantive changes are noted in the *Change Log* section at the bottom of the page describing each hook.  For each hook listed below, this specification identifies a specific version.  For the sake of interoperability, implementers are expected to adhere to the interface defined in the specified version of each hook, though compatible changes from future versions can also be supported.  CRD Services **SHALL** handle unrecognized context elements by ignoring them.

##### appointment-book
This hook is described in the CDS Hook specification [here](https://cds-hooks.hl7.org/hooks/appointment-book/2020May/appointment-book/).  This version of the CRD implementation guide refers to version 1.0 of the hook.

This hook would be triggered when the user of a CRD Client books a future appointment for a patient with themselves, with someone else within their organization or with another organization.  (Note that whether the CRD Client will create an appointment - triggering the `appointment-book` hook - or a ServiceRequest - triggering an `order-select` or `order-sign` hook - can vary depending on the service being booked and the organizations involved.)

Potentially relevant CRD advice related to this hook might include:

* Requirements related to the intended location and/or participants (e.g. warnings about out-of-network)

* Requirements related to the service being booked (e.g. Is prior authorization needed? Is the service covered? Is the indication appropriate? Is special documentation required?)

* Requirements related to the timing of the service (e.g. is the coverage still expected to be in effect? is the service too soon since the last service of that type?)

* Reminders about additional services that are recommended to be scheduled or booked for the same patient - either as part of the scheduled encounter or as part of additional appointments that could be created at the same time.

While this hook supports userIds of Patient and RelatedPerson, for CRD purposes it is enough to support Practitioner and PractitionerRole.  Support for Patient and RelatedPerson as users is optional.  (Note that Practitioner and PractitionerRole include both licensed healthcare professionals as well as administrative staff.)

The profiles expected to be used for the resources resolved to by the userId, patientId and encounterId and in the `appointments` context elements are as follows:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td><a href="StructureDefinition-profile-appointment.html">profile-appointment</a></td>
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
    <td><a href="StructureDefinition-profile-practitioner.html">profile-practitioner</a></td>
    <td/>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.uscore}}/StructureDefinition-us-core-practitionerrole.html">us-core-practitionerrole</a></td>
  </tr>
</table>


##### encounter-start
This hook is described in the CDS Hook specification [here](https://cds-hooks.hl7.org/hooks/encounter-start/2020May/encounter-start/).  This version of the CRD implementation guide refers to version 1.0 of the hook.

This hook would be triggered when a patient is admitted, a patient arrives for an out-patient visit and/or when a provider first engages with a patient during an encounter.  The `encounter-start` hook serves a similar purpose to the [appointment-book](#appointment-book) hook, though it provides less lead time to react to recommendations. If the purpose of the appointment is to perform a service that requires a 2-week prior authorization process, it is more efficient to identify prior-authorization requirements proactively though the use of appointment-book to prevent the patient from showing up for an appointment that will need to be cancelled and rescheduled.

The advice returned for this hook would include the same sorts of advice as provided for [appointment-book](#appointment-book).  However, the hook is still necessary because not all encounters will be the result of appointments, not all systems that schedule appointments will necessarily have checked for coverage requirements, and the patient's circumstances and/or coverage as well as the payer's guidelines could have evolved since the appointment was scheduled.

Note that Practitioner and PractitionerRole include both licensed healthcare professionals as well as administrative staff.

The profiles expected to be used for the resources resolved to by the userId, patientId and encounterId context references are as follows:


<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>US Core Profiles</th>
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
    <td><a href="StructureDefinition-profile-practitioner.html">profile-practitioner</a></td>
    <td/>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.uscore}}/StructureDefinition-us-core-practitionerrole.html">us-core-practitionerrole</a></td>
  </tr>
</table>


##### encounter-discharge
This hook is described in the CDS Hook specification [here](https://cds-hooks.hl7.org/hooks/encounter-discharge/2020May/encounter-discharge/).  This version of the CRD implementation guide refers to version 1.0 of the hook.

This hook would generally be specific to an in-patient encounter and would fire when a provider is performing the discharge process within the CRD Client.

Potentially relevant CRD advice related to this hook might include:

* Verifying that documentation requirements for the services performed have been met to ensure the services provided can be reimbursed

* Ensuring that required follow-on planning is complete and appropriate transfer of care has been arranged, particularly for accountable care models

The profiles expected to be used for the resources resolved to by the userId, patientId and encounterId context references are as follows:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>US Core Profiles</th>
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
    <td><a href="StructureDefinition-profile-practitioner.html">profile-practitioner</a></td>
    <td/>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.uscore}}/StructureDefinition-us-core-practitionerrole.html">us-core-practitionerrole</a></td>
  </tr>
</table>

##### order-select
This hook is described in the CDS Hook specification [here](https://cds-hooks.hl7.org/hooks/order-select/2020May/order-select/).  This version of the CRD implementation guide refers to version 1.0 of the hook.

This will probably be the most important and widely used hook for CRD as it will be fired as orders are created for medications, devices, services, etc. within the CRD Client.  The hook could fire multiple times as additional information is gathered and entered.  Services **SHALL NOT** return warnings indicating that insufficient information is available to determine coverage when returning coverage requirement cards.  It is to be expected that not all information will be available initially.  If the user decides that an order is 'complete' when not enough information is available, that will be caught by the [order-sign](#order-sign) hook.

While it might be possible to not support this hook and only use the order-sign hook, the benefit of supporting [order-select](https://cds-hooks.hl7.org/hooks/order-select/2020May/order-select/) is that information may be provided to alter a provider's behavior before they've gone very far in the authoring process.  It will be less aggravating for the provider to be prompted to change a medical equipment order when they've just picked the device and haven't filled in all the usage instructions than when everything is complete and they're just about to sign.

This hook allows multiple resource types to be present. Resources provided could be all of the same type or a mixture of types.  Coverage requirements **SHOULD** be limited only to those resources that are included in the `selections` context, though the content of other resources **SHOULD** also be considered before making recommendations about what additional actions are necessary.  (I.e. don't recommend an action if there's already a draft order to perform that action.)  

The different relevant resource types are as follows (support can vary between clients):

**CommunicationRequest**: Used when a provider requests that another provider transfer patient records or other supporting information to another organization or agency.

**DeviceRequest**: Used for durable medical equipment orders, such as wheelchairs, prosthetics, diabetic supplies, etc.  It can also be used to order glasses and other vision-correction devices.

**MedicationRequest**: Used to order inpatient and outpatient medications.  Can also be used to order vaccinations.

**ServiceRequest**: Used to order a referral, lab tests, diagnostic imaging and sometimes to schedule a future appointment (also see [appointment-book](#appointment-book)).

**NutritionOrder**: Used to order the preparation of specific meal types.  Generally used for in-patient care, but potentially also relevant for home-care.


Coverage requirement responses might include:

* Information about preauthorization and clinical documentation requirements, including forms to be completed

* Alternative therapies that are covered or required first-line therapies

* Potential drug-drug interactions based on existing payer knowledge

* Recommendations about in-network vs. out-of-network providers for referrals


There are no constraints or special rules related to this hook beyond the profiles expected to be used for the resources resolved to by the `patientId` or `encounterId` or in the `draftOrders` context element:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td><a href="StructureDefinition-profile-devicerequest.html">profile-devicerequest</a><sup>†</sup></td>
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
    <td><a href="StructureDefinition-profile-practitioner.html">profile-practitioner</a></td>
    <td/>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.uscore}}/StructureDefinition-us-core-practitionerrole.html">us-core-practitionerrole<sup>‡</sup></a></td>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-servicerequest.html">profile-servicerequest</a></td>
    <td/>
  </tr>
</table>

<sup>†</sup> DeviceRequest is not currently supported by the order-select and order-sign hooks.  A [proposal](https://github.com/cds-hooks/docs/issues/396) has been submitted to add them.  CRD Services **SHALL NOT** treat the presence of these resources in the `draftOrders` Bundle as an error and **SHOULD** support these resource types if relevant to their operations.

<sup>‡</sup> While this hook does not explicitly list PractitionerRole as an expected resource type for userId, it is not prohibited and is included to allow linking the user to a Practitioner in a specific role acting on behalf of a specific Organization.

Note: While this hook is defined for use when ordering, it is still relevant when proposing (e.g. as part of a consult note) or planning (e.g. as part of a care plan) the use of an intervention.  All the 'Request' resources support differentiating between plans, proposal and orders.  Where CRD Clients have an appropriate workflow and data capture mechanism, this hook **MAY** be used in scenarios that don't involve creating a true order.


##### order-sign
This hook is described in the CDS Hook specification [here](https://cds-hooks.hl7.org/hooks/order-sign/2020May/order-sign/).  This version of the CRD implementation guide refers to version 1.0 of the hook.

This hook serves a very similar purpose to [order-select](#order-select).  The main difference is that all the listed draft orders are considered 'complete'.  That means that it's appropriate to provide warnings if there is insufficient information to determine coverage requirements.  As well, all `draftOrders` are appropriate to comment on when using [order-sign](https://cds-hooks.hl7.org/hooks/order-sign/2020May/order-sign/) as the `selections` field in [order-select](https://cds-hooks.hl7.org/hooks/order-select/2020May/order-select/) is absent.

Use and profiles for [order-select](#order-select) also apply to `order-sign`.

#### Cards
[Cards](https://cds-hooks.hl7.org/1.0/#cds-service-response) are the mechanism used to return coverage requirements from the CRD Service to the CRD Client.

##### General guidance
In addition to the [guidance provided in the CDS Hooks specification](https://cds-hooks.hl7.org/1.0/#card-attributes), the following additional recommendations apply to CRD Services when constructing cards:

*  The `Card.indicator` **SHOULD** be populated from the perspective of the clinical decision maker, not the payer.  While failure to procure a prior authorization might be 'critical' from the perspective of payment, it would be - at best - a 'warning' from the perspective of clinical care.  'critical' must be reserved for reporting life or death or serious clinical outcomes.  Issues where the proposed course of action will negatively affect the ability of the payer or patient to be reimbursed would generally be a 'warning'.  Most Coverage Requirements **SHOULD** be marked as 'info'.

*  The `Card.source` **SHOULD** be populated with an insurer name that the user and patient would recognize (i.e. the responsible insurer on the patient's insurance card) including in situations where coverage recommendations are being returned by a benefits manager or intermediary operating the CRD service on behalf of the payer.  If an insurer is providing recommendations from another authority (e.g. a clinical society), the society's name and logo might be displayed, though usually only with the permission of that organization.

*  Users are busy.  Time spent reading a payer-returned card is inevitably time not spent reviewing other information or interacting with the patient.  If not useful or relevant, users will quickly learn to ignore - or even demand the disabling of - payer-provided alerts.  Therefore, information must be delivered efficiently and be tuned to provide maximum relevance.  Specifically:

    *  `Card.summary` **SHOULD** provide actionable information.  "Coverage alert" would not be very helpful. "Drug not covered.  Covered alternatives available" or "Prior authorization required" would be better.

    *  `Card.detail` and/or external links **SHOULD** only be provided when coverage recommendations can't be clearly provided in the 140-character limit of `Card.summary`.

    *  `Card.detail` **SHOULD** provide graduated information with critical information being provided in the first paragraph and less critical information towards the end of the page.

    *  `Card.detail` **SHOULD** provide enough context that a user can determine whether it is worth the precious seconds to launch an app or external link or not - ideally providing a sense of where to look for and how to use whatever link or app they do launch in the specific context of the order they're making at the time.

    *  Keep the number of cards manageable.  Consider whether user workflow will be faster with separate cards for each link or a single card having multiple links.  Typically using the smallest number of cards that still support descriptive actionable summaries is best.

    *  When providing links, don't send the user to the first page of an 80+ page PDF.  Keep document size short and/or provide linking directly to the section that is relevant for the context.

    *  While links are permitted in the markdown content of `Card.detail`, support for this is not universal, so links **SHOULD** also be provided in `Card.link`.  This also provides a consistent place for users to access all relevant links.

* CRD Client systems might not support all card capabilities, therefore card options **SHOULD** provide sufficient information for a user to perform record changes manually if automated support isn't possible.


##### Potential CRD Response Types
This section describes the different types of [responses](https://cds-hooks.hl7.org/1.0/#cds-service-response) that CRD Services can use when returning coverage requirements to CRD Clients, including CRD-specific profiles on cards to describe CRD-expected behavior.  It is possible that some CRD Services and CRD Clients will support additional card response patterns than those listed here, but such behavior is outside the scope of this specification.  Future versions of this specification might standardize additional response types.

Of the response types in this guide, conformant CRD Clients **SHALL** support the [External reference](#external-reference), [Instructions](#instructions) and  [Annotate](#annotate) responses and **SHOULD** support the remaining types.  CRD Services **SHALL** support at least one of these response type and **MAY** support as many as necessary to convey the requirements of the types of coverage they support.

Response types are listed from least sophisticated to most sophisticated - and potentially more useful/powerful.  As a rule, the more a card can automate manual processes and the more context-specific the behavior is, the more useful the decision support will be to the clinician and the more likely it will be used.

Notes:
* CRD Clients will provide resources, such as MedicationRequest, in the CDS Hook request context object. These resources might be temporary in the context in which the CDS Hook is triggered, such as when a proposed medication order is being reviewed. In this case, the CDS Client must maintain a stable identifier for these temporary resources in order to allow CRD responses to refer to them in CDS Hook Actions.

* Hook responses will frequently contain multiple cards and those cards might draw from a variety of response types.  For example, providing links, textual guidance as well as suggestions for alternative orders.

* The response types listed here are *not* the same as the [Configuration Options](#configuration-options-extension) specified above.  A single response type could correspond to multiple configuration options.  For example, [External Reference](#external-reference) could apply to clinical practice guidelines, prior authorization requirements, claims attachment requirements and other things.  Similarly, one configuration option could be satisfied with multiple response types.  For example, required Prior Authorization Forms could include both [External References](#external-reference) and explicit [Request Form Completion](#request-form-completion) responses.


###### External Reference
This response type presents a `Card` with one or more links to external web pages, PDFs, or other resources that provide relevant coverage information.  The links might provide clinical guidelines, prior authorization requirements, printable forms, etc. Typically, these references would be links to information available from the payer's website, though pointers to other authoritative sources are possible too.  The card **SHALL** have at least one `Card.link`.  The `Link.type` **SHALL** have a type of "absolute".

When reasonable, an "External Reference" card **SHOULD** contain a summary of the actionable information from the external reference.

For example, this CDS Hooks [Card](https://cds-hooks.hl7.org/1.0/#cds-service-response) contains two [Links](https://cds-hooks.hl7.org/1.0/#link) - a standard and a printer-friendly version.

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
        }
      ]
    }
{% endraw %}

###### Instructions
This response type presents a `Card` with textual guidance to display to the user making the decisions. The text might provide clinical guidelines, suggested changes, rules around prior authorization, or even something as simple as "No special coverage requirements". It can be generated in a more sophisticated context for the payer, while still remaining simple to consume for the provider because it more easily allows returned information to be tuned to the specific context of the order/encounter that triggered the hook. In some cases, the text returned might be generated uniquely each time a hook is fired.

This example CDS Hook [Card](https://cds-hooks.hl7.org/1.0/#cds-service-response) just contains a message:

{% raw %}
    {
      "summary": "Prior authorization required",
      "indicator": "warning",
      "detail": "All prescriptions for _Drug X_ with a dose higher than 100mg/day require prior authorization.  Forms and instructions can be found [here](http://example.org/prior-auth.pdf).",
      "source": {
        "label": "You're Covered Insurance",
        "url": "https://example.com",
        "icon": "https://example.com/img/icon-100px.png"
      }
    }
{% endraw %}


###### Annotate
This response type presents a `Card` with a piece of information that should be retained with the order/appointment/etc.  For example "No prior authorization for drug X required by ABC insurance", "Prior authorization number for X-ray from ABC insurance is 13245", or "This referral is not covered under the patient's DEF plan".  With information like this, merely displaying the text on the screen in a card isn't sufficient - it needs to be recorded in the associated order for future use or evidence.  These cards involve 'replacing' the submitted order, but leaving the order unchanged, with the exception that an additional 'note' is added to the resource instance. 

The note uses the [{{site.data.fhir.path}}datatypes.html#Annotation](Annotation) datatype and captures the comment, the date, and who made the assertion.  In this case, the commenter would be the payer organization.  Note that the text should *also* be displayed in the card, with the button link simply saying "Add to record" or something like that.  The requested action is always an 'update' and there is only ever one alternative.

When using this response type, the proposed order or appointment being updated **SHALL** comply with the following profiles:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td><a href="StructureDefinition-profile-appointment.html">profile-appointment</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-devicerequest.html">profile-devicerequest</a></td>
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
    <td><a href="StructureDefinition-profile-servicerequest.html">profile-servicerequest</a></td>
    <td/>
  </tr>
</table>

For example, this card proposes indicates that a prior authorization has been granted for a planned prescription:

```
    "suggestions": [
      {
        "label": "Prior authorization granted by XYZ insurer.  Auth #:12345 - add to record?",
        "actions": [{
          "type": "update",
          "description": "Add authorization to record",
          "resource": {
            "resourceType": "MedicationRequest",
            "id": "idfromcontext",
            "status": "draft",
            "intent": "initial-order",
            "medicationCodeableConcept": {
              "coding": {
                "system": "http://www.nlm.nih.gov/research/umls/rxnorm",
                "code": "616447",
                "display": "Mycophenolate Mofetil 250 MG Oral Tablet"
              }
            },
            "subject": {
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
            "note": [
              {
                "authorString": "XYZ Insurance",
                "time": "2019-02-15T15:07:18",
                "text": "Unsolicited prior authorization for Jane Smith to receive 6 tablets Mycophenolate Mofetil 250 mg oral tablets BID granted.  Please note prior authorization # 12345 on claim submission."
              }
            ],
            "dosageInstruction": {
              "text": "6 tablets every 12 hours.",
              "timing": {
                "repeat": {
                  "frequency": 1,
                  "period": 12,
                  "periodUnit": "h"
                }
              },
              "doseAndRate": {
                "doseQuantity": {
                  "value": 6,
                  "unit": "tablet"
                }
              }
            }
          }
        }]
      }
    ]
```


###### Propose alternate request
This response type can be used by payers to present a `Card` with suggested alternatives to the current proposed therapy.  This might be updating the order to change certain information or proposing to replace the order completely with one or more alternatives.  This might be used to propose a change to a first-line treatment, to alter therapy frequency or drug dosage to be consistent with coverage guidelines, to propose covered products or services as substitutes for a non-covered service and/or to propose therapeutically equivalent treatments that will have a lower cost to the patient.

Multiple alternatives can be proposed by providing multiple suggestions.  Each suggestion **SHOULD** contain either a single "update" action to revise the existing proposed order; or both a "delete" action for the current proposed order and a "create" action for the new proposed order.  In some cases, additional "create" actions might be needed if there's a need to convey a non-[contained]({{site.data.fhir.path}}references.html#contained) Medication, Device or other resource.  The "delete" action resource element is not expected to adhere to any profile as it is only expected to contain the "id" property of the resource being replaced.  Any other elements will be ignored.

The choice of "update" vs. "delete + create" **SHOULD** be based on how significant the change is - and how relevant other decision support on the original request will still be.  If cards returned by other service providers might still be relevant (e.g. because there was just a small change in dose or frequency), then performing an 'update' will allow updates from other decision support cards to also be applied.  If the change is significant enough that other decision support will not be relevant, a delete + create will allow the client to suppress decision support cards that no longer apply.

When using this response type, the proposed orders (and any associated resources) **SHALL** comply with the following profiles:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td><a href="StructureDefinition-profile-device.html">profile-device</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-devicerequest.html">profile-devicerequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-encounter.html">profile-encounter<sup>†</sup></a></td>
    <td/>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.uscore}}/StructureDefinition-us-core-medication.html">us-core-medication</a></td>
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
    <td><a href="StructureDefinition-profile-servicerequest.html">profile-servicerequest</a></td>
    <td/>
  </tr>
</table>
<sup>†</sup> Only used if updating an Encounter (e.g. to add a note)

For example, this card proposes replacing the draft prescription for a brand-name drug (shown only as the 'resourceType' and 'id' from the `draftOrders` entry) and instead creating an equivalent prescription with a generic medication.

```
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
            "medicationCodeableConcept": {
              "coding": {
                "system": "http://www.nlm.nih.gov/research/umls/rxnorm",
                "code": "616447",
                "display": "Mycophenolate Mofetil 250 MG Oral Tablet"
              }
            },
            "subject": {
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
            "dosageInstruction": {
              "text": "6 tablets every 12 hours.",
              "timing": {
                "repeat": {
                  "frequency": 1,
                  "period": 12,
                  "periodUnit": "h"
                }
              },
              "doseAndRate": {
                "doseQuantity": {
                  "value": 6,
                  "unit": "tablet"
                }
              }
            }
          }
        }]
      }
    ]
```


###### Identify additional orders as companions/pre-requisites for current order
This response type can be used to present a `Card` that recommends the introduction of additional orders. For example, the payer may recommend that certain lab tests be ordered along with a medication that is known to affect liver function.  This will normally involve additional "create" actions.  The fact there is no "delete" for the original order conveys that these are supplemental actions rather than replacement actions.  As with the [Propose Alternate Request](#propose-alternate-request) response type, in some cases multiple resources will need to be created to convey the full suggestion (e.g. Medication, Device, etc.)

When using this response type, the proposed orders (and any associated resources) **SHALL** comply with the following profiles:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td><a href="StructureDefinition-profile-communicationrequest.html">profile-communicationrequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-device.html">profile-device</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-devicerequest.html">profile-devicerequest</a></td>
    <td/>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.uscore}}/StructureDefinition-us-core-medication.html">us-core-medication</a></td>
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
    <td><a href="StructureDefinition-profile-servicerequest.html">profile-servicerequest</a></td>
    <td/>
  </tr>
</table>

This example proposes adding a monthly test to check liver function:

```
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
            "category": {
              "coding": {
                "system": "http://snomed.info/sct",
                "code": "108252007",
                "display": "Laboratory procedure"
              }
            },
            "code": {
              "coding": {
                "system": "http://www.ama-assn.org/go/cpt",
                "code": "80076",
                "display": "Hepatic function panel"
              }
            },
            "subject": {
              "reference": "Patient/123",
              "display": "Jane Smith"
            },
            "encounter": {
              "reference": "Encounter/ABC"
            },
            "occurrence": {
              "boundsDuration": {
                "value": 3,
                "unit": "months",
                "code": "mo",
                "system": "http://unitsofmeasure.org"
              },
              "frequency": 1,
              "period": 1,
              "periodUnit": "mo"
            },
            "authoredOn": "2019-02-15",
            "requester": {
              "reference": "PractitionerRole/987",
              "display": "Dr. Jones"
            }
          }
        }]
      }
    ]
```

###### Request form completion
This response type can be used to present a `Card` that indicates that there are forms that need to be completed.  These might contain documentation that must be submitted for prior authorization, attachments for claims submission, documentation that must be completed and retained as proof that clinical need protocols have been followed, or that must otherwise be retained and available for future audits.  While forms can also be expressed as static or active PDFs referenced by [External References](#external-reference), or within a [SMART Application](#launch-smart-application) this response type provides the form definition as a FHIR Questionnaire and creates a Task within the EMR allowing the completion of the form to be appropriately scheduled and/or delegated.  Alternatively, the Practitioner could choose to execute the task and fill out the form immediately if that makes more sense from a clinical workflow perspective.

This suggestion will always include a "create" action for the Task.  The Task will point to the questionnaire to be completed using a `Task.input` element with a `Task.input.type.text` of "questionnaire" and the canonical URL for the questionnaire in `Task.input.valueCanonical`.  Additional `Task.input` elements will provide information about how the completed questionnaire is to be submitted to the payer with a service endpoint if required.  The `Task.code` will always include the CRD-specific `complete-questionnaire` code.  The reason for completion will be conveyed in `Task.reasonCode`.  The Questionnaire might also be included with a separate conditional "create" action or it might be excluded with the presumption it will already be available or retrievable by the client via its canonical URL, either from the original source or from a local registry.

When using this response type, the proposed orders (and any associated resources) **SHALL** comply with the following profiles:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td><a href="StructureDefinition-profile-taskquestionnaire.html">profile-taskquestionnaire</a></td>
    <td/>
  </tr>
</table>

No profile is provided for the Questionnaires pointed to by the Task.  CRD Services **SHOULD** use questionnaires that are compliant with either the [Argonaut Questionnaire profiles](https://github.com/argonautproject/questionnaire) (for forms to be completed within the EMR) or the [Structured Data Capture profiles](http://hl7.org/fhir/uv/sdc/index.html) (for more sophisticated forms to be created within a SMART on FHIR app or through an external service).  

Note:
* Where CRD services use the Structured Data Capture profiles, they have the option of indicating an endpoint for submission of the questionnaire using Task.input or the SDC Questionnaire.endpoint extension to specify a service endpoint to submit completed questionnaires to a recipient.  If an endpoint is specified in both locations, both apply.
* CRD Clients **SHOULD** retain a copy of all completed forms for future reference.

The following is an example CDS Hook [Suggestion](https://cds-hooks.hl7.org/1.0/#suggestion) where the specified questionnaire is either expected to be available within the CRD Client or available for retrieval through its canonical URL.  As such, the [Action](https://cds-hooks.hl7.org/1.0/#action) only contains the FHIR [Task]({{site.data.fhir.path}}task.html) resource.  An example showing inclusion of both the Task and the referenced Questionnaire can be found [above](#if-none-exist).

```
    "suggestions": [
      {
        "label": "Add 'completion of the ABC form' to your task list (possibly for reassignment)",
        "actions": [{
          "type": "create",
          "description": "Add 'Complete ABC form' to the task list",
          "resource": {
            "resourceType": "Task",
            "basedOn": "Appointment/27",
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
            },
            "input": [{
              "type": {
                "text": "questionnaire"
              },
              "valueCanonical": "http://example.org/Questionnaire/XYZ|2"
            },{
              "type": {
                "text": "afterCompletion"
              },
              "valueCodeableConcept": {
                "coding": [{
                  "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/after-completion",
                  "code": "prior-auth",
                  "display": "Include in prior authorization"
                }]
              }
            }]
          }
        }]
      }
    ]
```


###### Create or update coverage information
This response type is used when the CRD Service is aware of additional coverage that is relevant to the current/proposed activity or has updates/corrections to make to the information held by the CRD Client.  For example, the CRD Client might be aware that a patient has coverage with a provider, but not know the plan number, member identifier or other relevant information.  This response allows the CRD Service to convey that information to the CRD Client and link it to the current/proposed action.  In theory, this type of response could also be used to convey corrected/additional prior authorization information the payer was aware of, however that functionality is out-of-scope for this release of the implementation guide.

This response will contain a single suggestion.  The primary action will either be a suggestion to "update" an existing Coverage instance (if the CRD Client already has one) or to "create" a new Coverage instance if the CRD Service is aware of Coverage that the CRD Client is not.  In addition, the suggestion could include updates on all relevant Request resources to add or remove links to Coverage instances, reflecting which Coverages are relevant to which types of requests.

For example, this CDS Hook [Card](https://cds-hooks.hl7.org/1.0/#cds-service-response) includes a single [Suggestion](https://cds-hooks.hl7.org/1.0/#suggestion) with two [Actions](https://cds-hooks.hl7.org/1.0/#action) - one is to update the [Coverage]({{site.data.fhir.path}}coverage.html) and the second is to update the draft order [MedicationRequest]({{site.data.fhir.path}}medicationrequest.html) to reference the existing Coverage.

```
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
```

###### Launch SMART application
SMART apps allow more sophisticated interaction between payers and providers.  They provide full control over user interface, workflow, etc.  With permission, they can also access patient clinical data to help guide the interactive experience and minimize data entry.  Apps can provide a wide variety of functions, including eligibility checking, guiding users through form entry, providing education, etc.

All such apps will need to go through the approval processes for the client's provider organization and typically also the associated software vendor.  This response type can cue the launching of such apps to occur in the context in which they are relevant to patient care and/or to payment-related decision-making.

This response type is just a modified version of the [External Reference](#external-reference) response type.  However, the `Link.type` will be "smart" instead of "absolute".  The `Link.appContext` will typically also be present.  

This card type also provides the mechanism to transition from CRD to the behavior defined in the [Documentation, Templates, and Rules (DTR) Implementation Guide](http://hl7.org/fhir/us/davinci-dtr).  The SMART app link returned is the one the payer uses to guide providers through filling out relevant questionnaires and is capable of both retrieving the relevant CQL from the payer to determine (and where appropriate, automatically populate) payer-sourced templates and documentation as well as retrieving information from the provider via queries authorized by the token used to launch the SMART app.  The card includes the complete app context needed for the CRD client to launch the SMART application (information gleaned by the CRD server either as data passed as part of hook invocation or subsequent querying by the service.

For example, this [Card](https://cds-hooks.hl7.org/1.0/#cds-service-response) contains a SMART App [Link](https://cds-hooks.hl7.org/1.0/#link) to perform an opioid assessment.

```
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
          "type": "smart",
          "appContext": "{\"questionnaire\":\"https://example.org/fhir/Questionnaire/OP123\",
              \"questionnaireToken\":\"a1235abe399...\",
              \"context\":\"{\"patientId\": \"123\",...}\"
          }"
        }
      ]
    }
```

The `appContext` in the above example follows a pattern used for invoking a [Da Vinci Documentation Templates &amp; Rules (DTR)](http://hl7.org/fhir/us/davinci-dtr) SMART app.  While the appContext can contain any information desired and coordinated between the designers of the CDS Hook service and the designers of the launched SMART App, Da Vinci DTR intends to support the use of 'common' SMART apps that can be used by multiple payers, such that the SMART apps can be interchangeable and the EHR might choose to launch a common app in place of the specific SMART app URL specified.

To support this behavior, the appContext **SHOULD** include the following properties:

* `questionnaire`: 1..1 - The canonical URL (potentially version-specific) for the Questionnaire to be completed by the app
* `questionnaireToken`: 0..1 - A JWT to be passed as a security token when querying for the Questionnaire in situations where 'permission' is needed to access the Questionnaire
* `context`: 1..1 - a copy of the `context` object that was passed to the service on invocation of the hook

###### Provide unsolicited prior authorization
This response type is used when the payer determines that prior authorization is necessary in order to cover the service described by the invoked hook, and that the information necessary to grant the prior authorization is already available.  Rather than requiring the provider to submit a prior authorization request, the payer generates a prior authorization response pre-emptively, indicating exactly what is covered and providing a prior authorization reference that can be communicated to downstream service providers.

The card will contain a single "create" action with a ClaimResponse instance complying with the [Da Vinci prior authorization profile](StructureDefinition-profile-claimresponse.html) (the resource used by FHIR to represent prior authorizations) - one per authorization.  (Multiple cards can be provided in the event that multiple prior authorizations are produced, as the provider must choose independently which ones they wish to store.

For example, this CDS Hook [Card](https://cds-hooks.hl7.org/1.0/#cds-service-response) includes a single [Suggestion](https://cds-hooks.hl7.org/1.0/#suggestion) with the necessary 'create' [Action](https://cds-hooks.hl7.org/1.0/#action).  For size reasons, the full content of the prior authorization is omitted, however an example prior authorization can be seen [here](ClaimResponse-priorauth-example.json).

```
    {
      "summary": "Store prior payer-generated authorization for this service",
      "indicator": "info",
      "source": {
        "label": "Some Payer",
        "url": "https://example.com",
        "icon": "https://example.com/img/icon-100px.png"
      },
      "suggestions": [
        {
          "label": "Store the prior authorization in the EHR",
          "uuid": "23d5f278-a742-4cb7-801b-ea32c2ae2ccf",
          "actions": [{
            "type": "create",
            "description": "Store prior authorization record",
            "resource": {
              "resourceType": "Claim",
              "id": "UR3503",
              "status": "active",
              ...
            }
          }]
        }
      ]
    }
```

###### Pre-emptive prior authorization

One result of invoking a CRD service may be that, based on the patient, their type of coverage and other information available in the patient's record queried by the CRD service, is that the service determines that - not only is prior authorization necessary for the intervention being ordered, but that the ordered intervention meets prior authorization requirements.  In such a case, the CRD service may return a card with two alternate suggestions - store the prior authorization in computable or add the prior authorization as an annotation to the order. 

The first will be handled through a 'create' action that stores a ClaimResponse instance complying with the HRex [unsolicited authorization] profile together with an 'update' to the order or appointment instance that triggered the CDS Hook invocation to modify the record adding the ClaimResponse as a 'supportingInfo' element - establishing a linkage between the order and the prior authorization.

The second suggestion will function exactly as per the 'annotate' card, with the annotation covering all relevant information needed for the prior authorization (billing codes, modifiers, authorized quantity, authorized amounts, time period, authorization number, etc.).  Support for this  second suggestion type is included as part of the mandatory support required for 'Annotate' suggestions.

```
    {
      "summary": "Store pre-emptive prior authorization for this service",
      "indicator": "info",
	  "detail": "This is an example card for pre-emptive prior authorization with two alternate suggestions - store the prior authorization in computable or add the prior authorization as an annotation to the order.",
      "source": {
        "label": "Some Payer",
        "url": "https://example.com",
        "icon": "https://example.com/img/icon-100px.png"
      },
      "suggestions": [
        {
          "label": "Store the prior authorization in the EHR",
          "uuid": "23d5f278-a742-4cb7-801b-ea32c2ae2ccf",
          "actions": [{
            "type": "create",
            "description": "Store ClaimResponse",
            "resource": {
              "resourceType": "ClaimResponse",
              "id": "cr1",
              "status": "active",
              ...
            }
          },
		  {
            "type": "update",
            "description": "Update to the order",
            "resource": {
            "resourceType": "ServiceRequest",
            ...
            "supportingInfo": [{
              "reference": "ClaimResponse/cr1"
            }],
            ...
          }
          }
		  ]
        },
        {
          "label": "Prior authorization as an annotation to the order",
          "uuid": "9309cc18-fea1-4939-ab0c-ecb15bedf043",
          "actions": [{
            "type": "update",
            "description": "Add authorization to record",
            "resource": {
              "resourceType": "ServiceRequest",
              ...
              "supportingInfo": [{
              "reference": "ClaimResponse/cr1"
            }],
			 "note": [
            {
              "text": "Adding authorization to the record"
            }
             ]
            }
          }]
        }
      ]
    }
```

#### Additional data retrieval
The context information provided as part of hook invocation will often not be enough for a CRD service to fully determine coverage requirements.  This section of the guide describes a common set of queries that define data that most, if not all, CRD Services will need to perform their requirements assessment.

For this release of the implementation guide, conformant CRD Clients **SHOULD** support the CDS Hooks [prefetch](https://cds-hooks.hl7.org/1.0/#prefetch-template) capability and be able to perform all the prefetch queries defined here and, where needed, **SHOULD** implement interfaces to [_include]({{site.data.fhir.path}}search.html#include) resources not available in the system's database.  (i.e. if some of the data is stored in a separate system, it should ideally still be retrievable via `_include` in queries executed against the client.)  However, each payer will define the prefetch requests for their CRD Service based on the information they require to provide coverage requirements.  They might include more and/or less than described in this section.  Prefetch requests **SHOULD** only include information that is always expected to be needed for each hook invocation.  When information is only needed for certain invocations of the hook (e.g. for particular types of medications or services), that information **SHALL** only be retrieved by query using the provided token, never requested universally via prefetch.  Not all CRD Clients will support all prefetch requests.  

<blockquote class="stu-note">
In future releases of this specification, the requirements in this section might become a **SHALL**.  Implementers are encouraged to provide feedback about this possibility based on their initial implementation experience.
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

Not all these will be relevant for all resource types.  Different resources have differently named data elements and search parameters for them.  In some cases, support only exists as extensions or does not exist at all.  Where necessary, this implementation guide defines additional extensions and/or SearchParameter instances to support retrieval of these elements.  The intention is for both extensions and search parameters to eventually migrate into the core FHIR specification.

There are two possible mechanisms that can be used by the service to gather the information needed: prefetch and querying against the EMR to retrieve additional resources.  Both of these mechanisms are defined as part of the [CDS Hooks specification](https://cds-hooks.hl7.org/1.0/#providing-fhir-resources-to-a-cds-service).  In some cases, a mixture of both approaches might be necessary.

##### Prefetch
Prefetch is an optional capability of CDS Hooks that allows the client to perform certain query functions on behalf of the CRD Service and provide the results in the initial hook invocation.  This allows the client to optimize query performance and can simplify functionality for the CRD Service.

In addition to the [base prefetch capabilities](https://cds-hooks.hl7.org/1.0/#prefetch-template) defined in the CDS Hooks specification, systems that support prefetch **SHOULD** support the additional prefetch capabilities [defined earlier in this specification](#additional-prefetch-capabilities).  The following table defines the 'standard' prefetch queries for this implementation guide that **SHOULD** be supported for each type of resource are shown in the table below.  CRD Clients **MAY** support only the resources needed to implement the relevant CDS Hooks and order types.  Those search parameters with hyperlinks are defined as part of this implementation guide.  The remainder are defined within their respective version of the FHIR core specification.

EMR implementations **SHOULD NOT** expect standardized prefetch key names.  EMRs supporting prefetch **SHALL** inspect the CDS Hooks Discovery Endpoint to determine exact prefetch key names and queries.

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
      &_include=Appointment:location<br/>
      &_include=Appointment:<a href="SearchParameter-appointment-insurance.html">insurance</a>:Coverage</code>
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
      &_include:iterate=PractitionerRole:practitioner<br/>
      &_include=DeviceRequest:insurance:Coverage</code>
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
      &_include=Encounter:location<br/>
      &_include=Encounter:<a href="SearchParameter-encounter-insurance.html">insurance</a>:Coverage</code>
    </td>
    <td>No requester</td>
  </tr>
  <tr>
    <td>MedicationRequest</td>
    <td>
      <code>MedicationRequest?_id={{context.medications.MedicationRequest.id}}<br/>
      &_include=MedicationRequest:patient<br/>
      &_include=MedicationRequest:intended-dispenser<br/>
      &_include=MedicationRequest:requester:PractitionerRole<br/>
      &_include=MedicationRequest:medication<br/>
      &_include:iterate=PractitionerRole:organization<br/>
      &_include:iterate=PractitionerRole:practitioner<br/>
      &_include=MedicationRequest:<a href="SearchParameter-medicationrequest-insurance.html">insurance</a>:Coverage</code>
    </td>
    <td>No performing location</td>
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
      &_include:iterate=PractitionerRole:practitioner<br/>
      &_include=MedicationRequest:<a href="SearchParameter-medicationrequest-insurance.html">insurance</a>:Coverage</code>
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
      &_include=NutritionOrder:<a href="SearchParameter-nutritionorder-insurance.html">insurance</a>:Coverage</code>
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
      &_include:iterate=PractitionerRole:practitioner<br/>
      &_include=ServiceRequest:<a href="SearchParameter-servicerequest-insurance.html">insurance</a>:Coverage</code>
    </td>
    <td>No performer location</td>
  </tr>
</table>
{% endraw %}

##### FHIR Resource Access
If information needed is not provided by prefetch, the CRD Service can query the client directly using the [FHIR resource access](https://cds-hooks.hl7.org/1.0/#fhir-resource-access) mechanism defined in the CDS Hooks specification.

This can be done either by using individual queries or by invoking a batch of separate queries.  In either case, the HTTP call that performs the query or executes the batch must pass the `fhirAuthorization.accessToken` in the Authorization header as defined in the [OAuth specification](https://www.oauth.com/oauth2-servers/accessing-data/making-api-requests).

The following two examples show a batch query that could retrieve all CRD-relevant resources as well as the structure of the corresponding batch response.

**Query Batch Request**<br/>
This query presumes that a hook has been invoked and the following information has been passed in as context:

```
  "userId": "PractitionerRole/ABC",
  "patientId": "123",
  "encounterId": "987"
```

As well, the `draftOrders` Bundle includes MedicationRequests that: reference 2 formulary medications (MED1, MED2), to be fulfilled by one pharmacy Organization (456), and are ordered by the same PractitionerRole with id 'ABC'.  Most importantly, they are all tied to the same Coverage record with id 'DEF'.

Note: This query also presumes that all this information would be relevant to the CRD Service.  In practice, the service would only query the information needed to determine coverage requirements.  Also, the service will only be able to query data where the scopes made available in the `fhirAuthorization.scope` permit the desired queries.

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


##### Query Notes
*  Conformant CRD Clients **SHOULD** be able to perform all the queries defined here and, where needed, **SHOULD** implement interfaces to [_include]({{site.data.fhir.path}}search.html#include) resources not available in the client's database.

* Executing these queries in either batch or prefetch will bring back some redundant information (e.g.  information that was already known to the CRD Client and included in the request). Examples of this redundant information include: returning the original request, returning Encounter and Appointment resources found in the hook contexts, and returning Patient, Practitioner, Organization and Coverage resources that are common for different request types for the order-sign hook. This redundancy is the cost of using the prefetch mechanism or batch mechanism. Payers seeking greater efficiency can perform direct queries that are more tuned at the cost of needing to make multiple service calls.

* The queries use the defined search parameter names from the respective FHIR specification versions. If parties processing these queries have varied from these 'standard' search parameter names (as indicated by navigating their CapabilityStatements), the CRD Service will be responsible for translating the parameters into the CRD client's local names. For example, if a particular EMR's CapabilityStatement indicates that the parameter name (that corresponds to HL7's 'encounter' search criteria) is named 'visit' on the client's server, the Service will have to construct its search URL accordingly.

* When full prefetch as defined here is not supported, CRD Clients **SHOULD**, at minimum, support the batch query syntax shown [above](#fhir-resource-access).  CRD Services **MAY** choose to support the batch query mechanism, perform client-specific queries as necessary, or return no results when a client does not support its prefetch requirements.

* While these queries attempt to bring back all the potentially relevant information, not all information will necessarily exist for all requests or events, particularly at the time the hook is called.  CRD Services **SHALL** provide what coverage requirements they can based on the information available.

* When processing data from query responses, always check the 'self' link to ensure that the server executed what was requested and processed the data as necessary - or try querying by a different mechanism (e.g. multiple queries rather than relying on `_include`).

#### Deferring Tasks
CRD clients SHOULD support deferring cards, allowing the information on a card to be reviewed by and/or the actions on a card to be performed by the current user or someone else at a later point.  If a CRD service feels that the ability to defer a card is important and (a) the system receiving the card does not have a native mechanism to defer a card and (b) the system does have the ability to accept 'create Task' actions, the CRD service MAY provide an alternate 'deferred' action that allows the card action to be performed later. CRD clients that do not provide native support for deferring cards ?SHOULD? support accepting Task create actions.

The action will display an appropriate message about deferring the action (e.g. launching the SMART app) and will cause the creation of a Task within the CRD client. This Task will have an owner of the current user and will comply with the [CRD Card Task] profile.  Once created, deferred card Tasks can be re-assigned, scheduled and otherwise managed as normal Tasks.

In addition, where no other deferral capabilities exist, a user can 'effectively' defer a DTR task by launching the DTR application, then saving and closing the app - which will save the current DTR session for later resumption by manually invoking the DTR application and selecting and resuming the in-progress session.  The user could also add a note to the in-progress order that DTR work requires completion.

### SMART on FHIR Hook Invocation
In addition to the real-time decision support provided by CDS Hooks, providers will sometimes need to seek coverage requirements information without invoking the workflow of their clinical system to actively create an order, appointment, encounter, etc.  A few real world examples where hooks may be invoked this way include: exploring a "what-if" scenario, answering a patient question related to whether a service would be covered, and retrieving a guidance document they had seen in a previous card.

The solution to this need to perform coverage discovery "any time" is the use of a SMART on FHIR app.  Many CRD Clients (e.g. EMR systems) already support SMART on FHIR.  That standard allows independently developed applications to be launched from within the CRD Client (possibly within the user interface) and to interact with its data.  As part of its scope, the Da Vinci organization will develop an open source SMART on FHIR application to allow users of CRD Clients to invoke coverage requirements discovery from CRD Services for "what-if" scenarios using a CRD Client's existing SMART on FHIR interface.  CRD implementers **MAY** choose to use this app directly or as the basis for their own app development.  Note that CRD Clients will have their own registration process for all such apps.

CRD Clients conforming with this specification **SHALL** support the SMART on FHIR interface, **SHALL** allow launching of SMART apps from within their application, and **SHALL** be capable of providing the SMART app access to information it exposes to CRD Services using the CDS Hooks interface.

The Da Vinci CRD SMART app has not yet been developed.  Once it exists, a link will be provided beneath the [CRD Confluence page](https://confluence.hl7.org/display/DVP/Coverage+Requirements+Discovery+(CRD)).  

NOTES:

* The use of SMART to explore "what-if" scenarios is distinct from the use of SMART envisioned in CDS Hooks:
    * rather than launching a SMART app based on a returned card, a SMART app is used here to invoke a CDS hook to artificially simulate a workflow in the CRD Client that would normally trigger a hook
    * when a SMART app is launched, draft orders within a CRD Client will not typically be available to the app to submit to the CRD Service - information for consideration in the "what-if" scenario will need to be entered into the app directly
    * when a CRD Service returns cards, any instructions associated with the cards will be displayed in the app but it may not be able to execute the instructions within the cards
* Exploration of "what-if" scenarios using the app is intended to work for all of the hooks. This might be accomplished through the use of separate SMART apps for different types of orders / processes (e.g. distinct what-if apps for ordering drugs, ordering labs, doing referrals, scheduling appointments, etc.) or a single SMART app that prompts the user to identify they scenario they are interested in exploring prior to invoking the hook.

#### Registering DTR apps with CRD

If a payer supports both CRD and DTR and the EHR intends to enable DTR in addition to CRD, then at the time the CRD service is enabled within the EHR, the service must be configured with the URL of the SMART app that is to be used within that EHR.  For configuration purposes either zero or one SMART app SHALL be configured.  The SMART app selected must be one that supports all of the Questionnaire data types, extensions and other options that will be used by the payer - potentially including adaptive forms.

**NOTE:** The URL selected MAY be a 'logical' URL that corresponds to an EHR internal function rather than a registered SMART app.

An EHR, on receipt of a CDS Hook card with a SMART app launch of the specified DTR URL choose to substitute that URL with the URL of an alternate SMART app, or with a card that allows launch of an internal function.  (Note: There is no standard mechanism for launching internal EHR functionality from a CDS Hook card as yet, so this will need to be an EHR-proprietary mechanism.).  EHRs performing such substitution might do so based on the user, organization, order type or any other configuration option.  All responsibility for selection of which app to use rests with the EHR.  The card-provided URL SHALL be the same for all DTR launches cards returned by the payer.

Any substituted app (or internal EHR functionality) would need to support the DTR 1.1 standard launch context expectations and would also need to ensure the alternate app or internal function likewise supports the necessary Questionnaire capabilities used by the payer.  The EHR SHALL also notify the payer that they are performing app substitution so that the payer can notify the EHR if the payer's Questionnaire requirements will be changing.

### Additional Considerations

1. Healthcare providers will rely on the information provided by the Coverage Requirements Discovery process to determine if there are any special steps they need to take such as requesting prior authorization.  As a result, it's important to them to know whether requirements exist or not.  CRD Services SHALL respond with an empty JSON object when there is no action to be taken by the provider (the CDS Hooks mechanism for representing no guidance – which is not shown to the user) which allows a computer to distinguish between "no requirements" and a textual requirement.

2. The receipt of coverage requirements (be it "no requirements" or specific requirements/recommendations) has financial implications for both healthcare providers and payers.  If a provider receives a message of "no requirements" and subsequently has a claim denied because of unmet requirements, it will be necessary for both sides to be able to confirm whether a "no requirements" response was sent and what information was in the hook invocation that led to that response.  Therefore, in addition to any logging performed for security purposes, both CRD Clients and CRD Services **SHALL** retain logs of all CRD-related hook invocations and their responses for access in the event of a dispute.  All `Card.suggestion` elements **SHALL** populate the `Suggestion.uuid` element to aid in log reconciliation.  Organizations **SHALL** have processes to ensure logs can be accessed by appropriate authorized users to help resolve discrepancies or issues in a timely manner.

NOTE: Because the information in these logs will often contain PHI, access to the logs themselves will need to be restricted and logged for security purposes.

3. CRD Clients that fire CDS hooks multiple times during the creation/editing/review phase are responsible for managing the resulting cards and determining what to display to the user.  CRD Clients **SHOULD** ensure that multiple cards with the same "advice" are handled in a way that will not create a burden on the user.

4. Most implementation guides provide JSON, XML and Turtle representations of artifacts.  However, because this guide is primarily using CDS Hooks (which only supports JSON) and SMART on FHIR (which primarily uses JSON), this implementation guide only publishes the JSON version of artifacts.

5. The examples in this guide use whitespace for readability.  Conformance systems **SHOULD** omit non-significant whitespace for performance reasons

6. Examples provided within this specification strive to be realistic, but might not reflect accurate/current coverage requirements
