<h2 align="center">
🏗 Under construction ... 🏗️
</h2>

# accpkgs

A collection of accelerator physics packages.

## Work in progress ...

### Build elegant from source

see: https://www.aps.anl.gov/Accelerator-Operations-Physics/Software/installationGuide_Linux


```
export HOST_ARCH="linux-x86_64"
export EPICS_HOST_ARCH="linux-x86_64"
export RPN_DEFNS="~/.defns.rpn"
```

```
curl -OJ https://ops.aps.anl.gov/downloads/epics.base.configure.tar.gz
curl -OJ https://ops.aps.anl.gov/downloads/defns.rpn
curl -OJ https://ops.aps.anl.gov/downloads/elegant.2021.4.0.tar.gz

curl -OJ https://ops.aps.anl.gov/downloads/epics.extensions.configure.tar.gz
curl -OJ https://ops.aps.anl.gov/downloads/SDDS.5.1.tar.gz
```

```
tar xf epics.base.configure.tar.gz
tar xf epics.extensions.configure.tar.gz
```
