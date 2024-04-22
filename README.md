# HArmonic DEcomposition of Spacetime

![cover](HADES_front_github.png)

Code related to the paper titled "[The flattening of spacetime hierarchy of the DMT brain state is characterised by harmonic decomposition of spacetime (HADES) framework]((https://academic.oup.com/nsr/advance-article/doi/10.1093/nsr/nwae124/7640873))"

The Harmonic Decomposition of Spacetime (HADES) framework that characterises how different harmonic modes defined in space are expressed over time. Here applied to the DMT dataset

## Folder descriptions

1. `data/`: folder containing data for the different steps of the HADES pipleine - decomposition, projections, dataset analysis and plotting
2. `utils/`: folder containing matlab functions for the different steps of the HADES pipleine - decomposition, projections, dataset analysis and plotting
3. `results/`: folder containing various outputs for the different steps of the HADES pipleine - decomposition, projections, dataset analysis and plotting
4. `figures/`: folder containing figures for the different steps of the HADES pipleine - decomposition, projections, dataset analysis and plotting

## File descriptions

1. `p0_HCP_denseFC_2_vertices.m`: MATLAB script to load the dense FC
2. `p1_HADES_basis_denseFC_vertex_on_HCP.m`: MATLAB scripts to run the laplace decomposition on the dense FC
3. `p2_HADES_plotting_basis.m`: MATLAB script to plot the functional harmonics on the cortical surface
4. `p3_HADES_DMT_FMRI_main_projectFH.m`: MATLAB script to project functional harmonics onto the timeseries
5. `p4_HADES_DMT_spatiotemporal_analysis.m`: MATLAB script to calculate the spatio-temporal analysis
6. `p5_HADES_DMT_dynamic_analysis_publication.m`: MATLAB script to calculate dynamic analysis
7. `p6_HADES_DMT_latent_space_analysis_publication.m`: MATLAB script to calculate latent space analysis analysis

1. `DMT_FMRI_main_projectsFH`: MATLAB script to run the Functional Harmonic projections to the DMT dataset
1. `DMT_FMRI_main_projectsFH`: MATLAB script to run the Functional Harmonic projections to the DMT dataset

## Installation
Simply download the repository to get started. Inside each code file, you'll find comments and documentation to guide you through usage.
The repository serves as standalone for the HADES method. Please Consult the documentiaton for further guidance

## Downloading data
Due to their privacy the DMT data is available upon request from the original authors of the experiment.
To derive the Functional Harmonics, the HCP dataset was used. As the file size exceeds github limit we share OSF repository where the additional files can be accessed.
Important: Certain parts of generate_paper_figures.m and generate_paper_suppfigures.m rely on this OSF-hosted data. Ensure it's saved in the correct folders for smooth script execution.

## Original data
The original empirical data stem from the Human Connectome Project. Refer to the provided link for comprehensive access, licensing, and usage terms.
## Dependencies
Before running demo_eigenmode_calculation.sh, surface_eigenmodes.py, or volume_eigenmodes.py:

Install SPM12 and load the module to matlab.
Some MATLAB-based scripts rely on external packages. Copies are stored in utils/ for version compatibility. Visit the provided links for detailed information and support.
gifti
cifti
spider plots - from Matlab repository - [spider_plots](https://uk.mathworks.com/matlabcentral/fileexchange/59561-spider_plot)
Atasoy et al. scripts based on papers on connectome harmonics. ([Atasoy2016](https://www.nature.com/articles/ncomms10340), [Atasoy2017](https://doi.org/10.1038/s41598-017-17546-0), [Atasoy2018](https://doi.org/10.1016/bs.pbr.2018.08.009))
## Compatibility
Codes are tested on MATLAB versions R2023b.

## Citation
[Article] J. Vohryzek,J. Cabral, C. Timmermann, S. Atasoy, L. Roseman, D.J. Nutt, R.L. Carhart-Harris, G. Deco, M.L. Kringelbach, The flattening of spacetime hierarchy of the DMT brain state is characterised by harmonic decomposition of spacetime (HADES) framework, NSR (2023) (DOI: [10.1093/nsr/nwae124](https://academic.oup.com/nsr/advance-article/doi/10.1093/nsr/nwae124/7640873))

[Preprint] J. Vohryzek,J. Cabral, C. Timmermann, S. Atasoy, L. Roseman, D.J. Nutt, R.L. Carhart-Harris, G. Deco, M.L. Kringelbach, Harmonic decomposition of spacetime (HADES) framework characterises the spacetime hierarchy of the DMT brain state, bioRxiv (2023) (DOI: [10.1101/2023.08.20.554019](https://www.biorxiv.org/content/10.1101/2023.08.20.554019v1.abstract))

## Further details
contact jakub.vohryzek@upf.edu
