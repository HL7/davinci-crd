Compliance with this implementation guide requires compliance with a number of profiles, extensions, value sets and custom search parameters.  This page provides an overview of where these artifacts can be found.

The FHIR artifacts used by CRD are organized according to whether the content was developed as part of the US Core implementation guides or are specific to this CRD implementation guide.

As a result, there are 2 different lists of artifacts - one for this Da Vinci implementation guide and one for the US Core implementation guide.

### Artifact Lists
<table>
  <tr>
    <td><a href="artifacts.html">CRD-specific Artifacts</a></td>
  </tr>
  <tr>
    <td><a href="http://hl7.org/fhir/us/core">US Core IG</a></td>
  </tr>
</table>

Additional information about the use of these artifacts, coverage requirements discovry (CRD) and the use of US Core can be found in the [formal specification](hooks.html#profiles).

These FHIR artifacts define the clinical data that can be provided by CRD Clients when invoking CDS hooks, queried (or retrieved using [prefetch](hooks.html#prefetch)) from CRD Clients by CRD Services and/or returned to client systems by hook services within [cards](hooks.html#cards).

The artifacts are of four types:

* [Profiles]({{site.data.fhir.path}}profiling.html) constrain FHIR resources to reflect CRD requirements
* [Extensions]({{site.data.fhir.path}}extensibility.html) define additional data elements that can be conveyed as part of a resource
* [Code Systems]({{site.data.fhir.path}}codesystem.html) define terminologies to be used in one or more of the profiles
* [Value Sets]({{site.data.fhir.path}}valueset.html) define the specific subsets of both CRD-defined and other code systems that must be (or are recommended to be) used within one or more profile elements

For the purpose of this implementation guide, [Must Support]({{site.data.fhir.path}}profiling.html#mustsupport) means that CRD Clients must be capable of exposing the data to at least some CRD Services.  CRD Services are not obligated to make use of Must Support elements when performing their coverage requirements discovery.

<!-- Todo: examples, capabilitystatement, TestScenario? -->
