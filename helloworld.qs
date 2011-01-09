
var directoryArray = [];
directoryArray = nativeFunctions.listDirectory(".");
for(var i = 0; i < directoryArray.length; i++)
{
    var evilVar = nativeFunctions.replace(directoryArray[i], "scripttest", "")
    log(evilVar);
}

var directoryArray2 = [];
directoryArray2 = nativeFunctions.listDirectory(".");

var result = compareArray(directoryArray, directoryArray2);
log("directory compare result: " + result.equal);
log("printing out found array:");
log(result.found);

var arguments = ['a' , 'abc.7z'];
//nativeFunctions.callProcess("7za", arguments);

var dirFileName = "directory_structure.txt";
var fileContents = nativeFunctions.readFile(dirFileName);
//log("fileContents of " + dirFileName + "are: ");
//log(fileContents);

var directoryArray3 = nativeFunctions.listDirectory(fileContents[0]);
//log(directoryArray3);

var randfunctionNameIn = "IN -> void helloworl3d::myn1ame(const Khan hehe, const aljdf aljf, void* aldsjf, void& alsjdf) \n";
var randfunctionNameOut = "OUT -> void helloworl3d::myn1ame(const Khan hehe, const aljdf aljf, void* aldsjf, void& alsjdf) \n";
var wordBoundary = "\\b";
var word = "(\\w+)";

var zeroOrMoreSpace = "\\s*";
var oneOrMoreSpace = "\\s+";
var zeroOrMoreCharacters = "(.*)"
var functionName = "(\\w+)";
var scopeOperator = "::";
var className = functionName;

var start = "(IN\\s?->\\s?)";
var stop = "(OUT\\s?->\\s?)";
var functionGrep = functionName + scopeOperator + className +  zeroOrMoreCharacters;
// non-capturing parentheses
var startFunction = start + zeroOrMoreCharacters + oneOrMoreSpace +functionGrep + wordBoundary + zeroOrMoreSpace;
log("startFunction: " + startFunction);
var stopFunction = stop + zeroOrMoreCharacters + oneOrMoreSpace + functionGrep + wordBoundary + zeroOrMoreSpace;
log("stopFunction: " + stopFunction);
nativeFunctions.findAndExtract(randfunctionNameIn, startFunction);
nativeFunctions.findAndExtract(randfunctionNameOut, stopFunction);

var logFile = "omb_core.log";
var functionObjects = [];
readLog();


log("logFile name: " + logFile);
// read from file
function readLog() {
    var fileContents = nativeFunctions.readFile(logFile);
    //log("fileContents: " + fileContents);
    //log("fileContents count: " + fileContents.length);
    for(var i = 0; i < fileContents.length; i++) {
        var content = fileContents[i];

        var result = nativeFunctions.findAndExtract(content, startFunction);
        if(result.pos != -1) {
            //var functionNameIndex = result.captureList.length -1;
            var functionNameIndex = 4;
            var classNameIndex = functionNameIndex - 1;
            log("in content: " + content);
            collectObjects(result.captureList[classNameIndex], result.captureList[functionNameIndex], "=>");

        } else {
            result = nativeFunctions.findAndExtract(content, stopFunction);
            if(result.pos != -1) {
                var functionNameIndex = 4;
                var classNameIndex = functionNameIndex - 1;
                log("out content: " + content);
                collectObjects(result.captureList[classNameIndex], result.captureList[functionNameIndex], "=>");
            }
        }
    }
    if(functionObjects.length != 0) {
        log("function")
        var fileName = "first";
        // remove previous file
        nativeFunctions.removeFile(fileName + ".msc");
        nativeFunctions.removeFile(fileName + ".png");
        writeDotLangToFile(fileName);
        createPngFromMsc(fileName);
    }
}

// put through the parse functions
// call collectObjects

function collectObjects(className, functionName, direction) {
    var functionObject = {};
    log("className: " + className)
    functionObject.className = className;
    functionObject.functionName = functionName;
    functionObject.direction = direction;
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
    //for(var i = 0; i < functionObjects.length && ( functionObjects.length % 2 == 0 ); i=i+2 ) {
    for(var i = 0; i < functionObjects.length; i=i+2 ) {

        var firstObj = functionObjects[i];
        var secondObj = functionObjects[i+1];
        if ( i != (functionObjects.length -1)) {
        var sequence = firstObj.className + firstObj.direction +  secondObj.className + "[label="+ "\""+ i + " : " + secondObj.functionName + "\""+ "];";
           log("sequence at " + i + " " + sequence);
           nativeFunctions.appendTextToFile(fileName, sequence);
        }
    }
    var endTag = "}";
    nativeFunctions.appendTextToFile(fileName, endTag);
}

function createPngFromMsc(fileName) {
    var inputFile = fileName + ".msc";
    var outputFile = fileName + ".png";
    var arguments = ['-T' , 'png' , '-o' , outputFile , '-i' , inputFile];
    log(arguments);
    nativeFunctions.callProcess("mscgen", arguments);
}


function compareArray(array1, array2)
{
    var result = {};
    var found = [];
    var notfound = [];
    var equal = false;
    for (var i = 0; i < array1.length; i++)
    {
        var foundItem = false;
        for (var j = 0; j < array2.length; j++)
        {
            if(array1[i] == array2[j])
            {
                foundItem = true;
                found.push(array2[j]);
                break;
            }
        }
        if ( !foundItem)
        {
            notfound.push(array1[i])
        }
    }

    if(found.length == array1.length)
        equal = true;

    result.found = found;
    result.notfound = notfound;
    result.equal = equal
    return result;
}


function log(message)
{
    nativeFunctions.printValue(message);
}
