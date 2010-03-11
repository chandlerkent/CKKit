/*
 * Copyright (c) 2010 Chandler Kent
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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
