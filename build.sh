#!/bin/bash

# Mini Java Compiler build and test script
# Modular procedural shell script with each phase separated
# each subroutine executes from the base directory

#============================================================
# MAIN DRIVER ROUTINE
#============================================================

# Global Variables
JTB_JAR="../stuff/jtb.jar"          # Tree Builder
MINI_J="../stuff/minijava.jj"       # Tree Builder Input
VAPOR_I="../stuff/vapor.jar"        # Vapor Interpreter
VAPOR_P="../stuff/vapor-parser.jar" # Vapor Parser
MARS="../stuff/mars.jar"            # MIPS Interpreter

# Driver for all the test harnesses, main is called at bottom
# each phase has a specific test harness procedure, test harnesses are commented out as needed
function main()
{
    do_p1
    # do_p2
    # do_p3
    # do_p4
}

#============================================================
# PHASE 1 - Type Checking
#============================================================

# phase1 test harness
function do_p1()
{
    init_p1         # if no build exists make one
    check_p1        # run preliminary type check on custom file
    manual_test_p1  # loop over every actual test file
    clean_p1        # rm .class files
    test_p1         # make the .tgz file and use official run script on it
    wipe_p1         # rm everything that gets auto generated by the script
}

# Create skeleton MiniJava parser and generate syntax tree classes and visitor classes, etc...
function init_p1()
{
    echo
    if ( test -d p1 ) ; then
        echo "0. Phase1 build exists"; echo
        return
    fi
    echo "0. Creating initial Phase1 build"; echo
    mkdir p1
    cd p1
    java -jar $JTB_JAR $MINI_J
    javacc jtb.out.jj
    touch Typecheck.java
    cd ..
}

# testing type checking on a custom file
function check_p1()
{
    P1_FILE="../tests/tester.java"
    cd p1
    echo "1. Compiling Phase1"; echo
    javac Typecheck.java
    echo "2. Checking "$P1_FILE; echo
    echo "See p1_logfile for trace"; echo
    java Typecheck < $P1_FILE > ../p1_logfile.txt
    cd ..
}

# force test all files manually
function manual_test_p1()
{
    echo "3. Manually testing all the Phase1Test cases"; echo
    echo "See p1_manual_logfile for trace"; echo
    if [ -e p1_manual_logfile  ] ; then rm p1_manual_logfile; fi
    cd p1
    javac Typecheck.java # just in case not already compiled
    for FILE in ../tests/Phase1Tester/SelfTestCases/* ;
    do
        echo "CHECKING: "$FILE >>../p1_manual_logfile.txt
        if ! java Typecheck < $FILE >> ../p1_manual_logfile.txt; then
            continue
        fi
        echo "" >> ../p1_manual_logfile.txt
    done
    cd ..
}

# remove any .class files from the build
# also used because cant submit .class files in the tarball
function clean_p1()
{
    cd p1;         rm *.class
    cd visitor;    rm *.class; cd ..
    cd visitor2;   rm *.class; cd ..
    cd syntaxtree; rm *.class; cd ..
    cd struct;     rm *.class; cd ..
    cd toolbox;    rm *.class; cd ..
    cd ..
}

# run the grading script with all the included test cases
# it expects a tar file named "hw1.tgz" to be used with the "run" script
# also it will reject tar files that are too big so must be less than 65kB in size
function test_p1()
{
    if [ -e hw1  ] ; then
        echo "Deleteing old hw1 folder"
        rm -rf hw1
    fi

    if [ -e hw1.tgz  ] ; then
        echo "Deleteing old hw1 tarball"
        rm -rf hw1.tgz
    fi

    echo "Making new tar file for submission"; echo

    mkdir hw1
    mkdir hw1/visitor2 # only want some of the files so no recurse copy (see below)
    mkdir hw1/struct
    mkdir hw1/toolbox

    cp p1/struct/*  hw1/struct
    cp p1/toolbox/* hw1/toolbox
    cp p1/Typecheck.java hw1
    cp p1/visitor2/DFStackVisitor.java hw1/visitor2
    cp p1/visitor2/DFStackVisitor2.java hw1/visitor2
    cp p1/visitor2/DFTypeCheckVisitor.java hw1/visitor2

    tar zcvf hw1.tgz hw1 > /dev/null

    echo "4. Running Phase1Tester Script"; echo

    cd tests/Phase1Tester

    source run SelfTestCases ../../hw1.tgz

    echo; echo "Delete the hw1/ && hw1.tgz && tests/Phase1Tester/Output/ if not needed"; echo

    cd ../..
}

# remove all the auto generated stuff from above
function wipe_p1()
{
    echo "5. wiping out the extras p1"; echo
    rm -rf hw1
    rm hw1.tgz
    rm p1_logfile.txt
    rm p1_manual_logfile.txt
    rm -rf tests/Phase1Tester/Output
}

#============================================================
# PHASE 2 - Intermediate Code Generation
#============================================================

# phase1 test harness
function do_p2()
{
    echo "Phase 2"
}

#============================================================
# PHASE 3 - Register Allocation
#============================================================

# phase1 test harness
function do_p3()
{
    echo "Phase 3"
}

#============================================================
# PHASE 4 - Activation Records and Instruction Selection
#============================================================

# phase1 test harness
function do_p4()
{
    echo "Phase 4"
}

#============================================================
# DRIVER - Run the main driver routine for the harnesses
#============================================================

main
