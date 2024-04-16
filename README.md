# GROWI Cloudron App

This repository contains the Cloudron app package source for [GROWI](https://github.com/weseek/growi)

## Installation

Install using the [Cloudron command line tooling](https://cloudron.io/references/cli.html)

```
cloudron install --image registry.tld/image:0.1.0
```

## Building

The app package can be built using the [Cloudron command line tooling](https://cloudron.io/references/cli.html).

```
cd open-webui-cloudron

cloudron build
cloudron install
```

## Update checklist

* [ ] Upgrade `version` in `CloudronManifest.json`
* [ ] Upgrade `VERSION` argument in `Dockerfile`

# Known Issues

- [ ] File uploading and plugin installation issue | See [#2](/../../issues/2)
- [ ] Embed elasticsearch in the package to allow searching for pages
- [ ] Inject SMTP variables | See upstream [Discussion #8729](https://github.com/weseek/growi/discussions/8729)
