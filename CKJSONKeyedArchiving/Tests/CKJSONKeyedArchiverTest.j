@import "../CKJSONKeyedArchiver.j"

@implementation CKJSONKeyedArchiverTest : OJTestCase

- (void)testThatCKJSONKeyedArchiverDoesInitialize
{
    [self assertNotNull:[[CKJSONKeyedArchiver alloc] initForWritingWithMutableData:nil]];
}

- (void)testThatCKJSONKeyedArchiverDoesInitializeAndReturnDataWhenDataIsString
{
    var data = @"Test";
    var response = [CKJSONKeyedArchiver archivedDataWithRootObject:data];
    
    [self assert:data equals:response];
}

- (void)testThatCKJSONKeyedArchiverDoesInitializeAndReturnDataWhenGivenMockObject
{
    var data = [[MockJSONParseObject alloc] init];
    var response = [CKJSONKeyedArchiver archivedDataWithRootObject:data];
    
    [self assert:[data aString] equals:response["StringKey"]];
    [self assert:[data aNumber] equals:response["NumberKey"]];
    [self assert:[data aBool] equals:response["BoolKey"]];
    [self assert:[data aNull] equals:response["NullKey"]];
    [self assert:[data anArray] equals:response["ArrayKey"]];
    [self assert:[data aDate] equals:new Date(response["DateKey"]["CPDateTimeKey"])];
    [self assertTrue:[[data aDictionary] isEqualToDictionary:[CPDictionary dictionaryWithJSObject:response["DictionaryKey"]["CP.objects"]]]];
    [self assert:@"MockJSONParseObject" equals:response["$$CLASS$$"]];
}

- (void)testThatCKJSONKeyedArchiverDoesInitializeAndReturnDataWhenGivenMockObjectWithChild
{
    var data = [[MockJsonParseObjectWithChild alloc] init];
    var response = [CKJSONKeyedArchiver archivedDataWithRootObject:data];
    
    [self assert:[data aString] equals:response["StringKey"]];
    [self assert:[data aNumber] equals:response["NumberKey"]];
    [self assert:[data aBool] equals:response["BoolKey"]];
    [self assert:[data aNull] equals:response["NullKey"]];
    [self assert:[data anArray] equals:response["ArrayKey"]];
    [self assert:[data aDate] equals:new Date(response["DateKey"]["CPDateTimeKey"])];
    [self assertTrue:[[data aDictionary] isEqualToDictionary:[CPDictionary dictionaryWithJSObject:response["DictionaryKey"]["CP.objects"]]]];
    [self assert:CPStringFromClass([data class]) equals:response["$$CLASS$$"]];
    [self assert:CPStringFromClass([[data child] class]) equals:response["ChildKey"]["$$CLASS$$"]];
}

- (void)testThatCKJSONKeyedArchiverDoesAllowKeyedCoding
{
    [self assertTrue:[CKJSONKeyedArchiver allowsKeyedCoding]];
}

@end


@implementation MockJSONParseObject : CPObject
{
    CPString        aString     @accessors;
    int             aNumber     @accessors;
    BOOL            aBool       @accessors;
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
