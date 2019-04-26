# jupyterhub-parcel

## Clone the submodules
```bash
git submodule update --init
```

## Create and activate the parcel-dev environment
```bash
conda env create -f parcel-dev.yaml
conda activate parcel-dev
```

## Compile the validator.jar
```bash
cd cm_ext && mvn install -q cm_ext && cd ..
```

```bash
# Generate the jupyterhub environment
conda env create .

# Generate the parcel-meta file
conda-env-to-parcel

# Use conda-pack to generate the parcel tar.gz
```
