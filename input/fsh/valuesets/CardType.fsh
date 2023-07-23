ValueSet: CardType
Id: cardType
Title: "CRD Card Types Value Set"
Description: "List of card types"
* ^status = #draft
* ^experimental = false
* include codes from system CRDTempCodes where concept descendent-of #_cardType