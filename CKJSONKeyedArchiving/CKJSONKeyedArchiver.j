@import <Foundation/CPCoder.j>

var CKJSONKeyedArchiverClassKey = @"$$CLASS$$";

@implementation CKJSONKeyedArchiver : CPCoder
{
    JSON    _json;
}

+ (JSON)archivedDataWithRootObject:(id)rootObject
{
    var json = {};
    var archiver = [[self alloc] initForWritingWithMutableData:json];
    
    return [archiver _encodeObject:rootObject];
    
    //return json;
}

+ (BOOL)allowsKeyedCoding
{
    return YES;
}

- (id)initForWritingWithMutableData:(JSON)json
{
    if (self = [super init])
    {
        _json = json;
    }
    return self;
}

- (void)encodeObject:(id)objectToEncode forKey:(CPString)aKey
{
    _json[aKey] = [self _encodeObject:objectToEncode];
}

- (JSON)_encodeObject:(id)objectToEncode
{
    var encodedJSON = {};
    
    if ([self _isObjectAPrimitive:objectToEncode])  // Primitives
    {
        encodedJSON = objectToEncode;
    }
    else if ([objectToEncode isKindOfClass:[CPArray class]]) // Override CPArray's default encoding because we want native JS Objects
    {
        var encodedArray = [];
        for (var i = 0; i < [objectToEncode count]; i++)
        {
            encodedArray[i] = [self _encodeObject:[objectToEncode objectAtIndex:i]];
        }
        encodedJSON = encodedArray;
    }
    else // Capp. objects
    {
        var archiver = [[[self class] alloc] initForWritingWithMutableData:encodedJSON];
        
        encodedJSON[CKJSONKeyedArchiverClassKey] = CPStringFromClass([objectToEncode class]);
        [objectToEncode encodeWithCoder:archiver];
    }

    return encodedJSON;
}

- (void)encodeNumber:(int)aNumber forKey:(CPString)aKey
{
    [self encodeObject:aNumber forKey:aKey];
}

- (void)encodeInt:(int)anInt forKey:(CPString)aKey
{
    [self encodeObject:anInt forKey:aKey];
}

- (JSON)_encodeDictionaryOfObjects:(CPDictionary)dictionaryToEncode forKey:(CPString)aKey
{
    var encodedDictionary = {};
    
    var keys = [dictionaryToEncode allKeys];
    for (var i = 0; i < [keys count]; i++)
    {
        encodedDictionary[keys[i]] = [self _encodeObject:[dictionaryToEncode objectForKey:keys[i]]];
    }
    
    _json[aKey] = encodedDictionary;
}

- (BOOL)_isObjectAPrimitive:(id)anObject
{
    var typeOfObject = typeof(anObject);
    return (typeOfObject === "string" || typeOfObject === "number" || typeOfObject === "boolean" || anObject === null);
}

@end
