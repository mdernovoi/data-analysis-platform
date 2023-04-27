

# Data Analysis Platform

Welcome to the Data Analysis Platform repository!

The Data Analysis Platform is a powerful and versatile infrastructure framework designed to help data analysts of every kind achieve reproducibility and streamline their workflows. Statistical evaluations, Business Intelligence (BI), Machine Learning (ML), and  Deep Learning (DL): everything is possible. With this platform, you can easily manage and track experiments, collaborate with team members, and build flexible and powerful pipelines based on GitLab.

This platform is entirely **technology agnostic**, making it suitable for use with any tool or language (BYOS - Bring Your Own Software principle). It is also designed with enterprise use in mind and offers easy deployment and built-in security features.


## Usage

For installation and usage instructions consult the documentation in the `doc/` directory.

Start here:

- [How does the Data Analysis Platform work](doc/architecture.md)
- [Initial installation and provisioning](doc/provision.md)

## Improvements and Suggestions

Please suggest any improvements or express wishes in the Issues section. A pull request with a corresponding implementation or fix is not required but would be appreciated.

## Roadmap

### Important

- [ ] Remove the requirement of public TLS certificates either by integrating self-signed certificates or implementing a no-tls option.
- [ ] Write thorough documentation and some HowTos.

### Security

- [ ] Secure the ssh config of the dev-base environment container.
- [ ] Hide the GitLab container registry behind the reverse proxy (currently, it is exposed due to compatibility issues).
    - Idea: Set server location in Minio.
- [ ] Consider adding TLS to Jupyter Notebooks in environment containers for remote development access.

### Less important

- [ ] Configure dependabot version alerts.
- [ ] Add a `CONTRIBUTING.md` file describing how to contribute to the project.
- [ ] Update `SECURITY.md` with concrete contact details.
- [ ] Add automated tests.

### Least important

- [ ] Use multi-stage Docker builds for environment containers to reduce image sizes.
- [ ] Render documentation on GitHub Pages or readthedocs.io

## Sponsors

- [Marine- und Automatisierungstechnik Rostock GmbH](https://mar-hro.de/en/)

