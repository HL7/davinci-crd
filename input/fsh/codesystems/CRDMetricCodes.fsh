CodeSystem: CRDMetricCodes
Id: crd-metric-codes
Title: "CRD Metric Codes"
Description: "Codes used within 'code' elements in the CRD Metric logical model."
* ^status = #active
* ^experimental = false
* ^caseSensitive = true
* ^hierarchyMeaning = #is-a
* ^content = #complete
* ^property[0].code = #abstract
* ^property[0].uri = "http://hl7.org/fhir/concept-properties#notSelectable"
* ^property[0].type = #boolean
// Metric token use
* #used                    "Authorization Token Used"          "An authorization token was used by the payer to access additional information from the provider system as part of the CDS Hooks call"
  * #rejected              "Authorization Token Rejected"      "The payer attempted to use an authorization token to access additional information from the provider system as part of the CDS Hooks call, however the access request failed.  (This is not used if the request succeeded but returned no records.)"
* #not-used                "Authorization Token Not Used"      "The payer did not attempt to use an authorization token to access additional information from the provider system as part of the CDS Hooks call"
// Metric data source
* #provider-src            "Provider-sourced"                  "The metric information was captured from the provider system's perspective"
* #payer-src               "Payer-sourced"                     "The metric information was captured from the payer system's perspective"
* #_HookType               "CDS Hooks Type (abstract)"         "A collector for the different types of CDS Hooks"
  * ^property.code = #abstract
  * ^property.valueBoolean = true
  * #appointment-book    "Appointment Book"     "CDS Hooks Appointment Book Hook"
  * #encounter-start     "Encounter Start"      "CDS Hooks Encounter Start Hook"
  * #encounter-discharge "Encounter Discharge"  "CDS Hooks Encounter Discharge Hook"
  * #order-dispatch      "Order Dispatch"       "CDS Hooks Order Dispatch Hook"
  * #order-select        "Order Select"         "CDS Hooks Order Select Hook"
  * #order-sign          "Order Sign"           "CDS Hooks Order Sign Hook"