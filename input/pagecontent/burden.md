{% include burdenReduction.md %}

### Systems
The CRD implementation guide defines the responsibilities of the two types of systems involved in a CRD solution:

**CRD clients** are typically systems that healthcare providers use at the point of care including electronic medical records systems, pharmacy systems, and other provider and administrative systems used for ordering, documenting, and executing patient-related services. Users of these systems need coverage requirements information to support care planning.

**CRD servers** (or servers) are systems that act on behalf of payer organizations to share information with healthcare providers about rules and requirements related to healthcare products and services covered by a patient's health plan. A CRD server will provide coverage information related to one or more insurance plans. CRD servers are a type of CDS service as defined in the CDS Hooks Specification.

### Users
The 'CDS' in 'CDS Hooks' stands for 'Clinical Decision Support'. However, the mechanism actually supports a variety of types of decision support and the responsible HL7 work group has confirmed that conveying guidance that is not strictly clinical, and providing guidance to non-clinical users (clerks, schedulers, etc.) is appropriate. Because all decision support provided by a CRD server is fully automated, there will be no human intervention on the payer side. If an automated system does not have enough information to provide guidance without human input, then no guidance will be provided.

