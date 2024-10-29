Compliance with this implementation guide requires compliance with several profiles, extensions, and value sets. This page provides an overview of where these artifacts can be found.

The FHIR artifacts used by CRD are organized according to whether the content was developed as part of the US Core implementation guides or are specific to this CRD implementation guide.

As a result, there are 2 different lists of artifacts: one for this Da Vinci implementation guide and one for the US Core implementation guide.

### Artifact Lists
<table>
  <tr>
    <td><a href="artifacts.html">CRD-Specific Artifacts</a></td>
  </tr>
  <tr>
    <td><a href="{{site.data.fhir.ver.uscore3}}/profiles.html">US Core 3.1 artifacts</a></td>
  </tr>
  <tr>
    <td><a href="{{site.data.fhir.ver.uscore6}}/profiles-and-extensions.html">US Core 6.1 artifacts</a></td>
  </tr>
  <tr>
    <td><a href="{{site.data.fhir.ver.uscore7}}/profiles-and-extensions.html">US Core 7.0 artifacts</a></td>
  </tr>
</table>

Additional information about the use of these artifacts, Coverage Requirements Discovery (CRD), and the use of US Core can be found in the [Foundational section](foundation.html#profiles).

These FHIR artifacts define the clinical data that can be provided by CRD clients when invoking CDS Hooks, queried (or retrieved using [prefetch](foundation.html#prefetch)) from CRD clients by CRD servers and/or returned to client systems by hook services within [cards](cards.html).

The artifacts are of four types:

* [Profiles]({{site.data.fhir.path}}profiling.html) constrain FHIR resources to reflect CRD requirements
* [Extensions]({{site.data.fhir.path}}extensibility.html) define additional data elements that can be conveyed as part of a resource
* [Code Systems]({{site.data.fhir.path}}codesystem.html) define terminologies to be used in one or more of the profiles
* [Value Sets]({{site.data.fhir.path}}valueset.html) define the specific subsets of both CRD-defined and other code systems that must be (or are recommended to be) used within one or more profile elements

For this implementation guide, [Must Support]({{site.data.fhir.path}}profiling.html#mustsupport) means that CRD clients must be capable of exposing the data to at least some CRD servers. CRD servers are not obligated to make use of Must Support elements when performing their coverage requirements discovery.

<!-- Todo: examples, capabilitystatement, TestScenario? -->