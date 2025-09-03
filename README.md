# Mental health outcomes of hospital staff during the COVID-19 pandemic in Iran

This repository accompanies the open-access article published in **BMC Health Services Research (2023) 23:1447**:
- DOI: 10.1186/s12913-023-10430-w

The study evaluates the mental health of hospital staff (nurses and physicians) during COVID-19 in Iran using the GHQ-28 questionnaire and **K-means clustering** to uncover latent patterns in responses and demographics.

## Repository Structure

```
mental-health-covid19-hospital-staff/
│
├── README.md                    # This file
├── LICENSE                      # MIT License
├── requirements.txt             # Python dependencies
├── environment.yml              # Conda environment
├── data/
│   └── README.md               # Data documentation and schema
├── analysis/
│   ├── clustering.R            # Main R analysis script
│   ├── visualization.py        # Python visualization script
│   └── notebooks/
│       └── exploratory_analysis.ipynb  # Jupyter notebook
├── results/
│   ├── figures/                # Generated plots and figures
│   └── tables/                 # Generated tables and summaries
└── paper/
    ├── README.md               # Paper information
    └── s12913-023-10430-w.pdf  # Published paper
```



## How to Reproduce

### Option A: R (recommended for parity with the paper)
1. Install R (≥ 4.0) and run the setup script:
   ```bash
   Rscript setup.R
   ```
   Or manually install packages:
   ```r
   install.packages(c("tidyverse", "cluster", "factoextra", "ggplot2", "readr"))
   ```
2. Place your **anonymized** GHQ-28 dataset at `data/ghq28_responses.csv`.
3. Run the main analysis:
   ```bash
   Rscript analysis/clustering.R
   ```
4. Outputs (figures and tables) will be written to `results/`.

### Option B: Python (for exploration)
1. Set up Python environment:
   ```bash
   # Using pip
   pip install -r requirements.txt
   
   # Or using conda
   conda env create -f environment.yml
   conda activate mental-health-clustering
   ```
2. Run the visualization script:
   ```bash
   cd analysis
   python visualization.py
   ```
3. Open `analysis/notebooks/exploratory_analysis.ipynb` and run the cells.
   It demonstrates the Elbow method and KMeans with `k=3` on a GHQ-like schema.

## Expected Data Schema (example)
- Demographics: `gender`, `marital_status`, `education_level`, `smoking`, `direct_exposure`, `chronic_disease`, `job`
- GHQ-28 items: `ghq1 ... ghq28` (Likert scores; higher indicates greater distress)

## Notes
- The article is licensed under **CC BY 4.0** and included in `/paper`.
- Patient-level data are **not** included here.
- If you use this repository, please cite the paper 



## Citation

If you use this repository, please cite the following paper:

```bibtex
@article{salehi2023mental,
  title={Mental health outcomes of hospital staff during the COVID-19 pandemic in Iran},
  author={Salehi, Sahar and Jamali, Maryam and Shafiei Neyestanak, Mahdi and Amjaz, Milad Safaei and Baigi, Vali and Yekaninejad, Mir Saeed},
  journal={BMC Health Services Research},
  volume={23},
  number={1},
  pages={1447},
  year={2023},
  publisher={Springer Nature},
  doi={10.1186/s12913-023-10430-w}
}
```

