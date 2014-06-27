//
//  DCHTTPOperation.h
//  Tourbillon
//
//  Created by Derek Chen on 13-10-16.
//  Copyright (c) 2013年 CaptainSolid Studio. All rights reserved.
//

#import "DCRunLoopOperation.h"
//#import "DCSafeARC.h"

extern NSString *kDCHTTPOperationErrorDomain;

// positive error codes are HTML status codes (when they are not allowed via acceptableStatusCodes)
//
// 0 is, of course, not a valid error code
//
// negative error codes are errors from the module

enum {
    kDCHTTPOperationErrorResponseTooLarge = -1,
    kDCHTTPOperationErrorOnOutputStream = -2,
    kDCHTTPOperationErrorBadContentType = -3,
};

@protocol DCHTTPOperationAuthenticationDelegate;

@interface DCHTTPOperation : DCRunLoopOperation {
}

- (id)initWithRequest:(NSURLRequest *)request; // designated
- (id)initWithURL:(NSURL *)url; // convenience, calls +[NSURLRequest requestWithURL:]

// Things that are configured by the init method and can't be changed.

@property (atomic, copy, readonly)  NSURLRequest *request;
@property (atomic, copy, readonly)  NSURL *URL;

// Things you can configure before queuing the operation.

// runLoopThread and runLoopModes inherited from DCRunLoopOperation
@property (atomic, copy, readwrite) NSIndexSet *acceptableStatusCodes; // default is nil, implying 200..299
@property (atomic, copy, readwrite) NSSet *acceptableContentTypes; // default is nil, implying anything is acceptable
@property (atomic, assign, readwrite) id<DCHTTPOperationAuthenticationDelegate> authenticationDelegate;

#if !defined(NDEBUG)
@property (atomic, copy, readwrite) NSError *debugError; // default is nil
@property (atomic, assign, readwrite) NSTimeInterval debugDelay; // default is none
#endif

// Things you can configure up to the point where you start receiving data.
// Typically you would change these in -connection:didReceiveResponse:, but
// it is possible to change them up to the point where -connection:didReceiveData:
// is called for the first time (that is, you could override -connection:didReceiveData:
// and change these before calling super).

// IMPORTANT: If you set a response stream, DCHTTPOperation calls the response
// stream synchronously.  This is fine for file and memory streams, but it would
// not work well for other types of streams (like a bound pair).

@property (atomic, strong, readwrite) NSOutputStream *responseOutputStream; // defaults to nil, which puts response into responseBody
@property (atomic, assign, readwrite) NSUInteger defaultResponseSize; // default is 1 MB, ignored if responseOutputStream is set
@property (atomic, assign, readwrite) NSUInteger maximumResponseSize; // default is 4 MB, ignored if responseOutputStream is set
// defaults are 1/4 of the above on iOS

// Things that are only meaningful after a response has been received;

@property (atomic, assign, readonly, getter=isStatusCodeAcceptable) BOOL statusCodeAcceptable;
@property (atomic, assign, readonly, getter=isContentTypeAcceptable) BOOL contentTypeAcceptable;

// Things that are only meaningful after the operation is finished.

// error property inherited from DCRunLoopOperation
@property (atomic, copy, readonly) NSURLRequest *lastRequest;
@property (atomic, copy, readonly) NSHTTPURLResponse *lastResponse;

@property (atomic, copy, readonly) NSData *responseBody;

@end


// DCHTTPOperation implements all of these methods, so if you override them
// you must consider whether or not to call super.
//
// These will be called on the operation's run loop thread.
@interface DCHTTPOperation (NSURLConnectionDelegate)

// Routes the request to the authentication delegate if it exists, otherwise
// just returns NO.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;

// Routes the request to the authentication delegate if it exists, otherwise
// just cancels the challenge.
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

// Latches the request and response in lastRequest and lastResponse.
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response;

// Latches the response in lastResponse.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

// If this is the first chunk of data, it decides whether the data is going to be
// routed to memory (responseBody) or a stream (responseOutputStream) and makes the
// appropriate preparations.  For this and subsequent data it then actually shuffles
// the data to its destination.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

// Completes the operation with either no error (if the response status code is acceptable)
// or an error (otherwise).
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

// Completes the operation with the error.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end

@protocol DCHTTPOperationAuthenticationDelegate <NSObject>

@required

// These are called on the operation's run loop thread and have the same semantics as their
// NSURLConnection equivalents.  It's important to realise that there is no
// didCancelAuthenticationChallenge callback (because NSURLConnection doesn't issue one to us).
// Rather, an authentication delegate is expected to observe the operation and cancel itself
// if the operation completes while the challenge is running.
- (BOOL)httpOperation:(DCHTTPOperation *)operation canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;
- (void)httpOperation:(DCHTTPOperation *)operation didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

@end
