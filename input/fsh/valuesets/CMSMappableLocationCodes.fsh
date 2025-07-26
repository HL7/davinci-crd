ValueSet: CMSMappableLocationCodes
Id: CMSMappableLocationCodes
Title: "CMS Mappable Location Codes Value Set"
Description: "Extends the base HL7-defined value set codes with supplementary codes needed to provide full coverage to the CMS location code set"
* ^status = #active
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* include codes from valueset http://terminology.hl7.org/ValueSet/v3-ServiceDeliveryLocationRoleType
* include http://terminology.hl7.org/CodeSystem/data-absent-reason#unknown
* include $temp#2
* include $temp#4
* include $temp#5
* include $temp#6
* include $temp#7
* include $temp#8
* include $temp#9
* include $temp#10
* include $temp#12
* include $temp#13
* include $temp#14
* include $temp#16
* include $temp#17
* include $temp#19
* include $temp#20
* include $temp#22
* include $temp#25
* include $temp#27
* include $temp#34
* include $temp#49
* include $temp#50
* include $temp#52
* include $temp#53
* include $temp#57
* include $temp#58
* include $temp#60
* include $temp#62
* include $temp#65
* include $temp#71
* include $temp#72
* include $temp#99
