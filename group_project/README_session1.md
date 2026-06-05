# Group Project — Session 1: Get to know your dataset

This session is about exploring the dataset your group has been assigned.
You're not analyzing it yet — you're building a mental map of what's in it.
Open the CSVs in `data/group_a_yogurt/` or `data/group_b_menstruation/`,
read them into R, and look around. Use Pi to help you when something is
unclear.

## Questions to answer as a group

- How many tables are there in your dataset, and what does each one contain?
1- There are 8 tables across two data folders, 4 in each group. 
### Group A — Yogurt (data/group_a_yogurt/)                                                                                             
                                                                                                                                         
 ┌───┬──────────────────────────────────┬───────┬──────────────────────────────────────────────────────────────────────────────────────┐ 
 │ # │ File                             │ Rows  │ What's in it                                                                         │ 
 ├───┼──────────────────────────────────┼───────┼──────────────────────────────────────────────────────────────────────────────────────┤ 
 │ 1 │ 00_sample_ids_yogurt.csv         │ 102   │ Links each participant (pid) to their samples (sample_id) at different time points   │ 
 │   │                                  │       │ (baseline vs after_antibiotic), and which arm they were in (yogurt vs                │ 
 │   │                                  │       │ unchanged_diet)                                                                      │ 
 ├───┼──────────────────────────────────┼───────┼──────────────────────────────────────────────────────────────────────────────────────┤ 
 │ 2 │ 01_participant_metadata_yogurt.c │ 51    │ Info about each participant: age, education, birth control method, days since last   │ 
 │   │ sv                               │       │ sex                                                                                  │ 
 ├───┼──────────────────────────────────┼───────┼──────────────────────────────────────────────────────────────────────────────────────┤ 
 │ 3 │ 02_qpcr_results_yogurt.csv       │ 102   │ Bacterial load numbers from qPCR — total bacteria, L. crispatus, and L. iners per    │ 
 │   │                                  │       │ sample                                                                               │ 
 ├───┼──────────────────────────────────┼───────┼──────────────────────────────────────────────────────────────────────────────────────┤ 
 │ 4 │ 03_luminex_results_yogurt.csv    │ 1,020 │ Cytokine concentrations (IL-1a, IL-1b, IL-6, IL-8, IL-10, TNFa) — one row per        │ 
 │   │                                  │       │ cytokine per sample (long format), with a flag for whether the value was within      │ 
 │   │                                  │       │ limits or out of range                                                               │ 
 └───┴──────────────────────────────────┴───────┴──────────────────────────────────────────────────────────────────────────────────────┘ 
                                                                                                                                         
 ────────────────────────────────────────────────────────────────────────────────                                                        
                                                                                                                                         
 ### Group B — Menstruation (data/group_b_menstruation/)                                                                                 
                                                                                                                                         
 ┌───┬──────────────────────────────────┬──────┬───────────────────────────────────────────────────────────────────────────────────────┐ 
 │ # │ File                             │ Rows │ What's in it                                                                          │ 
 ├───┼──────────────────────────────────┼──────┼───────────────────────────────────────────────────────────────────────────────────────┤ 
 │ 1 │ 00_sample_ids_period.csv         │ 108  │ Links participants to samples with time points (onset, week_post, end_bleeding) and   │ 
 │   │                                  │      │ arm (birth_control vs no_birth_control)                                               │ 
 ├───┼──────────────────────────────────┼──────┼───────────────────────────────────────────────────────────────────────────────────────┤ 
 │ 2 │ 01_participant_metadata_period.c │ 27   │ Participant info: age, PCOS status (pcos or no disease), period product used (tampon, │ 
 │   │ sv                               │      │ pad, menstrual_cup)                                                                   │ 
 ├───┼──────────────────────────────────┼──────┼───────────────────────────────────────────────────────────────────────────────────────┤ 
 │ 3 │ 02_luminex_period.csv            │ 864  │ Same style as group A — cytokine levels in long format, but with a different labeling │ 
 │   │                                  │      │ for the limits column (not_censored, below_detection_limit). Also includes MIG and    │ 
 │   │                                  │      │ IFNg   
 │ 4 │ 03_flow_cytometry_period.csv     │ 108  │ Immune cell counts from flow cytometry — CD45⁺, CD3⁺, CD4⁺ T cells, CD8⁺ T cells,     │ 
 │   │                                  │      │ neutrophils, etc. One row per sample                                                  │ 
 │               │ Yogurt                     │ Menstruation                                                                        
 │ Sample IDs    │ 102 records, 2 time points │ 108 records, 3 time points                                                            
 │ Participants  │ 51                         │ 27                                                             
 │ Luminex       │ 1,020 rows, 6 cytokines    │ 864 rows, 8 cytokines                                                                   
 │ Unique assays │ qPCR + Luminex             │ Luminex + Flow cytometry   │     
- For each table, what does **one row** represent? (the unit of observation)

2- One row reoresent One sample, One participant, one cytokine measurement

- For each table, what does **each column** mean? Which columns are
  categorical, which are numeric, which are identifiers?
3- Yogurt: 
pid, sample_id = identifier; 
time_point, cytokine, limits, arm, birth_control, education, sex = categorical; 
age, days_since_last_sex, qpcr_bacteria, qpcr_crispatus, qpcr_iners, conc = numeric.

Mentruation: 
pid, sample_id = identifier; 
time_point, cytokine, pcos_status, period_product, limits, arm, birth_control, education, sex = categorical; 
age, live_cd19_negative, cd45_negative, cd45_positive, neutrophils, cd3_negative, cd3_positive, cd4_t_cells, cd8_t_cells, conc = numeric.

- How are the tables linked to each other? What column(s) would you use to
  join them?

  4- it's possible to join pid for to add participant information, and sample_id to connect the essay results to the correct sample. 

- How many participants are in the study? How many observations per
  participant?

  5- Yogurt: 
  51 participants;
  2 samples per participant;
  2 qPCR rows per participant
  20 Luminex rows per participant

  Mentruation:
  27 participants;
  4 samples per participant;
  4 Flpw cytometry rows per participant
  32 Luminex rows per participant

- How are the numeric variables distributed? Are any heavily skewed? Do any
  have suspicious values?

  6- Yogurt:
  qpcr_bacteria: mean=9.4M; median=2.2M
  qpcr_crispatus: 65% of sample are 0. 
  qpcr_iners: mean=292; median=32
  suspicious: Luminex yogurt for IL-10 is out of range

Mentruation:
cd4_t_cells: min=37, max=425

- Where are the missing values, and what do you think they mean?
There are zero NA values anywhere in the dataset. all 8 tables are fully complete, no missing participant, no missing measurements. 

- What do you **not** understand about the dataset yet?

# Load the CSV files from both groups                                                                                                   
 # Group A — Yogurt study                                                                                                                
 sample_ids_yogurt <- read.csv("data/group_a_yogurt/00_sample_ids_yogurt.csv")                                                       
 participant_meta_yogurt <- read.csv("data/group_a_yogurt/01_participant_metadata_yogurt.csv")                                           
 qpcr_results_yogurt <- read.csv("data/group_a_yogurt/02_qpcr_results_yogurt.csv")                                                     
 luminex_yogurt <- read.csv("data/group_a_yogurt/03_luminex_results_yogurt.csv")