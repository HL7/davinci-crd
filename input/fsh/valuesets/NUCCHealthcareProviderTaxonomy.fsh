ValueSet: NUCCCareProviderTaxonomyNonIndividual
Title: "NUCC Healthcare Provider Taxonomy Non-Individual"
Description: "All NUCC Healthcare Provider Taxonomy codes that fall within the Non-Individual heading"
* ^experimental = false
* include codes from system $nucc-provider-taxonomy where grouping = "Agencies"
* include codes from system $nucc-provider-taxonomy where grouping = "Ambulatory Health Care Facilities"
* include codes from system $nucc-provider-taxonomy where grouping = "Hospital Units"
* include codes from system $nucc-provider-taxonomy where grouping = "Hospitals"
* include codes from system $nucc-provider-taxonomy where grouping = "Laboratories"
* include codes from system $nucc-provider-taxonomy where grouping = "Managed Care Organizations"
* include codes from system $nucc-provider-taxonomy where grouping = "Nursing & Custodial Care Facilities"
* include codes from system $nucc-provider-taxonomy where grouping = "Other Service Providers"
* include codes from system $nucc-provider-taxonomy where grouping = "Residential Treatment Facilities"
* include codes from system $nucc-provider-taxonomy where grouping = "Respite Care Facility"
* include codes from system $nucc-provider-taxonomy where grouping = "Suppliers"
* include codes from system $nucc-provider-taxonomy where grouping = "Transportation Services"

ValueSet: NUCCCareProviderTaxonomyIndividualOrGroups
Title: "NUCC Healthcare Provider Taxonomy Individual or Groups"
Description: "All NUCC Healthcare Provider Taxonomy codes that fall within the Individual or Groups (of Individuals) heading"
* ^experimental = false
* include codes from system $nucc-provider-taxonomy
* exclude codes from valueset NUCCCareProviderTaxonomyNonIndividual