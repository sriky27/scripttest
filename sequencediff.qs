var result = load('logtosequence.qs');
var logFile1 = "test.log";
var logFile2 = "test1.log";
var fileName;

// Create sequences from the two files
var returnValue1 = createSequenceFromLog(logFile1);
var returnValue2 = createSequenceFromLog(logFile2);

// feed the sequences to the diff file1.msc file2.msc > output.txt
log(returnValue1.sequenceFile);
log(returnValue2.sequenceFile);

var arguments1 = [  returnValue1.sequenceFile, returnValue2.sequenceFile];
var resultDiff = nativeFunctions.callProcessReadStdOut('diff', arguments1);
log(resultDiff);
// get the line numbers from the output
// get those lines grep for textcolor and linecolor and change to desired color.
