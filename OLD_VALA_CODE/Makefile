OS = LINUX
PKGS = 	--pkg gee-1.0 --pkg gtk+-3.0 --pkg gio-2.0 --pkg gmodule-2.0 --pkg json-glib-1.0 
		\

LIBS = \
	
FLAGS = -g
FILES = \
	 main.vala \
	 MasterState.vala \
	 Company.vala \
	 abstract-factory.vala \
	 stub_project.vala \
	 projectattribute.vala \
	 stub-persona.vala \
	 personalattribut.vala \
	 stub_product.vala \
	 productattribute.vala \
	 
    


all: $(FILES)
	valac $(FLAGS) $(PKGS) $(LIBS) -o main $(FILES)
	./main 

clean:
	find . -type f -name "*.so" -exec rm -f {} \;
	find . -type f -name "*.a" -exec rm -f {} \;
	find . -type f -name "*.o" -exec rm -f {} \;
	find . -type f -name "*.h" -exec rm -f {} \;
	find . -type f -name "*.c" -exec rm -f {} \;
	rm main


