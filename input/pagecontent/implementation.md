This page lists considerations and recommendations for implementation that fall outside the conformance expectations established by the specification. This covers content that the specification authors and project team consider to be essential business practices, good ideas, as well as concepts worthy of consideration and awareness. However, the content here doesn't define specific testable behavior.

### Suppressing Guidance

Some CRD clients might suppress certain types of payer guidance as being the 'default' presumption. For example, "Covered, no prior authorization required". In cases where CRD systems do this, there might be an issue if the CRD server becomes unable to respond and the CRD client does not clearly flag to the user that the service is not available. In that case, providers might incorrectly presume that authorization is not needed. Clients that perform such suppression of messages **SHALL** mitigate this potential for misinterpretation.

### Availability
<a name="FHIR-48625"> </a>
<p class="modified-content">While CRD availability isn't mission critical, outages will negatively impact both provider and payer healthcare experiences.  CRD servers <b>SHOULD</b> strive to achieve a minimum of 3-9s availability for their services and strive to provide at least some level of useful response to CRD clients even if some of their back-end systems are unavailable.</p>

### Limitations on Accuracy

In rare situations, circumstances might change in a way that invalidates information provided by a CRD server prior to execution of an ordered service. For example, coverage is terminated or changed by the employer, or data in the record is subsequently found to be erroneous. Providers (and where provided information is shared with them, patients) will need to be aware that, irrespective of this guide's expectations for [accuracy](foundation.html#accuracy), assertions made by a CRD server are always "point-in-time" and do not constitute an irrevocable promise any more than equivalent assertions made via telephone, fax, or mail.

### Managing 

Key aspects of interoperability for this specification include agreement on how to identify payers, identify different types of coverage, etc. As yet, there is no industry-wide solution to this issue. However, HL7 is working with industry partners on viable solutions to these issues. Guidance and recommendations on how to manage consistent identity of payer concepts as well as other topics can be found in the [CRD Implementer Support](https://confluence.hl7.org/pages/viewpage.action?pageId=91991946) confluence page. Some of the guidance there may migrate to this specification and become 'SHALL' in future releases, so implementers are strongly encouraged to align with the guidance on the page in their early development.

### Impact on payer processes

CRD functionality will typically not be able to be fully implemented using payers' existing adjudication engines. The business process involved is quite different:

* Traditional adjudication engines expect a formal submission of a prior authorization request that includes all elements necessary for adjudication, including specific billing codes, modifier codes, billing diagnoses, service types, etc. The specific performer, quantity, performer, timeframe, etc. will all be known and properly specified. A specific response is expected *only* for the service described.

* With CRD, the only information available is what the clinical user specifically enters when creating a clinical order, appointment, etc. Back-office or financially oriented users will generally not be involved at all. The user's objective is to drive the clinical process, not the billing process. The codes provided will be clinical ones and the information entered will focus on what the performer needs to execute the request, not on what a payer might want to support prior authorization. Information such as who will perform, where they will perform, when they will perform, etc. may not be known. With CRD there can be multiple contingent responses. For example "Not covered if billed as A or B, covered with prior authorization needed if billed as C or D, and no authorization required if billed as E".

* CRD isn't only seeking information about approval of a prior authorization. It also includes determining whether coverage exists, whether additional information is needed (such as DTR), etc. Legacy engines will not necessarily be set up to do this.

* The timeframes for evaluation will also differ. Many payers have an asynchronous prior authorization process where processing may take several minutes or even longer. CRD timelines are much shorter: 5 to 10 seconds, depending on circumstances.

Because of these considerations, modifications of existing engines or even development of independent engines to support CRD is likely.

Specific strategies that may be helpful for payers include:

#### General strategies

It will be common that the amount of information provided may be inadequate for a CRD server to confidently assert whether the requested service is covered or whether prior authorization is needed. Often the answer will be something like "if it's in network, then...", "if it's done on an out-patient basis, then...", or "if it's billed under one of these 3 codes, then..." The base results will fit into one of four buckets: "not covered", "covered with prior authorization required", "covered, with prior authorization granted", or "covered with no authorization needed". Typically, the "covered, with prior authorization granted" will not occur if there are multiple possible answers, as payers will not want to grant authorization if it's not clear what service will actually be billed. This means that, even in the worst case, a payer could theoretically provide a response with three coverage-information extensions, each documenting the circumstances in which that coverage circumstance will apply.

As much as possible, payers should endeavor to do exactly this. The specification allows payers to indicate the list of billing codes under which a given option will hold, as well as qualifiers such as "in network", "out of network", "performer type", etc. that apply to a specific coverage assertion.

However, in some cases the rules for determining what the coverage expectations are too complex to reasonably express or even to evaluate without more information. In these cases, a payer has a few options:

* If the request in the CDS Hook does not indicate the performer, the timeframe and/or the location and the payer's logic dictates that this information must be known before a reasonable response can be provided, the CRD server can use the 'info-needed' element to indicate what additional information (to be provided during order-dispatch or some other later business stage) is necessary to allow the payer to provide a useful response.

* Otherwise, the 'doc-needed' element can be sent indicating that additional (DTR) questions will need to be answered to provide the CRD server with enough information to evaluate coverage. 

#### Terminology

Information passed to the CRD server will typically contain clinical terminologies, might not contain billing terminologies, and will generally not include billing modifier codes or similar information often included in prior authorization requests. 

CRD servers will need to support these clinical terminologies or map them to internally used billing terminologies when determining decision support results. Even when the code on an order *is* a billing code such as CPT, the interpretation is different. Having a CPT code on an order does not guarantee that the same CPT code will appear on the eventual claim. CRD servers will need to map "order billing codes" to "potential claim billing codes" in the same manner as they map clinical codes.

In situations where CRD clients are aware of the likely billing codes at the time of ordering, they **MAY** send these codes as additional CodeableConcept.coding repetitions to assist in server processing. If using CPT, note the ability to convey CPT modifier codes via post-coordination as described in the [Using CPT](https://terminology.hl7.org/CPT.html) page on terminology.hl7.org. However, payers cannot depend on such additional codings being present. Mappings will be required.

This guide does not define how mappings between "ordered" codes and "potential resulting billing codes" are produced. Ideally, such mappings would be informed by payer knowledge of what sorts of claims typically result from orders of a particular type. In some cases, the mappings could vary based on performing organization or practitioner. Mappings will need to evolve as clinical and billing practices evolve and as the clinical and billing terminologies change.

It is more efficient if mappings can be shared across payers and providers. This implementation guide encourages industry participants to cooperate on the development of shared mappings and/or to work with terminology developers (e.g. AMA for CPT codes) to develop shared mappings as part of their code maintenance process.

#### Service Types, Billing Diagnoses and Other Modifiers

Often when submitting a claim or prior authorization request, the billing code does not stand alone. Instead, additional codes might be present that indicate information such as the level of complexity of the patient's condition, the reason for the service, exceptional circumstances such as "off hours", etc. This information often won't be present in the clinical resource transmitted in the CDS Hooks call.

CRD servers have a few options here:

1. Could potential modifiers impact the answer provided?  Often the answer will be "no". If a person doesn't have coverage for liposuction, it may not matter if it's in or out of network or delivered 'off hours'. If coverage determination can be made without knowing the modifiers, payers are expected to provide the information.

2. Some modifiers might be inferred from other information about the order. For example, the service types such as "sleep study" or "hearing aid" might be determined from the location or the provider the request is dispatched to if they can't be readily inferred from the code.

3. In some cases, the modifiers can be inferred from existing data about the patient. For example, if a treatment is sometimes given for diabetes treatment, and other times given for weight control, the payer could examine the record to see if there is a current condition indicating diabetes or obesity. If only one of the conditions exists, the payer can reasonably infer that as the reason for treatment (and can record their assumption as part of the coverage-information returned).

4. If modifiers are relevant to the coverage determination, there's no ability to infer their values from other information in the order or the patient's record, and the determination of potential coverage outcomes is too complex to simply return two or three alternative contingent coverage-information instances that reflect the level of coverage in different circumstances, the payer can use DTR to solicit the additional needed information.

Where a payer has made inferences beyond what's explicit in the CRD request, the response SHOULD make clear what assumptions around billing codes, in/out-of-network, delivery location were made in providing the response.  For example:

* presumed billing codes can be conveyed in the [billingCode element](StructureDefinition-ext-coverage-information-definitions.html#diff_Extension.extension:billingCode).
* limitations on quantity, period, or expectations about in-network/out-of-network can be conveyed in the [detail element](StructureDefinition-ext-coverage-information-definitions.html#diff_Extension.extension:detail).
