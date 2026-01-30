Instance: crd-client-actor
InstanceOf: ActorDefinition
Title: "CRD Client"
Usage: #definition
* id = "crd-client"
* url = "http://hl7.org/fhir/us/davinci-crd/ActorDefinition/crd-client"
* name = "CRDClientActor"
* description = "A system (or collection of systems) responsible for invoking CRD calls and responding to queries from a CRD Server."
* type = #system
* derivedFrom[+] = "http://hl7.org/fhir/us/davinci-hrex/ActorDefinition/consumer"
* derivedFrom[+] = "http://hl7.org/fhir/us/davinci-hrex/ActorDefinition/source"
* derivedFrom[+] = "http://hl7.org/fhir/us/davinci-hrex/ActorDefinition/disc-client"
* insert CommonActor

Instance: crd-client-org-actor
InstanceOf: ActorDefinition
Title: "CRD Client Organization"
Usage: #definition
* id = "crd-client-org"
* url = "http://hl7.org/fhir/us/davinci-crd/ActorDefinition/crd-client-org"
* name = "CRDClientOrgActor"
* description = "The legal entity responsible for configuring, running, and making the decisions around the use of a CRD Client system"
* type = #person
* insert CommonActor

Instance: crd-server-actor
InstanceOf: ActorDefinition
Title: "CRD Server"
Usage: #definition
* id = "crd-server"
* url = "http://hl7.org/fhir/us/davinci-crd/ActorDefinition/crd-server"
* name = "CRDServerActor"
* description = "A system (or collection of systems) responsible for responding to CRD calls."
* type = #system
* derivedFrom[+] = "http://hl7.org/fhir/us/davinci-hrex/ActorDefinition/consumer"
* derivedFrom[+] = "http://hl7.org/fhir/us/davinci-hrex/ActorDefinition/source"
* derivedFrom[+] = "http://hl7.org/fhir/us/davinci-hrex/ActorDefinition/disc-server"
* insert CommonActor

Instance: crd-server-org-actor
InstanceOf: ActorDefinition
Title: "CRD Server Organization"
Usage: #definition
* id = "crd-server-org"
* url = "http://hl7.org/fhir/us/davinci-crd/ActorDefinition/crd-server-org"
* name = "CRDServerOrgActor"
* description = "The legal entity responsible for configuring, running, and making the decisions around the use of a CRD Server system"
* type = #person
* insert CommonActor

RuleSet: CommonActor
* status = #active
* experimental = false
* date = "2022-11-25"