The current CRD, [DTR](http://hl7.org/fhir/us/davinci-dtr), [PAS](http://hl7.org/fhir/us/davinci-pas), and [CDex](http://hl7.org/fhir/us/davinci-cdex) supporting the electronic Prior Authorization (ePA) workflow only focuses on the interactions between the provider HIT in total and the payer HIT in total, not the necessary interactions among the respective HIT solutions that make up the provider and payer HIT environment that need to participate in the ePA workflow.

Organizations might need a varity of combinations of Health Information Technology (HIT) components to support new prior authorization regulatory requirements.  The U.S. Office of the National Coordinator for Health Information (ONC) is considering a certification process where certified software can use generic (or generically referenced) relied-upon software to meet certain requirements and can clearly specify the capabilities they rely on without the need to test each permutation of relied-upon software with which they support the ePA workflow. Further guidance is needed for the interactions necessary within each of the provider and payer HIT configurations based on the functions/roles of those HIT solutions, and requires the relied upon software approach using predictable, standards-based capabilities to participate in an ePA workflow and for HIT that provides full support for ePA workflow through its certified HIT.

The following drawing demonstrates the CRD Workflow exchanges between an integrated provider HIT environment and an integrated payer HIT environment in the upper portion.  The lower portion of the CRD workflow drawing represents the potential for electronic Prior Authorization (ePA) coordinator functionality to play a role between the provider HIT and the payer HIT.  It should be noted, that the exchanges between the provider HIT (including any ePA) and the payer HIT (including any ePA) **SHALL** replicate all of the defined exchanges between provider and payer (represented by the green and orange arrows).  The red and purple arrows are representative of information exchange between the Provider ePA and the Provider systems (red arrows) or the information exchange between the Payer ePA and the Payer systems (purple arrows).

<div>
	<img src="epA-workflow.png" alt="Complex diagram showing the components of an integrated provider solution communicating with an integrated payer solution, followed by a diagram that breaks the payer and provider functions into primary systems plus 'ePA Coordinator' systems that handle the CDS Hooks communication and exposes the interactions between the primary provider and primary payer systems and their respective ePA Coordinator systems."/>
	<b>Figure 1</b> - CRD Workflow with and without ePA Coordinators
</div>

The following drawing provides additional detail regarding the exchanges between a Provider ePA Coordinator, multiple Provider HIT systems and the payer.  The boxes below the workflow drawing indicate the activities of the various components. From left to right: 

* the Provider HIT systems,
* the Provider ePA coordinator, and
* the Payer HIT.

The numbered workflow in the Provider ePA Coordinator indicates the inputs from the example Provider HIT systems that are involved in creating the exchanges between the Provider HIT and the exchanges with the Payer. This includes:

1. Information required for authentication with the payer where required
2. CDS hooks request (need to clarify how access token is managed)
3. Ability to query for additional patient information
4. CDS hooks response

<div>
	<img src="ePA-coord-detail.png" alt="A diagram that drills into the coordinator workflows showing how the provider and payer systems might themselves not be monolithic and indicating which internal interactions would be with which systems."/>
	<b>Figure 2</b> - Provider ePA Coordinator Detail
</div>

The following graphic and associated table provides an example of the type of interactions that will need to be supported between an ePA coordinator and the various Provider HIT components.  These interactions include:

1. Initiating the CDS Hooks exchange
2. Providing access to the patient record via a FHIR API
3. Retrieving coverage information
4. Retrieving required and allowed clinical and administrative information
5. Returning the CDS hooks response (cards and systems actions)

The table briefly describes each action along with:

* Provider systems impacted
* Provider API requirements
* ePA Coordinator API requirements
* Comments regarding each transaction

<div>
	<img src="ePA-coord-interactions.png" alt="Drilling further into the interactions between provider system components, goes through each interaction and provides details about the API requirements driving interoperability for the interaction."/>
	<b>Figure 3</b> - Provider ePA Coordinator Interactions
</div>

The above graphics and descriptions outline the relevant interactions that will be further documented in subsequent releases of this IG as implementations of various combinations of HIT further inform the specifications.