Complying with this implementation guide means complying with a number of profiles, extensions, value sets and custom search parameters.  This page provides an overview of where this information can be found.

The FHIR artifacts used by CRD are organized according to two axes: 

* is the content intended for use in FHIR STU3 implementations or R4 implementations?

* is the content developed as part of the US Core implementation guides or is it Da Vinci-specific?

As a result, there are 4 different lists of artifacts - one for each of the STU3 and R4 representations of the US Core and Da Vinci implementation guides.

### Artifact Lists
<table>
  <tr>
    <td><a href="artifacts.html">FHIR R4 CRD-specific Artifacts</a></td>
  </tr>
  <tr>
    <td><a href="http://hl7.org/fhir/us/core/2019Jan">US Core (2.1.0 - R4 based)</a></td>
  </tr>
  <tr>
    <td><a href="STU3/artifacts.html">FHIR STU3 CRD-specific Artifacts</a></td>
  </tr>
  <tr>
    <td><a href="http://hl7.org/fhir/us/core/STU2">(2.0.0 - STU3 based)</a></td>
  </tr>
</table>

Additional information about the use of these artifacts, CRD for multiple FHIR versions and the use of US Core can be found in the [main specification](hooks.html#profiles).


These FHIR artifacts define the clinical data that can be queried (or retrieved using [prefetch](hooks.html#prefetch)) from client systems by CRD hook services and that can be returned to client systems by hook services within [cards](hooks.html#cards).

The artifacts are of four types:

* [Profiles]({{site.data.fhir.path}}profiling.html) constrain FHIR resources to reflect CRD requirements
* [Extensions]({{site.data.fhir.path}}extensibility.html) define additional data elements that can be conveyed as part of a resource
* [Code Systems]({{site.data.fhir.path}}codesystem.html) define CRD-specific terminologies to be used in one or more of those profiles
* [Value Sets]({{site.data.fhir.path}}valueset.html) define the specific subsets of both CRD-defined and other code systems that can be (or are recommended to be) used within one or more profile elements
* [Search Parameters]({{site.data.fhir.path}}searchparameter.html) defines additional search criteria needed to allow filtering of FHIR resources to those relevant for CRD use-cases


For the purpose of this implementation guide, [Must Support]({{site.data.fhir.path}}profiling.html#mustsupport) means that client systems must be capable of exposing the data to at least some payer systems.  Payer systems are not obligated to make use of Must Support elements in performing their coverage requirements determination processes.

<!-- Todo: examples, capabilitystatement, TestScenario? -->