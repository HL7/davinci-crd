<div class="modified-content" markdown="1">
CDS Hooks defines two different mechanisms for services to respond to a hook call: cards and system actions. This page profiles (constrains) the general rules for these responses from the CDS Hooks specification to reflect how they must be used when complying with this CRD specification.
</div>

### General Card and SystemAction rules

In addition to the [guidance provided in the CDS Hooks specification](https://cds-hooks.hl7.org/2.0/#card-attributes), the following additional guidance applies to CRD services when constructing cards:

*  The `Card.indicator` **SHOULD** be populated from the perspective of the clinical decision maker, not the payer. While failure to procure a prior authorization might be 'critical' from the perspective of payment, it would be - at best - a 'warning' from the perspective of clinical care. 'critical' must be reserved for reporting life or death or serious clinical outcomes. Issues where the proposed course of action will negatively affect the ability of the payer or patient to be reimbursed would generally be a 'warning'. Most Coverage Requirements **SHOULD** be marked as 'info'.

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

* Where <a href="https://cds-hooks.hl7.org/2.0/#system-action">systemActions</a> are used, CRD services **SHOULD NOT** return equivalent information in a card for user display. It is the responsibility of the CRD client to determine how best to present the results of the newly created or revised records.

### Potential CRD Response Types
The sections below describe the different types of [responses](https://cds-hooks.hl7.org/2.0/#cds-service-response) that CRD services can use when returning coverage requirements to CRD clients, including CRD-specific profiles on cards to describe CRD-expected behavior. It is possible that some CRD services and CRD clients will support response patterns other than those listed here, but such behavior is outside the scope of this specification. Future versions of this specification might standardize additional response types.

<div class="new-content" markdown="1">
Of the response types in this guide, conformant CRD clients **SHALL** support the [External Reference](#external-reference-response-type), [Instructions](#instructions-response-type), and [Coverage Information](#coverage-information-response-type) responses and **SHOULD** support the remaining types.
</div>
<div class="modified-content" markdown="1">
CRD services **SHALL**, at minimum, demonstrate an ability to return the same as those listed as ‘SHALL’ for clients above. Also see specific support expectations for the [coverage information response type](#coverage-information-response-type).
</div>

NOTE: Support for a response type does not mean that all orders, appointments, etc. will necessarily receive card guidance, merely that it must be able to return those response types for at least a subset of CRD invocations.

<div class="modified-content" markdown="1">
Provision of and acceptance of decision support cards outside the coverage and documentation requirements space is optional (for both server and client). CRD services that provide decision support for domains outside of coverage and/or documentation requirements are expected to only provide decision support that the CRD client cannot do alone. To minimize duplicate alerts and provider burden, CRD services that provide decision support for domains outside of coverage and/or documentation requirements **SHOULD** take reasonable steps to check that the CRD client does not have the information within its store that would allow it to detect the issue itself. If the information already exists in the CRD client, then the obligation is on the CRD client to manage the issue detection and reporting in its own manner and CRD services should not get involved.
</div>

Response types are listed from least sophisticated to most sophisticated, and potentially more useful or powerful. As a rule, the more a response can automate manual processes and the more context-specific the behavior is, the more useful the decision support will be to the clinician and the more likely it will be used.

Notes:
* CRD clients will provide resources, such as MedicationRequest, in the context object of the CDS Hook request. These resources might be temporary in the context in which the CDS Hook is triggered, such as when a proposed medication order is being reviewed. In this case, the CDS client must maintain a stable identifier for these temporary resources to allow CRD responses to refer to them in CDS Hook actions.

* Hook responses may contain multiple cards and/or system actions corresponding to a mixture of the response types defined in this IG. For example, providing links, textual guidance, as well as suggestions for alternative orders.

* The response types listed here are *not* the same as the [Configuration Options](deviations.html#configuration-options-extension) specified above. A single response type could correspond to multiple configuration options. For example, [External Reference](#external-reference-response-type) could apply to clinical practice guidelines, prior authorization requirements, claims attachment requirements, and other things. Similarly, one configuration option could be satisfied with multiple response types. For example, required prior authorization forms could include both [External References](#external-reference-response-type) and explicit [Request Form Completion](#request-form-completion-response-type) responses.

### External Reference Response Type
<div class="modified-content" markdown="1">
This response type presents a card with one or more links to external web pages, PDFs, or other resources that provide relevant coverage information. The links might provide clinical guidelines, prior authorization requirements, printable forms, etc. Typically, these references would be links to information available from the payer's website, though pointers to other authoritative sources are possible too. CRD services **SHALL NOT** use these cards to direct users to a portal for the purpose of initiating prior authorization or determining coverage. Use the [Coverage Information](#coverage-information-response-type) response instead.
</div>

The card **SHALL** have at least one `Card.link`. The `Link.type` **SHALL** have a type of "absolute".

When reasonable, an "External Reference" card **SHOULD** contain a summary of the actionable information from the external reference.

For example, this CDS Hooks [Card](https://cds-hooks.hl7.org/2.0/#cds-service-response) contains two [Links](https://cds-hooks.hl7.org/2.0/#link) - a standard and a printer-friendly version.

<!-- fragment Binary/CRDServiceResponse JSON BASE:cards.where(links.exists()) -->
{% raw %}
<pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.uuid">uuid</a>" : "urn:uuid:07bc9814-9d2a-11ee-8c90-0242ac120002",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.summary">summary</a>" : "CMS Home Oxygen Therapy Coverage Requirements",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.detail">detail</a>" : "Learn about covered oxygen items and equipment for home use; coverage requirements; criteria you must meet to furnish oxygen items and equipment for home use; Advance Beneficiary Notice of Noncoverage; oxygen equipment, items, and services that are not covered; and payments for oxygen items and equipment and billing and coding guidelines.",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.indicator">indicator</a>" : "info",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source">source</a>" : {
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source.label">label</a>" : "Centers for Medicare &amp; Medicaid Services",
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source.url">url</a>" : "https://cms.gov",
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source.topic">topic</a>" : {
      "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.system">system</a>" : "http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp",
      "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.code">code</a>" : "guideline",
      "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.display">display</a>" : "Guideline"
    }
  },
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.links">links</a>" : [
    {
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.links.label">label</a>" : "Home Oxygen Therapy Guidelines",
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.links.url">url</a>" : "https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/Home-Oxygen-Therapy-ICN908804.pdf",
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.links.type">type</a>" : "absolute"
    },
    {
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.links.label">label</a>" : "Home Oxygen Therapy Guidelines (printer-friendly)",
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.links.url">url</a>" : "https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/Home-Oxygen-Therapy-Text-Only.pdf",
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.links.type">type</a>" : "absolute"
    }
  ]
}</code></pre>

<p>As much as technically possible, links provided <strong>SHOULD</strong> be 'deep' links that take the user to the specific place in the documentation relevant to the current hook context to minimize provider reading and navigation time.</p>

<h3 id="instructions-response-type">Instructions Response Type</h3>
<div class="modified-content">
  <p>This response type presents a card with textual guidance to display to the user making the decisions. The text might provide clinical guidelines, suggested changes, or rules around prior authorization. It can be generated in a more sophisticated context for the payer, while remaining easy to consume for the provider because it allows returned information to be tuned to the specific context of the order/encounter that triggered the hook. In some cases, the text returned might be generated uniquely each time a hook is fired. CRD services <strong>SHALL NOT</strong> use these cards to direct users to a portal for the purpose of initiating prior authorization or determining coverage. Use the <a href="#coverage-information-response-type">Coverage Information</a> response instead.</p>
</div>

<p>This example CDS Hook <a href="https://cds-hooks.hl7.org/2.0/#cds-service-response">Card</a> just contains a message:</p>

<pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.summary">summary</a>" : "Patient is overdue for a PAP smear",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.detail">detail</a>" : "Last date on record for a PAP test for this patient was May, 2014. Tests should ideally be performed every 1-3 years",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.indicator">indicator</a>" : "info",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source">source</a>" : {
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source.label">label</a>" : "You're Covered Insurance",
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source.url">url</a>" : "https://example.com",
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source.icon">icon</a>" : "https://example.com/img/icon-100px.png",
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source.topic">topic</a>" : {
      "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.system">system</a>" : "http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp",
      "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.code">code</a>" : "clinical-reminder",
      "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.display">display</a>" : "Clinical Reminder"
    }
  }
}</code></pre>{% endraw %}

As much as technically possible, links provided **SHOULD** be 'deep' links that take the user to the specific place in the documentation relevant to the current hook context to minimize provider reading and navigation time.

### Instructions Response Type
<div class="modified-content" markdown="1">
This response type presents a card with textual guidance to display to the user making the decisions. The text might provide clinical guidelines, suggested changes, or rules around prior authorization. It can be generated in a more sophisticated context for the payer, while remaining easy to consume for the provider because it allows returned information to be tuned to the specific context of the order/encounter that triggered the hook. In some cases, the text returned might be generated uniquely each time a hook is fired. CRD services **SHALL NOT** use these cards to direct users to a portal for the purpose of initiating prior authorization or determining coverage. Use the [Coverage Information](#coverage-information-response-type) response instead.
</div>

This example CDS Hook [card](https://cds-hooks.hl7.org/2.0/#cds-service-response) just contains a message:

<!-- fragment Binary/CRDServiceResponse JSON BASE:cards.where(source.topic.where(code='clinical-reminder').exists()) -->
{% raw %}
<pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.summary">summary</a>" : "Patient is overdue for a PAP smear",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.detail">detail</a>" : "Last date on record for a PAP test for this patient was May, 2014. Tests should ideally be performed every 1-3 years",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.indicator">indicator</a>" : "info",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source">source</a>" : {
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source.label">label</a>" : "You're Covered Insurance",
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source.url">url</a>" : "https://example.com",
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source.icon">icon</a>" : "https://example.com/img/icon-100px.png",
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source.topic">topic</a>" : {
      "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.system">system</a>" : "http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp",
      "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.code">code</a>" : "clinical-reminder",
      "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.display">display</a>" : "Clinical Reminder"
    }
  }
}</code></pre>
{% endraw %}

### Coverage Information Response Type
<div class="modified-content" markdown="1">
This response type uses a <a href="https://cds-hooks.hl7.org/2.0/#system-action">systemAction</a> to automatically update the order or other resource in the CRD client with an extension that conveys information related to the coverage of the order. This response type **SHALL NOT** use a card.

Support expectations for this hook by CDS services are as follows:

1. Payers **SHALL** support supplying coverage information for all primary hooks: order-sign, order-dispatch, and appointment-book.
2. Payers **MAY** support supplying coverage information for all other hooks.
3. Payers **SHALL** supply coverage information for all hooks where they support it unless the EHR sends a configuration option asking them not to.
4. If coverage information is evaluated, a system action **SHALL** be returned for each in-scope request resource unless that request resource already has a coverage-information extension and the payer has no new information to add.
</div>

A new FHIR [coverage-information](StructureDefinition-ext-coverage-information.html) extension is defined that allows assertions around coverage and prior authorization to also be captured computably, including what assertion is made, what coverage the assertion is made with respect to, when the assertion was made, and - optionally - a trace ID that can be used for audit purposes.

Assertions about coverage, prior authorization requirements, etc. are contingent on the eventual claim for the ordered service being aligned with payer expectations. Because the order/appointment/etc. will not have the same information that would typically be included in a formal request for prior authorization or pre-determination, the payer will need to infer from the order what billing codes, qualifiers, dollar amounts, etc. would typically be involved. In some cases, the answer might differ depending on factors such as in/out of network, when the service is delivered, etc. These qualifiers around when the coverage assertion is considered valid **SHALL** be included as part of the annotation.

If a CRD service has provided limitations about when a coverage assertion applies that turn out to not be consistent with what the provider intends to do (e.g., payer says "covered if billed as X", but provider intends to bill as Y), then the provider can always use the normal prior authorization process to solicit an authorization that more precisely aligns with their expectations for how the service will eventually be billed.

If a CRD client submits a claim related to an order for which it has received a coverage-information extension for the coverage type associated with the claim, that claim **SHALL** include the `coverage-assertion-id` and, if applicable, the `satisfied-pa-id` in the X12 837 K3 segment. Further details about the specific location of eac element will be available in the X12 specifications. These identifiers will provide the necessary context to allow the payer to respect any commitments made as part of the CRD call and also to link together CRD results and eventual claims for analytics purposes.

In some cases, multiple *coverage-information* extension repetitions may be added by the CRD service. This might represent different guidance for different coverages the service supports for the same patient or different expectations (related to coverage, prior auth, or additional information) for different billing codes, different qualifiers (e.g., in-network vs out-of-network), etc. If multiple extension repetitions are present, all repetitions referencing differing insurance (coverage-information.coverage) **SHALL** have distinct coverage-assertion-ids and satisfied-pa-ids, if present. Where multiple repetions apply to the same coverage, they **SHALL** have the same coverage-assertion-ids and satisfied-pa-ids (if present). It is possible that some repetions for a coverage might have satisfied prior authorization with an ID, while others will not.

Systems **MAY** make calls related to orders even if there is already a coverage assertion recorded on the order. There is always the possibility that context has changed or new information available in the order will result in a new decision or additional guidance. The payer might also have other useful information not related to coverage or authorization. Information about the order or context might change between an initial `order-select` or `order-sign` and a subsequent `order-dispatch` or other hook invocation.

However, payers **SHALL NOT** send a system action to update the order unless something is new. Payers **SHOULD** take into account the previous decision in deciding how much processing is necessary before returning a response.

<div class="modified-content" markdown="1">
If a *coverage-information* extension indicates the need to collect additional information (via 'doc-needed'), the extension **SHOULD** include a reference to the questionnaire(s) to be completed. Where questionnaires are specified, this indicates that the payer supports <a href="http://hl7.org/fhir/us/davinci-dtr">Da Vinci DTR</a> and the relevant information can be gathered using those questionnaires as specified in that guide.</div>

<div class="added-content" markdown="1">
When a *coverage-information* response type indicates that additional clinical documentation is needed and the CRD client supports DTR, CRD clients **SHALL** ensure that clinical users have an opportunity to launch their DTR solution as part of the current workflow. Where a *coverage-information* response indicates that additional administrative documentation is needed, CRD clients **SHOULD** allow clinical users to have an opportunity to launch their DTR solution, but **SHOULD** make it clear that the information to be captured is non-clinical.

NOTE: Launching DTR does not necessarily mean launching a SMART on FHIR application. Some CRD clients might incorporate DTR client functionality natively rather than using an app.</div>

If the payer does not support DTR for the type of information needed, the CRD service **MAY** provide a 'link' or 'information' card pointing to the forms or portal to use to capture the additional information. The link **SHOULD NOT** require user authentication (i.e., no log-on needed) when accessing downloadable forms. For portal links, it is preferred if a separate logon is not needed (e.g., with temporary/high-entropy links). Forms downloaded from provided links can then be submitted as part of the prior authorization (e.g., PAS), claim submission, etc. based on the identified documentation purpose.

While using portals or other non-questionnaire data capture is not recommended or preferred, it may be necessary as a transitional measure. Future versions of this IG are likely to mandate that questionnaires be included when additional information is required. This transitional accommodation is not intended to relax regulatory or legislative requirements that require the use of DTR.

When using this response type, the proposed order or appointment being updated **SHALL** comply with the following profiles:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td>
<div class="modified-content" markdown="1">
    <a href="StructureDefinition-profile-appointment-with-order.html">profile-appointment-with-order</a></td>
    <td/>
  </tr>
  <tr>
    <td><a href="StructureDefinition-profile-appointment-no-order.html">profile-appointment-no-order</a></td>
</div>
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

<!-- fragment Binary/CRDServiceResponse JSON BASE:systemActions ELLIDE:resource.children().where(is(Extension).not()) -->
{% raw %}
        <pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.type">type</a>" : "update",
  "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest">resource</a>" : {
    "<a href="http://hl7.org/fhir/R4/servicerequest.html">resourceType</a>" : "ServiceRequest",
    ...
    "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.extension">extension</a>" : [
      {
        "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.extension">extension</a>" : [
          {
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "coverage",
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.value[x]">valueReference</a>" : {
              "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.reference">reference</a>" : "http://example.org/fhir/Coverage/example"
            }
          },
          {
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "covered",
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.value[x]">valueCode</a>" : "covered"
          },
          {
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "pa-needed",
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.value[x]">valueCode</a>" : "satisfied"
          },
          {
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "billingCode",
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.value[x]">valueCoding</a>" : {
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.system">system</a>" : "http://www.ama-assn.org/go/cpt",
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.code">code</a>" : "77065"
            }
          },
          {
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "billingCode",
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.value[x]">valueCoding</a>" : {
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.system">system</a>" : "http://www.ama-assn.org/go/cpt",
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.code">code</a>" : "77066"
            }
          },
          {
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "billingCode",
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.value[x]">valueCoding</a>" : {
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.system">system</a>" : "http://www.ama-assn.org/go/cpt",
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.code">code</a>" : "77067"
            }
          },
          {
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "reason",
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.value[x]">valueCodeableConcept</a>" : {
              "<a href="http://hl7.org/fhir/R4/datatypes.html#CodeableConcept#CodeableConcept.text">text</a>" : "In-network required unless exigent circumstances"
            }
          },
          {
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.extension">extension</a>" : [
              {
                "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "code",
                "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.value[x]">valueCodeableConcept</a>" : {
                  "<a href="http://hl7.org/fhir/R4/datatypes.html#CodeableConcept#CodeableConcept.coding">coding</a>" : [
                    {
                      "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.system">system</a>" : "http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp",
                      "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.code">code</a>" : "auth-out-network-only"
                    }
                  ]
                }
              },
              {
                "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "value",
                "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.value[x]">valueBoolean</a>" : true
              },
              {
                "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "qualification",
                "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.value[x]">valueString</a>" : "Out-of-network prior auth does not apply if delivery occurs at a service site designated as 'remote'"
              }
            ],
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "detail"
          },
          {
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "dependency",
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.value[x]">valueReference</a>" : {
              "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.reference">reference</a>" : "http://example.org/fhir/ServiceRequest/example2"
            }
          },
          {
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "date",
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.value[x]">valueDate</a>" : "2019-02-15"
          },
          {
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "coverage-assertion-id",
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.value[x]">valueString</a>" : "12345ABC"
          },
          {
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "satisfied-pa-id",
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.value[x]">valueString</a>" : "Q8U119"
          },
          {
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "contact",
            "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.value[x]">valueContactPoint</a>" : {
              "<a href="http://hl7.org/fhir/R4/datatypes.html#ContactPoint#ContactPoint.system">system</a>" : "url",
              "<a href="http://hl7.org/fhir/R4/datatypes.html#ContactPoint#ContactPoint.value">value</a>" : "http://some-payer/xyz-sub-org/get-help-here.html"
            }
          }
        ],
        "<a href="http://hl7.org/fhir/R4/extensibility.html#Extension#Extension.url">url</a>" : "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/ext-coverage-information"
      }
    ],
    ...
  }
}</code></pre>
{% endraw %}

CRD clients and services **SHALL** support the new CDS Hooks system action functionality to cause annotations to automatically be stored on the relevant request, appointment, etc. without any user intervention. In this case, the discrete information propagated into the order extension **SHALL** be available to the user for viewing. However, this might be managed with icons, flyovers, or alternate mechanisms than traditional CDS Hook card rendering. The key consideration is that the user is aware that the information is available and can easily access it. Client implementations will be responsible for ensuring that the only changes made to the CRD client record are to add the annotations contemplated here. CRD clients **MAY** be configured to not execute system actions under some circumstances, for example if the order has been cancelled or abandoned.

The information added to the order here is often going to be relevant/important not only to the creator of the order, but also to its eventual performer. This guide does not define how information around coverage is conveyed from the ordering system to the performing system. However, the [Post-acute Orders implementation guide](http://hl7.org/fhir/us/dme-orders) does provide a mechanism for electronic sharing of orders and could be used to convey the additional notes or extensions envisioned here as well.

<div class="added-content" markdown="1">
Payers with existing tools that process prior authorization requests may have dependencies on data elements that are not found in the clinical orders being submitted as part of CRD such as service type or modifier codes. In these cases, payers **SHOULD** attempt to infer values for these elements based on elements that are present. For example 'service type' can often be inferred based on the nature of the service, the location, the performer, etc. In situations where the inferred element has an impact on the results, payers should document that as part of their 'coverage-information' extension. In situations where inference is not possible and an element must be known, the payer may indicate that formal prior authorization is necessary. This situation should be minimized as much as possible.</div>

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
    <td><a href="StructureDefinition-profile-encounter3.1.html">profile-encounter3.1<sup>†</sup> (US-Core 3.1.1)</a> or <a href="StructureDefinition-profile-encounter6.1.html">profile-encounter6.1<sup>†</sup> (US-Core 6.1.0)</a></td>
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

<!-- fragment Binary/CRDServiceResponse2 JSON BASE:cards.where(source.topic.where(code='therapy-alternatives-req').exists()).suggestions EXCEPT:id | medication BASE:actions.resource -->
{% raw %}
        <pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.label">label</a>" : "Change to lower price name brand (selected name brand not covered)",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions">actions</a>" : [
    {
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.type">type</a>" : "delete",
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.description">description</a>" : "Remove name-brand prescription",
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.resourceId">resourceId</a>" : [
        "MedicationRequest/2222"
      ]
    },
    {
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.type">type</a>" : "create",
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.description">description</a>" : "Add lower-cost alternative",
      "<a href="http://hl7.org/fhir/R4/medicationrequest.html#MedicationRequest">resource</a>" : {
        "<a href="http://hl7.org/fhir/R4/medicationrequest.html">resourceType</a>" : "MedicationRequest",
        ...
        "<a href="http://hl7.org/fhir/R4/medicationrequest.html#MedicationRequest.medication[x]">medicationCodeableConcept</a>" : {
          "<a href="http://hl7.org/fhir/R4/datatypes.html#CodeableConcept#CodeableConcept.coding">coding</a>" : [
            {
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.system">system</a>" : "http://www.nlm.nih.gov/research/umls/rxnorm",
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.code">code</a>" : "1790533",
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.display">display</a>" : "Abuse-Deterrent 12 HR oxycodone 9 MG Extended Release Oral Capsule [Xtampza]"
            }
          ]
        },
        ...
      }
    }
  ]
}</code></pre>
{% endraw %}

### Identify Additional Orders Response Type
This response type can be used to present a card that recommends the introduction of additional orders as companions or prerequisites for the current order. For example, the payer might recommend that certain lab tests be ordered along with a medication that is known to affect liver function. This will normally involve additional 'create' actions. The fact there is no 'delete' for the original order conveys that these are supplemental actions rather than replacement actions. As with the [Propose Alternate Request](#propose-alternate-request-response-type) response type, in some cases multiple resources will need to be created to convey the full suggestion such as 'medication', 'device', etc.

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

<!-- fragment Binary/CRDServiceResponse2 JSON BASE:cards.where(source.topic.where(code='clinical-reminder').exists()).suggestions -->
{% raw %}
<pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.label">label</a>" : "Add monthly AST test for 1st 3 months",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions">actions</a>" : [
    {
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.type">type</a>" : "create",
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.description">description</a>" : "Add order for AST test",
      "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest">resource</a>" : {
        "<a href="http://hl7.org/fhir/R4/servicerequest.html">resourceType</a>" : "ServiceRequest",
        "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.status">status</a>" : "draft",
        "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.intent">intent</a>" : "original-order",
        "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.category">category</a>" : [
          {
            "<a href="http://hl7.org/fhir/R4/datatypes.html#CodeableConcept#CodeableConcept.coding">coding</a>" : [
              {
                "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.system">system</a>" : "http://snomed.info/sct",
                "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.code">code</a>" : "108252007",
                "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.display">display</a>" : "Laboratory procedure"
              }
            ]
          }
        ],
        "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.code">code</a>" : {
          "<a href="http://hl7.org/fhir/R4/datatypes.html#CodeableConcept#CodeableConcept.coding">coding</a>" : [
            {
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.system">system</a>" : "http://www.ama-assn.org/go/cpt",
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.code">code</a>" : "80076",
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.display">display</a>" : "Hepatic function panel"
            }
          ]
        },
        "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.subject">subject</a>" : {
          "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.reference">reference</a>" : "http://example.org/fhir/Patient/123",
          "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.display">display</a>" : "Jane Smith"
        },
        "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.encounter">encounter</a>" : {
          "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.reference">reference</a>" : "http://example.org/fhir/Encounter/ABC"
        },
        "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.occurrence[x]">occurrenceTiming</a>" : {
          "<a href="http://hl7.org/fhir/R4/datatypes.html#Timing#Timing.repeat">repeat</a>" : {
            "<a href="http://hl7.org/fhir/R4/datatypes.html#Timing#Timing.repeat.bounds[x]">boundsDuration</a>" : {
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Duration#Duration.value">value</a>" : 3,
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Duration#Duration.unit">unit</a>" : "months",
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Duration#Duration.system">system</a>" : "http://unitsofmeasure.org",
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Duration#Duration.code">code</a>" : "mo"
            },
            "<a href="http://hl7.org/fhir/R4/datatypes.html#Timing#Timing.repeat.frequency">frequency</a>" : 1,
            "<a href="http://hl7.org/fhir/R4/datatypes.html#Timing#Timing.repeat.period">period</a>" : 1,
            "<a href="http://hl7.org/fhir/R4/datatypes.html#Timing#Timing.repeat.periodUnit">periodUnit</a>" : "mo"
          }
        },
        "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.authoredOn">authoredOn</a>" : "2019-02-15",
        "<a href="http://hl7.org/fhir/R4/servicerequest.html#ServiceRequest.requester">requester</a>" : {
          "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.reference">reference</a>" : "http://example.org/fhir/PractitionerRole/987",
          "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.display">display</a>" : "Dr. Jones"
        }
      }
    }
  ]
}</code></pre>
{% endraw %}

### Request Form Completion Response Type
<div class="modified-content" markdown="1">
NOTE: DTR is the preferred solution where forms are needed for capture of information for payer purposes including, but not limited to, prior authorization, claims submission, or audit because of its ability to minimize data entry burden. This response type **SHOULD** only be used when DTR is not available or applicable.

This response type can be used to present a card that indicates that there are forms that need to be completed. The indicated forms might indicate additional documentation that must be submitted for prior authorization, attachments for claims submission, documentation that must be completed and retained as proof that clinical need protocols have been followed, or that must otherwise be retained and available for future audits. While forms can also be expressed as static or active PDFs referenced by [External References](#external-reference-response-type), or within a [SMART Application](#launch-smart-application-response-type), this response type provides the form definition as a FHIR Questionnaire and creates a Task within the CRD client allowing the completion of the form to be appropriately scheduled and/or delegated. Alternatively, the provider could choose to execute the task and fill out the form immediately if that makes more sense from a clinical workflow perspective.
</div>

This suggestion will always include a create action for the Task. The Task will point to the Questionnaire to be completed using a `Task.input` element with a `Task.input.type` of "questionnaire" and the canonical URL for the questionnaire in `Task.input.valueCanonical`. Additional `Task.input` elements will provide information about how the completed questionnaire is to be submitted to the payer with a service endpoint if required. The `Task.code` will always include the CRD-specific `complete-questionnaire` code. The reason for completion will be conveyed in `Task.reasonCode`. The Questionnaire might also be included with a separate conditional create action or it might be excluded with the presumption it will already be available or retrievable by the client via its canonical URL, either from the original source or from a local registry.

Instead of using a card, CRD services **MAY** opt to use a <a href="https://cds-hooks.hl7.org/2.0/#system-action">systemAction</a> instead. CRD clients supporting this response type **SHALL** support either approach.

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

The following is an example CDS Hook [Suggestion](https://cds-hooks.hl7.org/2.0/#suggestion), where the specified questionnaire is either expected to be available within the CRD client or available for retrieval through its canonical URL. As such, the [Action](https://cds-hooks.hl7.org/2.0/#action) only contains the FHIR [Task]({{site.data.fhir.path}}task.html) resource. An example showing inclusion of both the Task and the referenced Questionnaire can be found [above](deviations.html#if-none-exist).

<!-- fragment Binary/CRDServiceResponse2 JSON BASE:cards.where(source.topic.where(code='123').exists()).suggestions EXCEPT:url BASE:actions.where(resource is Questionnaire).resource -->
{% raw %}
<pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.label">label</a>" : "Add 'completion of the ABC form' to your task list (possibly for reassignment)",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions">actions</a>" : [
    {
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.type">type</a>" : "create",
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.description">description</a>" : "Add version 2 of the XYZ form to the clinical system's repository (if it doesn't already exist)",
      "<a href="http://hl7.org/fhir/R4/questionnaire.html#Questionnaire">resource</a>" : {
        "<a href="http://hl7.org/fhir/R4/questionnaire.html">resourceType</a>" : "Questionnaire",
        "<a href="http://hl7.org/fhir/R4/questionnaire.html#Questionnaire.url">url</a>" : "http://example.org/Questionnaire/XYZ",
        ...
      }
    },
    {
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.type">type</a>" : "create",
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.description">description</a>" : "Add 'Complete ABC form' to the task list",
      "<a href="http://hl7.org/fhir/R4/task.html#Task">resource</a>" : {
        "<a href="http://hl7.org/fhir/R4/task.html">resourceType</a>" : "Task",
        "<a href="http://hl7.org/fhir/R4/task.html#Task.basedOn">basedOn</a>" : [
          {
            "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.reference">reference</a>" : "http://example.org/fhir/Appointment/27"
          }
        ],
        "<a href="http://hl7.org/fhir/R4/task.html#Task.status">status</a>" : "ready",
        "<a href="http://hl7.org/fhir/R4/task.html#Task.intent">intent</a>" : "order",
        "<a href="http://hl7.org/fhir/R4/task.html#Task.code">code</a>" : {
          "<a href="http://hl7.org/fhir/R4/datatypes.html#CodeableConcept#CodeableConcept.coding">coding</a>" : [
            {
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.system">system</a>" : "http://hl7.org/fhir/uv/sdc/CodeSystem/temp",
              "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.code">code</a>" : "complete-questionnaire"
            }
          ]
        },
        "<a href="http://hl7.org/fhir/R4/task.html#Task.description">description</a>" : "Complete XYZ form for local retention",
        "<a href="http://hl7.org/fhir/R4/task.html#Task.for">for</a>" : {
          "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.reference">reference</a>" : "http://example.org/fhir/Patient/123"
        },
        "<a href="http://hl7.org/fhir/R4/task.html#Task.authoredOn">authoredOn</a>" : "2018-08-09",
        "<a href="http://hl7.org/fhir/R4/task.html#Task.input">input</a>" : [
          {
            "<a href="http://hl7.org/fhir/R4/task.html#Task.input.type">type</a>" : {
              "<a href="http://hl7.org/fhir/R4/datatypes.html#CodeableConcept#CodeableConcept.text">text</a>" : "questionnaire"
            },
            "<a href="http://hl7.org/fhir/R4/task.html#Task.input.value[x]">valueCanonical</a>" : "http://example.org/Questionnaire/XYZ|2"
          },
          {
            "<a href="http://hl7.org/fhir/R4/task.html#Task.input.type">type</a>" : {
              "<a href="http://hl7.org/fhir/R4/datatypes.html#CodeableConcept#CodeableConcept.text">text</a>" : "afterCompletion"
            },
            "<a href="http://hl7.org/fhir/R4/task.html#Task.input.value[x]">valueCodeableConcept</a>" : {
              "<a href="http://hl7.org/fhir/R4/datatypes.html#CodeableConcept#CodeableConcept.coding">coding</a>" : [
                {
                  "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.system">system</a>" : "http://example.org/fhir/CodeSystem/SomeCodes",
                  "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.code">code</a>" : "987",
                  "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.display">display</a>" : "Local Use"
                }
              ]
            }
          }
        ]
      }
    }
  ]
}</code></pre>
{% endraw %}

### Create or Update Coverage Records Response Type
This response type is used when the CRD service is aware of additional coverage that is relevant to the current/proposed activity or has updates or corrections to make to the information held by the CRD client. For example, the CRD client might be aware that a patient has coverage with a provider, but not know the plan number, member identifier, or other relevant information. This response allows the CRD service to convey that information to the CRD client and link it to the current/proposed action. In theory, this type of response could also be used to convey corrected/additional prior authorization information the payer was aware of, however that functionality is out of scope for this release of the implementation guide.

Instead of using a card, CRD services **MAY** opt to use a <a href="https://cds-hooks.hl7.org/2.0/#system-action">systemAction</a> instead. CRD clients supporting this response type **SHALL** support either approach. If receiving a system action, a CRD client **MAY** opt to place the new or updated record in a holding area for human review rather than directly modifying their source of truth.

NOTE: This functionality is somewhat redundant with the capabilities of the X12 270/271 transactions. This CRD capability **SHALL NOT** be used in situations where regulation dictates the use of the X12 functionality.

This response will contain a single suggestion. The primary action will either be a suggestion to update an existing coverage instance (if the CRD client already has one) or to create a new coverage instance if the CRD service is aware of coverage that the CRD client is not. In addition, the suggestion could include updates on all relevant request resources to add or remove links to coverage instances, reflecting which coverages are relevant to which types of requests.

For example, this CDS Hook [card](https://cds-hooks.hl7.org/2.0/#cds-service-response) includes a single [suggestion](https://cds-hooks.hl7.org/2.0/#suggestion) with an [action](https://cds-hooks.hl7.org/2.0/#action) to update the [Coverage]({{site.data.fhir.path}}coverage.html).

<!-- fragment Binary/CRDServiceResponse2 JSON BASE:cards.where(source.topic.where(code='insurance').exists()).suggestions -->
{% raw %}
<pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.label">label</a>" : "Update coverage information to be current",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.uuid">uuid</a>" : "urn:uuid:1207df9d-9ff6-4042-985b-b8dec21038c2",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions">actions</a>" : [
    {
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.type">type</a>" : "update",
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.suggestions.actions.description">description</a>" : "Update current coverage record",
      "<a href="http://hl7.org/fhir/R4/coverage.html#Coverage">resource</a>" : {
        "<a href="http://hl7.org/fhir/R4/coverage.html">resourceType</a>" : "Coverage",
        "<a href="http://hl7.org/fhir/R4/coverage.html#Coverage.id">id</a>" : "1234",
        "<a href="http://hl7.org/fhir/R4/coverage.html#Coverage.status">status</a>" : "active",
        "<a href="http://hl7.org/fhir/R4/coverage.html#Coverage.subscriberId">subscriberId</a>" : "192837",
        "<a href="http://hl7.org/fhir/R4/coverage.html#Coverage.beneficiary">beneficiary</a>" : {
          "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.reference">reference</a>" : "http://example.org/fhir/Patient/123"
        },
        "<a href="http://hl7.org/fhir/R4/coverage.html#Coverage.period">period</a>" : {
          "<a href="http://hl7.org/fhir/R4/datatypes.html#Period#Period.start">start</a>" : "2023-01-01",
          "<a href="http://hl7.org/fhir/R4/datatypes.html#Period#Period.end">end</a>" : "2023-11-30"
        },
        "<a href="http://hl7.org/fhir/R4/coverage.html#Coverage.payor">payor</a>" : [
          {
            "<a href="http://hl7.org/fhir/R4/references.html#Reference#Reference.reference">reference</a>" : "http://example.org/fhir/Organization/ABC"
          }
        ],
        "<a href="http://hl7.org/fhir/R4/coverage.html#Coverage.class">class</a>" : [
          {
            "<a href="http://hl7.org/fhir/R4/coverage.html#Coverage.class.type">type</a>" : {
              "<a href="http://hl7.org/fhir/R4/datatypes.html#CodeableConcept#CodeableConcept.coding">coding</a>" : [
                {
                  "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.system">system</a>" : "http://terminology.hl7.org/CodeSystem/coverage-class",
                  "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.code">code</a>" : "group"
                }
              ]
            },
            "<a href="http://hl7.org/fhir/R4/coverage.html#Coverage.class.value">value</a>" : "A1"
          }
        ]
      }
    }
  ]
}</code></pre>
{% endraw %}


<div class="modified-content" markdown="1">
If returning a card rather than a system action, this card type **SHOULD NOT** be returned for hook types that are likely to be triggered by clinical users rather than administrative staff. Cards of this type would be appropriate for hooks such as encounter-start or appointment-book, but would not be appropriate for order-select or order-sign.</div>

### Launch SMART Application Response Type
SMART apps allow more sophisticated interaction between payers and providers. They provide full control over user interface, workflow, etc. With permission, they can also access patient clinical data to help guide the interactive experience and minimize data entry. Apps can provide a wide variety of functions, including eligibility checking, guiding users through form entry, providing education, etc.

All such apps will need to go through the approval processes for the client's provider organization and typically also the associated software vendor. This response type can cause the launching of such apps to occur in the context in which they are relevant to patient care and/or to payment-related decision making.

This response type is just a modified version of the [External Reference](#external-reference-response-type) response type. However, the `Link.type` will be "smart" instead of "absolute". The `Link.appContext` will typically also be present. 

NOTE: This mechanism is no longer to be used for launching [DTR applications](http://hl7.org/fhir/us/davinci-dtr). That process is now handled entirely through the [Coverage Information](#coverage-information-response-type) response type above. It can still be used for launching other types of SMART apps not focused on gathering data for payer use with questionnaires.

For example, this [card](https://cds-hooks.hl7.org/2.0/#cds-service-response) contains a SMART app [link](https://cds-hooks.hl7.org/2.0/#link) to perform an opioid assessment:

<!-- fragment Binary/CRDServiceResponse2 JSON BASE:cards.where(source.topic.where(code='guideline').exists()) -->
{% raw %}
<pre class="json" style="white-space: pre; text-wrap: nowrap; width: auto;"><code class="language-json" style="white-space: pre; text-wrap: nowrap;">{
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.uuid">uuid</a>" : "urn:uuid:353cd963-2ecd-46f9-958b-ed7d2bbf6e01",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.summary">summary</a>" : "Launch opioid XYZ-assessment",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.indicator">indicator</a>" : "info",
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source">source</a>" : {
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source.label">label</a>" : "Some Payer",
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source.url">url</a>" : "https://example.com",
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source.icon">icon</a>" : "https://example.com/img/icon-100px.png",
    "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.source.topic">topic</a>" : {
      "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.system">system</a>" : "http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp",
      "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.code">code</a>" : "guideline",
      "<a href="http://hl7.org/fhir/R4/datatypes.html#Coding#Coding.display">display</a>" : "Guideline"
    }
  },
  "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.links">links</a>" : [
    {
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.links.label">label</a>" : "Opioid XYZ-assessment",
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.links.url">url</a>" : "https://example.org/opioid-assessment",
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.links.type">type</a>" : "smart",
      "<a href="https://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-CDSHooksResponse.html#CDSHooksResponse.cards.links.appContext">appContext</a>" : "{\&quot;payerXYZQNum\&quot;:\&quot;205f471f-f408-45d4-9213-0eedf95f417f\&quot;}"
    }
  ]
}</code></pre>
{% endraw %}
