This implementation guide uses specific terminology such as **SHALL**, **SHOULD**, **MAY** to flag statements that have relevance for the evaluation of conformance with the guide.  As well, profiles in this implementation guide make use of the [mustSupport]({{site.data.fhir.path}}profiling.html#mustsupport) element.  Base expectations for the interpretation of these terms are set in the [FHIR core specification]({{site.data.fhir.path}}conformance-rules.html#conflang) and general Da Vinci-wide expectations are [defined in HRex]({{site.data.fhir.ver.hrex}}/conformance.html).  A summary of all such conformance statements found in this implementation guide can be found [here](conformancedetails.html).

Additional conformance expectations specific to this guide are as follows:

### Conformance to this IG
In order to conform to this implementation guide, in addition to adhering to any relevant 'SHALL' statements:
* CRD clients - at least one of [CRD Client USCDI 1](CapabilityStatement-crd-client3.1.html), [CRD Client USCDI 3](CapabilityStatement-crd-client6.1.html), or [CRD Client USCDI 4](CapabilityStatement-crd-client7.0.html)
* CRD servers - [CRD Server USCDI 1, 3, 4](CapabilityStatement-crd-server.html)

<p class="modified-content" markdown="1">This means that §conf-1^crd-client^exchange:CRD clients **SHALL** support at least one of the three specified versions of US Core.§ §conf-2^crd-server^exchange:CRD servers **SHALL** be able to handle all three US Core versions.§</p>

### MustSupport
Profiles in this implementation guide make use of the [mustSupport]({{site.data.fhir.path}}profiling.html#mustsupport) element.

For data provided from CRD clients:

* §conf-3?^crd-client^exchange:If the CRD client maintains a mustSupport data element and surfaces it to users, then it **SHALL** be exposed in their FHIR interface when the data exists and privacy constraints permit.§

* §conf-4^crd-server^processing:CRD servers **SHALL** leverage mustSupport elements as available and appropriate to provide decision support.§

For responses provided by CRD servers:

* §conf-5?^crd-server^exchange:CRD servers **SHALL** populate mustSupport elements if an appropriate value exists.§

* §conf-6^crd-client^processing,ui:CRD clients **SHALL** make the mustSupport data available to the appropriate user (clinical or administrative) or leverage the data within their workflow as necessary to follow the intention of the provided decision support.§

<blockquote class="stu-note" markdown="1">
These requirements are somewhat different from US Core and HRex because the implementation needs are different. In US Core, there is generally an expectation for clients to modify code and persistence layers to add support for 'mustSupport' elements in profiles. This expectation does not hold for CRD. However, CRD does require surfacing elements in the FHIR interface if the system maintains the element.  <span class="new-content"><a name="FHIR-52454"> </a>U.S. Core mustSupport rules continue to apply for data elements that are marked as mustSupport in US Core.</span>
</blockquote>

Also see the mustSupport rules for the [HRex]({{site.data.fhir.ver.hrex}}/conformance.html#mustsupport) and [US Core]({{site.data.fhir.ver.uscore7}}/must-support.html) implementation guides, which apply to content adhering to data elements profiled in those guides.

### Profiles
This specification makes significant use of [FHIR profiles]({{site.data.fhir.path}}profiling.html), search parameter definitions, and terminology artifacts to describe the content to be shared as part of CDS Hooks calls. The implementation guide supports FHIR [R4]({{site.data.fhir.path}}) with profiles listed for each type of hook.

The full set of profiles defined in this implementation guide can be found by following the links on the [Artifacts](allartifacts.html) page.

### US Core
This implementation guide also leverages the [US Core 3.1]({{site.data.fhir.ver.uscore3}}), [US Core 6.1]({{site.data.fhir.ver.uscore6}}), and [US Core 7.0]({{site.data.fhir.ver.uscore7}}) set of profiles defined by HL7 for sharing non-veterinary EHR individual health data in the United States. Where US Core profiles exist, this guide either leverages them directly or uses them as a base for any additional constraints needed to support the coverage requirements discovery use case. Where no constraints are needed, this IG does not define additional profiles, as all US Core profiles are deemed to be part of this IG and available for use in CRD communications. For example, the US Core Observation and Condition profiles are likely to be of interest in at least some CRD scenarios and may be used by solutions conformant to this guide.

Where US Core profiles do not yet exist (e.g., for several of the 'Request' resources), profiles have been created that try to align with existing US Core profiles in terms of elements exposed and terminologies used.

Note that, in some cases, the US Core profiles require support for data elements that are not necessarily relevant to the CRD use case. The authors of this IG believe that leveraging existing standard interfaces will promote greater (and quicker) interoperability than would a more finely tuned custom interface. CRD clients might still choose to restrict what information is exposed to CRD servers based on their internal data access and governance rules.

Conformance expectations with respect to US Core in this IG are the same as [those defined in HRex]({{site.data.fhir.ver.hrex}}/conformance.html#uscore).

<div class="new-content"  markdown="1">
<a name="FHIR-50216"> </a>
### Interoperability Expectations
For the CRD specification to work successfully at scale, it is essential that CRD clients and servers be able to interoperate with each other without custom expectations or deviations driven by EHR-specific or payer-specific requirements.  The following rules are intended to help drive such consistency:

1. §conf-7^crd-server^exchange:When preparing [Coverage Information](StructureDefinition-ext-coverage-information.html) responses, CRD servers **SHALL NOT** depend on or set expectations for the inclusion of resource instances not compliant with profiles defined in this guide, HRex, or US Core.§  Similarly, §conf-8^crd-server^exchange:CRD servers **SHALL NOT** depend on or set expectations for the inclusion of any data elements not marked as mandatory (min cardinality >= 1) or mustSupport in those profiles.§
2. §conf-9?^crd-server^exchange:When preparing [response types](cards.html) other than Coverage Information, CRD servers **SHOULD** limit themselves to the same resource instances and data elements as permitted above for Coverage Information responses.§
3. §conf-10^crd-client^exchange:CRD clients **SHALL NOT** depend on or set expectations for CRD servers to communicate data elements not marked as mandatory or mustSupport in the CRD specification.§
4. In the event a need to communicate data structures or elements not covered as required or mustSupport in the specification, the organization identifying the requirement is expected to submit change requests proposing adding the relevant profiles and/or mustSupport elements to a future version of the CRD specification.  If the proposed change is adopted and published in the CRD continuous integration build or the CI build of one of its dependencies (e.g. US Core), §conf-11?^crd-client,crd-server^exchange:implementations **MAY**, by mutual agreement, pre-adopt the use of those additional CI-build profiles and/or mustSupport data elements and not be considered in violation of #1 or #3 above.§
5. §conf-12?^crd-client,crd-server^exchange:Where cardinality and other constraints present in profiles allow data elements to be omitted, CRD compliant systems **SHALL NOT** treat the omission of those elements as an error.§  I.e. CRD servers are expected to return appropriate Coverage Information responses, not 4xx errors, and CRD clients are expected to execute system actions and/or display cards as normal.
NOTE: It is acceptable for a Coverage Information response to indicate that additional information is needed (info-needed), questionnaires need to be completed (doc-needed), or a formal prior authorization needs to be submitted (pa-needed) in situations where optional mustSupport elements are missing.
6. §conf-13^crd-client,crd-server^exchange:CRD clients and services and **SHALL** use standard CRD data elements (i.e. elements found within CRD-defined or inherited profiles and marked as mandatory or mustSupport) to communicate needed data where the elements are intended to convey such information.§  (If an organization believes they have a requirement for a data element not marked as mustSupport in CRD or inherited profiles, they ought to raise the requirement for discussion on the [CRD stream](https://chat.fhir.org/#narrow/stream/180803-Da-Vinci-CRD) on chat.fhir.org.)
7. §conf-14^crd-client-org,crd-server-org^business:CRD implementing organizations **SHALL NOT** publish guidance setting expectations for where certain data elements are conveyed within CRD and inherited data structures§, but are expected to submit change requests to CRD, HRex, or US Core requesting that additional guidance be provided to implementers on data structure usage to increase consistency across implementations.
</div>