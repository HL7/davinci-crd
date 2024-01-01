ValueSet: CMSMappableLocationCodes
Id: CMSMappableLocationCodes
Title: "CMS Mappable Location Codes"
Description: "Extends the base HL7-defined value set codes with supplementary codes needed to provide full coverage to the CMS location code set"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* include codes from valueset http://terminology.hl7.org/ValueSet/v3-ServiceDeliveryLocationRoleType
* include codes from system CRDTempCodes where concept descendant-of #_cmsLocation
* include http://terminology.hl7.org/CodeSystem/data-absent-reason#unknown
