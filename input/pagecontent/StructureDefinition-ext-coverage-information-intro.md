<!--- Text entered into this file will appear at the top of the profiles page before the Formal Views of the profile content. -->

<div class="new-content" markdown="1">
### Introduction

This extension is added to FHIR Request and other resources as part of the CRD [Coverage Information Response Type](cards.html#coverage-information-response-type).

The process of describing the applicable coverage rules for a given product or service can be complex, so this extension includes
quite a few components.

The primary purpose of this extension is to convey three things:
1. Is the product/service covered under the patient's coverage? (**covered**)
2. If covered (or possibly covered), under the patient's coverage, is prior authorization necessary? (**pa-needed**)
3. Is there additional information that needs to be covered that will be needed for: prior authorization processing, claims adjudication, appropriate use review, by the performer for any of the preceding reasons, or for some other purpose? (**doc-needed**)

All of the remaining elements are used to provide support for those three primary elements.  There are several types of support.

<a name="scoping"> </a>
#### Scoping elements
These elements limit the applicability of the statement being made.  For example, if the statement is "covered, no prior authorization required", that assertion could be based on certain assumptions, such as the service being billed in a particular way or being performed in a particular time period time.  There can be multiple coverage-information repetitions that each have distinct scoping elements.  When this occurs, the interpretation is "if the scoping elements for the first coverage-information are true, the rules for coverage/authorization/etc. are defined in that coverage-information instance, otherwise keep looking for rules in subsequent coverage repetitions".  The union of the scoping elements in each coverage-information repetition **SHOULD** be disjoint.  I.e. for a given performed service, there should be a single coverage-information repetition that applies.

NOTE: The coverage information repetitions may not provide full coverage.  For example, it is possible that the eventual billed code will fall outside the list of billing codes and/or date ranges of any of the coverage-information repetitions present.  In that situation, no inference can be made about the coverage, prior authorization, or documentation requirements for the performed service.

* **billingCode** indicates the specific billing (codes) the coverage assertion applies to.  This reflects the fact that the code used for an ordered product or service could vary from the ordered code.  This is especially useful if the ordered code is not already a 'billing' code, but even if the ordered code _is_ a billing code, the performed code might still vary.
* **detail** can have multiple uses.  If the `detail.category` is 'limitation', then it acts as a scoping limitation.  For example, limitation to quantity or performance period
* **dependency** indicates that the assertion is dependent on the occurrence of one or more other orders.  For example, coverage for post-surgery rehabilitation might be dependent on the associated surgery proceeding as planned
* **expiry-date** is the date after which the provided coverage information should no longer be considered valid (typically when the patient's coverage ends or when coverage policies could change)

<a name="detail"> </a>
#### Detail elements
These elements provide additional details about the assertion being made, such as what type of documentation is needed.

* **doc-purpose** indicates the purposes for which additional documentation is needed when _doc-needed_ is indicated
* **info-needed** indicates the nature of additional information that is necessary to make a decision about coverage, prior authorization, or documentation in situations where one or more of _covered_, _pa-needed_, or _doc-needed_ is set to 'conditional'.
* **reason** indicates why the coverage decisions made apply.  These would typically be reasons for no coverage, why prior auth is necessary, or why documentation is needed. But it could also convey why prior authorization is NOT necessary (e.g. gold carded provider).  If one or more of the key decisions is "conditional", this will convey the details of the rules.  If there are multiple reason repetitions, each repetition **SHOULD** make clear exactly what aspect of the coverage information assertion the reason applies to.
* **detail** can have multiple uses.  If the `detail.category` is 'decisional' or 'other', then the information provides additional detail, such as instructions for claim or authorization submission, copay information, etc.
* **questionnaire** indicates the questionnaire(s) to be completed in situations where _doc-needed_ is flagged.  (Note that DTR is capable of determining the set of questionnaires if they are not listed in the coverage-information extension.)
* **satisfied-pa-id** is the authorization number that applies if the _pa-needed_ element is 'satisfied'

<a name="metadata"> </a>
#### Metadata elements
Additional information related to this specific coverage assertion, such as when it was made or where to reach out for additional details.

* **date** indicates when the assertion was made
* **coverage-assertion-id** is a unique number for the coverage assertion
* **contact** is how to reach out if there are questions or a need for additional support with respect to the provided coverage information
* **coverage** indicates which insurance coverage the coverage information applies to.  (In some cases, a service might make assertions for multiple coverages.)

</div>
