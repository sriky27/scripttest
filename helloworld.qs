
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


var fileContents = nativeFunctions.readFile("directory_structure.txt");
log("fileContents are:");
log(fileContents);

var directoryArray3 = nativeFunctions.listDirectory(fileContents[0]);
log(directoryArray3);

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
