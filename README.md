# jupyterhub-parcel

JupyterHub in a parcel!

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

## Build the parcel
```bash
ipython main.ipynb
```

## Use python's built-in httpserver to serve the parcels to CM
```bash
python -m http.server --directory parcels --port 14156
```
