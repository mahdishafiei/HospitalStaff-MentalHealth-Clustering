#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Mental Health Clustering Visualization Script
Reproduces figures from the paper: "Mental health outcomes of hospital staff during the COVID-19 pandemic in Iran"

Created on Sat Jul 1 14:11:50 2023
@author: mahdishafiei
Updated: 2024 - Repository version
"""

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import os
from pathlib import Path

# Set up output directory
output_dir = Path("../results/figures")
output_dir.mkdir(parents=True, exist_ok=True)

# Set style for publication-quality figures
plt.style.use('seaborn-v0_8-whitegrid')
plt.rcParams['figure.dpi'] = 300
plt.rcParams['savefig.dpi'] = 300
plt.rcParams['font.size'] = 12

# Figure 1: Mean GHQ-28 Total Scores by Cluster
# Data from the paper (approximate values)
categories1 = ['Cluster 1', 'Cluster 2', 'Cluster 3']
values1 = [30, 53, 12]  # Mean GHQ-28 total scores

# Create the plot
plt.figure(figsize=(8, 6))
bars = plt.bar(categories1, values1, color=['#2E9FDF', '#E7B800', '#00AFBB'], alpha=0.8)

# Adding labels and title
plt.title('Mean GHQ-28 Total Scores by Cluster', fontsize=14, fontweight='bold')
plt.ylabel('Mean GHQ-28 Total Score', fontsize=12)
plt.xlabel('Cluster', fontsize=12)

# Add value labels on bars
for bar, value in zip(bars, values1):
    plt.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.5, 
             f'{value}', ha='center', va='bottom', fontweight='bold')

plt.tight_layout()
plt.savefig(output_dir / 'figure1_ghq_scores_by_cluster.png', bbox_inches='tight')
plt.savefig(output_dir / 'figure1_ghq_scores_by_cluster.pdf', bbox_inches='tight')
plt.show()

####################################

# Figure 2: Job Distribution by Cluster (Stacked Bar Plot)
# Data from the paper
categories2 = ['Cluster 1', 'Cluster 2', 'Cluster 3']
nurses = [195, 81, 226]
physicians = [67, 16, 38]
lab_experts = [23, 6, 9]
midwives = [46, 25, 39]

# Create stacked bar plot
plt.figure(figsize=(10, 6))
colors = ['#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4']

plt.bar(categories2, nurses, label='Nurses', color=colors[0])
plt.bar(categories2, physicians, bottom=nurses, label='Physicians', color=colors[1])
plt.bar(categories2, lab_experts, bottom=[i+j for i,j in zip(nurses, physicians)], 
        label='Laboratory Experts', color=colors[2])
plt.bar(categories2, midwives, bottom=[i+j+k for i,j,k in zip(nurses, physicians, lab_experts)], 
        label='Midwives', color=colors[3])

plt.title('Job Distribution by Cluster', fontsize=14, fontweight='bold')
plt.ylabel('Number of Participants', fontsize=12)
plt.xlabel('Cluster', fontsize=12)
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.tight_layout()
plt.savefig(output_dir / 'figure2_job_distribution_by_cluster.png', bbox_inches='tight')
plt.savefig(output_dir / 'figure2_job_distribution_by_cluster.pdf', bbox_inches='tight')
plt.show()

#############################

# Figure 3: Education Level Distribution by Cluster
categories3 = ['Cluster 1', 'Cluster 2', 'Cluster 3']
bachelor = [322, 140, 364]
masters = [89, 30, 80]
phd_higher = [38, 7, 21]
diploma = [48, 14, 69]

# Create stacked bar plot
plt.figure(figsize=(10, 6))
colors = ['#FF9F43', '#10AC84', '#EE5A24', '#C44569']

plt.bar(categories3, bachelor, color=colors[0], label='Bachelor')
plt.bar(categories3, masters, color=colors[1], bottom=bachelor, label='Masters')
plt.bar(categories3, phd_higher, color=colors[2], bottom=[i+j for i,j in zip(bachelor, masters)], 
        label='PhD and Higher')
plt.bar(categories3, diploma, color=colors[3], bottom=[i+j+k for i,j,k in zip(bachelor, masters, phd_higher)], 
        label='Diploma')

plt.title('Education Level Distribution by Cluster', fontsize=14, fontweight='bold')
plt.ylabel('Number of Participants', fontsize=12)
plt.xlabel('Cluster', fontsize=12)
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
plt.tight_layout()
plt.savefig(output_dir / 'figure3_education_distribution_by_cluster.png', bbox_inches='tight')
plt.savefig(output_dir / 'figure3_education_distribution_by_cluster.pdf', bbox_inches='tight')
plt.show()

#############

# Figure 4: Direct COVID-19 Exposure by Cluster (Horizontal Stacked Bar)
categories4 = ['Cluster 1', 'Cluster 2', 'Cluster 3']
no_exposure = [21, 21, 33]  # Percentage with no direct exposure
yes_exposure = [79, 79, 67]  # Percentage with direct exposure

# Convert to numpy arrays
no_exposure = np.array(no_exposure)
yes_exposure = np.array(yes_exposure)

# Create horizontal stacked bar chart
plt.figure(figsize=(10, 6))
colors = ['#E74C3C', '#2ECC71']

plt.barh(categories4, no_exposure, color=colors[0], label='No Direct Exposure')
plt.barh(categories4, yes_exposure, left=no_exposure, color=colors[1], label='Direct Exposure')

plt.title('Direct COVID-19 Exposure by Cluster', fontsize=14, fontweight='bold')
plt.xlabel('Percentage (%)', fontsize=12)
plt.ylabel('Cluster', fontsize=12)
plt.legend()
plt.tight_layout()
plt.savefig(output_dir / 'figure4_direct_exposure_by_cluster.png', bbox_inches='tight')
plt.savefig(output_dir / 'figure4_direct_exposure_by_cluster.pdf', bbox_inches='tight')
plt.show()

###########################

# Figure 5: Previous Mental Health Problems (PMHP) by Cluster
categories5 = ['Cluster 1', 'Cluster 2', 'Cluster 3']
no_pmhp = [98, 96, 98]  # Percentage with no previous mental health problems
yes_pmhp = [2, 4, 2]    # Percentage with previous mental health problems

# Convert to numpy arrays
no_pmhp = np.array(no_pmhp)
yes_pmhp = np.array(yes_pmhp)

# Create horizontal stacked bar chart
plt.figure(figsize=(10, 6))
colors = ['#3498DB', '#E74C3C']

plt.barh(categories5, no_pmhp, color=colors[0], label='No Previous Mental Health Problems')
plt.barh(categories5, yes_pmhp, left=no_pmhp, color=colors[1], label='Previous Mental Health Problems')

plt.title('Previous Mental Health Problems by Cluster', fontsize=14, fontweight='bold')
plt.xlabel('Percentage (%)', fontsize=12)
plt.ylabel('Cluster', fontsize=12)
plt.legend()
plt.tight_layout()
plt.savefig(output_dir / 'figure5_pmhp_by_cluster.png', bbox_inches='tight')
plt.savefig(output_dir / 'figure5_pmhp_by_cluster.pdf', bbox_inches='tight')
plt.show()

print("All figures have been generated and saved to ../results/figures/")
print("Generated files:")
print("- figure1_ghq_scores_by_cluster.png/pdf")
print("- figure2_job_distribution_by_cluster.png/pdf")
print("- figure3_education_distribution_by_cluster.png/pdf")
print("- figure4_direct_exposure_by_cluster.png/pdf")
print("- figure5_pmhp_by_cluster.png/pdf")
