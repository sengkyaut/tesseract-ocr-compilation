#!/bin/bash
patch /usr/share/tesseract-ocr/tesstrain_utils.sh -i ${SCRIPTS_DIR}/tesstrain_utils.patch
patch ${BASE_DIR}/tesseract/src/training/unicharset/validate_myanmar.cpp -i ${SCRIPTS_DIR}/validate_myanmar.patch
