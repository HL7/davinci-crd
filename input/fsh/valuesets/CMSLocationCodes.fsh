ValueSet: CMSLocationCodes
Id: cmslocationcodes
Title: "CMS Location Codes Value Set"
Description: "Numeric codes defined by CMS to identify types of locations"
* ^status = #active
* ^experimental = false
* include codes from system CRDTempCodes where concept is-a #_cmsLocation