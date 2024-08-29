ValueSet: CRDServiceRequestCodes
Id: serviceRequestCodes
Title: "CRD Service Request Codes Value Set"
Description: "Example value set defines a set of CPT, SNOMED CT, HCPCS Level II and LOINC codes mirroring bindings found in the US Core Procedure and Observation Lab profiles"
* ^status = #active
* ^experimental = false
* ^copyright = "Current Procedural Terminology (CPT) is copyright 2020 American Medical Association. All rights reserved. This value set includes content from SNOMED CT, which is copyright © 2002+ International Health Terminology Standards Development Organisation (IHTSDO), and distributed by agreement between IHTSDO and HL7. Implementer use of SNOMED CT is not covered by this agreement. This material contains content from LOINC (http://loinc.org). LOINC is copyright © 1995-2020, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at http://loinc.org/license. LOINC® is a registered United States trademark of Regenstrief Institute, Inc."
* include codes from system $cpt
* include codes from system SNOMED_CT where concept is-a #71388002
* include codes from system $HCPCSReleaseCodeSets
* include codes from system $loinc