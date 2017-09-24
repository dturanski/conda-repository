FROM continuumio/miniconda:latest
COPY *.py /
COPY *.sh /
RUN chmod o+x /*.py; chmod o+x /*.sh
RUN conda update conda --yes
ENV CHANNEL http://conda:8000/functions
ENV PACKAGE_NAME="sample"
ENTRYPOINT ["./function-runner.sh"]
CMD []
