PIP := .env/bin/pip
PYTHON := .env/bin/python

env:
	echo "Create virtual environment..."
	virtualenv .env -p python3

rmenv:
	echo "Remove virtual environment..."
	rm -rf .env

# compile requirements.txt from requirements.in using pip-compile
compile_recs:
	$(PIP) install pip-tools
	.env/bin/pip-compile -o requirements.txt requirements.in

system_pkgs:
	sudo apt install libsndfile1

reqs:
	echo "Install python packages..."
	$(PIP) install -r requirements.txt --no-cache-dir
	.env/bin/jupyter contrib nbextension install --user

download:
	echo "Downloading the data..."
	mkdir -p data
	wget -O "data/annotations.csv" "https://zenodo.org/record/3873076/files/annotations.csv?download=1"
	wget -O "data/audio-eval-0.tar.gz" "https://zenodo.org/record/3873076/files/audio-eval-0.tar.gz?download=1"
	wget -O "data/audio-eval-1.tar.gz" "https://zenodo.org/record/3873076/files/audio-eval-1.tar.gz?download=1"
	wget -O "data/audio-eval-2.tar.gz" "https://zenodo.org/record/3873076/files/audio-eval-2.tar.gz?download=1"
	wget -O "data/audio.tar.gz" "https://zenodo.org/record/3873076/files/audio.tar.gz?download=1"
	wget -O "data/dcase-ust-taxonomy.yaml" "https://zenodo.org/record/3873076/files/dcase-ust-taxonomy.yaml?download=1"
	wget -O "data/README.md" "https://zenodo.org/record/3873076/files/README.md?download=1"
	wget -O "data/unpack_audio.sh" "https://zenodo.org/record/3873076/files/unpack_audio.sh?download=1"

extract:
	echo "Extracting the files..."
	tar -xzvf data/audio-eval-0.tar.gz -C data/
	tar -xzvf data/audio-eval-1.tar.gz -C data/
	tar -xzvf data/audio-eval-2.tar.gz -C data/
	tar -xzvf data/audio.tar.gz -C data/
	mv data/audio-eval-0/*.wav data/audio/
	mv data/audio-eval-1/*.wav data/audio/
	mv data/audio-eval-2/*.wav data/audio/

logmel:
	echo "Computing log-mel spectrograms..."
	$(PYTHON) 01-compute-log-mel.py

install: env reqs
	:

prep: download extract logmel
	:

