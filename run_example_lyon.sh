set -e

## Prepare
cd /home/ubuntu/irtx-parcels
mkdir /home/ubuntu/irtx-parcels/output

## Create environment
conda env create -f environment.yml -n parcels

## Activate environment
conda activate parcels

## Generate parcels
papermill "Generate Parcels.ipynb" /dev/null \
  -pinput_path /home/ubuntu/irtx-synpop/output \
  -poutput_path /home/ubuntu/irtx-parcels/output \
  -pinput_prefix lead_2022_100pct_ \
  -poutput_prefix lead_2022_ \
  -pscaling 1.0

papermill "Generate Parcels.ipynb" /dev/null \
  -pinput_path /home/ubuntu/irtx-synpop/output \
  -poutput_path /home/ubuntu/irtx-parcels/output \
  -pinput_prefix lead_2030_100pct_ \
  -poutput_prefix lead_2030_ \
  -pscaling 2.0
