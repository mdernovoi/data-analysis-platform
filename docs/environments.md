
# Custom Docker Environments

Reference the `README` of the `src/environments` directory in the `data-analysis-platform` repository for further info.

Since many Python and R packages require **system-level dependencies**, which can not be managed with `venv` or `renv`, full-fledged docker **containers** are used for **development** and repeatable **execution in GitLab pipelines**.

The idea is to reduce the gap between development and production environments by using the same containers for both purposes. Therefore, if something works during development, it will also work when the model is deployed to production.

To fully utilize the potential of a unified environment, **SSH** and a **Jupyter Server** are exposed, allowing for remote development. These containers look just like regular machines for an IDE with remote development capabilities such as **DataSpell** (recommended), **PyCharm**, or **VSCode**. 

The IDE handles all data transfers, remote execution, and debugging while the code remains on your local machine. Therefore, if something goes wrong, you can just recreate the development containers and rerun your code. 

**NOTE**: These containers can be used independently of the Data Analysis Platform. You can host them on GitHub and Docker Hub or build and run them on your local PC.



