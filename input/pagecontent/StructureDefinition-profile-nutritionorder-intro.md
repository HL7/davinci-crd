<!--- Text entered into this file will appear at the top of the profiles page before the Formal Views of the profile content. -->

### Usage

§§prof-10^crd-client^exchange:CRD Clients **SHALL** use CRD NutritionOrder profile to [resolve references](foundation.html#additional-data-retrieval) to NutritionOrder resources passed to CRD Servers (e.g. `selections` context references) and to populate `draftOrders` context objects.^

CRD Clients **SHALL** use CRD NutritionOrder profile to [resolve references](foundation.html#additional-data-retrieval) to NutritionOrder resources passed to CRD Servers (e.g. `selections` context references) and to populate `draftOrders` context objects when invoking the following CDS Hooks:
* [order-select](hooks.html#order-select)
* [order-sign](hooks.html#order-sign)
* [order-dispatch](hooks.html#order-dispatch)

§§

Information provided in [Must Support]({{site.data.fhir.path}}profiling.html#mustsupport) elements will commonly be required for CRD Servers to perform coverage requirements discovery.
<br/>
