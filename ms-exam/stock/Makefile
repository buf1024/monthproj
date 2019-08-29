DIRS = gateway srv web


build:
	 for i in $(DIRS);\
	 do \
		 cd $$i;\
		 make build;\
		 if [ $$? -ne 0 ] ; then\
			exit 1;\
			fi; \
			cd ..;\
		 done;\

install:
	for i in $(DIRS);\
	do \
		 cd $$i;\
		 make install;\
		 if [ $$? -ne 0 ] ; then\
			 exit 1;\
		 fi; \
		 cd ..;\
  	done;\

docker:
	for i in $(DIRS);\
	do \
		 cd $$i;\
		 make docker;\
		 if [ $$? -ne 0 ] ; then\
			 exit 1;\
		 fi; \
		 cd ..;\
       done;\



clean:
	for i in $(DIRS);\
	do \
		 cd $$i;\
		 make clean;\
		 if [ $$? -ne 0 ] ; then\
			 exit 1;\
		 fi; \
		 cd ..;\
       done;\

