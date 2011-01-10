var wordBoundary = "\\b";
var word = "(\\w+)";

var zeroOrMoreSpace = "\\s*";
var oneOrMoreSpace = "\\s+";
var zeroOrMoreCharacters = "(.*)"
var functionName = "(\\w+)";
var scopeOperator = "::";
var className = functionName;


var functionGrep = className + scopeOperator + functionName +  zeroOrMoreCharacters;

var hypenSeparator = "(-)";
var functionWithMessage = className + scopeOperator + functionName +  zeroOrMoreCharacters + hypenSeparator + oneOrMoreSpace + zeroOrMoreCharacters + wordBoundary;
// non-capturing parentheses
var start = "(IN\\s?->\\s?)";
var stop = "(OUT\\s?->\\s?)";
var startFunction = start + zeroOrMoreCharacters + oneOrMoreSpace +functionGrep + wordBoundary + zeroOrMoreSpace;
log("startFunction: " + startFunction);
var stopFunction = stop + zeroOrMoreCharacters + oneOrMoreSpace + functionGrep + wordBoundary + zeroOrMoreSpace;
log("stopFunction: " + stopFunction);

var logFile = "test.log";
var functionObjects = [];
var fileName;

createSequenceFromLog(logFile);

function createSequenceFromLog(logFile) {
    var objects = [];
    objects = nativeFunctions.split(logFile, "."); // getting the
    if(objects.length == 2 ) {
        fileName = objects[0];
        readLog();
    } else {
        log("logFile could not be split, split length expected to be 2");
    }
}


// read from file
function readLog() {
    var fileContents = nativeFunctions.readFile(logFile);
    for(var i = 0; i < fileContents.length; i++) {
        var content = fileContents[i];
        var defaultColor = "black";

        var result = nativeFunctions.findAndExtract(content, startFunction);
        if(result.pos != -1) {
            var functionNameIndex = 4; // fourth subexpression functionName
            var classNameIndex = functionNameIndex - 1; // third subexpression className
            collectObjects(result.captureList[classNameIndex], result.captureList[functionNameIndex], "=>", defaultColor);

        } else {
            result = nativeFunctions.findAndExtract(content, stopFunction);
            if(result.pos != -1) {
                var functionNameIndex = 4; // fourth subexpression functionName
                var classNameIndex = functionNameIndex - 1;
                collectObjects(result.captureList[classNameIndex], result.captureList[functionNameIndex], "=>", defaultColor);
            } else {
                result = nativeFunctions.findAndExtract(content, functionWithMessage);
                if(result.pos != -1) {
                    var functionNameIndex = 2;
                    var classNameIndex = 1;
                    log("out content: " + content);
                    log("function grep result:");
                    log(result.captureList);
                    var functionNameMessage = result.captureList[functionNameIndex] + result.captureList[result.captureList.length -1];
                    functionNameMessage = nativeFunctions.replace(functionNameMessage, "\"", "");
                    log(functionNameMessage);
                    // lone objects points to itself using the same object twice
                    collectObjects(result.captureList[classNameIndex], functionNameMessage, "=>", defaultColor);
                    collectObjects(result.captureList[classNameIndex], functionNameMessage, "=>", defaultColor);
                }
            }
        }
    }
    if(functionObjects.length != 0) {
        // remove previous file
        nativeFunctions.removeFile(fileName + ".msc");
        nativeFunctions.removeFile(fileName + ".png");
        writeDotLangToFile(fileName);
        createPngFromMsc(fileName);
    }
}

// put through the parse functions
// call collectObjects

function collectObjects(className, functionName, direction, color) {

    var functionObject = {};
    log("className: " + className)
    functionObject.className = className;
    functionObject.functionName = functionName;
    functionObject.direction = direction;
    functionObject.color = color;
    functionObjects.push(functionObject);
}

// remove duplicates from array

function writeDotLangToFile(fileName) {
    fileName = fileName + ".msc";
    nativeFunctions.createFile(fileName);

    // Write diagram
    var diagram = "msc {";
    nativeFunctions.appendTextToFile(fileName, diagram);

    // Append nodes
    var classNames = [];
    for(var i = 0; i < functionObjects.length; i++) {
        classNames.push(functionObjects[i].className);
    }

    nativeFunctions.appendTextToFile(fileName, "\n");

    // remove duplicates
    classNames = nativeFunctions.removeDuplicates(classNames);
    var joinedClassname = nativeFunctions.join(classNames, ",");
    joinedClassname = joinedClassname + ";";

    nativeFunctions.appendTextToFile(fileName, joinedClassname);

    nativeFunctions.appendTextToFile(fileName, "\n");
    // Create sequences
    for(var i = 0; i < functionObjects.length; i=i+2 ) {

        var firstObj = functionObjects[i];
        var secondObj = functionObjects[i+1];

        if ( secondObj!=undefined ) {
           var sequence = createSequence(firstObj, secondObj, i);
           log("sequence at " + i + " " + sequence);
           nativeFunctions.appendTextToFile(fileName, sequence);
        } else {
            // case for object which doesnot have the direction
            var secondObj = firstObj;
            var sequence = createSequence(firstObj, secondObj, i);
            nativeFunctions.appendTextToFile(fileName, sequence);
            // decrementing the count by one as only object is used
            --i;
        }
    }
    var endTag = "}";
    nativeFunctions.appendTextToFile(fileName, endTag);
}

function createSequence(firstObj, secondObj, sequenceNumber) {
    var textColor = firstObj.color;
    var lineColor = firstObj.color;
    var sequence = firstObj.className + firstObj.direction +  secondObj.className + "[label="+ "\""+ sequenceNumber / 2 + " : "
                   + secondObj.functionName + "\"," +  "textcolour=\"" + textColor + "\"," +
                   "linecolour=\""+ lineColor + "\"" + "];";
    return sequence;
}

function createPngFromMsc(fileName) {
    var inputFile = fileName + ".msc";
    var outputFile = fileName + ".png";
    var arguments = ['-T' , 'png' , '-o' , outputFile , '-i' , inputFile];
    log(arguments);
    nativeFunctions.callProcess("mscgen", arguments);
}



function log(message)
{
    nativeFunctions.printValue(message);
}
