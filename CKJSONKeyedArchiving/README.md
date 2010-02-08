CKJSONKeyedArchiver/Unarchiver allows you to archive/unarchive objects to JSON.

# Why?

JSON is more verbose than the native Cappuccino keyed archiving, can't be stored (natively) in most places, and probably has other disadvantages. So why the heck is it useful? Storage. Depending on where you plan to store the archived objects, JSON may be the best choice. This was developed to store objects in CouchDB which has a lot of advantages. First, the objects are actually smaller in CouchDB (probably because it is optimized to store JSON) and you can search your objects (which is actually pretty cool).

# Example Usage

**Basic** usage is exactly the same as the CPKeyedArchiver/Unarchiver. If all you want to do is archive and unarchive (linear) objects and object relationships, then this will work just fine.

    var json = [CKJSONKeyedArchiver archivedDataWithRootObject:anObject];
    var anObject = [CKJSONKeyedUnarchiver unarchiveObjectWithData:json];

# Limitations (Problems)

Currently the archiving is **VERY** naive. It does not support many of the more advanced features of archiving/unarchiving (like there is no delegate, ability to archive complex object relationships, etc.). I would very much welcome contributions to make these classes more inline with Cappuccino's native archiving capabilities. Please contact me if you have questions about what areas need improvement.