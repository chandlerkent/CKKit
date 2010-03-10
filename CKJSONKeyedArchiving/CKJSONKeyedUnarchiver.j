@import <Foundation/CPCoder.j>
@import <Foundation/CPDictionary.j>

var CKJSONKeyedUnarchiverClassKey = @"$$CLASS$$";

@implementation CKJSONKeyedUnarchiver : CPCoder
{
    JSON    _json;
}

+ (id)unarchiveObjectWithData:(JSON)json
{
    var unarchiver = [[self alloc] initForReadingWithData:json];
    return [unarchiver _decodeObject:json];
}

- (id)initForReadingWithData:(JSON)json
{
    if (self = [super init])
    {
        _json = json;
    }
    return self;
}

- (id)decodeObjectForKey:(CPString)aKey
{
    return [self _decodeObject:_json[aKey]];
}

- (int)decodeIntForKey:(CPString)aKey
{
    return [self _decodeObject:_json[aKey]];
}

- (id)_decodeObject:(JSON)encodedJSON
{
    var decodedObject = nil;
    
    if ([self _isJSONAPrimitive:encodedJSON]) // Primitives
    {
        decodedObject = encodedJSON;
    }
    else if (encodedJSON.constructor.toString().indexOf("Array") !== -1) // Handle arrays separately of its own decoding
    {
        var array = encodedJSON;
        for (var i = 0; i < [array count]; i++)
        {
           array[i] = [self _decodeObject:[array objectAtIndex:i]];
        }
        
        decodedObject = array;
    }
    else // Capp. objects
    {
        var unarchiver = [[[self class] alloc] initForReadingWithData:encodedJSON];
        
        var theClass = CPClassFromString(encodedJSON[CKJSONKeyedUnarchiverClassKey]);
        decodedObject = [[theClass alloc] initWithCoder:unarchiver];
    }
    
    return decodedObject;
}

- (id)_decodeDictionaryOfObjectsForKey:(CPString)aKey
{
    var decodedDictionary = [CPDictionary dictionary];
    
    var encodedJSON = _json[aKey];
    for (var key in encodedJSON)
    {
        if (key !== CKJSONKeyedUnarchiverClassKey)
        {
            [decodedDictionary setObject:[self _decodeObject:encodedObject[key]] forKey:key];
        }
    }

    return decodedDictionary;
}

- (BOOL)_isJSONAPrimitive:(JSON)json
{
    var typeOfObject = typeof(json);
    return (typeOfObject === "string" || typeOfObject === "number" || typeOfObject === "boolean" || json === null);
}

@end
