ValueSet: CRDConformanceStatementCategories
Id: cs-categories
Title: "CRD Conformance Statement Categories"
Description: "Categories for conformance statements found in the CRD IG"
* ^status = #active
* ^experimental = false
* include codes from system CRDTempCodes where concept descendent-of #_reqcat
