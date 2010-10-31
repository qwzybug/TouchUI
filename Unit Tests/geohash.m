#import <Foundation/Foundation.h>

#import "CTest.h"

int main (int argc, const char * argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    CTest *theTest = [[[CTest alloc] init] autorelease];
    [theTest main];

    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate distantFuture]];

    [pool drain];
    return 0;
}
