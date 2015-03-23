#----------------------------------------------------------------------
SWIG_DIR=/home/yunheo1/tool/swig/v3p0p5/install/bin
#----------------------------------------------------------------------

CC=g++
CFLAGS=-Wall -O3 -std=c++11
SRC_DIR=src
LIB_DIR=lib
BIN_DIR=bin

all: generate-a-single generate-q-single reconstruct q-to-q-paired q-to-q-single q-to-a-paired q-to-a-single remove-postfix-lsc remove-postfix-proovread sam-paired evaluate

generate-a-single: $(SRC_DIR)/generate-map.from-fasta.single.common.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/generate-map.from-fasta.single.common $(SRC_DIR)/generate-map.from-fasta.single.common.o

generate-q-single: $(SRC_DIR)/generate-map.from-fastq.single.common.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/generate-map.from-fastq.single.common $(SRC_DIR)/generate-map.from-fastq.single.common.o

reconstruct: $(SRC_DIR)/reconstruct-genome.rna.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/reconstruct-genome.rna $(SRC_DIR)/reconstruct-genome.rna.o

q-to-q-paired: $(SRC_DIR)/write-order-file.from-fastq.to-fastq.paired.common.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/write-order-file.from-fastq.to-fastq.paired.common $(SRC_DIR)/write-order-file.from-fastq.to-fastq.paired.common.o

q-to-q-single: $(SRC_DIR)/write-order-file.from-fastq.to-fastq.single.common.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/write-order-file.from-fastq.to-fastq.single.common $(SRC_DIR)/write-order-file.from-fastq.to-fastq.single.common.o

q-to-a-paired: $(SRC_DIR)/write-order-file.from-fastq.to-fasta.paired.common.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/write-order-file.from-fastq.to-fasta.paired.common $(SRC_DIR)/write-order-file.from-fastq.to-fasta.paired.common.o

q-to-a-single: $(SRC_DIR)/write-order-file.from-fastq.to-fasta.single.common.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/write-order-file.from-fastq.to-fasta.single.common $(SRC_DIR)/write-order-file.from-fastq.to-fasta.single.common.o

remove-postfix-lsc: $(SRC_DIR)/remove-postfix.fasta.single.lsc.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/remove-postfix.fasta.single.lsc $(SRC_DIR)/remove-postfix.fasta.single.lsc.cpp

remove-postfix-proovread: $(SRC_DIR)/remove-postfix.fasta.single.proovread.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/remove-postfix.fasta.single.proovread $(SRC_DIR)/remove-postfix.fasta.single.proovread.cpp

sam-paired: $(SRC_DIR)/write-order-file.sam.paired.common.o
	$(CC) $(CFLAGS) -o $(BIN_DIR)/write-order-file.sam.paired.common $(SRC_DIR)/write-order-file.sam.paired.common.o

$(SRC_DIR)/generate-map.from-fasta.single.common.o: $(SRC_DIR)/generate-map.from-fasta.single.common.cpp
	$(CC) $(CFLAGS) -c -o $@ $?

$(SRC_DIR)/generate-map.from-fastq.single.common.o: $(SRC_DIR)/generate-map.from-fastq.single.common.cpp
	$(CC) $(CFLAGS) -c -o $@ $?

$(SRC_DIR)/reconstruct-genome.rna.o: $(SRC_DIR)/reconstruct-genome.rna.cpp
	$(CC) $(CFLAGS) -c -o $@ $?

$(SRC_DIR)/remove-postfix.fasta.single.lsc.o: $(SRC_DIR)/remove-postfix.fasta.single.lsc.cpp
	$(CC) $(CFLAGS) -c -o $@ $?

$(SRC_DIR)/remove-postfix.fasta.single.proovread.o: $(SRC_DIR)/remove-postfix.fasta.single.proovread.cpp
	$(CC) $(CFLAGS) -c -o $@ $?

$(SRC_DIR)/write-order-file.from-fastq.to-fastq.paired.common.o: $(SRC_DIR)/write-order-file.from-fastq.to-fastq.paired.common.cpp
	$(CC) $(CFLAGS) -c -o $@ $?

$(SRC_DIR)/write-order-file.from-fastq.to-fastq.single.common.o: $(SRC_DIR)/write-order-file.from-fastq.to-fastq.single.common.cpp
	$(CC) $(CFLAGS) -c -o $@ $?

$(SRC_DIR)/write-order-file.from-fastq.to-fasta.paired.common.o: $(SRC_DIR)/write-order-file.from-fastq.to-fasta.paired.common.cpp
	$(CC) $(CFLAGS) -c -o $@ $?

$(SRC_DIR)/write-order-file.from-fastq.to-fasta.single.common.o: $(SRC_DIR)/write-order-file.from-fastq.to-fasta.single.common.cpp
	$(CC) $(CFLAGS) -c -o $@ $?

$(SRC_DIR)/write-order-file.sam.paired.common.o: $(SRC_DIR)/write-order-file.sam.paired.common.cpp
	$(CC) $(CFLAGS) -c -o $@ $?

$(SRC_DIR)/evaluate.o: $(SRC_DIR)/evaluate.cpp
	$(CC) -O3 -std=c++11 -c `perl -MConfig -e 'print join(" ", @Config{qw(ccflags optimize cccdlflags)}, "-I$$Config{archlib}/CORE")'` -o $@ $?

$(SRC_DIR)/evaluate-wrap.o: swig
	$(CC) -O3 -std=c++11 -c `perl -MConfig -e 'print join(" ", @Config{qw(ccflags optimize cccdlflags)}, "-I$$Config{archlib}/CORE")'` -o $@ $(SRC_DIR)/evaluate-wrap.cpp

swig:
	$(SWIG_DIR)/swig -perl5 -c++ -o $(SRC_DIR)/evaluate-wrap.cpp $(LIB_DIR)/evaluate.i
	mv $(SRC_DIR)/evaluate.pm $(LIB_DIR)

evaluate: $(SRC_DIR)/evaluate.o $(SRC_DIR)/evaluate-wrap.o
	$(CC) -O3 -std=c++11 `perl -MConfig -e 'print $$Config{lddlflags}'` -o $(LIB_DIR)/evaluate.so $?
	chmod 644 $(LIB_DIR)/evaluate.so

clean:
	rm -f $(BIN_DIR)/generate-map.from-fasta.single.common
	rm -f $(BIN_DIR)/generate-map.from-fastq.single.common
	rm -f $(BIN_DIR)/reconstruct-genome.rna
	rm -f $(BIN_DIR)/remove-postfix.fasta.single.common
	rm -f $(BIN_DIR)/write-order-file.from-fastq.to-fastq.paired.common
	rm -f $(BIN_DIR)/write-order-file.from-fastq.to-fastq.single.common
	rm -f $(BIN_DIR)/write-order-file.from-fastq.to-fasta.paired.common
	rm -f $(BIN_DIR)/write-order-file.from-fastq.to-fasta.single.common
	rm -f $(BIN_DIR)/write-order-file.sam.paired.common
	rm -f $(SRC_DIR)/*.o
	rm -f $(LIB_DIR)/evaluate.so
	rm -f $(SRC_DIR)/evaluate-wrap.cpp
	rm -f $(LIB_DIR)/evaluate.pm
