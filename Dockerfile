#
# Docker image for compiling Tesseract 4 (and Leptonica) from source code.
# Includes SSH Server (root password is toor).
# https://github.com/tesseract-ocr/tesseract/wiki/Compiling#linux
# http://www.leptonica.org/source/README.html
#

ARG RELEASE=latest

FROM ubuntu:${RELEASE}

ENV TZ=Asia/Yangon
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
	autoconf autoconf-archive automake build-essential checkinstall \
	cmake g++ git pkg-config wget xzgv zlib1g-dev \
	libtesseract-dev libcairo2-dev libicu-dev libjpeg-dev libpango1.0-dev \
	libgif-dev libwebp-dev libopenjp2-7-dev libpng-dev libtiff-dev libtool \
	tesseract-ocr-mya tesseract-ocr-script-mymr

# SSH for diagnostic
RUN apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:toor' | chpasswd
#RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN echo "export PATH=$PATH:/usr/share/tesseract-ocr" >> /etc/profile
RUN echo "export TESSDATA_PREFIX=/usr/share/tesseract-ocr/4.00/tessdata" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

# Directories
ENV SCRIPTS_DIR /root/scripts
ENV PKG_DIR /root/pkg
ENV BASE_DIR /root/workspace
ENV LEP_REPO_URL https://github.com/DanBloomberg/leptonica.git
ENV LEP_SRC_DIR ${BASE_DIR}/leptonica
ENV TES_REPO_URL https://github.com/tesseract-ocr/tesseract.git
ENV TES_SRC_DIR ${BASE_DIR}/tesseract
ENV TESSDATA_PREFIX /usr/share/tesseract-ocr/4.00/tessdata
ENV MYOCR_URL https://github.com/sengkyaut/MyOCR
ENV MYOCR_SRC_DIR ${BASE_DIR}/MyOCR

RUN mkdir ${SCRIPTS_DIR}
RUN mkdir ${PKG_DIR}
RUN mkdir ${BASE_DIR}


COPY ./container-scripts/* ${SCRIPTS_DIR}/
RUN chmod +x ${SCRIPTS_DIR}/*
RUN ${SCRIPTS_DIR}/repos_clone.sh

#Patching
COPY ./patch_files/* ${SCRIPTS_DIR}/
RUN chmod +x ${SCRIPTS_DIR}/*.sh
RUN ${SCRIPTS_DIR}/start_patch.sh

WORKDIR /root
