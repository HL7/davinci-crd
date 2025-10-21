CDS Hooks is relatively new technology.  It is considered a "Standard for Trial Use" (STU), meaning that it will continue to evolve based on implementer feedback and could change in ways that are not compatible with the current draft.  Also, the initial version of the CDS Hooks specification focuses on the core architecture and a relatively simple set of capabilities.  Additional capabilities will be introduced in future versions.

To meet requirements identified by Da Vinci project participants, it is necessary to introduce additional capabilities above and beyond what is currently found in the CDS Hooks specification.  This section of the CRD implementation guide describes those additional capabilities and the mechanism the implementation guide proposes to implement them.  The purpose of these customizations is to enable testing at connectathons and to support feedback into the CDS Hooks design process.

Each capability listed here has been proposed to the CDS Hooks community and could become part of the official specification in a future release.  However, there is a significant likelihood that the way the requirements are met will vary from the syntax or even the architectural approach proposed in this guide.  Future versions of this implementation guide will be updated to align with how these requirements are addressed in future versions of the CDS Hooks specification.  Until both the CDS Hooks content and the FHIR and US Core content underlying this specification are *Normative* (locked into backward compatibility mode), the CRD implementation guide will remain as STU.

This implementation guide extends/customizes CDS Hooks in 5 ways: additional hook resources, a hook configuration mechanism, additional prefetch capabilities, additional response capabilities, and the ability to link hooks to their corresponding request.  Each are described below:

### Additional Hook scope
In the [current build](https://cds-hooks.org/hooks/order-sign/), the order-sign hook can be used for both 'draft' orders that are newly created as well as for updated orders that are active.  The balloted version of the hooks this IG release is bound to are limited to draft orders.  This IG adopts the newer wording, meaning that the order-sign hook can be triggered both on newly created orders, as well as when orders are updated (changing status, changing timeframe, etc.).  The hook can also be re-triggered if there is a key change to the context, most typically the establishment of new or renewed coverage relevant to the order.

### New hook configuration mechanism
The CRD Servers provided by payers will support discovery of different types of coverage requirements that will return different types of information to users on [CDS Cards]({{site.data.fhir.ver.cdshooks}}/index.html#cds-service-response), such as:

*  Whether authorization is required
*  <span class="modified-content" markdown="1"><a name="FHIR-52531"> </a>Payer-preferred alternative therapies</span>
*  Best practices associated with the planned therapy which payers expect adherence to
*  Forms and documentation for retention within the CRD client
*  Forms and documentation that must be provided with a prior authorization request
*  Forms and documentation that must be included with a claim submission

Not all the coverage information returned by a CRD Server will be relevant to all users of all CRD Clients. It would therefore be useful to be able to configure CRD Servers to withhold certain card types from certain provider types, user roles, or specific users.  Preferences could potentially be configured within the CRD Server or within the CRD Client.

Managing preferences within a CRD Server would require processes to support communication and management of customization requests, as well as additional complexity within the CRD Server software.  Managing preferences within the CRD Client would require it to either request specific information by invoking multiple calls to different services or by invoking a single call to the service indicating the response types desired.

The approach in this implementation guide is designed to allow the users or administrators of CRD Clients to manage and dynamically communicate desired response types to the CRD Server at the time a service is invoked.  At this time, it is not clear whether this capability will be of interest to vendors, users, or other types of CDS Services.  Therefore, rather than proposing a change to the base CDS Hooks specification, this IG leverages the CDS Hooks extension mechanism to provide an experimental approach to specify and control the types of information returned to users. Connectathon and implementation experience could support requesting that these changes, or some variant of them, be included in a future version of the CDS Hooks specification.

Extensions will be enabled in two places:

1.  The [CDS Service Discovery Response]({{site.data.fhir.ver.cdshooks}}/index.html#response) object that describes the service's capabilities will include an extension that describes what [configuration options](StructureDefinition-CDSHookServicesExtensionConfiguration.html) can be set by the CRD Client
2.  The hook's [HTTP Request]({{site.data.fhir.ver.cdshooks}}/index.html#http-request_1) object will include an extension to pass specific configuration settings as part of the hook invocation


### Configuration options extension
<p class="modified-content">An extension called <a href="StructureDefinition-CDSHookServicesExtensionConfiguration.html">davinci-crd.configuration-options</a> will define a configuration object with an array of available configurable options within the CDS Service, where:</p>

*  Each option **SHALL** include four mandatory elements:
    *  A `code` that will be used when setting configuration during hook invocation, and has an ([extensible](http://www.hl7.org/fhir/terminologies.html#extensible)) binding to the <a href="ValueSet-cardType.html">CRD Card Types</a> ValueSet.
    *  A data `type` for the parameter.  At present, allowed values are "boolean" and "integer". (NOTE: These are the JSON data types and not the FHIR data types.)
    *  A display `name` for the configuration option to appear in the client's user interface when performing configuration.
    *  A `description` providing a 1-2 sentence description of the effect of the configuration option.
*  A `default` value **SHALL** also be provided to show users what to expect when an override is not specified.

CRD servers **SHALL**, at minimum, offer configuration options for each type of card they support (with a code corresponding to the <a href="ValueSet-cardType.html">CRD Card Types</a> ValueSet and a type of ‘boolean’, where setting the flag to false will result in the server not returning any cards of the specified type). This allows CRD clients to control what types of cards they wish to receive at all, or to receive in particular workflow contexts or for certain users.  This configuration mechanism also allows EHRs to minimize information overload and avoid presentation of duplicative or low-utility CRD alerts.

For example, a [CDS Discovery Response]({{site.data.fhir.ver.cdshooks}}/index.html#response) from a CRD Server might look like this:

{% raw %}
{% fragment Binary/CRDServices JSON EXCEPT:services.where(hook='order-sign') EXCEPT:hook | extension BASE:services EXCEPT:`davinci-crd.configuration-options`.where(code='coverage-info' or code='max-cards') BASE:services.extension %}
{% endraw %}

Notes:

*  This version of the implementation guide provides only limited standardization of the codes, names, types, or descriptions for configuration options for CRD Servers.  Future versions of the CRD specification may standardize additional configuration options that have been identified as useful by individual payer and CRD client experimentation - thereby improving consistency in behavior across payer services to ease the burden on those performing configuration.

*  There is no mechanism to express co-occurrence rules amongst configuration options.  Guidance can be given about allowed combinations in descriptions, but payer services **SHALL** gracefully handle disallowed/nonsensical combinations.  I.e. the CRD Server must:

    *  allow for the possibility that CRD Clients might not adhere to their co-occurrence rules,

    *  include explicit checks of inbound data for adherence to rules; and

    *  indicate that CRD checking could not be done and log appropriate information to allow engagement with CRD Clients to address any payer-specific needs.

*  Codes **SHALL** be valid JSON property names and **SHALL** come from the <a href="ValueSet-cardType.html">CRD Card Types</a> list if an applicable type is in that list.

*  Codes, names, and descriptions **SHALL** be unique within a [CDS Service]({{site.data.fhir.ver.cdshooks}}/index.html#response) definition.  They **SHOULD** be consistent across different hooks supported by the same payer when dealing with the same types of configuration options.

*  Payer services providing more than one type of coverage requirement information/guidance **SHOULD** expose configuration options allowing clients to dynamically control what information is returned by the service.

#### Hook configuration extension
<p class="modified-content">An extension called <a href="StructureDefinition-CDSHookServiceRequestExtensionRequestConfig.html">davinci-crd.configuration</a> will define a second configuration object that will contain an array of codes and values corresponding to the configuration options configured within the CRD Client.</p>

For example, the hook [HTTP Request]({{site.data.fhir.ver.cdshooks}}/index.html#http-request_1) would look like this:

{% fragment Binary/CRDServiceRequest JSON EXCEPT:hook | extension %}


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
One of the options supported in CDS Hooks is the ability for a service to request that certain data be [prefetched]({{site.data.fhir.ver.cdshooks}}/index.html#prefetch-template) for efficiency reasons and to simplify processing for the CDS service.  However, there is a limit in that, in the current CDS Hooks specification, prefetch can only use hook context information that is expressed as a simple key value.  It cannot leverage context information passed as resources.

A [proposal](https://github.com/cds-hooks/docs/issues/377) has been submitted suggesting how to address this issue.  The work group responsible for the specification has proposed adopting a modified version of this proposal that does not include _include support.  This version of the implementation guide pre-adopts that proposal.  

<a name="FHIR-49128"> </a>
<p class="modified-content">(See the <a href="foundation.html#additional-data-retrieval">foundation page</a> for language on conformance expectations.)</p>

The limitations on the XPath expressions that can be used are as follows:
* variables are limited to 'context' and the data elements reachable from it. (e.g. `_id={% raw %}{{context.draftOrders.entry.resource.ofType(ServiceRequest).location.id()}}{% endraw %}`)
* functions are limited to today(), ofType(), resolve(), and a new function read() (discussed below)
* addition or subtraction of 'days' (e.g. `lt{% raw %}{{today() - 7 days}}{% endraw %}`)

Additional restrictions on prefetch in general are that only the following are expected to be supported:
* instance level read interactions (for resources with known ids such as Patient, Practitioner, or Encounter)
* type level search interactions; e.g. patient={% raw %}{{context.patientId}}{% endraw %}
* Resource references (e.g. patient={% raw %}{{context.patientId}}){% endraw %}
* token search parameters using equality (e.g. code=4548-4) and optionally the :in modifier (no other modifiers for token parameters)
* date search parameters on date, dateTime, instant, or Period types only, and using only the prefixes eq, lt, gt, ge, le
* the _count parameter to limit the number of results returned
* the _sort parameter to allow for most recent and first queries

Prefetches can depend on the results of prior prefeches.  In this case, the result of the prior prefetch can be expressed as a variable using the name specified in the prefetch.  For example, if one prefetch value was defined as:
  `"encounter": "Encounter?_id={% raw %}{{%context.encounterId}}{% endraw %}"`
then a subsequent prefetch could be defined as:
  `"practitioners" : "Practitioner?_id=%encounter.participant.individual.resolve().ofType(Practitioner).id"`
  
NOTE: Dependencies on other prefetches should be minimized as it limits what queries can be performed in parallel.  Prefetches with dependencies **SHALL** be listed after the prefetches they depend on.

Recognizing these tokens doesn't mean the client must support prefetch or the requested prefetch query, only that it recognizes the token, doesn't treat it as an error and - if it supports the query - substitutes the token correctly.

For example, a prefetch for `order-sign` might look like this:

{% raw %}
{% fragment Binary/CRDServices JSON BASE:services.where(hook='order-sign') EXCEPT:prefetch %}
{% endraw %}


This might result in an executed query that looks like this: `Practitioner?_id=2347,10948,5881`


### Additional response capabilities
CDS Hooks supports suggestions that involve multiple actions.  CRD uses this in one situation where additional capabilities will be needed: creating a Task to complete a Questionnaire.

In this case, the creation of the Questionnaire needs to be conditional - it **SHOULD** only occur if that specific Questionnaire version doesn't already exist, and the payer service **SHALL** query to determine if the client has a copy of the Questionnaire before sending the request.  This capability is supported in FHIR's [transaction]({{site.data.fhir.path}}http.html#transaction)  
functionality.  However, not all the capabilities and guidance included there have been incorporated into CDS Hooks 'suggestions', in part to keep the specification simpler.

For this release of the implementation guide, these requirements will be handled as follows:

#### if-none-exist
<p class="modified-content">The <code>suggestion.action</code> object will use an extension to carry the if-none-exist query, as per FHIR's <a href="{{site.data.fhir.path}}http.html#ccreate">conditional create</a> functionality.  The extension property will be <a href="StructureDefinition-CDSHookServiceResponseExtensionIfNoneExist.html">davinci-crd.if-none-exist</a>.</p>

<span class="modified-content" markdown="1"><a name="FHIR-52533"> </a><a name="FHIR-52707"> </a>For example, this [CDS Hooks Suggestion]({{site.data.fhir.ver.cdshooks}}/index.html#suggestion) adhering to the [Request Form Completion Response Type](cards.html#request-form-completion-response-type) contains a single [Action]({{site.data.fhir.ver.cdshooks}}/index.html#action) referencing an HL7 [Questionnaire]({{site.data.fhir.path}}questionnaire.html).</span>  The Questionnaire will only be created if it didn't already exist:

{% fragment Binary/CRDServiceResponse2 JSON BASE:cards.where(source.topic.where(code='123').exists()).suggestions.actions.where(resource is Questionnaire) EXCEPT:url | version BASE:resource %}


#### Linkage between created resources
The linkage between resources by `id` in different Actions within a single Suggestion doesn't require any extension to CDS Hooks, but it does require additional guidance.  For the purposes of this implementation guide, the inclusion of the `id` element in 'created' resources and references in created and updated resources within multi-action suggestions **SHALL** be handled as per FHIR's [transaction processing rules]({{site.data.fhir.path}}http.html#trules). I.e. Treating each requested action as being an entry in a FHIR transaction bundle where the base URL is the base URL of the CRD Client's server.  POST corresponds to an `action.type` of 'create' and PUT corresponds to an action.type of 'update'.  Specifically, this means that if a FHIR Reference points to the resource type and `id` of a resource of another 'create' Action in the same Suggestion, then the reference to that resource **SHALL** be updated by the server to point to the `id` assigned by the client when performing the 'create'.  CRD Clients **SHALL** perform 'creates' in an order that ensures that referenced resources are created prior to referencing resources.

For example, the following [CDS Hooks Suggestion]({{site.data.fhir.ver.cdshooks}}/index.html#suggestion) will cause the creation of a new [ServiceRequest]({{site.data.fhir.path}}servicerequest.html) that will be pointed to by a newly created ([DeviceRequest]({{site.data.fhir.path}}devicerequest.html) resource):

{% fragment Binary/CRDServiceResponse JSON BASE:cards.where(source.topic.where(code='therapy-alternatives-opt').exists()).suggestions ELIDE:actions.where(type='delete') EXCEPT:id | basedOn BASE:actions.resource %}

Note: Sending existing prior authorizations is not in scope for this version of the IG.

### Linking cards to requests
Some CDS hooks have a single context.  [encounter-start](hooks.html#encounter-start) and [encounter-discharge](hooks.html#encounter-discharge) are tied to their respective encounter and there is no question as to which encounter a returned card is associated with.  However, the [appointment-book](hooks.html#appointment-book), [order-select](hooks.html#order-select), and [order-sign](hooks.html#order-sign) hooks all allow passing in multiple resources as part of the hook invocation.  Each card returned in the hook response might be associated with only one of the referenced appointment or order resources, or a subset of them.  A CRD client might wish to be able to track *what* resource(s) a card was associated with.  This might be for audit, to control how or where the card is rendered on the screen, to allow the card to be directly associated with the triggering resource, or to enable various other workflow considerations.

<p class="modified-content">This implementation guide defines a standard extension - <a href="StructureDefinition-CDSHookServiceResponseExtensionAssociatedResource.html">davinci-crd.associated-resource</a> -  that can appear on any card that provides a local reference to the appointment, order, or other context resource to which the card is 'pertinent'.  It is optional and has a value consisting of 1..* local references referring to the resource type and resource id of the resource being linked.</p>

If a hook service is invoked on a collection of resources, all cards returned that are specific to only a subset of the resources passed as context **SHALL** disambiguate in the `detail` element which resources they're associated with in a human-friendly way.  Typically, this means using test name, drug name, or some other mechanism rather than a bare identifier as identifiers might not be visible to the end user for resources that are not yet fully 'created'.  As well, cards **SHOULD** include this new extension to allow computable linkage.

{% fragment Binary/CRDServiceResponse2 JSON BASE:cards.where(source.topic.where(code='therapy-alternatives-req').exists()) EXCEPT:extension | summary | indicator %}


### Controlling hook invocation
<a name="FHIR-49897"> </a>
<p class="modified-content">Provider systems <b>SHALL</b> only invoke hooks on payer services where the patient record indicates active coverage with the payer associated with the service and where there is no recorded indication the patient intends to bypass insurance coverage (i.e. the service or product is not flagged as 'patient-pay').  Providers <b>MAY</b> limit hook invocation to only those payers that are believed to potentially have relevant information related to the current action - for example, clinical guidance, contraindication detection, etc.  This might be more payers than just those that are likely to provide coverage for the services referred to by the hook.</p>

To avoid confusion for providers, where a patient has multiple active coverages that could be relevant to the current order/appointment/etc., CRD clients **SHALL** select from those coverages which is most likely to be primary and only solicit coverage information for that one payer.  If they invoke CRD on other payers, CRD clients **SHALL** ensure that card types that return coverage information are disabled for those 'likely secondary' payers. In situations where a CRD client determines that there are different primary coverages for different items in the same order action, they MAY choose to send separate CRD calls (each with its own access token) for the collection of services pertinent to that Coverage.  Alternatively, the client can submit all requests in a single call with the Coverage that is most broadly applicable.

NOTE: There is no expectation that CRD clients will only make calls to payer services that are 'known' to provide coverage for the proposed service.  In some cases, the EHR will not know at the time of order entry which payer(s) will have claims submitted to them.  Also, a payer with active coverage might have information relevant to the order even if a claim will never be submitted to them (e.g. contraindications) or require a formal declaration of non-coverage, even though that declaration is a given.

Where the patient has multiple active coverages that the CRD client deems appropriate to call the respective CRD servers for, the CRD client **SHALL** invoke all CRD server calls in parallel and display results simultaneously to ensure timely response to user action.
