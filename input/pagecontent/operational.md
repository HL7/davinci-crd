<div class="new-content" markdown="1">
Some of the implementation expectations related to CRD are not conformance expectations that relate to the specification itself, but rather business practices that will need to be in place within and amongst the organizations that implement the specification.  This section describes considerations that should be taken into account as part of establishing such agreements and practices, whether done on a site-by-site basis, or as part of a network organization.

### Business Agreements

When enabling CRD between payers and providers, agreements will need to be in place.  Considerations for inclusion in such agreements include:

* Expectations for payers to adhere to non-expired CRD coverage declarations except in situations where the coverage has changed in a manner outside the payer's control.

### Prior Authorization Cases
<a name="FHIR-45673"> </a>Payers often make decisions about prior authorization based not only on the information in a single order, but also based on other services that are also being provided.  For example, an order for rehabilitation therapy might be considered differently when evaluated in consideration with an associated order for surgery than if that associated surgery information wasn't known.  There are several ways a payer could be made aware of 'related' orders:

* The orders might come at the same time as part of the same hook (e.g. on order-sign) if the orders are being processed at the same time.
* One order might point to another via the 'based-on' relationship if one order is happening under the authorization of another order
* Other active orders can be retrieved by performing a query against the patient record.
* Other orders the payer has already received information about (e.g. via other authorization requests, CDex, etc.)

If a payer makes a coverage determination that is specifically related to the existence (and expected fulfillment) of other orders, that can be conveyed using the 'dependency' element within the coverage-information extension."

### Additional Recommendations
* <a name="FHIR-51776"></a>§ops-1^crd-client,crd-server^exchange:CRD clients and servers **SHOULD** support encounter-start and order-select, both to allow payer caching and to allow payers to return useful responses when possible (e.g. coverage expired, service not covered) with the limited information available in those hooks.§  Requirements for either or both hook might be tightened to 'SHALL' in a future release of this specification.

</div>
