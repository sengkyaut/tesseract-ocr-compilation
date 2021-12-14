#!/bin/bash

#docker exec -it t4cmp sh scripts/compile_leptonica.sh && \
sudo docker exec -it skt4cmp sh scripts/compile_tesseract.sh && \
sudo docker exec -it skt4cmp tesseract \-v
