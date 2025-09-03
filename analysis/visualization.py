#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul 1 14:11:50 2023
@author: mahdishafiei
"""

import matplotlib.pyplot as plt
import numpy as np

# Figure 1: Simple Bar Graph
# Sample data
categories1 = ['Cluster 1', 'Cluster 2', 'Cluster 3']
values1 = [30, 53, 12]

# Plotting the bar graph
plt.bar(categories1, values1)

# Adding labels and title
plt.ylabel('Scores')

# Displaying the graph
plt.show()

####################################

# Figure 2: Stacked Bar Plot
# Sample data
categories2 = ['Cluster 1', 'Cluster 2', 'Cluster 3']
values2_1 = [195, 81, 226]
values2_2 = [67, 16, 38]
values2_3 = [23, 6, 9]
values2_4 = [46, 25, 39]

# Plotting the stacked bar plot
plt.bar(categories2, values2_1, label='Nurses')
plt.bar(categories2, values2_2, bottom=values2_1, label='Physician')
plt.bar(categories2, values2_3, bottom=[i+j for i,j in zip(values2_1, values2_2)], label='Laboratory expert')
plt.bar(categories2, values2_4, bottom=[i+j+k for i,j,k in zip(values2_1, values2_2, values2_3)], label='Midwife')

plt.ylabel('Count')
plt.legend()
plt.show()

#############################

# Figure 3: Improved Stacked Bar Plot with Different Colors
categories3 = ['Cluster 1', 'Cluster 2', 'Cluster 3']
values3_1 = [322, 140, 364]
values3_2 = [89, 30, 80]
values3_3 = [38, 7, 21]
values3_4 = [48, 14, 69]

# Plotting the stacked bar plot with different colors
plt.bar(categories3, values3_1, color='coral', label='Bachelor')
plt.bar(categories3, values3_2, color='aqua', bottom=values3_1, label='Masters')
plt.bar(categories3, values3_3, bottom=[i+j for i,j in zip(values3_1, values3_2)], label='PhD and higher')
plt.bar(categories3, values3_4, color='magenta', bottom=[i+j+k for i,j,k in zip(values3_1, values3_2, values3_3)], label='Diploma')

plt.ylabel('Count')
plt.legend()
plt.show()

#############

# Figure 4: Horizontal Stacked Bar Chart
# Sample data
categories4 = ['Cluster 1', 'Cluster 2', 'Cluster 3']
values4_1 = [21, 21, 33]
values4_2 = [79, 79, 67]

# Convert the data to numpy arrays
values4_1 = np.array(values4_1)
values4_2 = np.array(values4_2)

# Plotting the horizontal stacked bar chart
plt.barh(categories4, values4_1, label='Direct exposure = -')
plt.barh(categories4, values4_2, left=values4_1, label='Direct exposure = +')

# Adding labels and title
plt.xlabel('Percent')

# Adding a legend
plt.legend()

# Displaying the graph
plt.show()

###########################

# Figure 5: Improved Horizontal Stacked Bar Chart with Different Colors
# Sample data
categories5 = ['Cluster 1', 'Cluster 2', 'Cluster 3']
values5_1 = [98, 96, 98]
values5_2 = [2, 4, 2]

# Convert the data to numpy arrays
values5_1 = np.array(values5_1)
values5_2 = np.array(values5_2)

# Plotting the horizontal stacked bar chart with different colors
plt.barh(categories5, values5_1, color='navy', label='PMHP = -')
plt.barh(categories5, values5_2, color='red', left=values5_1, label='PMHP = +')

# Adding labels and title
plt.xlabel('Percent')

# Adding a legend
plt.legend()

# Displaying the graph
plt.show()
