# Makefile
CC = g++
LL = g++

CFLAGS =  @obj/simulate_evolving_seq.cflags  
LDFLAGS =  -static   
LDLIBS = -lm
#------------- end of header -----------------------------

OBJECTS = \
	obj/sequence.o \
	obj/random.o \
	obj/simulate_evolving_seq.o \
	obj/common.o \
	obj/alphabet.o

simulate_evolving_seq : $(OBJECTS)
	$(LL) $(LDFLAGS) -o simulate_evolving_seq $(OBJECTS) $(LDLIBS)


obj/sequence.o: c-lib/sequence/sequence.cpp c-lib/sequence/sequence.h \
 c-lib/util/common.h c-lib/NR-3.04/nr3.h c-lib/sequence/alphabet.h \
 c-lib/util/random.h c-lib/NR-3.04/ran.h
	$(CC) -c $(CFLAGS) -o obj/sequence.o                     c-lib/sequence/sequence.cpp

obj/random.o: c-lib/util/random.cpp c-lib/util/random.h c-lib/NR-3.04/nr3.h \
 c-lib/NR-3.04/ran.h c-lib/NR-3.04/gamma.h
	$(CC) -c $(CFLAGS) -o obj/random.o                       c-lib/util/random.cpp

obj/simulate_evolving_seq.o: simulate_evolving_seq.cpp c-lib/util/common.h \
 c-lib/NR-3.04/nr3.h c-lib/sequence/sequence.h c-lib/sequence/alphabet.h \
 c-lib/util/random.h c-lib/NR-3.04/ran.h c-lib/sequence/alphabet.h
	$(CC) -c $(CFLAGS) -o obj/simulate_evolving_seq.o        simulate_evolving_seq.cpp

obj/common.o: c-lib/util/common.cpp c-lib/util/common.h c-lib/NR-3.04/nr3.h
	$(CC) -c $(CFLAGS) -o obj/common.o                       c-lib/util/common.cpp

obj/alphabet.o: c-lib/sequence/alphabet.cpp c-lib/sequence/alphabet.h
	$(CC) -c $(CFLAGS) -o obj/alphabet.o                     c-lib/sequence/alphabet.cpp

# ------------------------------------

clean :
	rm -f obj/*.o

tags :
	ctags --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ -f .tags --recurse=yes c-lib

