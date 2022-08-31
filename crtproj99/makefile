BINLIB = CMPSYS
LIBLIST=$(BIN_LIB)
SHELL=/QOpenSys/usr/bin/qsh

all: TestRpg.rpgle 

%.rpgle
  system -s "CHGATR OBJ('./qrpglesrc/$*.rpgle') ATR(*CCSID) VALUE(1253)"
  liblist -a $(LIBLIST);\
  system "CRTBNDRPG OBJ($(BIN_LIB)/$*) SRCSTMF('./qrpglesrc/$*.rpgle') COMMIT(*NONE) DEBUG(*SOURCE) OPTION(*EVENTF)"
