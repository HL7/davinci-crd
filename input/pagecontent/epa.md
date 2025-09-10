The current CRD, [DTR](http://hl7.org/fhir/us/davinci-dtr), [PAS](http://hl7.org/fhir/us/davinci-pas), and [CDex](http://hl7.org/fhir/us/davinci-cdex) supporting the electronic Prior Authorization (ePA) workflow only focus on the interactions between the provider Health Information Technology (HIT) in total and the payer HIT in total, not the necessary interactions among the respective HIT solutions that make up the provider and payer HIT environment that need to participate in the ePA workflow.

Organizations might need a variety of combinations of HIT components to support new prior authorization regulatory requirements. The Assistant Secretary for Technology Policy/Office of the National Coordinator for Health IT (ASTP/ONC) is considering a certification process where certified software can use generic (or generically referenced) relied-upon software to meet certain requirements and can clearly specify the capabilities they rely on without the need to test each permutation of relied-upon software with which they support the ePA workflow. Further guidance is needed for the interactions necessary within each of the provider and payer HIT configurations based on the functions/roles of those HIT solutions, and requires the relied upon software approach using predictable, standards-based capabilities to participate in an ePA workflow and for HIT that provides full support for ePA workflow through its certified HIT.

The following drawing demonstrates the CRD workflow exchanges between an integrated provider HIT environment and an integrated payer HIT environment in the upper portion. The lower portion of the CRD workflow drawing represents the potential for electronic Prior Authorization (ePA) coordinator functionality to play a role between the provider HIT and the payer HIT. It should be noted that the exchanges between the provider HIT (including any ePA) and the payer HIT (including any ePA) **SHALL** replicate all of the defined exchanges between provider and payer (represented by the green and orange arrows). The red and purple arrows are representative of information exchange between the Provider ePA and the Provider systems (red arrows) or the information exchange between the Payer ePA and the Payer systems (purple arrows).

<div>
	<img src="epA-workflow.png" alt="Complex diagram showing the components of an integrated provider solution communicating with an integrated payer solution, followed by a diagram that breaks the payer and provider functions into primary systems plus 'ePA coordinator' systems that handle the CDS Hooks communication and exposes the interactions between the primary provider and primary payer systems and their respective ePA coordinator systems."/>
	<b>Figure 1</b> - CRD workflow with and without ePA coordinators
</div>


The following drawing provides additional detail regarding the exchanges between a provider ePA coordinator, multiple provider HIT systems and the payer. The boxes below the workflow drawing indicate the activities of the various components. From left to right: 

* the provider HIT systems,
* the provider ePA coordinator, and
* the payer HIT.

The numbered workflow in the provider ePA coordinator box indicates the inputs from the provider HIT systems that are involved in creating the exchanges between the provider and the Payer. This includes:

1. Information required for authentication with the payer
2. CDS Hooks request, including how an access token is managed
3. Ability to query for additional patient information
4. CDS Hooks response

<div>
  <img src="ePA-coord-detail.png" alt="A diagram that presents the coordinator workflows showing how the provider and payer systems might themselves not be monolithic and indicating which internal interactions would be with each system."/>
  <b>Figure 2</b> - Provider ePA coordinator detail
</div>

The following graphic and table provides an example of the type of interactions that will need to be supported between an ePA coordinator and the various provider HIT components. These interactions include:

1. Initiating the CDS Hooks exchange
2. Providing access to the patient record via a FHIR API
3. Retrieving coverage information
4. Retrieving required and allowed clinical and administrative information
5. Returning the CDS Hooks response (cards and systems actions)

The table briefly describes each action along with:

* Provider systems affected
* Provider API requirements
* ePA coordinator API requirements
* Comments regarding each transaction

<div>
  <img src="ePA-coord-interactions.png" alt="Further detail regarding the interactions between provider system components, goes through each interaction and provides details about the API requirements for each."/>
  <b>Figure 3</b> - Provider ePA coordinator interactions
</div>

The above graphics and descriptions outline the relevant interactions that will be further documented in subsequent releases of this IG as implementations of various combinations of HIT further inform the specifications.
