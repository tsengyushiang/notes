# Setup Latex Docker Container

### Create Dockerfile

`Dockerfile`

```Dockerfile
FROM leplusorg/latex
RUN apt-get update && apt-get install -y fonts-noto-cjk
```

- Package `fonts-noto-cjk` is used to compile chinese, if you don't need just remove the command.

### Build Image

```
docker build -t my-latex-image .
```

### Preparing LaTex Files

- Copy example from following link and renamed it `entry.tex`.

    - [Tree Graph](./examples/forest.md)

### Compile LaTex to PDF

```
docker run --rm -v ./:/tmp my-latex-image latexmk -outdir=/tmp -pdfxe /tmp/entry.tex
```

- `-pdfxe` use compiler XeLaTex, I use it for package `\usepackage{xeCJK}`
- You can use `-pdf` instead to use compiler pdfLaTex.
