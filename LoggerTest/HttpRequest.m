/*
 * HttpRequest.m
 */

#import "HttpRequest.h"
#import "Util.h"
#import "Logger.h"

#define TIMEOUT_INTERVAL 30

@implementation HttpRequest
@synthesize url = m_url;

/*
 * Constructor
 */
- (id)init
{
	if(!(self = [super init]))
		return nil;
		
	m_delegates = utilCreateNonRetainedArray();
	m_data = [[NSMutableData alloc] init];
    
	return self;
}

/*
 * Destructor
 */
- (void)dealloc
{
    assert (m_connection == nil);
}

/*
 * Add a delegate
 */
- (void)addDelegate:(id<HttpRequestDelegate>)delegate
{
	[m_delegates addObject:delegate];
}

/*
 * Remove a delegate
 */
- (void)removeDelegate:(id<HttpRequestDelegate>)delegate
{
	[m_delegates removeObject:delegate];
}

/*
 * Fire an error to all delegates. Copy the array before iteration to
 * handle delegates getting unregistered during the loop, and check that
 * each delegate is still in the original array before dispatching.
 * The number of delegates will normally be small (1 or 2), so the 
 * copy and extra lookups shouldn't be an issue.
 */
- (void)fireError:(NSString*)error withCode:(NSInteger)code
{
	[[Logger instance] appendInfoLog:[NSString stringWithFormat:@"HttpRequest(%08X) error %@ - %@",(int)self, m_url, error] withSummary:@"REQUEST_ERROR"];
	for(id<HttpRequestDelegate> delegate in m_delegates)
        [delegate httpRequest:self finishedWithData:nil andError:error andCode:code];
}

/*
 * Fire data to all delegates. Copy the array before iteration to
 * handle delegates getting unregistered during the loop, and check that
 * each delegate is still in the original array before dispatching.
 * The number of delegates will normally be small (1 or 2), so the 
 * copy and extra lookups shouldn't be an issue.
 */
- (void)fireData:(NSData*)data
{
	for(id<HttpRequestDelegate> delegate in m_delegates)
        [delegate httpRequest:self finishedWithData:data andError:nil andCode:0];
}

/*
 * Main start method. Everything comes through here.
 */
- (void)start:(NSString*)url data:(NSData*)requestData
	andContentType:(NSString*)contentType
{
	// Cancel any existing request
	[self cancel];
	
	// Keep a copy of the original URL that was passed in. This is mainly
	// so we can identify this request by URL externally. For that reason
	// we store the URL before converting it to an absolute URL.
	m_url = url;

	NSMutableURLRequest* req = [NSMutableURLRequest
		requestWithURL:[NSURL URLWithString:url]
		cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
		timeoutInterval:TIMEOUT_INTERVAL];
	
	// Send the HTTP request	
	m_connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}

/*
 * Start a request with just a URL
 */
- (void)start:(NSString*)url
{
	[self start:url data:nil andContentType:nil];
}

/*
 * Handle an initial reply from the HTTP request
 */
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSHTTPURLResponse*)response
{
	if(response.statusCode != 200)
	{
		[self cancel];

		[self fireError:[NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"HTTP Error", @"HTTP Error"), response.statusCode] withCode:response.statusCode];
	}
}

/*
 * Handle new data
 */
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
	[m_data appendData:data];
}

/*
 * Handle an error from the HTTP request
 */
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
	[self cancel];
    
	id description = error.localizedDescription;
    NSString * descriptionString = [description isKindOfClass:[NSString class]] ? description : @"connection failed";
	[self fireError:descriptionString withCode:error.code];
}

/*
 * Handle request complete
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[self fireData:m_data];
}

/*
 * Cancel the request
 *
 * Don't clear delegates in the cancel, this is the delegates responsibility
 */
- (void)cancel
{
    // ignore second cancel if we get one
    if (m_connection == nil)
        return;
    
    // clear our url
	m_url=nil;
    
    // clear out the data
	[m_data setLength:0];
    
    // clear the connection if we need to
	[m_connection cancel];
	m_connection = nil;
}

@end
