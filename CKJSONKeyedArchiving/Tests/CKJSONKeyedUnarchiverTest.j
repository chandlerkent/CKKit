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
 
@import "../CKJSONKeyedUnarchiver.j"

@implementation CKJSONKeyedUnarchiverTest : OJTestCase

- (void)testThatCKJSONKeyedUnarchiverDoesInitialize
{
    [self assertNotNull:[[CKJSONKeyedUnarchiver alloc] initForReadingWithData:{}]];
}

- (void)testThatCKJSONKeyedUnarchiverDoesUnarchiveAString
{
    var data = @"Test";
    var response = [CKJSONKeyedUnarchiver unarchiveObjectWithData:data];
    
    [self assert:data equals:response];
}

- (void)testThatCKJSONKeyedUnarchiverDoesUnarchiveMockObject
{
    var data = {"$$CLASS$$":"MockJSONParseObject","StringKey":"Bob","NumberKey":42,"BoolKey":true,"NullKey":null,"ArrayKey":["Bob",42,true,null],"DictionaryKey":{"$$CLASS$$":"CPDictionary","CP.objects":{"array":["Bob",42,true,null],"null":null,"bool":true,"number":42,"string":"Bob"}},"DateKey":{"$$CLASS$$":"CPDate","CPDateTimeKey":1263762168983}};

    var response = [CKJSONKeyedUnarchiver unarchiveObjectWithData:data];

    [self assert:@"MockJSONParseObject" equals:CPStringFromClass([response class])];
    [self assert:data["StringKey"] equals:[response aString]];
    [self assert:data["NumberKey"] equals:[response aNumber]];
    [self assert:data["BoolKey"] equals:[response aBool]];
    [self assert:data["NullKey"] equals:[response aNull]];
    [self assert:data["ArrayKey"] equals:[response anArray]];
    [self assert:new Date(data["DateKey"]["CPDateTimeKey"]) equals:[response aDate]];
    [self assertTrue:[[CPDictionary dictionaryWithJSObject:data["DictionaryKey"]["CP.objects"]] isEqualToDictionary:[response aDictionary]]];
}

- (void)testThatCKJSONKeyedUnarchiverDoesUnarchiveMockObjectWithChild
{
    var data = {"$$CLASS$$":"MockJsonParseObjectWithChild","StringKey":"Bob","NumberKey":42,"BoolKey":true,"NullKey":null,"ArrayKey":["Bob",42,true,null],"DictionaryKey":{"$$CLASS$$":"CPDictionary","CP.objects":{"array":["Bob",42,true,null],"null":null,"bool":true,"number":42,"string":"Bob"}},"DateKey":{"$$CLASS$$":"CPDate","CPDateTimeKey":1263762235196},"ChildKey":{"$$CLASS$$":"MockJSONParseObject","StringKey":"Bob","NumberKey":42,"BoolKey":true,"NullKey":null,"ArrayKey":["Bob",42,true,null],"DictionaryKey":{"$$CLASS$$":"CPDictionary","CP.objects":{"array":["Bob",42,true,null],"null":null,"bool":true,"number":42,"string":"Bob"}},"DateKey":{"$$CLASS$$":"CPDate","CPDateTimeKey":1263762235196}}};

    var response = [CKJSONKeyedUnarchiver unarchiveObjectWithData:data];

    [self assert:@"MockJsonParseObjectWithChild" equals:CPStringFromClass([response class])];
    [self assert:data["StringKey"] equals:[response aString]];
    [self assert:data["NumberKey"] equals:[response aNumber]];
    [self assert:data["BoolKey"] equals:[response aBool]];
    [self assert:data["NullKey"] equals:[response aNull]];
    [self assert:data["ArrayKey"] equals:[response anArray]];
    [self assert:new Date(data["DateKey"]["CPDateTimeKey"]) equals:[response aDate]];
    [self assertTrue:[[CPDictionary dictionaryWithJSObject:data["DictionaryKey"]["CP.objects"]] isEqualToDictionary:[response aDictionary]]];
    [self assert:data["ChildKey"]["$$CLASS$$"] equals:CPStringFromClass([[response child] class])];
}

@end

@implementation MockJSONParseObject : CPObject
{
    CPString        aString     @accessors;
    int             aNumber     @accessors;
    BOCK            aBool       @accessors;
    id              aNull       @accessors;
    CPArray         anArray     @accessors;
    CPDictionary    aDictionary @accessors;
    CPDate          aDate       @accessors;
}

- (id)init
{
    if(self = [super init])
    {
        aString = "Bob";
        aNumber = 42;
        aBool = YES;
        aNull = nil;
        anArray = [aString, aNumber, aBool, aNull];
        aDate = [CPDate date];
        aDictionary = [CPDictionary dictionaryWithObjects:[aString, aNumber, aBool, aNull, anArray] forKeys:["string", "number", "bool", "null", "array"]];
    }
    return self;
}

- (id)initWithCoder:(CPCoder)coder
{
    self = [super init];
    if(self)
    {
        aString     = [coder decodeObjectForKey:@"StringKey"];
        aNumber     = [coder decodeObjectForKey:@"NumberKey"];
        aBool       = [coder decodeObjectForKey:@"BoolKey"];
        aNull       = [coder decodeObjectForKey:@"NullKey"];
        anArray     = [coder decodeObjectForKey:@"ArrayKey"];
        aDictionary = [coder decodeObjectForKey:@"DictionaryKey"];
        aDate       = [coder decodeObjectForKey:@"DateKey"];
    }
    return self;
}

- (void)encodeWithCoder:(CPCoder)coder
{
    [coder encodeObject:aString forKey:@"StringKey"];
    [coder encodeObject:aNumber forKey:@"NumberKey"];
    [coder encodeObject:aBool forKey:@"BoolKey"];
    [coder encodeObject:aNull forKey:@"NullKey"];
    [coder encodeObject:anArray forKey:@"ArrayKey"];
    [coder encodeObject:aDictionary forKey:@"DictionaryKey"];
    [coder encodeObject:aDate forKey:@"DateKey"];
}

@end

@implementation MockJsonParseObjectWithChild : MockJSONParseObject
{
    MockJSONParseObject child   @accessors;
}

- (id)init
{
    if(self = [super init])
    {
        child = [[MockJSONParseObject alloc] init];
    }
    return self;
}

- (id)initWithCoder:(CPCoder)coder
{
    self = [super initWithCoder:coder];
    if(self)
    {
        child = [coder decodeObjectForKey:@"ChildKey"];
    }
    return self;
}

- (void)encodeWithCoder:(CPCoder)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:child forKey:@"ChildKey"];
}

@end
