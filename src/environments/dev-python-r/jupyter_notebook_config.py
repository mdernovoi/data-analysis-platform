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
#                        To generate, type in a python/IPython shell:
#  
#                          from notebook.auth import passwd; passwd()
#  
#                        The string should be of the form type:salt:hashed-
#  password.
#  Default: ''

# Reference: secrets/jupyter_notebook_password.txt
# TODO: insert dynamically
c.NotebookApp.password = 'argon2:$argon2id$v=19$m=10240,t=10,p=8$9BGVnM6SZ7ukiJ4pizD9MA$KjoSD/HNoGJ9oUN+QvYXCRPCYX6Wqz5F9c6066gOKHI'

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


