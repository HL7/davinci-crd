One of the main objectives of the CRD implementation guide (and the burden reduction guides as a whole) is to
improve efficiency of the healthcare system with respect to provider-payer interaction.  However, for this
objective to be achieved, it's important that the information provided by payers be useful and timely and
it's equally important that the relevant information from the EHR be available (and findable) for payers in
computable form.

EHRs, payers, and governing authorities such as CMS will all have an interest in understanding how well the
implementation of CRD is working.  They will be interested in such questions as:

* How long does the average CRD call take to execute?
* How many CRD calls result in 'satisfied' authorization?
* How many CRD calls require access to provider information, and what type is accessed

It is likely that formal metrics (likely using the [Measure]({{site.data.fhir.path}}measure.html) resource)
will be defined to help evaluate and potentially benchmark CRD implementations.  However, in order to evaluate
such measures, the relevant information will need to be available in both provider and payer systems to support
the measures.

In the interest of enabling such evaluation processes, this guide has defined a 
[logical CRD Metric model](StructureDefinition-CRDMetricData.html) that describes the data elements most
likely to be relevant for such evaluation.

This model is NOT a FHIR data structure for information exchange.  Instead, it is a logical model that describes
the types of data that should be available and any constraints on the data (e.g. cardinality, terminology) that
should be captured by CRD implementers to support the evaluation of metrics.  Measures can then be defined
in a standardized way based on these measures.

CRD implementers **SHOULD** store information for each CRD call in a manner that would allow them to respond to
measures based on this logical model.