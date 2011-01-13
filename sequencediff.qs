var result = load('logtosequence.qs');
var logFile1 = "test.log";
var logFile2 = "test1.log";
var fileName;

// Create sequences from the two files
createSequences();
function createSequences() {
var returnValue1 = createSequenceFromLog(logFile1);
var returnValue2 = createSequenceFromLog(logFile2);

// feed the sequences to the diff file1.msc file2.msc > output.txt
log(returnValue1.sequenceFile);
log(returnValue2.sequenceFile);

var arguments1 = [  returnValue2.sequenceFile, returnValue1.sequenceFile];
var resultDiff = nativeFunctions.callProcessReadStdOut('diff', arguments1);
log(resultDiff);
var linesDiffInSequence = getDiffInSequences(resultDiff);
changeColorInSequenceUsingDiff(linesDiffInSequence.left, returnValue2.sequenceFile);
changeColorInSequenceUsingDiff(linesDiffInSequence.right, returnValue1.sequenceFile);
}
// get the line numbers from the output
// 4c4 means on line 4 change is there on both sides
// 7,15c7 means on
// a. line 7 change is there on both sides
// b. from 7 - 15 changes is there on the left side
// color for change is red
// same applies for append replacing a with c.
// color for append is blue
//getDiffSequence();


function getDiffInSequences(resultDiff) {
// regular expression to get the diff
var number = "(\\d+)";
var comma = "(,)";
var appendCharacter = "a";
var append = "[" + appendCharacter + "]";
var changeCharacter = "c";
var change = "[" + changeCharacter + "]";
var questionMark = "?";
var lineNumbers = number + comma + questionMark + number + questionMark;

var appendDiffExpression = lineNumbers + append + lineNumbers;
log("appendDiffExpression: " + appendDiffExpression);
var changeDiffExpression = lineNumbers + change + lineNumbers;
log("changeDiffExpression: " + changeDiffExpression);
resultDiff = nativeFunctions.removeNewLine(resultDiff);

var resultObject = {};

var left = {};
left.changedLines = [];
left.appendedLines = [];

var right = {};
right.changedLines = [];
right.appendedLines = [];

resultObject.left = left;
resultObject.right = right;

for(var i = 0; i < resultDiff.length; i++) {
    var result = nativeFunctions.findAndExtract(resultDiff[i], appendDiffExpression);
    log(resultDiff[i]);
    if(result.pos != -1) {
        log(result.captureList);
        var appendedLines = nativeFunctions.split(result.captureList[0], comma);
        // evil avoid hardcoding
        var leftAppendedLines = appendedLines[0];
        splitAppend(leftAppendedLines, left.appendedLines);
        var rightAppendedLines = appendedLines[1];
        splitAppend(rightAppendedLines, right.appendedLines);


    } else {
        result = nativeFunctions.findAndExtract(resultDiff[i], changeDiffExpression);
        if(result.pos != -1) {
            log(result.captureList);
            var changedLines = nativeFunctions.split(result.captureList[0], changeCharacter);
            // evil avoid hardcoding
            var leftChangedLines = changedLines[0];

            splitAppend(leftChangedLines, left.changedLines);
            var rightChangedLines = changedLines[1];
            splitAppend(rightChangedLines, right.changedLines);
        }
    }
}

log("left changedLines" + left.changedLines);
log("right changedLines" + right.changedLines);
return resultObject;
}

function splitAppend(inputArray, outputArray) {
    inputArray = nativeFunctions.split(inputArray, ",");
    for(var i = 0; i < inputArray.length; i++)
        outputArray.push(inputArray[i]);
}

function changeColorInSequenceUsingDiff(linesDiffInSequence, fileName) {
    var textColorRegEx = "textcolour=\"" + zeroOrMoreCharacters + "\"";
    var lineColorRegEx = "linecolour=\"" + zeroOrMoreCharacters + "\"";
    var redColor = "red";
    var blueColor = "blue";
    var fileContents = nativeFunctions.readFile(fileName);
    chaneColorInSequence(fileContents, linesDiffInSequence.changedLines, redColor);
    chaneColorInSequence(fileContents, linesDiffInSequence.appendedLines, blueColor);

    // write filecontents to the file
    // evil
    var outPutFileName = getBaseFileName(fileName) + "-diff";
    // write filecontents to the file
    var outPutMsc = outPutFileName + ".msc";
    nativeFunctions.removeFile(outPutMsc);
    nativeFunctions.appendTextToFile(outPutMsc, fileContents);
    // create png out of it
    createPngFromMsc(outPutFileName);
}

function chaneColorInSequence(sequences, diffArray, color) {
    var defaultColor = "(black)";

    log("diffArray length:" + diffArray.length);
    if(diffArray.length == 2) {
        log(diffArray);
        var i = 0;
        log(i);
        for(var i = parseInt(diffArray[0]); i < parseInt(diffArray[1]); i++) {
            log(i);
            log("before change " + sequences[i]);
            sequences[i] = nativeFunctions.replace(sequences[i], defaultColor,color);
            log("after change " + sequences[i]);
        }
    } else {
        nativeFunctions.replace(sequences[parseInt(diffArray[0])], defaultColor,color);
    }
}

// get those lines grep for textcolor and linecolor and change to desired color.
