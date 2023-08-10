[Cards](https://cds-hooks.hl7.org/2.0/#cds-service-response) are the mechanism used to return coverage requirements from the CRD Server to the CRD Client.

In addition to the [guidance provided in the CDS Hooks specification](https://cds-hooks.hl7.org/2.0/#card-attributes), the following additional guidance applies to CRD Servers when constructing cards:

*  The `Card.indicator` **SHOULD** be populated from the perspective of the clinical decision maker, not the payer.  While failure to procure a prior authorization might be 'critical' from the perspective of payment, it would be - at best - a 'warning' from the perspective of clinical care.  'critical' must be reserved for reporting life or death or serious clinical outcomes.  Issues where the proposed course of action will negatively affect the ability of the payer or patient to be reimbursed would generally be a 'warning'.  Most Coverage Requirements **SHOULD** be marked as 'info'.

*  The `Card.source` **SHOULD** be populated with an insurer name that the user and patient would recognize (i.e. the responsible insurer on the patient's insurance card), including in situations where coverage recommendations are being returned by a benefits manager or intermediary operating the CRD Server on behalf of the payer.  If an insurer is providing recommendations from another authority (e.g. a clinical society), the society's name and logo might be displayed, though usually only with the permission of that organization.

*  `Card.source.topic` **SHALL** be populated, and has an [extensible](http://www.hl7.org/fhir/terminologies.html#extensible) binding to the ValueSet <a href="ValueSet-cardType.html">CRD Card Types.</a> The rationale is to allow CRD clients to potentially filter or track the usage of different types of cards.

*  Users are busy.  Time spent reading a payer-returned card is inevitably time not spent reviewing other information or interacting with the patient.  If not useful or relevant, users will quickly learn to ignore - or even demand the disabling of - payer-provided alerts.  Therefore, information must be delivered efficiently and be tuned to provide maximum relevance.  Specifically:

    *  `Card.summary` **SHOULD** provide actionable information.  "Coverage alert" would not be very helpful. "Drug not covered.  Covered alternatives available" or "Prior authorization required" would be better.

    *  `Card.detail` and/or external links **SHOULD** only be provided when coverage recommendations can't be clearly provided in the 140-character limit of `Card.summary`.

    *  `Card.detail` **SHOULD** provide graduated information, with critical information being provided in the first paragraph and less critical information towards the end of the page.

    *  `Card.detail` **SHOULD** provide enough context that a user can determine whether it is worth the precious seconds to launch an app or external link or not - ideally providing a sense of where to look for and how to use whatever link or app they do launch in the specific context of the order they're making at the time.

    *  Keep the number of cards manageable.  Consider whether user workflow will be faster with separate cards for each link or a single card having multiple links.  Typically, using the smallest number of cards that still support descriptive actionable summaries is best.

    *  When providing links, don't send the user to the first page of an 80+ page PDF.  Keep document size short and/or provide linking directly to the section that is relevant for the context.

    *  While links are permitted in the markdown content of `Card.detail`, support for this is not universal, so links **SHOULD** also be provided in `Card.link`.  This also provides a consistent place for users to access all relevant links.

* CRD Client systems might not support all card capabilities, therefore card options **SHOULD** provide sufficient information for a user to perform record changes manually if automated support isn't possible.

<div markdown="1" class="new-content">

* Where <a href="https://cds-hooks.hl7.org/2.0/#system-action">systemActions</a> are used, CRD Servers **SHOULD NOT** return equivalent information in a card for user display.  It is the responsibility of the CRD Client to determine how best to present the results of the newly created or revised records.

<p>
The card.source.topic element above is new.
</p>
</div>

### Potential CRD Response Types
This section describes the different types of [responses](https://cds-hooks.hl7.org/2.0/#cds-service-response) that CRD Servers can use when returning coverage requirements to CRD Clients, including CRD-specific profiles on cards to describe CRD-expected behavior.  It is possible that some CRD Servers and CRD Clients will support additional card response patterns than those listed here, but such behavior is outside the scope of this specification.  Future versions of this specification might standardize additional response types.

Of the response types in this guide, conformant CRD Clients **SHALL** support the [External Reference](#external-reference), [Instructions](#instructions), and  [Coverage Information](#coverage-information) responses and **SHOULD** support the remaining types.

CRD Servers **SHALL**, at minimum, demonstrate an ability to return cards with the following type: [Coverage](#coverage-information), [External Reference](#external-reference) and [Instructions](#instructions) card types (card type code `documentation`).

NOTE: Support for a card type does not mean that all orders/appointments/etc. will necessarily receive card guidance, merely that it must be able to return those card types for at least a subset of CRD invocations

Provision of and acceptance of decision support cards outside the coverage and documentation requirements space is optional (for both server and client).  CRD Servers that provide decision support for non-coverage/documentation areas **SHALL** check that the CRD client does not have the information within its store that would allow it to detect the issue itself.  If the information already exists in the CRD client, then the obligation is on the CRD Client to manage the issue detection and reporting in its own manner and CRD Servers should not get involved.

Response types are listed from least sophisticated to most sophisticated - and potentially more useful/powerful.  As a rule, the more a card can automate manual processes and the more context-specific the behavior is, the more useful the decision support will be to the clinician and the more likely it will be used.

Notes:
* CRD Clients will provide resources, such as MedicationRequest, in the CDS Hook request context object. These resources might be temporary in the context in which the CDS Hook is triggered, such as when a proposed medication order is being reviewed. In this case, the CDS Client must maintain a stable identifier for these temporary resources to allow CRD responses to refer to them in CDS Hook Actions.

* Hook responses will frequently contain multiple cards and those cards might draw from a variety of response types.  For example, providing links, textual guidance, as well as suggestions for alternative orders.

* The response types listed here are *not* the same as the [Configuration Options](deviations.html#configuration-options-extension) specified above.  A single response type could correspond to multiple configuration options.  For example, [External Reference](#external-reference) could apply to clinical practice guidelines, prior authorization requirements, claims attachment requirements, and other things.  Similarly, one configuration option could be satisfied with multiple response types.  For example, required Prior Authorization Forms could include both [External References](#external-reference) and explicit [Request Form Completion](#request-form-completion) responses.

<div markdown="1" class="new-content">

* Where a Coverage Information card type indicating that additional clinical documentation is needed and the CRD client supports DTR, CRD Clients **SHALL** ensure that clinical users have an opportunity to launch the DTR app as part of the current workflow.  Where a Coverage Information indicates that additional administrative documentation is needed, CRD Clients **SHOULD** allow clinical users to have an opportunity to launch the DTR app, but should make it clear that the information to be captured is non-clinical.

* Launching DTR does not necessarily mean launching a SMART on FHIR application.  Some CRD clients might incorporate DTR client functionality natively rather than using an app.

</div>


### External Reference
This response type presents a Card with one or more links to external web pages, PDFs, or other resources that provide relevant coverage information.  The links might provide clinical guidelines, prior authorization requirements, printable forms, etc. Typically, these references would be links to information available from the payer's website, though pointers to other authoritative sources are possible too.  The card **SHALL** have at least one `Card.link`.  The `Link.type` **SHALL** have a type of "absolute".

When reasonable, an "External Reference" card **SHOULD** contain a summary of the actionable information from the external reference.

For example, this CDS Hooks [Card](https://cds-hooks.hl7.org/2.0/#cds-service-response) contains two [Links](https://cds-hooks.hl7.org/2.0/#link) - a standard and a printer-friendly version.

{% raw %}
```
{
  "summary": "CMS Home Oxygen Therapy Coverage Requirements",
  "indicator": "info",
  "detail": "Learn about covered oxygen items and equipment for home use; coverage requirements; criteria you must meet to furnish oxygen items and equipment for home use; Advance Beneficiary Notice of Noncoverage; oxygen equipment, items, and services that are not covered; and payments for oxygen items and equipment and billing and coding guidelines.",
  "source": {
    "label": "Centers for Medicare & Medicaid Services",
    "url": "https://cms.gov",
    "topic": {
      "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp",
      "code": "coverage",
      "display": "Coverage"
    }
  },
  "links": [
    {
      "label": "Home Oxygen Therapy Guidelines",
      "url": "https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/Home-Oxygen-Therapy-ICN908804.pdf",
      "type": "absolute"
    }, {
      "label": "Home Oxygen Therapy Guidelines (printer-friendly)",
      "url": "https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/Home-Oxygen-Therapy-Text-Only.pdf",
      "type": "absolute"
    }
  ]
}
```
{% endraw %}

<div markdown="1" class="new-content">

As much as technically possible, links provided **SHOULD** be 'deep' links that take the user to the specific place in the documentation relevant to the current hook context to minimize provider reading and navigation time.

</div>

### Instructions
This response type presents a `Card` with textual guidance to display to the user making the decisions. The text might provide clinical guidelines, suggested changes, rules around prior authorization, or even something as simple as "No special coverage requirements". It can be generated in a more sophisticated context for the payer, while remaining simple to consume for the provider because it more easily allows returned information to be tuned to the specific context of the order/encounter that triggered the hook. In some cases, the text returned might be generated uniquely each time a hook is fired.

This example CDS Hook [Card](https://cds-hooks.hl7.org/2.0/#cds-service-response) just contains a message:

{% raw %}
```
{
  "summary": "Prior authorization required",
  "indicator": "warning",
  "detail": "All prescriptions for _Drug X_ with a dose higher than 100mg/day require prior authorization.  Forms and instructions can be found [here](http://example.org/prior-auth.pdf).",
  "source": {
    "label": "You're Covered Insurance",
    "url": "https://example.com",
    "icon": "https://example.com/img/icon-100px.png",
    "topic": {
      "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp",
      "code": "auth-req",
      "display": "Prior Authorization Required?"
    }
  }
}
```
{% endraw %}

<div markdown="1" class="new-content">

### Coverage Information
This response type does not present a `Card`.  Instead, it uses a <a href="https://cds-hooks.hl7.org/2.0/#system-action">systemAction</a> to automatically update the order or other resource in the CRD Client with an extension that conveys information related to the coverage of the order.

A new FHIR [coverage-information](StructureDefinition-ext-coverage-information.html) extension is defined that allows assertions around coverage and prior authorization to also be captured computably, including what assertion is made, what coverage the assertion is made with respect to, when the assertion was made, and - optionally - a trace id that can be used for audit purposes.

Assertions about coverage, prior authorization requirements, etc. are of course contingent on the eventual claim for the ordered service being aligned with the payer expectations.  Because the order/appointment/etc. will not have the same information that would typically be included in a formal request for prior authorization or pre-determination, the payer will need to infer from the order what billing codes, qualifiers, dollar amounts, etc. would typically be involved.  In some cases, the answer might differ depending on factors such as in/out of network, when the service is delivered, etc.  These qualifiers around when the coverage assertion is considered valid **SHALL** be included as part of the annotation.

If a CRD service has provided limitations about when a coverage assertion applies that turn out to not be consistent with what the provider intends to do (e.g. payer says covered if billed as X, but provider intends to bill as Y), then the provider can always use the normal prior authorization process to solicit an authorization that more precisely aligns with their expectations for how the service will eventually be billed.

It is possible that more than one extension could be present, representing coverage information for different coverages for the same order.  It is also possible for multiple assertions to be present for the same coverage - for example the fact that prior authorization must be solicited by the performing provider, but that clinical and administrative DTR are also necessary.

Systems **MAY** fire calls related to orders even if there is already a coverage assertion recorded on the order.  There is always the possibility that context has changed or new information available in the order will result in a new decision or additional guidance. The payer may also have other useful information not related to coverage/authorization.  As well, information about the order or context might change between an initial `order-select` or `order-sign` and a subsequent `order-dispatch` or other hook invocation.

However, payers **SHALL NOT** send a system action to update the order unless something is new.  Payers **SHOULD** take into account the previous decision in deciding how much processing is necessary before returning a response.

When using this response type, the proposed order or appointment being updated **SHALL** comply with the following profiles:

<table class="grid">
  <thead>
    <tr>
      <th>CRD Profiles</th>
      <th>US Core Profiles</th>
    </tr>
  </thead>
  <tr>
    <td><a href="StructureDefinition-profile-appointment.html">profile-appointment</a></td>
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

```
{
  "systemActions": [{
    "type": "update",
    "resource": {
      "resourceType": "ServiceRequest",
      "id": "idfromcontext",
      "extension": [
        {
          "url": "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/ext-coverage-information"
          "extension": [
            {
              "url": "coverage",
              "valueReference": {
                "reference": "Coverage/example"
              }
            },
            {
              "url": "covered",
              "valueCode": "covered"
            },
            {
              "url": "pa-needed",
              "valueCode": "satisfied"
            },
            {
              "url": "billingCode",
              "valueCoding": {
                "system": "http://www.ama-assn.org/go/cpt",
                "code": "77065"
              }
            },
            {
              "url": "billingCode",
              "valueCoding": {
                "system": "http://www.ama-assn.org/go/cpt",
                "code": "77066"
              }
            },
            {
              "url": "billingCode",
              "valueCoding": {
                "system": "http://www.ama-assn.org/go/cpt",
                "code": "77067"
              }
            },
            {
              "url": "reason",
              "valueCodeableConcept": {
                "text": "In-network required unless exigent circumstances"
              }
            },
            {
              "url": "detail",
              "extension": [
                {
                  "url": "code",
                  "valueCodeableConcept": {
                    "coding": [{
                      "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp",
                      "code": "auth-out-network-only"
                    }]
                  }
                },
                {
                  "url": "value",
                  "valueBoolean": true
                },
                {
                  "url": "qualification",
                  "valueString": "Out-of-network prior auth does not apply if delivery occurs at a service site designated as 'remote'"
                }
              ]
            },
            {
              "url": "dependency",
              "valueReference": {
                "reference": "ServiceRequest/example2"
              }
            },
            {
              "url": "date",
              "valueDate": "2019-02-15"
            },
            {
              "url": "coverage-assertion-id",
              "valueString": "12345ABC"
            },
            {
              "url": "satisfied-pa-id",
              "valueString": "Q8U119"
            },
            {
              "url": "contact",
              "valueContactPoint": {
                "system": "url",
                "value": "http://some-payer/xyz-sub-org/get-help-here.html"
              }
            }
          ]
        } 
      ],
      "status": "draft",
      "intent": "original-order",
      "code": {
        "coding": [{
          "system": "http://snomed.info/sct",
          "code": "726551006",
          "display": "Contrast enhanced spectral mammography (Procedure)"
        }]
      },
      "subject": {
        "reference": "Patient/123",
        "display": "Jane Smith"
      },
      "encounter": {
        "reference": "Encounter/ABC"
      },
      "authoredOn": "2019-02-15",
      "requester": {
        "reference": "PractitionerRole/987",
        "display": "Dr. Jones"
      },
      "note": [
        {
          "authorString": "XYZ Insurance",
          "time": "2019-02-15T15:07:18-05:00",
          "text": "Prior authorization required for Contrast enhanced spectral mammography under coverage ABC.  (Determination 1234ABC made Feb 15, 2019)"
        }
      ]
    }
  }]
}
```
CRD clients and services **SHALL** support the new CDS Hooks system action functionality to cause annotations to automatically be stored on the relevant request, appointment, etc. without any user intervention. In this case, the discrete information propagated into the order extension **SHALL** be available to the user for viewing.  However, this might be managed with icons, flyovers or alternate mechanisms than traditional CDS Hook card rendering.  The key consideration is that the user is aware that the information is available and can easily get to it.  Client implementations will be responsible for ensuring that the only changes made to the CRD client record are to add the annotations contemplated here.  CRD clients **MAY** be configured to not execute system actions under some circumstances - e.g. if the order has been cancelled/abandoned.

The information added to the order here is often going to be relevant/important not only to the creator of the order, but also to its eventual performer.  This guide does not define how information around coverage is conveyed from the ordering system to the performing system.  However, the [Post-accute Orders implementation guide](http://hl7.org/fhir/us/dme-orders) does provide a mechanism for electronic sharing of orders and could be used to convey the additional notes/extensions envisioned here as well.
</div>

### Propose alternate request
This response type can be used by payers to present a `Card` with suggested alternatives to the current proposed therapy.  This might be updating the order to change certain information or proposing to replace the order completely with one or more alternatives.  This might be used to propose a change to a first-line treatment, to alter therapy frequency or drug dosage to be consistent with coverage guidelines, to propose covered products or services as substitutes for a non-covered service, and/or to propose therapeutically equivalent treatments that will have a lower cost to the patient.

Multiple alternatives can be proposed by providing multiple suggestions.  Each suggestion **SHOULD** contain either a single "update" action to revise the existing proposed order; or a "delete" action for the current proposed order and a "create" action for the new proposed order.  In some cases, additional "create" actions might be needed if there's a need to convey a non-[contained]({{site.data.fhir.path}}references.html#contained) Medication, Device, or other resource.  The "delete" action resource element is not expected to adhere to any profile, as it is only expected to contain the "id" property of the resource being replaced.  Any other elements will be ignored.

The choice of "update" vs. "delete + create" **SHOULD** be based on how significant the change is and how relevant other decision support on the original request will still be.  If cards returned by other service providers might still be relevant (e.g. because there was just a small change in dose or frequency), then performing an 'update' will allow updates from other decision support cards to also be applied.  If the change is significant enough that other decision support will not be relevant, a delete + create will allow the client to suppress decision support cards that no longer apply.

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
    <td><a href="{{site.data.fhir.ver.uscore}}/StructureDefinition-us-core-medication.html">us-core-medication</a></td>
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
<sup>†</sup> Only used if updating an Encounter (e.g. to add a note)

For example, this card proposes replacing the draft prescription for a brand-name drug (shown only as the 'resourceType' and 'id' from the `draftOrders` entry) and instead creating an equivalent prescription with a generic medication.

```
"suggestions": [{
  "label": "Change to generic (name brand not covered)",
  "actions": [{
    "type": "delete",
    "description": "Remove name-brand prescription",
    "resource": {
      "resourceType": "MedicationRequest",
      "id": "draftrx1"
    }
  }, {
    "type": "create",
    "description": "Add equivalent generic prescription",
    "resource": {
      "resourceType": "MedicationRequest",
      "status": "draft",
      "intent": "original-order",
      "medicationCodeableConcept": {
        "coding": [{
          "system": "http://www.nlm.nih.gov/research/umls/rxnorm",
          "code": "616447",
          "display": "Cellcept 250 MG Oral Capsule"
        }]
      },
      "subject": {
        "reference": "Patient/123",
        "display": "Jane Smith"
      },
      "encounter": {
        "reference": "Encounter/ABC"
      },
      "authoredOn": "2019-02-15",
      "requester": {
        "reference": "PractitionerRole/987",
        "display": "Dr. Jones"
      },
      "dosageInstruction": [{
        "text": "6 tablets every 12 hours.",
        "timing": {
          "repeat": {
            "frequency": 1,
            "period": 12,
            "periodUnit": "h"
          }
        },
        "doseAndRate": [{
          "doseQuantity": {
            "value": 6,
            "unit": "tablet"
          }
        }]
      }]
    }
  }]
}]
```


### Identify additional orders as companions/prerequisites for current order
This response type can be used to present a `Card` that recommends the introduction of additional orders. For example, the payer may recommend that certain lab tests be ordered along with a medication that is known to affect liver function.  This will normally involve additional "create" actions.  The fact there is no "delete" for the original order conveys that these are supplemental actions rather than replacement actions.  As with the [Propose Alternate Request](#propose-alternate-request) response type, in some cases multiple resources will need to be created to convey the full suggestion (e.g. Medication, Device, etc.)

When using this response type, the proposed orders (and any associated resources) **SHALL** comply with the following profiles:

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
    <td><a href="{{site.data.fhir.ver.uscore}}/StructureDefinition-us-core-medication.html">us-core-medication</a></td>
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

```
"suggestions": [{
  "label": "Add monthly AST test for 1st 3 months",
  "actions": [{
    "type": "create",
    "description": "Add order for AST test",
    "resource": {
      "resourceType": "ServiceRequest",
      "status": "draft",
      "intent": "original-order",
      "category": [{
        "coding": [{
          "system": "http://snomed.info/sct",
          "code": "108252007",
          "display": "Laboratory procedure"
        }]
      }],
      "code": {
        "coding": [{
          "system": "http://www.ama-assn.org/go/cpt",
          "code": "80076",
          "display": "Hepatic function panel"
        }]
      },
      "subject": {
        "reference": "Patient/123",
        "display": "Jane Smith"
      },
      "encounter": {
        "reference": "Encounter/ABC"
      },
      "occurrence": {
        "boundsDuration": {
          "value": 3,
          "unit": "months",
          "code": "mo",
          "system": "http://unitsofmeasure.org"
        },
        "frequency": 1,
        "period": 1,
        "periodUnit": "mo"
      },
      "authoredOn": "2019-02-15",
      "requester": {
        "reference": "PractitionerRole/987",
        "display": "Dr. Jones"
      }
    }
  }]
}]
```

### Request form completion
This response type can be used to present a `Card` that indicates that there are forms that need to be completed.  The indicated forms might contain documentation that must be submitted for prior authorization, attachments for claims submission, documentation that must be completed and retained as proof that clinical need protocols have been followed, or that must otherwise be retained and available for future audits.  While forms can also be expressed as static or active PDFs referenced by [External References](#external-reference), or within a [SMART Application](#launch-smart-application), this response type provides the form definition as a FHIR Questionnaire and creates a Task within the CRD client allowing the completion of the form to be appropriately scheduled and/or delegated.  Alternatively, the Practitioner could choose to execute the task and fill out the form immediately if that makes more sense from a clinical workflow perspective.

This suggestion will always include a "create" action for the Task.  The Task will point to the questionnaire to be completed using a `Task.input` element with a `Task.input.type.text` of "questionnaire" and the canonical URL for the questionnaire in `Task.input.valueCanonical`.  Additional `Task.input` elements will provide information about how the completed questionnaire is to be submitted to the payer with a service endpoint if required.  The `Task.code` will always include the CRD-specific `complete-questionnaire` code.  The reason for completion will be conveyed in `Task.reasonCode`.  The Questionnaire might also be included with a separate conditional "create" action or it might be excluded with the presumption it will already be available or retrievable by the client via its canonical URL, either from the original source or from a local registry.

<div markdown="1" class="new-content">

Instead of using a card, CRD services **MAY** opt to use a <a href="https://cds-hooks.hl7.org/2.0/#system-action">systemAction</a> instead.  CRD clients supporting this card type **SHALL** support either approach.

NOTE: DTR is the preferred solution where forms are needed for capture of information for payer purposes including, but not limited to, prior authorization, claims submission, or audit because of its ability to minimize data entry burden.  This card type **SHOULD** only be used when DTR is not available or applicable.

</div>

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

No profile is provided for the Questionnaires pointed to by the Task.  CRD Servers **SHOULD** use questionnaires that are compliant with either the [Argonaut Questionnaire profiles](https://github.com/argonautproject/questionnaire) (for forms to be completed within the CRD client) or the [Structured Data Capture profiles](http://hl7.org/fhir/uv/sdc/index.html) (for more sophisticated forms to be created within a SMART on FHIR app or through an external service).  

Note:
* Where CRD Servers use the Structured Data Capture profiles, they have the option of indicating an endpoint for submission of the questionnaire using Task.input or the SDC Questionnaire.endpoint extension to specify a service endpoint to submit completed questionnaires to a recipient.  If an endpoint is specified in both locations, both apply.
* CRD Clients **SHOULD** retain a copy of all completed forms for future reference.

The following is an example CDS Hook [Suggestion](https://cds-hooks.hl7.org/2.0/#suggestion), where the specified questionnaire is either expected to be available within the CRD Client or available for retrieval through its canonical URL.  As such, the [Action](https://cds-hooks.hl7.org/2.0/#action) only contains the FHIR [Task]({{site.data.fhir.path}}task.html) resource.  An example showing inclusion of both the Task and the referenced Questionnaire can be found [above](deviations.html#if-none-exist).

```
"suggestions": [{
  "label": "Add 'completion of the ABC form' to your task list (possibly for reassignment)",
  "actions": [{
    "type": "create",
    "description": "Add 'Complete ABC form' to the task list",
    "resource": {
      "resourceType": "Task",
      "basedOn": "Appointment/27",
      "status": "ready",
      "intent": "order",
      "code": {
        "coding": [{
          "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp",
          "code": "complete-questionnaire"
        }]
      },
      "description": "Complete XYZ form for inclusion in prior authorization",
      "for": {
        "reference": "Patient/some-patient-id"
      },
      "authoredOn": "2018-08-09",
      "reasonCode": {
        "coding": [{
          "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp",
          "code": "prior-auth-reason",
          "display": "Needed for prior authorization"
        }]
      },
      "input": [{
        "type": {
          "text": "questionnaire"
        },
        "valueCanonical": "http://example.org/Questionnaire/XYZ|2"
      },{
        "type": {
          "text": "afterCompletion"
        },
        "valueCodeableConcept": {
          "coding": [{
            "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp",
            "code": "prior-auth-include",
            "display": "Include in prior authorization"
          }]
        }
      }]
    }
  }]
}]
```


### Create or update coverage information
This response type is used when the CRD Server is aware of additional coverage that is relevant to the current/proposed activity or has updates/corrections to make to the information held by the CRD Client.  For example, the CRD Client might be aware that a patient has coverage with a provider, but not know the plan number, member identifier, or other relevant information.  This response allows the CRD Server to convey that information to the CRD Client and link it to the current/proposed action.  In theory, this type of response could also be used to convey corrected/additional prior authorization information the payer was aware of, however that functionality is out-of-scope for this release of the implementation guide.

<div markdown="1" class="new-content">

Instead of using a card, CRD services **MAY** opt to use a <a href="https://cds-hooks.hl7.org/2.0/#system-action">systemAction</a> instead.  CRD clients supporting this card type **SHALL** support either approach.  If receiving a system action, a CRD client **MAY** opt to place the new or updated record in a holding area for human review rather than directly modifying their source of truth.

NOTE: This functionality is somewhat redundant with the capabilities of the X12 270/271 transactions.  This CRD capability **SHALL NOT** be used in situations where regulation dictates the use of the X12 functionality.

</div>

This response will contain a single suggestion.  The primary action will either be a suggestion to "update" an existing Coverage instance (if the CRD Client already has one) or to "create" a new Coverage instance if the CRD Server is aware of Coverage that the CRD Client is not.  In addition, the suggestion could include updates on all relevant Request resources to add or remove links to Coverage instances, reflecting which Coverages are relevant to which types of requests.

For example, this CDS Hook [Card](https://cds-hooks.hl7.org/2.0/#cds-service-response) includes a single [Suggestion](https://cds-hooks.hl7.org/2.0/#suggestion) with two [Actions](https://cds-hooks.hl7.org/2.0/#action) - one is to update the [Coverage]({{site.data.fhir.path}}coverage.html) and the second is to update the draft order [MedicationRequest]({{site.data.fhir.path}}medicationrequest.html) to reference the existing Coverage.

```
{
  "summary": "Patient coverage information is incomplete",
  "indicator": "info",
  "source": {
    "label": "Some Payer",
    "url": "https://example.com",
    "icon": "https://example.com/img/icon-100px.png",
    "topic": {
      "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp",
      "code": "coverage",
      "display": "Coverage"
    }
  },
  "suggestions": [{
    "label": "Update coverage information to be current",
    "uuid": "1207df9d-9ff6-4042-985b-b8dec21038c2",
    "actions": [{
      "type": "update",
      "description": "Update current coverage record",
      "resource": {
        "resourceType": "Coverage",
        "id": "1234",
        "subscriberId": "192837",
        "class": {
          "type": "group",
          "value": "A1"
        }
      }
    }]
  }]
}
```

### Launch SMART application
SMART apps allow more sophisticated interaction between payers and providers.  They provide full control over user interface, workflow, etc.  With permission, they can also access patient clinical data to help guide the interactive experience and minimize data entry.  Apps can provide a wide variety of functions, including eligibility checking, guiding users through form entry, providing education, etc.

All such apps will need to go through the approval processes for the client's provider organization and typically, also the associated software vendor.  This response type can cause the launching of such apps to occur in the context in which they are relevant to patient care and/or to payment-related decision-making.

This response type is just a modified version of the [External Reference](#external-reference) response type.  However, the `Link.type` will be "smart" instead of "absolute".  The `Link.appContext` will typically also be present.  

<div markdown="1" class="modified-content">

NOTE: This mechanism is no longer to be used for launching [Documentation, Templates, and Rules (DTR) applications](http://hl7.org/fhir/us/davinci-dtr).  That process is now handled entirely through the [Coverage Information](#coverage-information) card type above.  It can still be used for launching other types of SMART apps not focused on gathering data for payer use via Questionnaire.

For example, this [Card](https://cds-hooks.hl7.org/2.0/#cds-service-response) contains a SMART App [Link](https://cds-hooks.hl7.org/2.0/#link) to perform an opioid assessment:

```
{
  "summary": "Launch opioid XYZ-assessment",
  "indicator": "info",
  "detail": "This is an example card.",
  "source": {
    "label": "Some Payer",
    "url": "https://example.com",
    "icon": "https://example.com/img/icon-100px.png",
    "topic": {
      "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp",
      "code": "coverage",
      "display": "Coverage"
    }
  },
  "links": [{
    "label": "Opioid XYZ-assessment",
    "url": "https://example.org/opioid-assessment",
    "type": "smart",
    "appContext": "{
        ...
    }"
  }]
}
```

</div>
