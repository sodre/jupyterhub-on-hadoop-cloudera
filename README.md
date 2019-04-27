# jupyterhub-on-hadoop-cloudera
This repo generates the JupyterHub Parcel and CSD(Custom Service Descriptor) to support 
@jimcrist's jupyter-on-hadoop effort. Ideally, this repo will move under the 
jupyterhub-on-hadoop repo.

Documentation in this repo is strictly restricted to the generation of parcels and CSDs.
For instructions on how to use them in your Cloudera Cluster, please refer to the
[Jupyter-on-Hadoop Docs][1]


## Getting started
  1. Update the git submodules.
     ```bash
     git submodule update --init
     ```
  2. Install and activate the development conda environment 
     ```bash
     conda env create
     conda activate cloudera-dev
     ```
  3. Compile and Install the Cloudera's Extension Tools
     ```bash
     pushd cm_ext 
     
     mvn -DskipTests install 
     mkdir -p $CONDA_PREFIX/lib/cloudera
     cp -f validator/target/validator.jar $CONDA_PREFIX/lib/cloudera/
     
     install ../bin/validator.sh $CONDA_PREFIX/bin
     install make_manifest/make_manifest.py $CONDA_PREFIX/bin
     
     popd
     ```
     
## Buiding a new Parcel
  1. Add/Replace/Update JupyterHub requirements by editing the
     `parcel/environment.yml` conda-environment file.
  2. Run `build.py`
     ```
     cd parcels
     ./build.py
     ```

## Use python's built-in httpserver to serve the parcels to CM
```bash
  python -m http.server --directory parcels --port 14156
```

  [1]: https://jcrist.github.io/jupyterhub-on-hadoop/