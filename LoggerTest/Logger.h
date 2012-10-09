//
//  Logger.h
//

@interface Logger: NSObject
{
	int 			 m_size;
	NSMutableArray * m_logArray;
    
    NSString *       m_lastLog;
    int              m_dupCount;
}

- (id)initWithSize:(int)size;
- (void) appendInfoLog:(NSString*)log withSummary:(NSString*)summary;

// The one and only global instance
+ (Logger*)instance;

@end
