# Adaptive data collection for intra-individual studies affected by adherence

Code related to the paper "Adaptive data collection for intra-individual studies affected by adherence" (Monacelli et al., 2022). The code was developed and executed with the R version 4.0.5 (2021.03.31).  

## Usage

The structure of the code is detailed in the following graph.

https://github.com/AI-for-Better-Living/adc-tinnitus/blob/main/code_structure1.png

In particular, the figures and tables in the paper were obtained through the following scripts. 

| Results  |  Scripts          |
| -------- | ---------------   |
| Figure 1 |  do_problem.R.    | 
| Figure 2 |  reprgraph.R      | 
| Figure 3 |  ecdfs.R.         |
| Figure 4 |  hist_adherence.R | 
| Table 1  |  wlc_sim.R.       |
| Table 2  | wlc_real.R        |


Table 2 and a portion of Figure 3 can not be replicated by the user because of privacy issues with the tinnitus dataset. Nevertheless, the code which produced them is included. Algorithm 1 and Algorithm 2 of the paper are implemented, respectively, in the scripts "trigger0.R" and "trigger1.R".

## Contact

Greta Monacelli (greta.monacelli2@mail.dcu.ie)




