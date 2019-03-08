### Business need

Providers need to easily discover which payer covered services or devices have:

* Specific documentation requirements, 

* Rules for determining need for specific treatments/services

* Requirement for Prior Authorization (PA) or other approvals

* Specific guidance.   

With a FHIR based API, providers can discover in real-time specific payer requirements that may affect the ability to have certain services or devices covered by the responsible payer.  The discovery may be based on:

* Plan conditions only (i.e. no need for Protected Health InformationPHI)

* Member identification (PHI) and potentially other clinical information to guide discovery

Furthermore, the API can allow a payer (with authorization) to query additional patient information to better inform the guidance provided, for example by determining what information already exists or steps have already occurred.

The payer response might include:

* An indication that no coverage requirements exist

* A list of services, templates, documents, rules that do apply

* URI to retrive specific items (e.g. templates or forms)

* The ability to launch an application to further explore or complete requirements


### Example CRD "success" Scenarios

#### Scenario 1
Mrs. Jones is a 35 year old, previously healthy female who is seen by Dr. Good for a new onset headache that began abruptly 2 weeks prior to her visit. They are severe at times, last several hours and have been occurring with increasing frequency. Now they are occurring daily. Her physical including neurologic exam is normal. Dr. Good is concerned about an intracranial process.

Dr. Good wants to order a head CT to check for any masses but is unsure whether the service would be covered by Mrs. Jones' insurance, and if so, whether special authorization or documentation is needed.  

Dr. Good launches an app within his Electronic Medical Record (EMR) and indicates that he wants to see coverage requirements for Mrs. Jones' plan for a 'head CT'.  The app sends a query to Mrs. Jones insurer asking to identify any coverage requirements.  The insurer system returns information within a few seconds identifying that a prior-authorization form will need to be completed and submitted as well as additional clinical documentation that will be needed (Progress Note, prior studies, etc.).  It also provides a link to the form.  Dr. Jones completes the necessary paperwork to initiate a prior authorization and sends the relevant supporting information to the imaging center as part of the referral.

(optional) – The application also provides Dr. Good a list of nearby imaging centers that are on Mrs. Jones' plan.

#### Scenario 2
Mrs. Smith is an 75 year-old on Medicare Fee-For-Service with long standing chronic obstructive pulmonary disease (COPD) who has had slowly and progressively worsening shortness of breath with activity. In the office, her room air saturation after a 5 minute walk is 84%. She has additional evaluation that reveals no new findings. Dr. Good wants to initiate home oxygen therapy for Mrs. Smith.

As Dr. Good begins crafting the order in his EMR, it notes that Mrs. Smith has Medicare coverage and initiates automatically queries the CMS (Centers for Medicare/Medicaid Services) server passing the code for home oxygen therapy.  An alert appears at the bottom of order entry screen appears alerting Dr. Good that specific testing and documentation is required to substantiate the need for home oxygen therapy.

Dr. Good retrieves the documentation templates which are prepopulated from the EHR and completes any remaining documentation requirements, signs the documentation and includes it in Mrs. Smith's medical record.

#### Scenario 3
Mr. Light is a 45 year old generally healthy male who presents for an annual exam. His physical exam is normal. Dr. Good checks a basic metabolic panel and determines that Mr. Light's kidney function is diminished (Creatinine of 2.5) which is new compared to his function one year prior (Creatinine of 1). Dr. Good wants to refer Mr. Light to a nephrologist for further evaluation.

As Dr. Good is completing the referral, his EMR contacts Mr. Light's server which identifies that for the referral to be covered under Mr. Light's coverage, a specific form must be completed and specific medication documentation must be provided as part of a prior-authorization.  The EMR provides a link to an insurer-provided app that displays the form, partly populated with information from his EMR and guides him through the process of completing the information needed for the prior-authorization.

### CRD workflow
The high level workflow for CRD is envisioned to work as follows:

{::options parse_block_html="false" /}
<figure>
  <img height="300px" src="overview.png" alt="CRD Workflow diagram"/>
</figure>
{::options parse_block_html="true" /}


**1. Clinical action (potentially) needed**<br/>
A practitioner decides that a clinical action is needed or wants to explore the coverage ramifications of taking a clinical action.  Possible clinical actions include:

* Admitting a patient or starting a patient visit

* Ordering a drug, device, procedure, etc.

* Making a referral or scheduling a future appointment

* Discharging a patient

Based on whether the provider has decided to perform the action or just wishes to explore, they will proceed to 2a or 2b.

**2a. Provider performs EMR action**<br/>
The provider uses their EMR to initiate the clinical action - i.e. starts to admit the patient, write the prescription or referral, make the appointment, etc.  They then begin filling in the needed information such as selecting a drug, identifying a type of referral or appointment, etc.

**2b. Provider starts 'CRD what-if'**<br/>
The provider uses their EMR to launch a 'What if?' CRD app that allows them to explore payer coverage requirements.  The provider indicates the type of action they're considering and the CRD app prompts for additional information relevant to coverage determination, such as the proposed drug, type of referral or appointment, etc.

**3. Provider checks Payer CRD needs**<br/>
The EMR or CRD app checks the the CRD requirements of the Payer service - particularly whether it needs protected health information (PHI) to evaluate coverage requirements or whether a simple coverage type and the proposed clinical action is sufficient.  The provider application might also indicate what configuration options are available, such as control over the types of coverage requirements returned, the number of requirements returned, etc.

NOTE: this won't necessarily occur each time the EMR or CRD app makes a call to the server as the payer server requirements are expected to be static and can therefore be cached.

**4. System starts CRD query**<br/>
The EMR (in the background as the provider is typing) or the CRD app (once sufficient information has been provided) initiates a CRD query to the payer service providing coverage type and/or patient identity and information about the proposed clincial action.  It might also provide one or more of the following:

* a 'token' that temporarily allows the payer to securely query the EMR for additional patient information relevant to determining coverage requirements

* configuration information that indicates what types of requirements the provider is interested in (e.g. pre-authorization needs, clinical documentation requirements, product coverage, product recommendations).  (These requirements might be managed by the EMR and could be specific to the provider, the context and/or the role.)

**5. (Optional) Payer gets additional data**<br/>
The payer might use the EMR's secure API, together with the temporary access token, to query additional information from the patient's record.  Examples include checking whether records already exist to support an action (e.g. lab results, allergy to a first line medication), checking whether next steps are in place (e.g. follow-up visits scheduled, lab tests ordered to monitor effectiveness/safety), etc.  This step could involve multiple queries of different types of data until the payer has what they need to determine coverage requirements.

**6. Payer returns CRD results**<br/>
Based on the information provided/retrieved, the payer returns guidance to the provider.  The guidance can be in several forms:

* A simple message indicating that there are no coverage requirements

* A message describing what coverage requirements exist

* A link to external documentation describing coverage requirements

* Specific forms or templates that needs to be completed

* A link to an application that allows the provider to provide needed information or to provide additional detail to help guide coverage requirements determination

* Links to substitute the planned action for a different action and/or to add additional actions (e.g. to add a concurrent medication, additional diagnostic tests, etc.)  For example, a proposal to change the proposed drug to a required first-line treatment or to one that is covered by the patient's plan.

The requirements themselves might include needs for pre-authorization, particular forms that must be completed, medical documentation that must exist or be provided, recommendations on alternative therapies, etc.

**7. Provider invokes links**
If the response included links to additional information or apps, the Provider can direct EMR to interact further with the Payer system by retrieving the linked-to information or launching the provided application.


#### Considerations

* The scenario above uses the term 'Provider'.  Typically that would be a physician, but in some cases it could be a nurse, clerk or other individual.

* The EMR would only communicate to Payer systems they have specifically authenticated and have a trust relationship with.

* Similarly, the EMR would only launch apps or retrieve links that had previously been determined to be safe and trustworthy.

* The EMR would determine in which situations a payer system would be contacted for CRD purposes and what level of information the payer would be permitted to receive - including through the payer query mechanism.  The determination of what information is shared could be influenced by patient consent and other internal business rules.

* The CRD query and response will be implemented by making a CDS Hooks service call and returning a set of cards


### Potential additional uses

While the primary purpose of this implementation guide is to ensure that healthcare providers using EMRs are aware of insurance plan requirements that might impact payment for services rendered, the CRD architecture and infrastructure can potentially be used for other purposes that enhance the provider-payer-patient relationship:

* Providing guidance to practitioners about lower-cost or better covered product alternatives

* Identifying in-network providers for the delivery of services

* Making providers aware of clinical risks (e.g. potential drug-drug interactions) based on payer knowledge from previous claims

* Improving accountable care delivery by making recommendations related to clinical practice guidelines or best practices

* Expanding usage beyond EMRs to allied healthcare providers (dentistry, vision care, physio therapy, etc.)

* Surface the CRD back-end to patients, their care givers and/or healthcare providers through a web-based user interface to support exploring coverage requirements without the use of an EMR