<div class="new-content">
Some of the implementation expectations related to CRD are not conformance expectations that relate to the specification itself, but rather business practices that will need to be in place within and amongst the organizations that implement the specification.  This section describes considerations that should be taken into account as part of establishing such agreements and practices, whether done on a site-by-site basis, or as part of a network organization.

### Business Agreements

When enabling CRD between payers and providers, agreements will need to be in place.  Considerations for inclusion in such agreements include:

* Expectations for payers to adhere to non-expired CRD coverage declarations except in situations where the coverage has changed in a manner outside the payer's control.
</div>
<div class="new-content"><a name="FHIR-51776"></a>
CRD clients and servers SHOULD support encounter-start and order-select, both to allow payer caching and to allow payers to return useful responses when possible (e.g. coverage expired, service not covered) with the limited information available in those hooks.  Requirements for either or both hook might be tightened to SHALL in a future release of this specification.
</div>