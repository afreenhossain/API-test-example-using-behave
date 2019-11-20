# API-test-example-using-behave
API testing using python's [behave](https://github.com/behave/behave) library

## Requirements
1. Python 3.x.x. ([here](https://realpython.com/installing-python/#step-2-run-the-installer) is a documentation for different OS)
3. (optional). Virtual environment for the project. I personally use [pyenv](https://github.com/pyenv) along with [virtualenv](https://github.com/pyenv/pyenv-virtualenv)

## Setup
1. Install requirements
```bash
pip install -r requirements.txt
```
2. Setting base URL.
 Copy `sample_env` file and save it as `.env` in the same directory. Then replace `BASE_URL` with desired server URL.

## Running
```bash
behave
```
For more details go [here](https://github.com/behave/behave)

Alternatively you can run without a `.env` file if you set the BASE_URL in the OS environment as variable. So the following will also work,
```bash
BASE_URL=http://preview.airwallex.com:30001 behave
```
