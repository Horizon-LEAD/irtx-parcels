# IRTX Synthetic parcel model

## Introduction

The present model uses a synthetic population to generate the daily parcel
demand of a region. While it is based on marginal survey data from France,
it can theoretically be applied to other use cases as well.

The basic idea is to take a list of synthetic (or real) households and persons
including their sociodemographic attributes. Those should include *household size*,
*socioprofessional category* (following the French defintiion), and *age* per person.

After, an Iterative Proportional Fitting procedure is applied to the data to attach
an average number of parcels per year to each household, based on the sociodemographic
attributes. This value is then transformed into an average number of parcels per
day for each household, which, in a final step, is transformed into a discrete value
using a Poisson sampling process. The methodology is described in detail in

> Hörl, S., Puchinger, J., 2022. From synthetic population to parcel demand: A modeling pipeline
and case study for last-mile deliveries in Lyon. Paper accepted for presentation at the Transport Research Arena (TRA) 2022, November 2022, Lisbon.

## Requirements

### Software requirements

The model is packaged as a `Jupyter` notebook. All dependencies to run the model
have been collected in a `conda` environment, which is available in the LEAD
repository as `environment.yml`:

```bash
conda env create -n parcels -f environment.yml
```

### Input / Output

#### Input

To run the model, a synthetic population (for instance, as created by the IRTX
population synthesis model), needs to be located in an arbitrary directory denoted
by `/path/to/input`. The structure of this directory should look as follows:

```
/path/to/input/lead_homes.gpkg
/path/to/input/lead_persons.csv
/path/to/input/lead_activities.csv
```

#### Output

The output of the model is one geographic file that contains for each household
with at least one parcel that has been generated for the synthetic day:

- Coordinates (location) of the household
- Number of parcels to be delivered
- Identifier of the household to link back to the synthetic population

Assuming that `/path/to/output` has been defined as the output path of the model
(see below), the resulting file will be created as `/path/to/output/lead_parcels.gpkg`.

# Running the model

To run the model, the `conda` environment needs to be prepared and entered. After,
the model is packaged as a `jupyter` notebook which can be run programmatically
using `papermill`, which is part of the environment dependencies. Including the
full set of command line options, the model can be run as follows:

```bash
papermill "Generate Parcels.ipynb" /dev/null \
  -pinput_path /home/ubuntu/parcels/input \
  -poutput_path /home/ubuntu/parcels/input \
  -pinput_prefix lead_ \
  -poutput_prefix lead_ \
  -prandom_seed 0 \
  -pscaling 1.0
```

The **mandatory** parameters are detailed in the following table:

Parameter             | Values                            | Description
---                   | ---                               | ---
`input_path`          | String                            | Path to the input directory containing the synthetic population
`output_path`         | String                            | Path to the output directory into which the parcel data will be written (can be the same)

The following **technical** parameters are available:

Parameter             | Values                            | Description
---                   | ---                               | ---
`input_prefix`          | String (default `lead_`)        | Defines which prefix the population input files have
`output_prefix`         | String (default `lead_`)        | Defines which prefix the parcel output file will have

Using these parameters, one can, for instance, process `xyz_persons.csv` and write `abc_parcels.gpkg` in the same directory, depending on which population scenarios should be read and which parcel scenario should be written.

Finally, **scenario** parameters exist that can be configured:

Parameter             | Values                            | Description
---                   | ---                               | ---
`random_seed`         | Integer (default `0`)             | Allows to generate instances with different random variation
`scaling`             | Real (default `1.0`)              | Allows to uniformly scale up or down the total parcel demand

## Standard scenarios

For the Lyon living lab, some standard scenarios can be run:

- Using an unscaled output from the population synthesis model to create the baseline parcel demand for 2022.
- Using an unscaled output from the population synthesis model to create the parcel demand for 2030, with an increase of parcel by a factor of two.

The scaling factor could also be an input to create multiple different scenarios on the LEAD platform.

**Baseline demand 2022**

```
-pinput_path /path/to/irtx-synpop-output \
-poutput_path /path/to/output \
-pinput_prefix lead_2022_100pct_ \
-poutput_prefix lead_2022_ \
-pscaling 1.0
```
**Future demand 2030**

```
-pinput_path /path/to/irtx-synpop-output \
-poutput_path /path/to/output \
-pinput_prefix lead_2030_100pct_ \
-poutput_prefix lead_2030_ \
-pscaling 2.0
```
