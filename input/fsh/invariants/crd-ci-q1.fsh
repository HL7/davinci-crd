Invariant: crd-ci-q1
Description: "Questionnaire and QuestionnaireResponse are only allowed when doc-needed exists and not equal to 'no' "
Severity: #error
Expression: "extension.where(url='questionnaire' or url='response').exists() implies (extension.where(url = 'doc-needed').exists() and extension.where(url = 'doc-needed').value.code != 'no')"

Invariant: crd-ci-q2
Description: "If covered is set to 'no', then 'pa-needed' should not exist."
Severity: #error
Expression: "extension.where(url = 'covered').value.code != 'no' implies extension.where(url = 'pa-needed').exists()"

Invariant: crd-ci-q3
Description: "If 'info-needed' exists, then at least one of 'covered', 'pa-needed', or 'doc-needed' must be 'conditional'."
Severity: #error
Expression: "extension.where(url = 'info-needed').exists() implies (extension.where(url = 'covered' or url = 'pa-needed' or url = 'doc-needed').value = 'conditional').count() >= 1"

Invariant: crd-ci-q4
Description: "If 'PA' is 'satisfied', then 'Doc-purpose' can't be 'PA'."
Severity: #error
Expression: "extension.where(url = 'pa-needed').value.code = 'satisfied' implies extension.where(url = 'doc-purpose').value.code != 'PA'"

Invariant: crd-ci-q5
Description: "'satisfied-pa-id' should only exist if 'pa-needed' is set to 'satisfied'."
Severity: #error
Expression: "extension.where(url = 'pa-needed').value.code = 'satisfied' implies extension.where(url = 'satisfied-pa-id').exists()"
