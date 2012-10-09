//
//  ViewController.h
//  LoggerTest
//
//  Created by Tom Horn on 3/10/12.
//  Copyright (c) 2012 Tom Horn. All rights reserved.
//

#import "HttpRequest.h"
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <HttpRequestDelegate>
{
    // timer to poll the API
	NSTimer *						m_pollTimer;
    
    UILabel *                       m_log;
    int                             m_count;
    
    NSMutableArray *                m_requestList;
}

@end
