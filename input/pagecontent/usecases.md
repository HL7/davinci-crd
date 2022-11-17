### Business Need

Providers need to easily discover which payer covered services, medications (not covered by NCPDP) or devices have:
* Specific documentation requirements,
* Rules for determining the need for specific treatments/services,
* Requirements for Prior Authorization (PA) or other approvals, and
* Specific guidance.  


This implementation guide defines a FHIR based API that providers can use to discover, in real time, specific payer requirements that may affect whether services or devices provided to a patient are covered by their responsible payer.  The Coverage Requirement Discovery may be based on:
* Plan conditions only (i.e. without Protected Health Information - PHI), or also
* Plan member identification (PHI) and, potentially, clinical information needed to determine requirements.

When needed, the API will allow payers with authorization to query provider systems for additional patient information needed to inform the guidance provided - for example by determining what information already exists or what steps have already occurred.

The payer response to a CRD request might include:
* An indication that no coverage requirements exist
* A list of services, templates, documents, and/or rules that do apply
* A URI to retrieve specific items, such as templates or forms
* The ability to launch an application to further explore or complete requirements


### Example CRD "Success" Scenarios

#### Scenario 1
Mrs. Jones is a 35-year-old, previously healthy female who is seen by Dr. Good for a new onset headache that began abruptly 2 weeks prior to her visit.  Her headaches are severe at times, last several hours, have been occurring with increasing frequency, and are now occurring daily.  Her physical including neurologic exam is normal.  Dr. Good is concerned about an intracranial process.

Dr. Good wants to order a head CT to check for any masses but is unsure whether the service would be covered by Mrs. Jones' payer, and if so, whether special authorization or documentation will be required.  

Dr. Good launches an app within his Electronic Medical Record (EMR) and indicates that he wants to see coverage requirements for Mrs. Jones' plan for a 'head CT'.  The app sends a query to a CRD Server used by Mrs. Jones' payer asking for any requirements corresponding to her coverage.  The CRD service returns information within a few seconds identifying that a prior authorization request must be completed and submitted, as well as the additional clinical documentation required (Progress Note, prior studies, etc.).  It also provides a link to the required form.  Dr. Good completes the necessary paperwork to initiate a prior authorization and sends the relevant supporting information to the imaging center as part of the referral.

Note: An app may also provide Dr. Good with additional useful information, such as a list of nearby imaging centers that are on Mrs. Jones' plan.

#### Scenario 2
Mrs. Smith is a 75-year-old female on a Medicare Fee-For-Service plan with long standing chronic obstructive pulmonary disease (COPD) who has had slowly and progressively worsening shortness of breath with activity.  In the office, her room air saturation after a 5-minute walk is found to be 84%.  She has additional evaluation that reveals no new findings.  Dr. Good wants to initiate home oxygen therapy for Mrs. Smith.

As Dr. Good begins crafting the order in his EMR<sup>*</sup>, it uses Mrs. Smith's coverage information to initiate a querying to a CRD Server used by her payer that includes the code for home oxygen therapy.  An alert appears at the bottom of the EMR order entry screen notifying Dr. Good that specific testing and documentation is required to substantiate the need for home oxygen therapy.

Dr. Good retrieves specific documentation templates which have already been populated with information from his EMR.  He completes any remaining documentation requirements, signs the documentation, and includes it in Mrs. Smith's medical record.

<sup>*</sup> Note: This flow envisions the use of the Order Select hook, which allows guidance to be returned while the user is in the process of writing the order.  However, this is an optional hook, so for some systems, the flow of the use-case would be altered to have the clinician only receive guidance when they had completed the order and reached the 'signing' step.

#### Scenario 3
Mr. Light is a 45-year-old generally healthy male who presents for an annual exam.  His physical exam is normal.  Dr. Good checks a basic metabolic panel and determines that Mr. Light's kidney function is diminished (Creatinine of 2.5) which is new compared to his function one year prior (Creatinine of 1). Dr. Good wants to refer Mr. Light to a nephrologist for further evaluation.

As Dr. Good is completing the referral, his EMR contacts a CRD Server used by Mr. Light's health plan.  The service notifies him that, for the referral to be covered under Mr. Light's coverage, the physician must request prior authorization and provide specific medication documentation as part of the request.  The EMR provides a link to an insurer-provided app that displays the form, partly populated with information from his EMR and guides him through the process of completing the information needed for the prior authorization.

### CRD Workflow
The high-level workflow for CRD is envisioned to work as follows:

{::options parse_block_html="false" /}
<figure>
  <img height="300px" src="overview.png" alt="CRD Workflow diagram"/>
  <figcaption><b>    Figure 1: CRD Workflow</b></figcaption>
  <p></p>
</figure>
{::options parse_block_html="true" /}


**1. Clinical action (potentially) needed**<br/>
A healthcare provider decides that a clinical action is needed or wants to explore the coverage ramifications of taking a clinical action.  Possible clinical actions include:
* Admitting a patient or starting a patient visit
* Ordering a drug, device, procedure, etc.
* Choosing when or where an existing order will be performed
* Making a referral or scheduling a future appointment
* Discharging a patient

Based on whether the provider has decided to perform the action or just wishes to explore, they will proceed to 2a or 2b.

**2a. Provider performs EMR action**<br/>
The provider uses an EMR to initiate the clinical action from step #1, entering required information (e.g. a drug, a type of referral or appointment, etc.) into forms provided by the EMR.

**2b. Provider starts 'CRD what-if'**<br/>
The provider uses an EMR to launch a 'What if?' CRD SMART app to explore payer coverage requirements.  The provider indicates the type of action they're considering into the CRD SMART app which prompts for additional information relevant to coverage determination, such as the proposed drug, type of referral or appointment, etc.

**3. Provider checks Payer CRD needs**<br/>
The EMR or CRD SMART app contacts a CRD Server used by their patient's payer to find out what information is required to perform Coverage Requirements Discovery (CRD) - particularly whether the CRD Server requires protected health information (PHI) to evaluate the patient's coverage requirements, or whether the patient's coverage type and the proposed clinical action is enough.  Optionally, the CRD service might provide the EMR with information about configuration options, such as the option to control the types of coverage requirements returned to the user or the number of requirements returned.

Note:
* Different patients will have coverage from different payers and different payers may use different CRD Servers.
* Payer server requirements are expected to be static. The EMR or CRD SMART app may choose to cache information received.
* Modular EMR systems may need to retrieve the coverage type or other information required by the CRD Server from other systems within the provider's environment.

**4. System starts CRD query**<br/>
The EMR (in the background as the provider is typing) or the CRD SMART app (once enough information has been provided) initiates a query to the CRD Server providing the patient's coverage type and/or identity along with information about the proposed clinical action.  The EMR might also provide the CRD Server with one or more of the following:
* a 'token' to allow the CRD Server to temporarily and securely request additional patient information from the EMR in step #5.
* configuration information that indicates the type of information the EMR user is interested in receiving (e.g. whether prior authorization or clinical documentation is required, or products covered or recommended by the plan.

Note:
* Configuration options - received in step #3 - might be managed by the EMR and information provided could be specific to the context of the request, a user role, or an individual user.

**5. (Optional) Payer service gets additional data**<br/>
If additional information is needed to process the query, the CRD Server may use the EMR's secure API, with the temporary access token provided in step #4, to request additional information from the patient's record.  Examples include requests for information needed to assess whether the action is needed (e.g. an allergy to a first line medication, lab result), whether recommended next steps are in place (e.g. follow-up visits scheduled, lab tests ordered to monitor effectiveness/safety), etc.  The CRD Server might submit multiple queries for different types of data to determine coverage requirements.

Note:
* By requesting additional information directly from the EMR, a CRD Server can determine what documentation already exists and what requirements already exist, using that information to make the most accurate assessment possible before providing cards to the user that suggest additional documentation is necessary or prior authorization needs to be requested.  CRD Servers should always attempt to gather what information they can automatically before providing responses that might require human action, such as completing a Questionnaire or launching DTR.

**6. Payer service returns CRD results**<br/>
Based on the information provided/retrieved, the payer system returns guidance to the provider.  The guidance can be in several forms:
* A simple message indicating that service is covered without additional requirements
* A message describing what coverage requirements exist
* A link to external documentation describing coverage requirements to help inform/educate providers (not as a substitute for electronic prior authorization)
* Links to specific forms or templates that need to be completed
* A link to open a SMART application that allows the provider to provide needed information or additional detail to help guide coverage requirements discovery
* Links with recommendations to substitute the planned action with a different action and/or to add additional actions (e.g. proposals to replace a proposed drug to a required first-line treatment or a drug covered by the patient's plan, to add a concurrent medication, additional diagnostic tests, etc.)

Payer requirements might include the need for prior authorization, forms that must be completed, medical documentation that must exist or be provided, recommendations on alternative therapies, etc.

**7. Provider invokes links**<br/>
If the response includes links to additional information or apps, the provider can direct the EMR to interact further with the payer system by retrieving the linked-to information or launching the provided application.


#### Considerations

* This page uses the term EMR as though it is a single monolithic system.  In practice, there may be a variety of systems working together that interact as a CRD client
* The scenario above uses the term 'healthcare provider'.  Typically, that would be a physician, but in some cases, it could be a nurse, clerk, or other individual.
* The EMR would only communicate to CRD Servers they have specifically authenticated and have a trust relationship with.
* Similarly, the EMR would only launch apps or retrieve links that had previously been determined to be safe and trustworthy.  When launched, user context should be passed to apps to avoid the need for users, who have already been authenticated by the EMR, to log in again.
* The EMR would determine in which situations a payer system would be contacted for CRD purposes and what level of information the payer system would be permitted to receive - including through the payer query mechanism.  The determination of what information is shared could be influenced by patient consent and other internal business rules.
* The CRD query and response will be implemented by making a CDS Hooks service call and returning a set of cards.

### Potential Additional Uses

While the primary purpose of this implementation guide is to ensure that healthcare providers using EMRs are aware of insurance plan requirements that might impact payment for services rendered, the CRD architecture and infrastructure can potentially be used for other purposes that enhance the provider-payer-patient relationship:
* Providing guidance to providers about lower-cost or better-covered product alternatives
* Identifying in-network providers for the delivery of services
* Making providers aware of clinical risks (e.g. potential drug-drug interactions) based on payer knowledge from previous claims
* Improving accountable care delivery by making recommendations related to clinical practice guidelines or best practices
* Expanding usage beyond EMRs to allied healthcare providers (dentistry, vision care, physiotherapy, etc.)
* Surfacing the CRD back-end to patients, their care-givers, and/or healthcare providers through a web-based user interface to support exploring coverage requirements without the use of an EMR
