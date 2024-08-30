
Instance: HL7Location-CRDTemp
InstanceOf: ConceptMap
Title: "HL7 Location code to CMS location code"
Description: "A mapping between the location code mandated by HL7 with the equivalent concepts in the CMS code system (where equivalents exist)"
Usage: #definition
* name = "HL7LocationCRDTempMap"
* status = #active
* experimental = false
* sourceCanonical = "http://terminology.hl7.org/ValueSet/v3-ServiceDeliveryLocationRoleType"
* targetCanonical = "http://hl7.org/fhir/us/davinci-crd/ValueSet/cmslocationcodes"
* group[+]
  * source = $v3-RoleCode
  * target = $temp
  * insert mapeq(#PHARM, [[Pharmacy]], #1, [[Pharmacy **]])
  * insert mapeq(#SCHOOL, [[school]], #3, [[School]])
  * insert mapeq(#PROFF, [[Provider's Office]], #11, [[Office]])
  * insert mapeq(#MOBL, [[Mobile Unit]], #15, [[Mobile Unit]])
  * insert mapeq(#WORK, [[work site]], #18, [[Place of Employment-]])
  * insert mapeq(#HOSP, [[Hospital]], #21, [[Inpatient Hospital]])
  * insert mapeq(#ER, [[Emergency room]], #23, [[Emergency Room - Hospital]])
  * insert mapeq(#SU, [[Surgery clinic]], #24, [[Ambulatory Surgical Center]])
  * insert mapwide(#MHSP, [[Military Hospital]], #26, [[Military Treatment Facility]])
  * insert mapeq(#SNF, [[Skilled nursing facility]], #31, [[Skilled Nursing Facility]])
  * insert mapwide(#NCCF, [[Nursing or custodial care facility]], #32, [[Nursing Facility]])
  * insert mapwide(#NCCF, [[Nursing or custodial care facility]], #33, [[Custodial Care Facility]])
  * insert mapwide(#AMB, [[Ambulance]], #41, [[Ambulance - Land]])
  * insert mapwide(#AMB, [[Ambulance]], #42, [[Ambulance - Air or Water]])
  * insert mapeq(#PHU, [[Psychiatric hospital unit]], #51, [[Inpatient Psychiatric Facility]])
  * insert mapeq(#RHII, [[intellectual impairment center]], #54, [[Intermediate Care Facility/ Individuals with Intellectual Disabilities]])
  * insert mapeq(#SURF, [[Substance use rehabilitation facility]], #55, [[Residential Substance Abuse Treatment Facility]])
  * insert mapeq(#PSYCHF, [[Psychatric Care Facility]], #56, [[Psychiatric Residential Treatment Center]])
  * insert mapeq(#RHU, [[Rehabilitation hospital unit]], #61, [[Comprehensive Inpatient Rehabilitation Facility]])
  * insert mapeq(#MBL, [[medical laboratory]], #81, [[Independent Laboratory]])
