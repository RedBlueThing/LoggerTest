//
//  Logger.m
//

#import "Logger.h"

Logger * g_pLoggerInstance;

@implementation Logger

- (id)initWithSize:(int)size
{
	if(!(self = [super init]))
		return nil;
	
	assert(g_pLoggerInstance==nil);
	g_pLoggerInstance=self;

	m_size = size;
	m_logArray = [[NSMutableArray alloc] init];

	return self;
}

- (void) appendLog:(NSString*)log
{
	[m_logArray addObject:log];
	
	if ([m_logArray count] >= m_size)
        [m_logArray removeObjectAtIndex:0];
    
    // send to NSLog as well
    NSLog(@"%@", log);
}

- (NSString*)removeSepFromLog:(NSString*)log
{
    NSString * newLog = [log stringByReplacingOccurrencesOfString:@"#" withString:@"-"];
    newLog = [newLog stringByReplacingOccurrencesOfString:@"\n" withString:@"<BR>"];
    return newLog;
}

- (NSString*) dateString
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
    return [dateFormatter stringFromDate:[NSDate date]];
}

// N.B.
// This message doesn't do much (it is a cut down version of a more complicated message).
// I have left it here ecause the crash is much harder to reproduce without it.
//
// I am just keeping a reference to the last log message, nothing dangerous right?
- (BOOL) duplicateLog:(NSString*)log
{
    m_lastLog = log;
    return NO;
}

- (void) appendInfoLog:(NSString*)log withSummary:(NSString*)summary
{
    if ([self duplicateLog:log])
        return;
    
    [self appendLog:[NSString stringWithFormat:@"INFO#%@#%@#%@",[self dateString], summary, [self removeSepFromLog:log]]];
}

+ (Logger*)instance
{
	return g_pLoggerInstance;
}

@end

