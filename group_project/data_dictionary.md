# Data Dictionary — Group A: Yogurt Study

## Overview

This dataset comes from a study about **yogurt consumption and the vaginal microbiome**.
There are **51 participants**, each sampled at two time points (baseline + after antibiotics),
for a total of **102 samples**. About half ate yogurt; the other half kept their normal diet.

---

## 1. `00_sample_ids_yogurt.csv` (102 rows + header | 4 columns)

**One row =** one sample collected from a participant at one time point.

| Column      | Description |
|-------------|---|
| `pid`       | Participant ID (e.g. `pid_25`). Links to the metadata file. |
| `time_point`| `baseline` or `after_antibiotic` — when the sample was taken. |
| `arm`       | Study group: `yogurt` (ate yogurt) or `unchanged_diet` (control). |
| `sample_id` | Unique sample code (e.g. `UNCH001`, `YOG002`). Links to lab results. |

- 52 yogurt samples, 50 unchanged diet samples
- 51 baseline, 51 after antibiotic

---

## 2. `01_participant_metadata_yogurt.csv` (51 rows + header | 7 columns)

**One row =** one participant enrolled in the study.

| Column               | Description |
|----------------------|---|
| `pid`                | Participant ID. Matches the `pid` in the sample IDs file. |
| `arm`                | `yogurt` or `unchanged_diet`. 26 yogurt, 25 control. |
| `days_since_last_sex`| Days since last sexual encounter (whole number). |
| `birth_control`      | Type of birth control (e.g. `no hormonal birth control`, `Depoprovera`). |
| `age`                | Age in years. |
| `education`          | Education level (e.g. `less than grade 9`, `grade 10-12, matriculated`). |
| `sex`                | All participants are `female`. |

---

## 3. `02_qpcr_results_yogurt.csv` (102 rows + header | 4 columns)

**One row =** qPCR results from one sample (measures bacterial DNA).

| Column            | Description |
|-------------------|---|
| `sample_id`       | Which sample this came from. Links to the sample IDs file. |
| `qpcr_bacteria`   | Total bacterial DNA (copy count — large numbers). |
| `qpcr_crispatus`  | DNA of *Lactobacillus crispatus* (good bacteria, linked to vaginal health). 0 = not detected. |
| `qpcr_iners`      | DNA of *Lactobacillus iners* (a less protective *Lactobacillus* species). |

---

## 4. `03_luminex_results_yogurt.csv` (1020 rows + header | 4 columns)

**One row =** one cytokine measurement from one sample (long format).

| Column      | Description |
|-------------|---|
| `sample_id` | Which sample. Links to the sample IDs file. |
| `cytokine`  | The immune signaling molecule measured. 10 types: `IFN-Y`, `IL-10`, `IL-1a`, `IL-1b`, `IL-6`, `IL-8`, `IP-10`, `MIG`, `MIP-3a`, `TNFa`. |
| `conc`      | Concentration of that cytokine (in the Luminex assay units). |
| `limits`    | `within limits` (reliable) or `out of range` (couldn't measure accurately). |

(102 samples × 10 cytokines = 1020 rows.)

---

## How the four files connect

```
01_participant_metadata (51 participants)
      │ pid matches
      ▼
00_sample_ids (102 samples)
      │ sample_id matches
      ▼
   ├── 02_qpcr_results (102 rows — 1 per sample)
   └── 03_luminex_results (1020 rows — 10 per sample)
```