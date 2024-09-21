CDS Hooks is a relatively new technology.  It is considered a "Standard for Trial Use" (STU), meaning that it will continue to evolve based on implementer feedback and could change in ways that are not compatible with the current draft.  As well, the initial version of the CDS Hooks specification has focused on the core architecture and a relatively simple set of capabilities.  Additional capabilities will be introduced in future versions.

To meet requirements identified by Da Vinci project participants, it is necessary to introduce additional capabilities above and beyond what is currently found in the CDS Hooks specification.  This section of the CRD implementation guide describes those additional capabilities and the mechanism the implementation guide proposes to implement them.  The purpose of these customizations is to enable testing at connectathons and to support feedback into the CDS Hooks design process.

Each capability listed here has been proposed to the CDS Hooks community and could become part of the official specification in a future release.  However, there is a significant likelihood that the way the requirements are met will vary from the syntax or even the architectural approach proposed in this guide.  Future versions of this implementation guide will be updated to align with how these requirements are addressed in future versions of the CDS Hook specification.  Until both the CDS Hooks content and the FHIR and US Core content underlying this specification are *Normative* (locked into backward compatibility mode), the CRD implementation guide will remain as STU.

This implementation guide extends/customizes CDS Hooks in 5 ways: additional hook resources, a hook configuration mechanism, additional prefetch capabilities, additional response capabilities, and the ability to link hooks to their corresponding request.  Each are described below:

### Additional Hook scope
In the [current build](https://cds-hooks.org/hooks/order-sign/), the order-sign hook can be used for both 'draft' orders that are newly created as well as for updated orders that are active.  The balloted version of the hooks this IG release is bound to are limited to draft orders.  This IG adopts the newer wording, meaning that the order-sign hook can be triggered both on newly created orders, as well as when orders are updated (changing status, changing time-frame, etc.).  The hook can also be re-triggered if there is a key change to the context, most typically the establishment of new or renewed coverage relevant to the order.

### Additional Hook resources
Two of the hooks used by this specification (`order-select` and `order-sign`) identify specific "order" resources that can be passed as part of the hook invocation.  CRD has use-cases for additional resource types to be passed to this hook.  Specifically:

* [CommunicationRequest]({{site.data.fhir.path}}communicationrequest.html) - Needed to trigger CRD when a provider requests that another provider transfer patient records or other supporting information to another organization or agency.

* [Task]({{site.data.fhir.path}}task.html) - Task is used to seek fulfillment of an order from service providers.  Because coverage can be influenced by who is asked to perform an order, coverage requirements can be relevant here.  As well, task is used to request changes to existing therapies (e.g. stopping a medication, suspending a therapy, etc.) and changes to therapy can also have impacts on coverage requirements.

The proposal to add these resources to the existing hook definitions [can be found](https://github.com/cds-hooks/docs/issues/396) on the CDS hooks [issue tracker](https://github.com/cds-hooks/docs/issues).

### New hook configuration mechanism
The CRD Servers provided by payers will support discovery of different types of coverage requirements that will return different types of information to users on [CDS Cards](https://cds-hooks.hl7.org/2.0/#cds-service-response), such as:

*  Whether authorization is required
*  Recommended alternative therapies
*  Best practices associated with the planned therapy that are expected to be adhered to
*  Forms and documentation for retention within the CRD client
*  Forms and documentation that must be provided with a prior authorization request
*  Forms and documentation that must be included with a claim submission

Not all the coverage information returned by a CRD Server will be relevant to all users of all CRD Clients. It would therefore be useful to be able to configure CRD Servers to withhold certain card types from certain provider types, user roles, or specific users.  Preferences could potentially be configured within the CRD Server or within the CRD Client.

Managing preferences within a CRD Server would require processes to support communication and management of customization requests, as well as additional complexity within the CRD Server software.  Managing preferences within the CRD Client would require it to either request specific information by invoking multiple calls to different services or by invoking a single call to the service indicating the response types desired.

The approach in this implementation guide is designed to allow the users or administrators of CRD Clients to manage and dynamically communicate desired response types to the CRD Server at the time a service is invoked.  At this time, it is not clear whether this capability will be of interest to vendors, users, or other types of CDS Services.  Therefore, rather than proposing a change to the base CDS Hook specification, this IG leverages the CDS Hook extension mechanism to provide an experimental approach to specify and control the types of information returned to users. Connectathon and implementation experience could support requesting that these changes, or some variant of them, be included in a future version of the CDS Hook specification.

Extensions will be enabled in two places:

1.  The [CDS Service Discovery Response](https://cds-hooks.hl7.org/2.0/#response) object that describes the service's capabilities will include an extension that describes what [configuration options](StructureDefinition-CDSHookServicesExtensionConfiguration.html) can be set by the CRD Client
2.  The hook's [HTTP Request](https://cds-hooks.hl7.org/2.0/#http-request_1) object will include an extension to pass specific configuration settings as part of the hook invocation


### Configuration options extension
An extension called `davinci-crd.configuration-options` will define a configuration object with an array of available configurable options within the CDS Service, where:  

*  Each option **SHALL** include four mandatory elements:
    *  A `code` that will be used when setting configuration during hook invocation, and has an ([extensible](http://www.hl7.org/fhir/terminologies.html#extensible)) binding to the <a href="ValueSet-cardType.html">CRD Card Types</a> ValueSet.
    *  A data `type` for the parameter.  At present, allowed values are "boolean" and "integer". (NOTE: These are the JSON data types and not the FHIR data types.)
    *  A display `name` for the configuration option to appear in the client's user interface when performing configuration.
    *  A `description` providing a 1-2 sentence description of the effect of the configuration option.
*  A `default` value **SHALL** also be provided to show users what to expect when an override is not specified.

CRD servers **SHALL**, at minimum, offer configuration options for each type of card they support (with a code corresponding to the <a href="ValueSet-cardType.html">CRD Card Types</a> ValueSet and a type of ‘boolean’, where setting the flag to false will result in the server not returning any cards of the specified type). This allows CRD clients to control what types of cards they wish to receive at all, or to receive in particular workflow contexts or for certain users.  This configuration mechanism also allows EHRs to minimize information overload and avoid presentation of duplicative or low-utility CRD alerts.

For example, a [CDS Discovery Response](https://cds-hooks.hl7.org/2.0/#response) from a CRD Server might look like this:

<!-- fragment Binary/CRDServices JSON EXCEPT:services.where(hook='order-sign') EXCEPT:hook | extension BASE:services EXCEPT:`davinci-crd.configuration-options`.where(code='coverage-info' or code='max-cards') BASE:services.extension -->
{% raw %}
<pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksServices.html#CDSHooksServices.services">services</a>" : [
    ...
    {
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksServices.html#CDSHooksServices.services.extension">extension</a>" : {
        "<a href="StructureDefinition-CDSHookServicesExtensionConfiguration.html#CDSHookServicesExtensionConfiguration">davinci-crd.configuration-options</a>" : [
          {
            "<a href="StructureDefinition-CDSHookServicesExtensionConfiguration.html#CDSHookServicesExtensionConfiguration.code">code</a>" : "coverage-info",
            "<a href="StructureDefinition-CDSHookServicesExtensionConfiguration.html#CDSHookServicesExtensionConfiguration.type">type</a>" : "boolean",
            "<a href="StructureDefinition-CDSHookServicesExtensionConfiguration.html#CDSHookServicesExtensionConfiguration.name">name</a>" : "Coverage Information",
            "<a href="StructureDefinition-CDSHookServicesExtensionConfiguration.html#CDSHookServicesExtensionConfiguration.description">description</a>" : "Information related to the patient's coverage, including whether a service is covered, requires prior authorization, is approved without seeking prior authorization, and/or requires additional documentation or data collection",
            "<a href="StructureDefinition-CDSHookServicesExtensionConfiguration.html#CDSHookServicesExtensionConfiguration.default">default</a>" : true
          },
          ...
          {
            "<a href="StructureDefinition-CDSHookServicesExtensionConfiguration.html#CDSHookServicesExtensionConfiguration.code">code</a>" : "max-cards",
            "<a href="StructureDefinition-CDSHookServicesExtensionConfiguration.html#CDSHookServicesExtensionConfiguration.type">type</a>" : "integer",
            "<a href="StructureDefinition-CDSHookServicesExtensionConfiguration.html#CDSHookServicesExtensionConfiguration.name">name</a>" : "Maximum cards",
            "<a href="StructureDefinition-CDSHookServicesExtensionConfiguration.html#CDSHookServicesExtensionConfiguration.description">description</a>" : "Indicates the maximum number of cards to be returned from the service.  The services will prioritize cards such as highest priority ones are delivered",
            "<a href="StructureDefinition-CDSHookServicesExtensionConfiguration.html#CDSHookServicesExtensionConfiguration.default">default</a>" : 10
          }
        ]
      },
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksServices.html#CDSHooksServices.services.hook">hook</a>" : "order-sign",
      ...
    }
  ]
}</code></pre>
{% endraw %}

Notes:

*  This version of the implementation guide provides only limited standardization of the codes, names, types, or descriptions for configuration options for CRD Servers.  Future versions of the CRD specification may standardize additional configuration options that have been identified as useful by individual payer and CRD client experimentation - thereby improving consistency in behavior across payer services to ease the burden on those performing configuration.

*  There is no mechanism to express co-occurrence rules amongst configuration options.  Guidance can be given about allowed combinations in descriptions, but payer services **SHALL** gracefully handle disallowed/nonsensical combinations.  I.e. the CRD Server must:

    *  allow for the possibility that CRD Clients might not adhere to their co-occurrence rules,

    *  include explicit checks of inbound data for adherence to rules; and

    *  indicate that CRD checking could not be done and log appropriate information to allow engagement with CRD Clients to address any payer-specific needs.

*  Codes **SHALL** be valid JSON property names and **SHALL** come from the <a href="ValueSet-cardType.html">CRD Card Types</a> list if an applicable type is in that list.

*  Codes, names, and descriptions **SHALL** be unique within a [CDS Service](https://cds-hooks.hl7.org/2.0/#response) definition.  They **SHOULD** be consistent across different hooks supported by the same payer when dealing with the same types of configuration options.

*  Payer services providing more than one type of coverage requirement information/guidance **SHOULD** expose configuration options allowing clients to dynamically control what information is returned by the service.

#### Hook configuration extension
An extension called `davinci-crd.configuration` will define a second configuration object that will contain an array of codes and values corresponding to the configuration options configured within the CRD Client.

For example, the hook [HTTP Request](https://cds-hooks.hl7.org/2.0/#http-request_1) would look like this:

<!-- fragment Binary/CRDServiceRequest JSON EXCEPT:hook | extension -->
{% raw %}
<pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksRequest.html#CDSHooksRequest.extension">extension</a>" : {
    "davinci-crd.configuration" : {
      "<a href="StructureDefinition-CDSHookServiceRequestExtensionRequestConfig.html#CDSHookServiceRequestExtensionRequestConfig.value">cost</a>" : false,
      "<a href="StructureDefinition-CDSHookServiceRequestExtensionRequestConfig.html#CDSHookServiceRequestExtensionRequestConfig.value">claim</a>" : false,
      "<a href="StructureDefinition-CDSHookServiceRequestExtensionRequestConfig.html#CDSHookServiceRequestExtensionRequestConfig.value">appropriate-use</a>" : false,
      "<a href="StructureDefinition-CDSHookServiceRequestExtensionRequestConfig.html#CDSHookServiceRequestExtensionRequestConfig.value">max-cards</a>" : 5
    }
  },
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksRequest.html#CDSHooksRequest.hook">hook</a>" : "order-sign",
  ...
}</code></pre>
{% endraw %}


Notes:

*  Where CRD Clients support the optional configuration options, the following requirements apply:
    *  CRD Clients **SHOULD** expose configuration options through a configuration screen to allow users and/or system administrators to control the types of information returned.
    *  CRD Clients **SHALL** convey configuration options when invoking the hook using the davinci-crd.configuration extension. It will be a single object whose properties will be drawn from the code values from configuration options and whose values will be of the type defined for that option.
    *  CRD Clients **SHOULD** provide an ability to leverage the dynamic configuration capabilities of payer services based on provider role, individual provider, and/or hook invocation location as best meets the needs of their users.

* Because support for some configuration is required for all CRD servers, the following requirements apply:
    *  CRD Servers **SHALL** behave in the manner prescribed by any supported configuration information received from the CRD Client.
    *  CRD Servers **SHALL NOT** require the inclusion of configuration information in a hook call (i.e. no hook invocation is permitted to fail because configuration information was not included).
    *  CRD Clients **MAY** send configuration information that CRD Servers do not support. In this case, the CRD Server **SHALL** ignore the unsupported configuration information.

*  This specification provides no guidance on exactly when/how CRD Clients are expected to manage hook configuration.  This could be done at the level of provider roles, individual providers, location from which the hook is invoked, or other means.  CRD Clients can experiment and determine what types of configuration make the most sense and at what levels they can support managing/persisting configuration information.


### Additional prefetch capabilities
One of the options supported in CDS Hooks is the ability for a service to request that certain data be [prefetched](https://cds-hooks.hl7.org/2.0/#prefetch-template) for efficiency reasons and to simplify processing for the CDS service.  However, there is a limit in that, in the current CDS Hooks specification, prefetch can only use hook context information that is expressed as a simple key value.  It cannot leverage context information passed as resources.

A [proposal](https://github.com/cds-hooks/docs/issues/377) has been submitted suggesting how to address this issue.  This version of the implementation guide pre-adopts that proposal.

Specifically, where a hook defines a context element that consists of a resource or collection of resources (e.g. [order-select.draftOrders](https://cds-hooks.hl7.org/hooks/order-select/2020May/order-select.html#context) or [order-sign.draftOrders](https://cds-hooks.hl7.org/hooks/order-sign/2020May/order-sign#context)), systems **SHALL** recognize context tokens of the form `context.<context property>.<FHIR resource name>.id` in prefetch queries.  Those tokens **SHALL** evaluate to a comma-separated list of the identifiers of all resources of the specified type within that context key.

Note: Recognizing these tokens doesn't mean the client must support prefetch or the requested prefetch query, only that it recognizes the token, doesn't treat it as an error and - if it supports the query - substitutes the token correctly.

For example, a prefetch for `order-sign` might look like this:

{% raw %}
<!-- fragment Binary/CRDServices JSON BASE:services.where(hook='appointment-book') EXCEPT:prefetch -->
<pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  ...
  "prefetch" : {
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksServices.html#CDSHooksServices.services.prefetch.value">patient</a>" : "Patient/{{context.patientId}}",
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksServices.html#CDSHooksServices.services.prefetch.value">encounter</a>" : "Encounter?_id={{context.encounterId}}&amp;_include=Encounter:service-provider&amp;_include=Encounter:practitioner&amp;_include=Encounter:location",
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksServices.html#CDSHooksServices.services.prefetch.value">coverage</a>" : "Coverage?patient={{context.patientId}}&amp;status=active",
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksServices.html#CDSHooksServices.services.prefetch.value">appointment</a>" : "Appointment?_id={{context.appointments.entry.resource.ofType(Appointment).id}}&amp;_include=Appointment:practitioner:PractitionerRole&amp;_include:iterate=PractitionerRole:organization&amp;_include:iterate=PractitionerRole:practitioner&amp;_include=Appointment:location"
  }
}</code></pre>{% endraw %}


This might result in an executed query that looks like this: `ServiceRequest?_id=2347,10948,5881&_include=ServiceRequest:performer`

<blockquote class="stu-note">
<p>
This proposed pre-adoption is not CDS Hooks conformant.  It is possible that the CDS Hooks community will adopt an alternative solution or choose not to make any changes.  Community discussion about this proposal can be found on the CDS Hooks issue list <a href="https://github.com/cds-hooks/docs/issues/377">here</a> and in Jira <a href="https://jira.hl7.org/browse/FHIR-35804">here</a>.  This implementation guide will be updated to align with the decision of the community and might, if necessary, fall back to the use of extensions if CDS Hooks does not choose to support prefetch based on context resources and the payer community determines that prefetch is still required.
</p>
<p>
In addition to this preadoption, this implementation guide presumes support for prefetch query capabilities more sophisticated than the recommended <a href="https://cds-hooks.hl7.org/2.0/#prefetch-query-restrictions">prefetch query restrictions</a> in the CDS Hooks specification.  Specifically, the use of <a href="{{site.data.fhir.path}}search.html#include">_include</a>, as seen in the example above.  It also uses a query-like mechanism to reference 'draft' orders that might not yet be available in the CRD client's repository for query, which will require query-like functionality to be implemented against in-memory objects.
</p>
</blockquote>

### Additional response capabilities
CDS Hooks supports suggestions that involve multiple actions.  Coverage Requirements Discovery uses this in one situation where additional capabilities will be needed:

*  Creating a Task to complete a Questionnaire; and

In this case, the creation of the Questionnaire needs to be conditional - it **SHOULD** only occur if that specific Questionnaire version doesn't already exist, and the payer service **SHALL** query to determine if the client has a copy of the Questionnaire before sending the request.  This capability is supported in FHIR's [transaction]({{site.data.fhir.path}}http.html#transaction)  
functionality.  However, not all the capabilities/guidance included there has been incorporated into CDS Hooks 'suggestions', in part to keep the specification simpler.

For this release of the implementation guide, these requirements will be handled as follows:

#### if-none-exist
The `suggestion.action` object will use an extension to carry the if-none-exist query, as per FHIR's [conditional create]({{site.data.fhir.path}}http.html#ccreate) functionality.  The extension property will be `davinci-crd.if-none-exist`.  

For example, this [CDS Hook Suggestion](https://cds-hooks.hl7.org/2.0/#suggestion) contains two [Actions](https://cds-hooks.hl7.org/2.0/#action) - one referencing an HL7 [Questionnaire]({{site.data.fhir.path}}questionnaire.html) and the other the [Task]({{site.data.fhir.path}}task.html) to complete the Questionnaire.  The Questionnaire will only be created if it didn't already exist:

<!-- fragment Binary/CRDServiceResponse2 JSON BASE:cards.where(source.topic.where(code='123').exists()).suggestions.actions.where(resource is Questionnaire) EXCEPT:url | version BASE:resource -->
{% raw %}
<pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.type">type</a>" : "create",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.description">description</a>" : "Add version 2 of the XYZ form to the clinical system's repository (if it doesn't already exist)",
  "<a href="http://hl7.org/fhir/R4/questionnaire.html#Questionnaire">resource</a>" : {
    "<a href="http://hl7.org/fhir/R4/questionnaire.html">resourceType</a>" : "Questionnaire",
    "<a href="http://hl7.org/fhir/R4/questionnaire.html#Questionnaire.url">url</a>" : "http://example.org/Questionnaire/XYZ",
    "<a href="http://hl7.org/fhir/R4/questionnaire.html#Questionnaire.version">version</a>" : "2",
    ...
  }
}</code></pre>
{% endraw %}


#### Linkage between created resources
The linkage between resources by `id` in different Actions within a single Suggestion doesn't require any extension to CDS Hooks, but it does require additional guidance.  For the purposes of this implementation guide, the inclusion of the `id` element in 'created' resources and references in created and updated resources within multi-action suggestions **SHALL** be handled as per FHIR's [transaction processing rules]({{site.data.fhir.path}}http.html#trules). I.e. Treating each requested action as being an entry in a FHIR transaction bundle where the base URL is the base URL of the CRD Client's server.  POST corresponds to an `action.type` of 'create' and PUT corresponds to an action.type of 'update'.  Specifically, this means that if a FHIR Reference points to the resource type and `id` of a resource of another 'create' Action in the same Suggestion, then the reference to that resource **SHALL** be updated by the server to point to the `id` assigned by the client when performing the 'create'.  CRD Clients **SHALL** perform 'creates' in an order that ensures that referenced resources are created prior to referencing resources.

For example, the following [CDS Hook Suggestion](https://cds-hooks.hl7.org/2.0/#suggestion) will cause the creation of a new [ServiceRequest]({{site.data.fhir.path}}servicerequest.html) that will be pointed to by a newly created ([DeviceRequest]({{site.data.fhir.path}}devicerequest.html) resource).  The ClaimResponse would be created before the MedicationRequest would be updated:

<!-- fragment Binary/CRDServiceResponse JSON BASE:cards.where(source.topic.where(code='therapy-alternatives-opt').exists()).suggestions ELLIDE:actions.where(type='delete') EXCEPT:id | basedOn BASE:actions.resource -->
{% raw %}
<pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.label">label</a>" : "Change to an order for purchase",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions">actions</a>" : [
    ...
    {
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.type">type</a>" : "create",
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.description">description</a>" : "Add purchase order",
      "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest">resource</a>" : {
        "<a href="http://hl7.org/fhir/R4/servicerequest.html">resourceType</a>" : "ServiceRequest",
        "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.id">id</a>" : "AAA",
        ...
      }
    },
    {
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.type">type</a>" : "create",
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.description">description</a>" : "Add specific (discounted) device order",
      "<a href="http://hl7.org/fhir/R4/devicerequest.html#DeviceRequest">resource</a>" : {
        "<a href="http://hl7.org/fhir/R4/devicerequest.html">resourceType</a>" : "DeviceRequest",
        "<a href="http://hl7.org/fhir/R4/devicerequest.html#DeviceRequest.id">id</a>" : "BBB",
        ...
        "<a href="http://hl7.org/fhir/R4/devicerequest.html#DeviceRequest.basedOn">basedOn</a>" : [
          {
            "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.reference">reference</a>" : "ServiceRequest/AAA"
          }
        ],
        ...
      }
    }
  ]
}</code></pre>
{% endraw %}

Note: Sending existing prior authorizations is not in scope for this version of the IG.

### Linking cards to requests
Some CDS hooks have a single context.  [encounter-start](hooks.html#encounter-start) and [encounter-discharge](hooks.html#encounter-discharge) are tied to their respective encounter and there is no question as to which encounter a returned card is associated with.  However, the [appointment-book](hooks.html#appointment-book), [order-select](hooks.html#order-select), and [order-sign](hooks.html#order-sign) hooks all allow passing in multiple resources as part of the hook invocation.  Each card returned in the hook response might be associated with only one of the referenced appointment or order resources, or a subset of them.  A CRD client might wish to be able to track *what* resource(s) a card was associated with.  This might be for audit, to control how or where the card is rendered on the screen, to allow the card to be directly associated with the triggering resource, or to enable various other workflow considerations.

This implementation guide defines a standard extension - `davinci-associated-resource` -  that can appear on any card that provides a local reference to the appointment, order, or other context resource to which the card is 'pertinent'.  It is optional and has a value consisting of 1..* local references referring to the resource type and resource id of the resource being linked.

If a hook service is invoked on a collection of resources, all cards returned that are specific to only a subset of the resources passed as context **SHALL** disambiguate in the `detail` element which resources they're associated with in a human-friendly way.  Typically, this means using test name, drug name, or some other mechanism rather than a bare identifier as identifiers might not be visible to the end user for resources that are not yet fully 'created'.  As well, cards **SHOULD** include this new extension to allow computable linkage.

<!-- fragment Binary/CRDServiceResponse2 JSON BASE:cards.where(source.topic.where(code='therapy-alternatives-req').exists()) EXCEPT:extension | summary | indicator -->
{% raw %}
<pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  ...
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.summary">summary</a>" : "Replace order with covered generic?",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.indicator">indicator</a>" : "info",
  ...
}</code></pre>
{% endraw %}


### Controlling hook invocation
Provider systems **SHALL** only invoke hooks on payer services where the patient record indicates active coverage with the payer associated with the service.  Providers **MAY** limit hook invocation to only those payers that are believed to potentially have relevant information related to the current action - for example, clinical guidance, contraindication detection, etc.  This might be more payers than just those that are likely to provide coverage for the services referred to by the hook.  

<div class="modified-content" markdown="1">
To avoid confusion for providers, where a patient has multiple active coverages that could be relevant to the current order/appointment/etc., CRD clients **SHALL** select from those coverages which is most likely to be primary and only solicit coverage information for that one payer.  If they invoke CRD on other payers, CRD clients **SHALL** ensure that card types that return coverage information are disabled for those 'likely secondary' payers. In situations where a CRD client determines that there are different primary coverages for different items in the same order action, they MAY choose to send separate CRD calls (each with its own access token) for the collection of services pertinent to that Coverage.  Alternatively, the client can submit all requests in a single call with the Coverage that is most broadly applicable.
</div>

NOTE: There is no expectation that CRD clients will only make calls to payer services that are 'known' to provide coverage for the proposed service.  In some cases, the EHR will not know at time of order entry which payer(s) will have claims submitted to them.  Also, a payer with active coverage might have information relevant to the order even if a claim will never be submitted to them (e.g. contraindications) or require a formal declaration of non-coverage, even though that declaration is a given.

Where the patient has multiple active coverages that the CRD client deems appropriate to call the respective CRD servers for, the CRD client **SHALL** invoke all CRD server calls in parallel and display results simultaneously to ensure timely response to user action.
