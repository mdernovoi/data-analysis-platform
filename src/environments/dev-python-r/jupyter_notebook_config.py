# Configuration file for jupyter-notebook.

c = get_config()  #noqa

## The IP address the notebook server will listen on.
#  Default: 'localhost'
c.NotebookApp.ip = '*'

## Whether to open in a browser after starting.
#                          The specific browser used is platform dependent and
#                          determined by the python standard library `webbrowser`
#                          module, unless it is overridden using the --browser
#                          (NotebookApp.browser) configuration option.
#  Default: True
c.NotebookApp.open_browser = False

## Hashed password to use for web authentication.
#  
#  To generate:
#
#   1) Install prerequisites: `sudo apt-get install python3 python3-pip python3-venv`
#   2) Create python virtual environment: `python3 -m venv .venv`
#   3) Activate the virtual environment: `source .venv/bin/activate`
#   4) Install Jupyter Notebook: `pip install notebook`
#   5) Generate hashed password with value from `secrets/jupyter_notebook_password.txt`: 
#       `python3`
#       `from notebook.auth import passwd; passwd()`
#   6) Copy the output to the `c.NotebookApp.password` field of this config.
#
# TODO: generate and insert dynamically
c.NotebookApp.password = {{TODO:REPLACE}} 

## Forces users to use a password for the Notebook server.
#                        This is useful in a multi user environment, for instance when
#                        everybody in the LAN can access each other's machine through ssh.
#  
#                        In such a case, serving the notebook server on localhost is not secure
#                        since any user can connect to the notebook server via ssh.
#  Default: False
# c.NotebookApp.password_required = False

## The port the notebook server will listen on (env: JUPYTER_PORT).
#  Default: 8888
c.NotebookApp.port = 8888


