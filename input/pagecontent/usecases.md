### Business Need

Providers need to easily discover which payer-covered services, medications (not covered by NCPDP) or devices have:
* Specific documentation requirements,
* Rules for determining the need for specific treatments/services,
* Requirements for Prior Authorization (PA) or other approvals, and
* Specific guidance.  


This implementation guide defines a FHIR API that providers can call to discover - in real time - specific payer requirements that may affect whether services or devices provided to a patient are covered by their health plan.  The Coverage Requirement Discovery may be based on:
* Plan conditions only (i.e., without Protected Health Information (PHI)), or also
* Plan member identification (PHI) and, potentially, clinical information needed to determine requirements.

When needed, the API will allow payers with authorization to query provider systems for additional patient information needed to inform the guidance provided - for example by determining what information already exists or what steps have already occurred.

The payer response to a CRD request might include:
* An indication that no coverage requirements exist
* A list of services, templates, documents, and/or rules that apply
* A URI to retrieve specific items, such as templates or forms
* The ability to launch an application to further explore or complete requirements


### Example CRD "Success" Scenarios

#### Scenario 1
Mrs. Jones is a 35-year-old, previously healthy female who is seen by Dr. Good for a new onset headache that began abruptly 2 weeks prior to her visit. Her headaches are severe at times, last several hours, have been occurring with increasing frequency, and are now occurring daily. Her physical, including neurologic exam, is normal. Dr. Good is concerned about an intracranial process.

Dr. Good wants to order a head CT to check for any masses. Dr. Good begins filling out the order for the CT in their EHR. In the background, the EHR initiates a call to the CRD server used by Mrs. Jones' payer providing information about the patient, her coverage and the CT order. The CRD service returns information within a few seconds identifying that a prior authorization request must be completed and submitted, as well as a list of the additional clinical documentation required (e.g., Progress Note or prior studies). It also provides a link to the required form. Dr. Good launches an app to complete the necessary paperwork to initiate a prior authorization and sends the relevant supporting information to the imaging center as part of the referral.

Note: An app may also provide Dr. Good with additional useful information, such as a list of nearby imaging centers that are on Mrs. Jones' plan.

#### Scenario 2
Mrs. Smith is a 75-year-old female on a Medicare Fee-For-Service plan with longstanding chronic obstructive pulmonary disease (COPD) who has had slowly and progressively worsening shortness of breath with activity. In the office, her room air oxygen saturation after a 5-minute walk is found to be 84%. She has an additional evaluation that reveals no new findings. Dr. Good wants to initiate home oxygen therapy for Mrs. Smith.

Dr. Good is completing<sup>*</sup> an order for home oxygen therapy. The EHR initiates a query to the CRD server used by her payer that includes the code for a portable oxygen generator. An alert appears on the EHR order entry screen notifying Dr. Good that specific testing and documentation is required to substantiate the need for home oxygen therapy and specifically for a portable oxygen generator. The EHR allows Dr. Good to immediately document the required information by starting Documentation Templates and Rules (DTR).

DTR retrieves specific documentation templates which have already been populated with information from the EHR. Dr. Good completes the remaining documentation requirements that require clinical input, signs the documentation, and includes it in Mrs. Smith’s medical record. They leave the remaining portion of the documentation to be completed by their administrative staff who will find an appropriate supplier and forward the order and documentation.

<sup>*</sup> Note: This flow envisions the use of the Order Sign hook, which allows guidance to be returned while the user is in the process of signing the order. 

#### Scenario 3
Mr. Light is a 45-year-old generally healthy male who presents for an annual exam. His physical exam is normal. Dr. Good checks a basic metabolic panel and determines that Mr. Light's kidney function is diminished (Creatinine of 2.5) which is new compared to his function one year prior (Creatinine of 1). Dr. Good wants to refer Mr. Light to a nephrologist for further evaluation.

As Dr. Good is completing the referral, their EHR contacts a CRD server used by Mr. Light's health plan. The service notifies them that for the referral to be covered under Mr. Light's coverage, the physician must request prior authorization and provide specific medical documentation as part of the request. The EHR provides a link to an insurer-provided app that displays the form partly populated with information from their EHR and guides them through the process of completing the information needed for prior authorization.

#### Scenario 4
Mrs. Abdallah is a 30-year-old female who is struggling with weight issues. Dr. Good feels that she'd be a good candidate for a dietary consult, however Mrs. Abdallah isn't sure whether her plan will cover the service and doesn't think she can afford it with her current salary. Before going through the work of writing up a formal referral, Dr. Good opts to check whether a referral would be covered. They launch an app within their EHR which auto-populates with information from the current patient. They choose "MNT/nutrition counseling" from the list of possible referral services and the app contacts Mrs. Abdallah's payer's CRD server. The server indicates that while Mrs. Abdallah does have coverage, MNT/nutrition counseling is not a benefit of her plan. Dr. Good informs Mrs. Abdallah of this, and they come up with an alternate plan. Dr. Good recommends a useful series of online videos and a couple of books Mrs. Abdallah can get from the library. Dr. Good also suggests Mrs. Abdallah shop around a bit for health plans when it comes time to renew her coverage for the following year.

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
A healthcare provider decides that a clinical action is needed or wants to explore the coverage ramifications of taking a clinical action. Possible clinical actions include:
* Admitting a patient or starting a patient visit
* Ordering a drug, device, procedure, etc.
* Choosing when or where an existing order will be performed
* Making a referral or scheduling a future appointment
* Discharging a patient

Based on whether the provider has decided to perform the action or just wishes to explore, they will proceed to 2a or 2b.

**2a. Provider performs EHR action**<br/>
The provider uses an EHR to initiate the clinical action from step #1, entering required information (e.g., a drug, a type of referral, or appointment) into forms provided by the EHR.

**2b. Provider starts 'CRD what-if'**<br/>
The provider uses an EHR to launch a 'what if?' CRD SMART app to explore payer coverage requirements. The provider indicates the type of action they're considering into the CRD SMART app which prompts for additional information relevant to coverage determination, such as the proposed drug, type of referral or appointment, etc.

**3. Provider checks Payer CRD needs**<br/>
The EHR or CRD SMART app contacts a CRD server used by their patient's payer to find out what information is required to perform Coverage Requirements Discovery (CRD) - particularly whether the CRD server requires protected health information (PHI) to evaluate the patient's coverage requirements, or whether the patient's coverage type and the proposed clinical action is enough. Optionally, the CRD service might provide the EHR with information about configuration options, such as the option to control the types of coverage requirements returned to the user or the number of requirements returned.

Note:
* Each patient will have coverage from their own specific payer and each payer may use their own unique CRD server.
* Payer server requirements are expected to be static. The EHR or CRD SMART app may choose to cache information received.
* Modular EHR systems may need to retrieve the coverage type or other information required by the CRD server from other systems within the provider's environment.

It is up to payers to determine whether and how long to cache information such as "is member covered" and "what are coverage rules for service x", as well as if and how to check whether cached information is 'dirty' (i.e. the underlying record has changed). From a performance perspective, if follow-on hooks (i.e., Order Dispatch or a subsequent Order Sign for revisions) are invoked, there is no expectation information will be cached if no hook for that patient has fired in the last 24 hours, which is why the response time target is longer in that situation.

In the event decisions are made based on dirty cached data, the unique identifier provided with the Coverage Information extension will allow the payer to trace what information the decision was based on. Also, CRD responses are point-in-time assertions, and it is possible that circumstances will change (e.g., a policy being cancelled) that will invalidate the response provided.

**4. System starts CRD query**<br/>
The EHR (in the background as the provider is typing) or the CRD SMART app (once enough information has been provided) initiates a query to the CRD server providing the patient's coverage type and/or identity along with information about the proposed clinical action. The EHR might also provide the CRD server with one or more of the following:
* a 'token' to allow the CRD server to temporarily and securely request additional patient information from the EHR in step #5.
* configuration information that indicates the type of information the EHR user is interested in receiving (e.g., whether prior authorization or clinical documentation is required, or products covered, or recommendations from the health plan).

Note:
* Configuration options received in step #3 might be managed by the EHR and the information provided could be specific to the context of the request, a user role, or an individual user.

**5. (Optional) Payer service gets additional data**<br/>
If additional information is needed to process the query, the CRD server may invoke the EHR's secure API, with the temporary access token provided in step #4, to request additional information from the patient's record. (In some cases, the EHR may provide information up-front based on pre-fetch requests from the payer's configuration information.) Examples include requests for information needed to assess whether the action is needed (e.g., a lab result or an allergy to a first line medication), whether recommended next steps are in place (e.g., follow-up visits scheduled, lab tests ordered to monitor effectiveness/safety), etc. The CRD server might submit multiple queries for different types of data to determine coverage requirements.

Note:
* By requesting additional information directly from the EHR, a CRD server can determine what documentation already exists and what requirements already exist and can use that information to make the most accurate assessment possible before providing cards to the user that suggest that additional documentation is necessary or that prior authorization must be requested. CRD servers should always attempt to gather what information they can automatically before providing responses that might require human action, such as completing a Questionnaire or launching DTR.

**6. Payer service returns CRD results**<br/>
Based on the information provided and/or retrieved, the payer system returns guidance to the provider. The guidance can be in several forms:
* A simple message indicating that service is covered without additional requirements
* A message describing what coverage requirements exist
* A link to external documentation that supports provided assertions that coverage does or doesn't exist, or whether prior authorization is needed.

<div class="modified-content" markdown="1"><a name="FHIR-52463"> </a>
* Links to specific forms or templates that need to be completed with instructions to launch DTR to gather additional information.
</div>

* An indication that prior authorization is necessary and has been approved, including information such as the prior authorization number and assumed billing codes.
* Links with recommendations to substitute the planned action with a different action and/or to add additional actions (e.g., proposals to replace a requested drug with a required first-line treatment or another drug covered by the patient's plan, to add a concurrent medication, additional diagnostic tests, etc.)

Payer requirements might include the need for prior authorization, forms that must be completed, medical documentation that must exist or be provided, recommendations on alternative therapies, etc.

**7. Provider invokes links**<br/>
If the response includes links to additional information or apps, the provider can direct the EHR to interact further with the payer system by retrieving the linked-to information or launching the provided application.

#### Considerations
* This page uses the term EHR as though it is a single monolithic system. In practice, there may be a variety of systems working together that interact as a CRD client.
* The scenario above uses the term 'healthcare provider'. Typically, that would be a physician, but in some cases, it could be a nurse, clerk, or other individual.
* The EHR would only communicate with CRD servers with which it is authenticated and has a trust relationship. 
* Similarly, the EHR would only launch apps or retrieve links that had previously been determined to be safe and trustworthy. When launched, user context should be passed to apps to avoid the need for users to log in again if they have already been authenticated by the EHR.
* The EHR would determine in which situations a payer system would be contacted for CRD purposes and what level of information the payer system would be permitted to receive, including through the payer query mechanism. The determination of what information is shared could be influenced by patient consent and other internal business rules.
* The CRD query and response will be implemented by making a CDS Hooks service call and returning a set of cards and/or system actions.

### Potential Additional Uses
While the primary purpose of this implementation guide is to ensure that healthcare providers using EHRs are aware of insurance plan requirements that might affect payment for services rendered, the CRD architecture and infrastructure can potentially be used for other purposes that enhance the provider-payer-patient relationship:
* Providing guidance to providers about lower-cost or better-covered product alternatives
* Identifying in-network providers for the delivery of services
* Making providers aware of clinical risks (e.g., potential drug-drug interactions) based on payer knowledge from previous claims
* Improving accountable care delivery by making recommendations related to clinical practice guidelines or best practices
* Expanding usage beyond EHRs to allied healthcare providers (dentistry, vision care, physiotherapy, etc.)
* Surfacing CRD capabilities to patients, their caregivers, or their healthcare providers through a web-based user interface to support exploring coverage requirements without the use of an EHR