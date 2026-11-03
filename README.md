# CESR Server Guide.

Getting started with the CESR workstations. Written by J.C. Vaught.

## Getting Started.

Download the [Getting Started PDF](docs/getting-started.pdf). Its editable [LaTeX source](docs/getting-started.tex) is stored beside it.

The guide covers VS Code Remote SSH, terminal commands, a Python test, Git, and Python environments with uv, Conda, and Mamba. It uses 12-point text and one-inch margins.

## Student programs and installers.

The [hello.py](hello.py) program checks that Python runs on the remote workstation. The [git.sh](git.sh) and [miniforge.sh](miniforge.sh) installers run under your own account on the Linux workstations. Run them in the remote Linux terminal.

## Build the PDF.

With a suitable LaTeX installation, run these commands from the repository folder.

```sh
cd docs
latexmk -pdf getting-started.tex
```

The resulting PDF is written beside its source. LaTeX auxiliary files and local Python environments are ignored by Git.
