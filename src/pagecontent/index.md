<blockquote class="stu-note">
This implementation guide is still under revision.  It is distributed for preliminary review by the community to confirm overall approach.
</blockquote>

### Scope
Todo

### Understanding FHIR

This implementation guide is based on the HL7 (FHIR)[{{site.data.fhir.path}}index.html] standard.  It uses terminology, notations and design principles that are
specific to FHIR.  Before reading this implementation guide, it's important to be familiar with some of the basic principles of FHIR as well
as general guidance on how to read FHIR specifications.  Readers who are unfamiliar with FHIR are encouraged to read (or at least skim) the following
prior to reading the rest of this implementation guide.

* [FHIR overview]({{site.data.fhir.path}}overview.html)
* [Developer's introduction]({{site.data.fhir.path}}overview-dev.html)
* (or [Clinical introduction]({{site.data.fhir.path}}overview-clinical.html))
* [FHIR data types]({{site.data.fhir.path}}datatypes.html)
* [Using codes]({{site.data.fhir.path}}terminologies.html)
* [References between resources]({{site.data.fhir.path}}references.html)
* [How to read resource & profile definitions]({{site.data.fhir.path}}formats.html)
* [Base resource]({{site.data.fhir.path}}resource.html)

It's a good idea to also look at the resources used by this implementation guide as well - specifically:
* TODO

### CDS Hooks

TODO

### FHIR Versions

TODO

### Content and organization

**Background and use-cases** describes the intent of this implementation guide and provides examples of how this specification can be used by payors

**CDS Hooks Considerations** describes how the CDS hooks framework will be used and highlights those portions of the CDS Hooks specifications that systems conformant with this implementaiton guide will need to support, any constraints on the general CDS Hooks framework that will need to be adhered to as well as business processes that will need to be executed between payors and EHRs wishing to leverage this implementation guide

**Data standards** Summarizes the resources used by this profile and 

**Hook responses** Describes the types of cards that Payors can return in response to hook invocation and constraints on those responses

**Security and consent** Describes expectations and assumptions around security and consent related to this implementation guide

**Examples** includes a set of examples showing how this specification can be used to solve different business cases

**Credits** Indicates the individuals and organizations involved in developing this implementation guide
