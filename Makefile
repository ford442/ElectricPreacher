COMPILER_FLAGS= -sUSE_SDL=2 -std=c++17 -masm=intel -ggdb3 -Wpedantic -Wall -Wextra -Wconversion -Wsign-conversion -Wstrict-null-sentinel -Wold-style-cast -Wnoexcept -Wctor-dtor-privacy -Woverloaded-virtual -Wsign-promo -Wzero-as-null-pointer-constant -Wsuggest-final-types -Wsuggest-final-methods -Wsuggest-override
LINKER_FLAGS= -sUSE_SDL=2 lib/libjsoncpp.a 
EXECUTABLE=ElectricPreacher.js
CXX=emcc

HEADER=$(wildcard includes/*.hpp)
SOURCES=$(wildcard src/*.cpp)
TMP_OBJECTS=$(SOURCES:.cpp=.o)
OBJECTS=$(TMP_OBJECTS:src/%=build/%)

all: pre bin/$(EXECUTABLE)


pre:
	@echo -e "\e[0;32m============== Compiling  =============\e[0m"
	@mkdir -p bin build

bin/$(EXECUTABLE): main.cpp $(OBJECTS) $(HEADER)
	@echo -e "\e[1;32mcompiling : $^ -> $@\e[0m"
	@$(CXX) $^ $(COMPILER_FLAGS) $(LINKER_FLAGS) -o $@

build/%.o: src/%.cpp
	@echo -e "\e[1;33m >> $^ -> $@\e[0m"
	@$(CXX) $(COMPILER_FLAGS) -c $^ -o $@

clean :
	clear
	@echo -e "\e[0;33m============== Cleaning  ==============\e[0m"
	rm -f build/*.o

run: all
	@echo -e "\e[0;31m================= Run ================\e[0m"
	@echo -e "\e[0;31m"
	@./bin/$(EXECUTABLE)
	@echo "\e[0m"

valrun: all
	@echo -e "\e[0;31m============ Valgrind Run ============\e[0m"
	valgrind --leak-check=full --show-reachable=yes --show-leak-kinds=all --error-limit=no --gen-suppressions=all --log-file=supdata.log ./$(EXECUTABLE)

mrproper: clean
	rm -f bin/$(EXECUTABLE)

.PHONY: clean mrproper
