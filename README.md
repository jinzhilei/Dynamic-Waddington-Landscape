# Dynamic Waddington Epigenetic Landscape — Simulation Code

Numerical simulations for the paper:

  **"A unified cross-scale framework for the dynamic Waddington epigenetic landscape"**
  Yuling Xue and Jinzhi Lei
  School of Mathematical Sciences, Tiangong University, Tianjin, China.

## Overview

This repository contains MATLAB code that numerically solves a unified
PDE-integral framework coupling a Fokker-Planck equation (governing
stochastic gene regulatory network dynamics) with a mechanistic,
probability-conserving proliferation operator. The population probability
density function f(x,t) yields the dynamic Waddington landscape
U(x,t) = -log f(x,t).

The governing equation (Ito form) is

    f_t = -div(F_tilde * f) + div div(D_tilde * f) + R[f],

where F_tilde is the Itô drift in epigenetic coordinates, D_tilde is the
state-dependent diffusion tensor, and R[f] is the proliferation operator
encoding cell division, apoptosis, and mitotic epigenetic inheritance.

## Requirements

- MATLAB R2018b or later
- Statistics and Machine Learning Toolbox (for gammpdf)

## Repository Structure

```
code/
  Single-gene/          -- 1-D gene regulatory network (single-gene model)
  Binary-genes/         -- 2-D gene regulatory network (binary-gene model)
```

### Single-gene model (1-D)

Models a single epigenetic coordinate with the gene circuit

    dX/dt = g0 + g1 * X^4/(k2^4 + X^4) - k1*X + noise,

mapped to epigenetic coordinates via x = log(1+X).  This is the
canonical bistable / multistable single-gene autoregulation model used
for Figures 2 and Supplementary Figures S1-S3.

Key files:

  main.m                  Main entry point; runs Flag=0,1,2 simulations
  parameter.m             Model parameters (proliferation, death, kinetics)
  Control.m               Simulation controls (time, grid, stopping criteria)
  Solve_Equation.m        Time-stepping solver (core loop)
  One_Step_Update.m       Single time-step: drift + diffusion + proliferation
  fsolve_Update.m         Proliferation operator R[f] for Flags 0-3
  F_tilde_function.m      Itô drift in epigenetic coordinates
  D_tilde_function.m      Diffusion coefficient in epigenetic coordinates
  CN.m                    Upwind discretization matrix for diffusion operator
  p.m                     Epigenetic inheritance kernel (Gaussian mixture)
  mybeta.m                Proliferation rate function (Flag-dependent)
  mykappa.m               Exit/removal rate function (Flag-dependent)
  Integrate.m             Numerical integration (trapezoidal rule)
  FindDelay.m             Delay buffer for cell-cycle time tau
  Initializationf.m       Load and normalize initial probability density
  dataanalysis.m          Plot time-series profiles and convergence errors
  figure2f.m              Data for Fig. 2 panels (left/right basin init.)
  FigureS1.m              Grid-convergence study (upwind scheme)
  figureS2.m              Parameter sweep: beta and kappa dependence
  figureS3.m              Inheritance kernel sensitivity study
  RunR0.m / RunRbar.m / RunR_full.m / RunR_star.m
                          Standalone runners for individual proliferation operators

Flags (control proliferation operator R[f]):

  Flag 0:  R[f] = 0 (no proliferation; pure Fokker-Planck dynamics)
  Flag 1:  Rbar[f]  (homogeneous proliferation rate betabar)
  Flag 2:  Rfull[f] (state- and population-dependent proliferation + death)
  Flag 3:  beta* Rbar[f] (constant beta, with inheritance kernel)

### Binary-genes model (2-D)

Models a two-dimensional gene regulatory network with two epigenetic
coordinates, representing a lineage bifurcation circuit with mutual
 repression / activation.  Used for figures involving 2-D landscape
surfaces.

Key files:

  main.m                  Main entry point; runs Flag=0,1 simulations
  parameter.m             2-D model parameters (GRN + cell cycle)
  Control.m               Simulation controls (2-D grid)
  Solve_Equation.m        2-D time-stepping solver
  One_Step_Update.m       Red-black Gauss-Seidel solver for 2-D PDE
  F1_tilde_function.m     Drift in x1 direction
  F2_tilde_function.m     Drift in x2 direction
  D_tilde.m               Diffusion coefficient (scalar, state-dependent)
  Lambda_function.m       Diagonal of discretized diffusion operator
  ac_function.m           Off-diagonal coefficients for GS iteration
  beta.m                  2-D proliferation rate function
  kappa.m                 2-D exit rate function
  RF.m                    2-D proliferation operator R[f]
  GQ.m                    2-D cell cycle source term
  p.m / p1.mat / p2.mat   2-D epigenetic inheritance kernel
  dataanalysis.m          2-D surface plotting and error analysis
  Initializationf.m       Normalize initial condition
  FindDelay.m             Delay buffer (2-D)
  rename_*.py             Utility scripts for renaming data files

## How to Run

### Single-gene model

1. Navigate to the Single-gene directory:

       cd Single-gene

2. Prepare initial data (if not already present):

       % Run Initializationsetting.m to generate initial condition files
       % in the Initf/ subdirectory.

3. Run the main simulation:

       main

   This runs Flags 0, 1, 2 sequentially and writes output to
   output/R0/, output/R1/, output/R2/.
   If the program prompts that the output directory does not exist,
   you need to create the corresponding output data directory first.

4. Generate specific figures:

       figure2f          % Fig. 2 data (left/right basin splits)
       FigureS1          % Supp. Fig. S1 (upwind convergence)
       figureS2          % Supp. Fig. S2 (beta/kappa sweep)
       figureS3          % Supp. Fig. S3 (inheritance kernel)
       RunR0             % Standalone: Flag 0 only
       RunRbar           % Standalone: Flag 1 only
       RunR_full         % Standalone: Flag 2 only
       RunR_star         % Standalone: Flag 3 (pssi parameter sweep)

5. Analyze results:

       dataanalysis

### Binary-genes model

1. Navigate to the Binary-genes directory:

       cd Binary-genes

2. Run the main simulation:

       main(0)           % Flag 0: no self-activation
       main(1)           % Flag 1: with self-activation

3. Analyze 2-D results:

       dataanalysis

## Output Files

Each simulation produces .dat files in space-time format:

  md-{Flag}-f.dat        Population density f(t, x)       [n_t x (n_x+1)]
  md-{Flag}-Q.dat        Quiescent cell density Q(t, x)   [n_t x (n_x+1)]
  md-{Flag}-Qsum.dat     Total cell number Qsum(t)        [n_t x 3]
  md-{Flag}-Rf.dat       Proliferation operator R[f](t,x) [n_t x (n_x+1)]

The first column is time; subsequent columns are spatial values.

## Numerical Methods

- Spatial discretization: Upwind scheme for convection, central
  difference for diffusion, on a uniform grid.
- Time integration: Forward Euler (explicit) for single-gene;
  implicit red-black Gauss-Seidel iteration for binary-genes.
- Boundary conditions: No-flux (zero probability current) at domain
  boundaries.
- Stopping criteria: Fixed final time (MD.T) or steady-state detection
  (f-error below MD.steadyTolerance).
- Probability normalization: Applied at each output step to ensure
  integral(f) = 1.

## Parameters

Core parameters are defined in parameter.m for each model.  Key
parameters include:

  g0, g1          Gene expression basal / maximal rates
  k1, k2          Degradation / Hill constants
  D               Molecular noise intensity
  betabar         Base proliferation rate
  kappa0          Basal exit (apoptosis/differentiation) rate
  tau             Cell cycle duration (delay)
  mu              Apoptosis rate during proliferation
  pssi0, pssi1    Inheritance kernel shape parameters
  zzeta           Mitotic noise level

## Citation

If you use this code in your research, please cite:

  Xue, Y. & Lei, J. (2026). A unified cross-scale framework for the
  dynamic Waddington epigenetic landscape. Preprint.

## Authors

- Yuling Xue (lead developer)
- Jinzhi Lei (PI, corresponding author: jzlei@tiangong.edu.cn)

School of Mathematical Sciences, Tiangong University, Tianjin, China.
Center for Applied Mathematics, Tiangong University.
