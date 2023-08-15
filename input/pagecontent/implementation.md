This page lists considerations and recommendations for implementation that fall outside the conformance expectations established by the specification.  I.e. It covers content that the specification authors and project team consider to be essential business practices, good ideas, as well as concepts worthy of consideration/awareness.  However, the content here doesn't define specific testable behavior.

### Suppressing Guidance

Some CRD clients might suppress certain types of payer guidance as being the 'default' presumption.  E.g. "Covered, no prior authorization required".  Where CRD systems do this, there might be an issue if the CRD service becomes unable to respond and the CRD client does not clearly flag to the user that the service is not available.  I.e. Providers might incorrectly presume that authorization is not needed.  Clients that perform such suppression of messages **SHALL** mitigate this potential for misinterpretation.

### Limitations on Accuracy

In rare situations, circumstances might change in a way that invalidates information provided by a CRD server prior to execution of an ordered service.  E.g. coverage is terminated or changed by the employer, data in the record is subsequently found to be erroneous, etc.  Providers (and where provided information is shared with them, patients) will need to be aware that, irrespective of this guide's expectations for [accuracy](foundation.html#accuracy), assertions made by a CRD Server are always "point-in-time" and do not constitute an irrevocable promise any more than equivalent assertions made in the paper/fax/phone-call world.

### Managing 

Key aspects of interoperability for this specification include agreement on how to identify payers, identify different types of coverage, etc.  As yet, there is no industry wide solution to this issue.  However, HL7 is working with industry partners on viable solutions to these issues.  Guidance and recommendations on how to manage consistent identity of payer concepts as well as other topics can be found in the [CRD Implementer Support](https://confluence.hl7.org/pages/viewpage.action?pageId=91991946) confluence page.  Some of the guidance there may migrate to this specification and become 'SHALL' in future releases, so implementers are strongly encouraged to align with the guidance on the page in their early development.

#### Impact on payer processes

Information passed to the CRD Server will typically contain clinical terminologies, might not contain billing terminologies, and will generally not include billing modifier codes or similar information often included in prior authorization requests.  CRD Servers will need to support these clinical terminologies or map them to internally used billing terminologies when determining decision support results - such as whether a therapy is covered or requires prior authorization.  In some cases, mappings may not be fully deterministic and may impact the ability to respond with useful decision support.  Services will also need to consider that the mapping they perform between clinical terminologies and billing codes may be different than the bill coding process performed by the client system when claims are eventually submitted.  This may mean that assertions about coverage or prior authorization requirements will need to be expressed conditionally.  E.g. "Provided this service is billed as X, Y or Z, then prior authorization is not needed".

In situations where CRD Clients are aware of the likely billing codes at the time of ordering, they **MAY** send these codes as additional CodeableConcept.coding repetitions to assist in server processing.  If using CPT, note the ability to convey CPT modifier codes via post-coordination as described in the [Using CPT]((https://terminology.hl7.org/CPT.html) page on terminology.hl7.org.

It is more efficient if mappings can be shared across payers and providers.  This implementation guide encourages industry participants to cooperate on the development of shared mappings and/or to work with terminology developers (e.g. AMA for CPT codes) to develop shared mappings as part of their code maintenance process.
