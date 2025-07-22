CDS Hooks defines two different mechanisms for services to respond to a hook call: cards and system actions. This page profiles (constrains) the general rules for these responses from the CDS Hooks specification to reflect how they must be used when complying with this CRD specification.

### General Card and SystemAction rules

In addition to the [guidance provided in the CDS Hooks specification]({{site.data.fhir.ver.cdshooks}}/index.html#card-attributes), the following additional guidance applies to CRD services when constructing cards:

*  The `Card.indicator` **SHOULD** be populated from the perspective of the clinical decision maker, not the payer. While failure to procure a prior authorization might be 'critical' from the perspective of payment, it would be - at best - a 'warning' from the perspective of clinical care. 'critical' must be reserved for reporting life or death or serious clinical outcomes. Issues where the proposed course of action will negatively affect the ability of the payer or patient to be reimbursed would generally be a 'warning'. Most Coverage Requirements **SHOULD** be marked as 'info'.

*  All `Card.suggestion` elements **SHALL** populate the Suggestion.uuid element.

*  The `Card.source.label` **SHOULD** be populated with an insurer name that the user and patient would recognize (i.e., the responsible insurer on the patient's insurance card), including in situations where coverage recommendations are being returned by a benefits manager or intermediary operating the CRD Service on behalf of the payer. If an insurer is providing recommendations from another authority (e.g., a clinical society), the society's name and logo might be displayed, though usually only with the permission of that organization.

*  `Card.source.topic` **SHALL** be populated, and has an [extensible](http://www.hl7.org/fhir/terminologies.html#extensible) binding to the ValueSet <a href="ValueSet-cardType.html">CRD Response Types.</a> The rationale is to allow CRD clients to filter or track the usage of different types of cards.

*  Users are busy. Time spent reading a payer-returned card is time taken from reviewing other information or interacting with the patient. If not useful or relevant, users will quickly learn to ignore - or even demand the disabling of - payer-provided alerts. Therefore, information must be delivered efficiently and be tuned to provide maximum relevance. Specifically:

    *  `Card.summary` **SHOULD** provide actionable information. "Coverage alert" would not be very helpful. "Drug not covered. Covered alternatives available" or "Prior authorization required" would be better.

    *  `Card.detail` and/or external links **SHOULD** only be provided when coverage recommendations can't be clearly provided in the 140-character limit of `Card.summary`.

    *  `Card.detail` **SHOULD** provide graduated information, with critical information being provided in the first paragraph and less critical information towards the end of the page.

    *  `Card.detail` **SHOULD** provide enough context that a user can determine whether it is worth their time to launch an app or follow an external link, ideally providing a sense of where to look for and how to use whatever link or app they launch in the specific context of the order they're making.

    *  Keep the number of cards manageable. Consider whether user workflow will be faster with separate cards for each link or a single card having multiple links. Typically it is best to use the smallest number of cards that still support descriptive and actionable summaries.

    *  When providing links, don't send the user to the first page of a large document. Keep document size short and/or link directly to the section that is relevant for the context.

    *  While links are permitted in the markdown content of `Card.detail`, support for this is not universal, so links **SHOULD** also be provided in `Card.link`. This also provides a consistent place for users to access all relevant links.

* CRD client systems might not support all card capabilities, therefore card options **SHOULD** provide sufficient information for a user to perform record changes manually if automated support isn't available.

* Where <a href="{{site.data.fhir.ver.cdshooks}}/index.html#system-action">systemActions</a> are used, CRD services **SHOULD NOT** return equivalent information in a card for user display. It is the responsibility of the CRD client to determine how best to present the results of the newly created or revised records.

### Potential CRD Response Types
The sections below describe the different types of [responses]({{site.data.fhir.ver.cdshooks}}/index.html#cds-service-response) that CRD services can use when returning coverage requirements to CRD clients, including CRD-specific profiles on cards to describe CRD-expected behavior. It is possible that some CRD services and CRD clients will support response patterns other than those listed here, but such behavior is outside the scope of this specification. Future versions of this specification might standardize additional response types.
<a name="FHIR-50009"> </a>
<p class="modified-content">Conformant CRD clients and services **SHALL** support the [Coverage Information](#coverage-information-response-type) (see specific support expectations documented there) and **SHOULD** support the remaining types.</p>

NOTE: Support for a response type does not mean that all orders, appointments, etc. will necessarily receive card guidance, merely that it must be able to return those response types for at least a subset of CRD invocations.

Provision of and acceptance of decision support cards outside the coverage and documentation requirements space is optional (for both server and client). CRD services that provide decision support for domains outside of coverage and/or documentation requirements are expected to only provide decision support that the CRD client cannot do alone. To minimize duplicate alerts and provider burden, CRD services that provide decision support for domains outside of coverage and/or documentation requirements **SHOULD** take reasonable steps to check that the CRD client does not have the information within its store that would allow it to detect the issue itself. If the information already exists in the CRD client, then the obligation is on the CRD client to manage the issue detection and reporting in its own manner and CRD services should not get involved.

Response types are listed from least sophisticated to most sophisticated, and potentially more useful or powerful. As a rule, the more a response can automate manual processes and the more context-specific the behavior is, the more useful the decision support will be to the clinician and the more likely it will be used.

Notes:
* CRD clients will provide resources, such as MedicationRequest, in the context object of the CDS Hook request. These resources might be temporary in the context in which the CDS Hook is triggered, such as when a proposed medication order is being reviewed. In this case, the CDS client must maintain a stable identifier for these temporary resources to allow CRD responses to refer to them in CDS Hook actions.

* Hook responses may contain multiple cards and/or system actions corresponding to a mixture of the response types defined in this IG. For example, providing links, textual guidance, as well as suggestions for alternative orders.

* The response types listed here are *not* the same as the [Configuration Options](deviations.html#configuration-options-extension) specified above. A single response type could correspond to multiple configuration options. For example, [External Reference](#external-reference-response-type) could apply to clinical practice guidelines, prior authorization requirements, claims attachment requirements, and other things. Similarly, one configuration option could be satisfied with multiple response types. For example, required prior authorization forms could include both [External References](#external-reference-response-type) and explicit [Request Form Completion](#request-form-completion-response-type) responses.

### External Reference Response Type
This response type presents a card with one or more links to external web pages, PDFs, or other resources that provide relevant coverage information. The links might provide clinical guidelines, prior authorization requirements, printable forms, etc. Typically, these references would be links to information available from the payer's website, though pointers to other authoritative sources are possible too. CRD services **SHALL NOT** use these cards to direct users to a portal for the purpose of initiating prior authorization or determining coverage. Use the [Coverage Information](#coverage-information-response-type) response instead.

The card **SHALL** have at least one `Card.link`. The `Link.type` **SHALL** have a type of "absolute".

When reasonable, an "External Reference" card **SHOULD** contain a summary of the actionable information from the external reference in the `detail` element.

For example, this CDS Hooks [Card]({{site.data.fhir.ver.cdshooks}}/index.html#cds-service-response) contains two [Links]({{site.data.fhir.ver.cdshooks}}/index.html#link) - a standard and a printer-friendly version.

{% fragment Binary/CRDServiceResponse JSON BASE:cards.where(links.exists()) %}

<p>As much as technically possible, links provided <strong>SHOULD</strong> be 'deep' links that take the user to the specific place in the documentation relevant to the current hook context to minimize provider reading and navigation time.</p>


### Instructions Response Type
This response type presents a card with textual guidance to display to the user making the decisions. The text might provide clinical guidelines, suggested changes, or rules around prior authorization. It can be generated in a more sophisticated context for the payer, while remaining easy to consume for the provider because it allows returned information to be tuned to the specific context of the order/encounter that triggered the hook. In some cases, the text returned might be generated uniquely each time a hook is fired. CRD services **SHALL NOT** use these cards to direct users to a portal for the purpose of initiating prior authorization or determining coverage. Use the [Coverage Information](#coverage-information-response-type) response instead.

This example CDS Hook [card]({{site.data.fhir.ver.cdshooks}}/index.html#cds-service-response) just contains a message:

{% fragment Binary/CRDServiceResponse JSON BASE:cards.where(source.topic.where(code='clinical-reminder').exists()) %}

### Coverage Information Response Type
This response type uses a <a href="{{site.data.fhir.ver.cdshooks}}/index.html#system-action">systemAction</a> to automatically update the order or other resource in the CRD client with an extension that conveys information related to the coverage of the order. As discussed on the [home page](index.html#cmsdiscretion), the functionality of this response type has been enhanced to allow directly returning a prior authorization number as part of a CRD response.  Regardless of the content, this response type **SHALL NOT** use a card.

Support expectations for this hook by CDS services are as follows:

1. Payers **SHALL** support supplying coverage information for all primary hooks: order-sign, order-dispatch, and appointment-book.
2. Payers **MAY** support supplying coverage information for all other hooks.
3. Payers **SHALL** supply coverage information for all hooks where they support it unless the EHR sends a configuration option asking them not to.
4. If coverage information is evaluated, a system action **SHALL** be returned for each in-scope request resource unless that request resource already has a coverage-information extension and the payer has no new information to add.

A new FHIR [coverage-information](StructureDefinition-ext-coverage-information.html) extension is defined that allows assertions around coverage and prior authorization to also be captured computably, including what assertion is made, what coverage the assertion is made with respect to, when the assertion was made, and - optionally - a trace ID that can be used for audit purposes.
<a name="FHIR-50318"> </a>
<p class="new-content">
The extension generally gets added to the request reource that was passed to the CDS server (the Appointment, Encounter, ServiceRequest, etc.).  There is one exception, which is if an Appointment is 'basedOn' a ServiceRequest, the system action requesting a resoruce update to add or change the coverage-information extension(s) will be against the ServiceRequest, not the appointment.
</p>

Assertions about coverage, prior authorization requirements, etc. are contingent on the eventual claim for the ordered service being aligned with payer expectations. Because the order/appointment/etc. will not have the same information that would typically be included in a formal request for prior authorization or pre-determination, the payer will need to infer from the order what billing codes, qualifiers, dollar amounts, etc. would typically be involved. In some cases, the answer might differ depending on factors such as in/out of network, when the service is delivered, etc. These qualifiers around when the coverage assertion is considered valid **SHALL** be included as part of the annotation.

If a CRD service has provided limitations about when a coverage assertion applies that turn out to not be consistent with what the provider intends to do (e.g., payer says "covered if billed as X", but provider intends to bill as Y), then the provider can always use the normal prior authorization process to solicit an authorization that more precisely aligns with their expectations for how the service will eventually be billed.

If a CRD client submits a claim related to an order for which it has received a coverage-information extension for the coverage type associated with the claim, that claim **SHALL** include the `coverage-assertion-id` and, if applicable, the `satisfied-pa-id` in the X12 837 K3 segment. Further details about the specific location of each element will be available in the X12 specifications. These identifiers will provide the necessary context to allow the payer to respect any commitments made as part of the CRD call and also to link together CRD results and eventual claims for analytics purposes.
<a name="FHIR-51420"> </a>
<p class="modified-content">In some cases, multiple *coverage-information* extension repetitions may be added by the CRD service. This might represent different guidance for different coverages the service supports for the same patient or different expectations (related to coverage, prior auth, or additional information) for different billing codes, different qualifiers (e.g., in-network vs out-of-network), etc. If multiple extension repetitions are present, all repetitions referencing differing insurance (coverage-information.coverage) <b>SHALL</b> have distinct coverage-assertion-ids and satisfied-pa-ids, if present. Where multiple repetitions apply to the same coverage, they <b>MAY</b> have the same coverage-assertion-ids and satisfied-pa-ids (if present).  It is possible that some repetitions for a coverage might have satisfied prior authorization with an ID, while others will not.</p>

Systems **MAY** make calls related to orders even if there is already a coverage assertion recorded on the order. There is always the possibility that context has changed or new information available in the order will result in a new decision or additional guidance. The payer might also have other useful information not related to coverage or authorization. Information about the order or context might change between an initial `order-select` or `order-sign` and a subsequent `order-dispatch` or other hook invocation.

However, payers **SHALL NOT** send a system action to update the order unless something is new. Payers **SHOULD** take into account the previous decision in deciding how much processing is necessary before returning a response.
<a name="FHIR-50102"> </a>
<p class="additional-content">When returning a system action to update a resource with this response type, the resource content **SHALL NOT** make changes any data elements other than adding or modifying coverage-information extensions</p>

If a *coverage-information* extension indicates the need to collect additional information (via 'doc-needed'), the extension **SHOULD** include a reference to the questionnaire(s) to be completed. If the payer supports Da Vinci DTR, the indicated forms will be the ones completed within the DTR form filler.  If no Questionnaires are specified, DTR will determine the needed forms itself.  For systems that don't support DTR (e.g. because the coverage isn't subject to regulation mandating DTR), the indicated Questionnaire canonicals can be used to determine data to be gathered in some other (non-DTR) way.
<a name="FHIR-49830"> </a>
<p class="modified-content">When a <i>coverage-information</i> response type indicates that additional clinical or patient documentation is needed and the CRD client supports DTR, CRD clients <b>SHALL</b> ensure that clinical users have an opportunity to launch their DTR solution as part of the current workflow. Where a <i>coverage-information</i> response indicates that additional administrative documentation is needed, CRD clients <b>SHOULD</b> allow clinical users to have an opportunity to launch their DTR solution, but <b>SHOULD</b> make it clear that the information to be captured is non-clinical.</p>

NOTE: Launching DTR does not necessarily mean launching a SMART on FHIR application. Some CRD clients might incorporate DTR client functionality natively rather than using an app.
<a name="FHIR-50006"> </a>
<p class="modified-content">When invoking CRD, there may be situations where 'needed' information is not available.  For example, the date of birth might be 'unknown' and there might only be a subscriber id but not a member id.  Alternatively, the payer may not be able to find a member with the specified identifier, the payer might want a location and none is provided, or the payer needs a diagnosis code but the provided code is free text.  In such situations, this is NOT considered an error with the CDS Hook invocation.  A successful response with a coverage-information system action is still necessary.</p>

The CRD service **SHOULD** either prompt for the additional needed information using DTR or return a coverage-information extension indicating that the patient is not covered with a reason indicating the issue (e.g. the member could not be found/resolved).

If the payer does not support DTR for the type of information needed, the CRD service **MAY** provide a 'link' or 'information' card pointing to the forms or portal to use to capture the additional information. The link **SHOULD NOT** require user authentication (i.e., no log-on needed) when accessing downloadable forms. For portal links, it is preferred if a separate logon is not needed (e.g., with temporary/high-entropy links). Forms downloaded from provided links can then be submitted as part of the prior authorization (e.g., PAS), claim submission, etc. based on the identified documentation purpose.

While using portals or other non-questionnaire data capture is not recommended or preferred, it may be necessary as a transitional measure. Future versions of this IG are likely to mandate that questionnaires be included when additional information is required. This transitional accommodation is not intended to relax regulatory or legislative requirements that require the use of DTR.
<a name="FHIR-49637"> </a>
<div class="modified-content">
<p>If the CRD service is unable to resolve the patient, the Coverage Information <b>SHALL</b> indicate "not covered" with a reason code of <a href="ValueSet-coverageAssertionReasons.html#x-http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp-no-member-found">no-member-found</a>.</p>

<p>If the CRD is able to resolve the patient but they do not have active coverage, the Coverage Information <b>SHALL</b> indicate "not covered" with a reason of <a href="ValueSet-coverageAssertionReasons.html#x-http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp-no-active-coverage">no-active-coverage</a>.</p>
</div>
<div class="additional-content">
<a name="FHIR-51413"> </a>
<p>This specification allows returning either a single coverage-information repetition that says "conditional" or multiple coverage-information repetitions with specific assumptions that then indicate "covered", "auth-needed", etc.  The recommended criteria for deciding whether to return a single or multiple is as follows:</p>
<ul>
<li>If the decision is driven by different subsets of billing codes or different time-frames (i.e. discrete information that can be conveyed using coverage-information.billingCode or detail codes of allowed-period), then use multiple repetitions.</li>
<li>If the decision is driven by other information that can't be easily listed in the coverage-information (e.g. what specific provider delivers the service, where it happens, etc.) then use 'Conditional' and indicate the specific additional information needed to make a decision.</li>
</ul>
<p>For example, if the payer doesn't know whether authorization is necessary (or if the service is covered at all) because it's necessary to know whether the performer will be in network or not, this SHOULD be conveyed as a single coverage-information extension that is marked as 'conditional' for authorization and/or coverage with info-needed set to at least include provider and/or location, with a 'reason' indicating the authorization rules.  This might be the standard code of auth-out-network-only.</p>
<a name="FHIR-49950"> </a>
<p>If a system action containing a coverage-information extension is returned, the CRD client <b>SHALL</b> retain that coverage-information extension and expose it as part of the Request resource in all subsequent communications with that payer, including communications made using DTR and PAS.  The coverage-information.coverage-assertion-id will service as a 'linking' id allowing the payer to associate any cached information they have retained relating to the processing of this Request.</p>
</div>

When using this response type, the proposed order or appointment being updated **SHALL** comply with the following profiles:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td><a href="StructureDefinition-profile-appointment-with-order.html">profile-appointment-with-order</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-appointment-no-order.html">profile-appointment-no-order</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-devicerequest.html">profile-devicerequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-medicationrequest.html">profile-medicationrequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-nutritionorder.html">profile-nutritionorder</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-servicerequest.html">profile-servicerequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-visionprescription.html">profile-visionprescription</a></td>
    <td/>
  </tr>
</table>

For example, this card indicates that a prior authorization has been satisfied for a planned procedure:

{% fragment Binary/CRDServiceResponse JSON BASE:systemActions ELIDE:resource.children().where(is(Extension).not()) %}

CRD clients and services **SHALL** support the new CDS Hooks system action functionality to cause annotations to automatically be stored on the relevant request, appointment, etc. without any user intervention. In this case, the discrete information propagated into the order extension **SHALL** be available to the user for viewing. However, this might be managed with icons, flyovers, or alternate mechanisms than traditional CDS Hook card rendering. The key consideration is that the user is aware that the information is available and can easily access it. Client implementations will be responsible for ensuring that the only changes made to the CRD client record are to add the annotations contemplated here. CRD clients **MAY** be configured to not execute system actions under some circumstances, for example if the order has been cancelled or abandoned.

The information added to the order here is often going to be relevant/important not only to the creator of the order, but also to its eventual performer. This guide does not define how information around coverage is conveyed from the ordering system to the performing system. However, the [Post-acute Orders implementation guide](http://hl7.org/fhir/us/dme-orders) does provide a mechanism for electronic sharing of orders and could be used to convey the additional notes or extensions envisioned here as well.

Payers with existing tools that process prior authorization requests may have dependencies on data elements that are not found in the clinical orders being submitted as part of CRD such as service type or modifier codes. In these cases, payers **SHOULD** attempt to infer values for these elements based on elements that are present. For example 'service type' can often be inferred based on the nature of the service, the location, the performer, etc. In situations where the inferred element has an impact on the results, payers should document that as part of their 'coverage-information' extension. In situations where inference is not possible and an element must be known, the payer may indicate that formal prior authorization is necessary. This situation should be minimized as much as possible.

### Propose Alternate Request Response Type
This response type can be used by payers to present a card with suggested alternatives to the current proposed therapy. This might be updating the order to change certain information or proposing to replace the order completely with one or more alternatives. This might be used to propose a change to a first-line treatment, to alter therapy frequency or drug dosage to be consistent with coverage guidelines, to propose covered products or services as substitutes for a non-covered service, or to propose therapeutically equivalent treatments that will have a lower cost to the patient.

Multiple alternatives can be proposed by providing multiple suggestions. Each suggestion **SHOULD** contain either a single "update" action to revise the existing proposed order; or a "delete" action for the current proposed order and a "create" action for the new proposed order. In some cases, additional "create" actions might be needed if there is a need to convey a non-[contained]({{site.data.fhir.path}}references.html#contained) Medication, Device, or other resource. The "delete" action resource element is not expected to adhere to any profile, as it is only expected to contain the "id" property of the resource being replaced. Any other elements will be ignored.

The choice of "update" vs. "delete + create" **SHOULD** be based on how significant the change is and how relevant other decision support on the original request will still be. If cards returned by other service providers might still be relevant (e.g., because there was just a small change in dose or frequency), then performing an update will allow updates from other decision support cards to also be applied. If the change is significant enough that other decision support will not be relevant, a "delete + create" will allow the client to suppress decision support cards that no longer apply.

When using this response type, the proposed orders (and any associated resources) **SHALL** comply with the following profiles:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td><a href="StructureDefinition-profile-device.html">profile-device</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-devicerequest.html">profile-devicerequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-encounter.html">profile-encounter<sup>†</sup></a></td>
    <td/>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.uscore6}}/StructureDefinition-us-core-medication.html">us-core-medication</a></td>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-medicationrequest.html">profile-medicationrequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-nutritionorder.html">profile-nutritionorder</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-servicerequest.html">profile-servicerequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-visionprescription.html">profile-visionprescription</a></td>
    <td/>
  </tr>
</table>
<sup>†</sup> Only used if updating an Encounter (e.g., to add a note)

For example, this card proposes replacing the draft prescription for a brand-name drug (shown only as the 'resourceType' and 'id' from the `draftOrders` entry) and instead creating an equivalent prescription with a lower-cost medication.

{% fragment Binary/CRDServiceResponse2 JSON BASE:cards.where(source.topic.where(code='therapy-alternatives-req').exists()).suggestions EXCEPT:id | medication BASE:actions.resource %}

### Identify Additional Orders Response Type
This response type can be used to present a card that recommends the introduction of additional orders as companions or prerequisites for the current order. For example, the payer might recommend that certain lab tests be ordered along with a medication that is known to affect liver function. This will normally involve additional 'create' actions. The fact that there is no 'delete' for the original order conveys that these are supplemental actions rather than replacement actions. As with the [Propose Alternate Request](#propose-alternate-request-response-type) response type, in some cases multiple resources will need to be created to convey the full suggestion such as 'medication', 'device', etc.

When using this response type, the proposed orders and any associated resources **SHALL** comply with the following profiles:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td><a href="StructureDefinition-profile-communicationrequest.html">profile-communicationrequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-device.html">profile-device</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-devicerequest.html">profile-devicerequest</a></td>
    <td/>
  </tr>
  <tr>
    <td/>
    <td><a href="{{site.data.fhir.ver.uscore6}}/StructureDefinition-us-core-medication.html">us-core-medication</a></td>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-medicationrequest.html">profile-medicationrequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-nutritionorder.html">profile-nutritionorder</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-servicerequest.html">profile-servicerequest</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-visionprescription.html">profile-visionprescription</a></td>
    <td/>
  </tr>
</table>

This example proposes adding a monthly test to check liver function:

{% fragment Binary/CRDServiceResponse2 JSON BASE:cards.where(source.topic.where(code='clinical-reminder').exists()).suggestions %}

### Request Form Completion Response Type
NOTE: DTR is the preferred solution where forms are needed for capture of information for payer purposes including, but not limited to, prior authorization, claims submission, or audit because of its ability to minimize data entry burden. This response type **SHOULD** only be used when DTR is not available or applicable.

This response type can be used to present a card that indicates that there are forms that need to be completed. The indicated forms might indicate additional documentation that must be submitted for prior authorization, attachments for claims submission, documentation that must be completed and retained as proof that clinical need protocols have been followed, or that must otherwise be retained and available for future audits. While forms can also be expressed as static or active PDFs referenced by [External References](#external-reference-response-type), or within a [SMART Application](#launch-smart-application-response-type), this response type provides the form definition as a FHIR Questionnaire and creates a Task within the CRD client allowing the completion of the form to be appropriately scheduled and/or delegated. Alternatively, the provider could choose to execute the task and fill out the form immediately if that makes more sense from a clinical workflow perspective.

This suggestion will always include a create action for the Task. The Task will point to the Questionnaire to be completed using a `Task.input` element with a `Task.input.type` of "questionnaire" and the canonical URL for the questionnaire in `Task.input.valueCanonical`. Additional `Task.input` elements will provide information about how the completed questionnaire is to be submitted to the payer with a service endpoint if required. The `Task.code` will always include the CRD-specific `complete-questionnaire` code. The reason for completion will be conveyed in `Task.reasonCode`. The Questionnaire might also be included with a separate conditional create action or it might be excluded with the presumption it will already be available or retrievable by the client via its canonical URL, either from the original source or from a local registry.

Instead of using a card, CRD services **MAY** opt to use a <a href="{{site.data.fhir.ver.cdshooks}}/index.html#system-action">systemAction</a> instead. CRD clients supporting this response type **SHALL** support either approach.

When using this response type, the proposed orders (and any associated resources) **SHALL** comply with the following profiles:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td><a href="StructureDefinition-profile-taskquestionnaire.html">profile-taskquestionnaire</a></td>
    <td/>
  </tr>
</table>

No profile is provided for the questionnaires pointed to by the Task. CRD services **SHOULD** use questionnaires that are compliant with either the [Argonaut questionnaire profiles](https://github.com/argonautproject/questionnaire) (for forms to be completed within the CRD client) or the [Structured Data Capture (SDC) profiles](http://hl7.org/fhir/uv/sdc/index.html) (for more sophisticated forms to be created within a SMART on FHIR app or through an external service). 

Note:
* Where CRD services use the SDC profiles, they have the option of indicating an endpoint for submission of the questionnaire using Task.input or the SDC Questionnaire.endpoint extension to specify a service endpoint to submit completed questionnaires. If an endpoint is specified in both locations, both apply.
* CRD clients **SHOULD** retain a copy of all completed forms for future reference.

The following is an example CDS Hook [Suggestion]({{site.data.fhir.ver.cdshooks}}/index.html#suggestion), where the specified questionnaire is either expected to be available within the CRD client or available for retrieval through its canonical URL. As such, the [Action]({{site.data.fhir.ver.cdshooks}}/index.html#action) only contains the FHIR [Task]({{site.data.fhir.path}}task.html) resource. An example showing inclusion of both the Task and the referenced Questionnaire can be found [above](deviations.html#if-none-exist).

{% fragment Binary/CRDServiceResponse2 JSON BASE:cards.where(source.topic.where(code='123').exists()).suggestions EXCEPT:url BASE:actions.where(resource is Questionnaire).resource %}

### Create or Update Coverage Records Response Type
This response type is used when the CRD service is aware of additional coverage that is relevant to the current/proposed activity or has updates or corrections to make to the information held by the CRD client. For example, the CRD client might be aware that a patient has coverage with a provider, but not know the plan number, member identifier, or other relevant information. This response allows the CRD service to convey that information to the CRD client and link it to the current/proposed action. In theory, this type of response could also be used to convey corrected/additional prior authorization information the payer was aware of, however that functionality is out of scope for this release of the implementation guide.

Instead of using a card, CRD services **MAY** opt to use a <a href="{{site.data.fhir.ver.cdshooks}}/index.html#system-action">systemAction</a> instead. CRD clients supporting this response type **SHALL** support either approach. If receiving a system action, a CRD client **MAY** opt to place the new or updated record in a holding area for human review rather than directly modifying their source of truth.

NOTE: This functionality is somewhat redundant with the capabilities of the X12 270/271 transactions. This CRD capability **SHALL NOT** be used in situations where regulation dictates the use of the X12 functionality.

This response will contain a single suggestion. The primary action will either be a suggestion to update an existing coverage instance (if the CRD client already has one) or to create a new coverage instance if the CRD service is aware of coverage that the CRD client is not. In addition, the suggestion could include updates on all relevant request resources to add or remove links to coverage instances, reflecting which coverages are relevant to which types of requests.

For example, this CDS Hook [card]({{site.data.fhir.ver.cdshooks}}/index.html#cds-service-response) includes a single [suggestion]({{site.data.fhir.ver.cdshooks}}/index.html#suggestion) with an [action]({{site.data.fhir.ver.cdshooks}}/index.html#action) to update the [Coverage]({{site.data.fhir.path}}coverage.html).

{% fragment Binary/CRDServiceResponse2 JSON BASE:cards.where(source.topic.where(code='insurance').exists()).suggestions %}


If returning a card rather than a system action, this card type **SHOULD NOT** be returned for hook types that are likely to be triggered by clinical users rather than administrative staff. Cards of this type would be appropriate for hooks such as encounter-start or appointment-book, but would not be appropriate for order-select or order-sign.

### Launch SMART Application Response Type
SMART apps allow more sophisticated interaction between payers and providers. They provide full control over user interface, workflow, etc. With permission, they can also access patient clinical data to help guide the interactive experience and minimize data entry. Apps can provide a wide variety of functions, including eligibility checking, guiding users through form entry, providing education, etc.

All such apps will need to go through the approval processes for the client's provider organization and typically also the associated software vendor. This response type can cause the launching of such apps to occur in the context in which they are relevant to patient care and/or to payment-related decision making.

This response type is just a modified version of the [External Reference](#external-reference-response-type) response type. However, the `Link.type` will be "smart" instead of "absolute". The `Link.appContext` will typically also be present. 

NOTE: This mechanism is no longer to be used for launching [DTR applications](http://hl7.org/fhir/us/davinci-dtr). That process is now handled entirely through the [Coverage Information](#coverage-information-response-type) response type above. It can still be used for launching other types of SMART apps not focused on gathering data for payer use with questionnaires.

For example, this [card]({{site.data.fhir.ver.cdshooks}}/index.html#cds-service-response) contains a SMART app [link]({{site.data.fhir.ver.cdshooks}}/index.html#link) to perform an opioid assessment:

{% fragment Binary/CRDServiceResponse2 JSON BASE:cards.where(source.topic.where(code='guideline').exists()) %}
