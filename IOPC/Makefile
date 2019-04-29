FCOMPFLAGS    =	-O0 -g -C -fpe0 -traceback 
#FCOMPFLAGS    =	 -O2  
#FCOMPFLAGS    =	 -pg -tpp7 -O3  -align  -axN -tpp7 
#FCOMPFLAGS    =	 -pg  -O2 -axN 
CCOMPFLAGS    =	-O

FFLAGS        =	$(FCOMPFLAGS)
CFLAGS        = $(CCOMPFLAGS)
LDFLAGS       =	$(FCOMPFLAGS)

LD            =	ifort   
FC            =	ifort   

MAKEFILE      =	Makefile
PROGRAM       =	iopc      

OBJS	      =	main.o        \
		varsh.o       \
		rdconf.o      \
		rdconf_vel.o  \
		wrconf_vel.o  \
		wrconf.o      \
                input.o       \
                ofile.o       \
		wtrj.o

all:		$(PROGRAM)

$(PROGRAM)::	$(INCS)
		@/bin/rm -f $(OBJS) 

$(PROGRAM)::	$(OBJS) $(MAKEFILE)
		@$(LD) $(LDFLAGS) $(OBJS) -o $(PROGRAM)

#clean:;		@rm -f $(OBJS)
