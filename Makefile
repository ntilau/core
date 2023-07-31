.SUFFIXES: .cpp .o

ARCH = $(shell uname -m)
#ARCH = aarch64
PLAT = $(shell uname -s | tr '[:upper:]' '[:lower:]')-gnu
# PLAT = w64-mingw32
EXTRA = 
# EXTRA = -lpsapi -liphlpapi

BIN = fes$(VER)

CC = $(ARCH)-$(PLAT)-g++ -w

INCDIR = -I./dep/include
LIBDIR = -L./dep/lib/$(ARCH)-$(PLAT)/

BINDIR  = ./bin/$(ARCH)-$(PLAT)
OBJDIR  = ./obj/$(ARCH)-$(PLAT)
SRCDIR  = ./src$(VER)
TEST    = ./test

ARGS = $(TEST)/RectangularWG.poly

CFLAGS = $(INCDIR) -O2 -fPIC -fopenmp -static -DTETLIBRARY -DTRIANGLE
LFLAGS = $(LIBDIR) -print-file-name=libc.a -fPIC -fopenmp -static -static-libgcc -static-libstdc++ -s \
	-lsmumps -ldmumps -lcmumps -lzmumps -lmumps_common -lmpiseq_seq -lpord \
	-ltet -ltriangle \
	-larpack -llapack -lblas -lgfortran -lquadmath -lc\
	$(EXTRA)
SRCS=$(wildcard  $(SRCDIR)/*.cpp)
OBJS=$(patsubst $(SRCDIR)/%.cpp, $(OBJDIR)/%.o, $(SRCS))

all: $(BINDIR) $(OBJDIR) $(BIN)

$(BIN): $(OBJS)
	$(CC) -o $(BINDIR)/$@ $^ $(LFLAGS)

$(BINDIR):
	if [ ! -d "$(BINDIR)" ]; then mkdir -p $(BINDIR); fi

$(OBJDIR):
	if [ ! -d "$(OBJDIR)" ]; then mkdir -p $(OBJDIR); fi

$(OBJDIR)/%.o : $(SRCDIR)/%.cpp
	$(CC) $(CFLAGS) -c  $< -o $@

.PHONY: test
test:
	$(BINDIR)/$(BIN) $(ARGS)

.PHONY: clean
clean:
	rm -f $(OBJDIR)/*.o $(BINDIR)/$(BIN)*


