This implementation guide uses specific terminology such as **SHALL**, **SHOULD**, **MAY** to flag statements that have relevance for the evaluation of conformance with the guide.  As well, profiles in this implementation guide make use of the [mustSupport]({{site.data.fhir.path}}profiling.html#mustsupport) element.  Base expectations for the interpretation of these terms are set in the [FHIR core specification]({{site.data.fhir.path}}conformance-rules.html#conflang) and general Da Vinci-wide expectations are [defined in HRex]({{site.data.fhir.ver.hrex}}/conformance.html).

Additional conformance expectations specific to this guide are as follows:

### Conformance to this IG
In order to conform to this implementation guide, in addition to adhering to any relevant 'SHALL' statements, a system **SHALL** conform to at least one of the CapabilityStatements listed here:
* CRD clients - at least one of [CRD Client USCDI 1](CapabilityStatement-crd-client3.1.html), [CRD Client USCDI 3](CapabilityStatement-crd-client6.1.html), or [CRD Client USCDI 4](CapabilityStatement-crd-client7.0.html)
* CRD servers - [CRD Server USCDI 1, 3, 4](CapabilityStatement-crd-server.html)

### MustSupport
Profiles in this implementation guide make use of the [mustSupport]({{site.data.fhir.path}}profiling.html#mustsupport) element.

For data provided from CRD clients:

* If the CRD client maintains the data element and surfaces it to users, then it **SHALL** be exposed in their FHIR interface when the data exists and privacy constraints permit.

* CRD servers **SHALL** leverage mustSupport elements as available and appropriate to provide decision support.

For responses provided by CRD servers:

* CRD servers **SHALL** populate the element if an appropriate value exists. 

* CRD clients **SHALL** make the data available to the appropriate user (clinical or administrative) or leverage the data within their workflow as necessary to follow the intention of the provided decision support.

NOTE: These requirements are somewhat different from US Core and HRex because the implementation needs are different. In US Core, there is generally an expectation for clients to modify code and persistence layers to add support for 'mustSupport' elements in profiles. This expectation does not hold for CRD. However, CRD does require surfacing elements in the FHIR interface if the system maintains the element.

Also see the mustSupport rules for the [HRex]({{site.data.fhir.ver.hrex}}/conformance.html#mustsupport) and [US Core]({{site.data.fhir.ver.uscore7}}/must-support.html) implementation guides, which apply to content adhering to data elements profiled in those guides.

### Profiles
This specification makes significant use of [FHIR profiles]({{site.data.fhir.path}}profiling.html), search parameter definitions, and terminology artifacts to describe the content to be shared as part of CDS Hooks calls. The implementation guide supports FHIR [R4]({{site.data.fhir.path}}) with profiles listed for each type of hook.

The full set of profiles defined in this implementation guide can be found by following the links on the [Artifacts](allartifacts.html) page.

### US Core
This implementation guide also leverages the [US Core 3.1]({{site.data.fhir.ver.uscore3}}), [US Core 6.1]({{site.data.fhir.ver.uscore6}}), and [US Core 7.0]({{site.data.fhir.ver.uscore7}}) set of profiles defined by HL7 for sharing non-veterinary EHR individual health data in the United States. Where US Core profiles exist, this guide either leverages them directly or uses them as a base for any additional constraints needed to support the coverage requirements discovery use case. Where no constraints are needed, this IG does not define additional profiles, as all US Core profiles are deemed to be part of this IG and available for use in CRD communications. For example, the US Core Observation and Condition profiles are likely to be of interest in at least some CRD scenarios and may be used by solutions conformant to this guide.

Where US Core profiles do not yet exist (e.g., for several of the 'Request' resources), profiles have been created that try to align with existing US Core profiles in terms of elements exposed and terminologies used.

Note that, in some cases, the US Core profiles require support for data elements that are not necessarily relevant to the CRD use case. The authors of this IG believe that leveraging existing standard interfaces will promote greater (and quicker) interoperability than would a more finely tuned custom interface. CRD clients might still choose to restrict what information is exposed to CRD servers based on their internal data access and governance rules.

Conformance expectations with respect to US Core in this IG are the same as [those defined in HRex]({{site.data.fhir.ver.hrex}}/conformance.html#uscore).
