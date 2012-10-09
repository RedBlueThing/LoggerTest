/*
 * Util.m
 * Misc utility functions
 */

#import "Util.h"

BOOL isVerbose (void)
{
    return NO;
}
/*
 * Create a new array that doesn't retain its members
 * Initial reference count of the array is 1
 */
NSMutableArray * utilCreateNonRetainedArray(void)
{
	CFArrayCallBacks callbacks;
	memset(&callbacks, 0, sizeof(callbacks));
	CFMutableArrayRef ref = CFArrayCreateMutable(NULL, 0, &callbacks);	
	return (__bridge_transfer NSMutableArray*)ref;
}
