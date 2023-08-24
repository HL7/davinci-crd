ValueSet: CRDCardType
Id: cardType
Title: "CRD Card Types Value Set"
Description: "List of card types defined by the CRD spec"
* ^status = #active
* ^experimental = false
* include codes from system CRDTempCodes where concept descendent-of #_cardType