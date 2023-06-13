# RMKMC_repetition
It is the repetition of RMKMC algorithm, The RMKMC algorithm is proposed by Cai, Nie, Huang in their paper "Multi-view K-Means Clustering on Big Data (2013)". You can find the original paper at http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.415.8610&rep=rep1&type=pdf.

This project references https://github.com/SHIZHE1011/RMKMCplus, which we have collated into MATLAB code.

The code is run by running 'demo.m'. The RMKMC algorithm can be viewed in 'RMKMC.m'.

The RMKMC algorithm replicated in this project has one major shortcoming in its implementation: we use a violent search method to find the minimum value of Eq(13) in the paper, which severely reduces the efficiency of the algorithm. We will be improved later.
