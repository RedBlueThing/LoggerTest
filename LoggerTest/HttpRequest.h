/*
 * HttpRequest.h
 */

@class HttpRequest;

/*
 * Implement this interface to receive callbacks from an HTTP request
 */
@protocol HttpRequestDelegate

- (void)httpRequest:(HttpRequest*)request
	finishedWithData:(NSData*)data
	andError:(NSString*)error 
    andCode:(NSInteger)code;

@end

/*
 * Simple HTTP request class
 */
@interface HttpRequest : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
	NSMutableArray*		m_delegates;
	NSMutableData*		m_data;
	NSString*			m_url;
	NSURLConnection*	m_connection;
    void*               m_object;
}

@property (readonly) NSString* url;

- (void)cancel;
- (void)start:(NSString*)url;

- (void)addDelegate:(id<HttpRequestDelegate>)delegate;
- (void)removeDelegate:(id<HttpRequestDelegate>)delegate;

@end
