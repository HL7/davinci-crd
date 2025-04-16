Instance: example-of-NutritionOrder
InstanceOf: CRDNutritionOrder
Title: "NutritionOder example"
Description: "Example nutrition order populated based on CRD profile"
Usage: #example
* id = "example"
* identifier
  * system = "http://example.org/nutrition-requests"
  * value = "123"
* status = #draft
* intent = #order
* patient = Reference(Patient/example)
* encounter = Reference(Encounter/example)
* dateTime = "2014-09-17"
* orderer = Reference(Practitioner/full)
* allergyIntolerance = Reference(http://example.org/fhir/AllergyIntolerance/example) "Cashew Nuts"
* foodPreferenceModifier = $diet#dairy-free
* excludeFoodModifier = $sct#227493005 "Cashew Nut"
* oralDiet
  * type[0] = $sct#15108003 "Restricted fiber diet"
    * text = "Fiber restricted diet"
  * type[+] = $sct#16208003 "Low fat diet"
    * text = "Low fat diet"
  * schedule.repeat
    * boundsPeriod.start = "2015-02-10"
    * frequency = 3
    * period = 1
    * periodUnit = #d
  * nutrient
    * modifier = $sct#256674009 "Fat"
    * amount = 50 'g' "grams"