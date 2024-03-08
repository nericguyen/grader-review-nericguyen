CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

if [[ -f ./student-submission/ListExamples.java ]]
then
    echo "File found! Running Tests."
else
    echo "File not found, please check your file name/submission"
    exit
fi

cp student-submission/ListExamples.java grading-area 
cp TestListExamples.java grading-area
cp -r lib grading-area

pwd
  cd grading-area
pwd

javac -cp $CPATH *.java
if [[ $? -ne 0 ]]
then
  echo "The program failed to compile! Loser!"
  exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt

allSuccess=$(grep -i "OK (" junit-output.txt)
if [[ $? -eq 0 ]]
then 
  allSuccessReturn=$(echo $allSuccess | awk -F'[ (]' '{print $3}')
  echo "All tests passed, your score is $allSuccessReturn / $allSuccessReturn"
  exit 0
fi

lastline=$(grep -i "Tests run:" junit-output.txt)
tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
successes=$((tests - failures))
echo "Your score is $successes / $tests"