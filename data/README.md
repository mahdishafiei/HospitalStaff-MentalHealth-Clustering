# Data Directory

This folder is a placeholder for the GHQ-28 survey data and any derived datasets.
**Raw, individual-level data should NOT be committed** unless fully anonymized and cleared for public release.

## Expected File (example)
- `ghq28_responses.csv` — one row per participant. Example columns:
  - `id` (optional, anonymized)
  - `gender` (Male/Female)
  - `marital_status` (Single/Married)
  - `education_level` (High school/Diploma/Bachelor/Masters/PhD+)
  - `smoking` (No/Yes)
  - `direct_exposure` (No/Yes) - Direct exposure to COVID-19 patients
  - `chronic_disease` (No/Yes) - Previous chronic diseases
  - `job` (Physician/Nurse/Laboratory Expert/Midwife/Nurse Assistance/Other)
  - `ghq1` ... `ghq28` — Likert-scored GHQ-28 items (0-3 scale)
  - `ghq_somatic` — Somatic symptoms subscale (items 1-7)
  - `ghq_anxiety` — Anxiety/insomnia subscale (items 8-14)
  - `ghq_social` — Social dysfunction subscale (items 15-21)
  - `ghq_depression` — Severe depression subscale (items 22-28)
  - `ghq_total` — Total GHQ-28 score

## Data Availability
As stated in the paper, datasets are available from the corresponding author upon reasonable request.

## Privacy
Ensure all data are de-identified and compliant with applicable regulations and IRB/ethics approvals.