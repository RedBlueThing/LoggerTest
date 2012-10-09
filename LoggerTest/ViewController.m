//
//  ViewController.m
//  LoggerTest
//
//  Created by Tom Horn on 3/10/12.
//  Copyright (c) 2012 Tom Horn. All rights reserved.
//

#import "Logger.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    m_requestList = [[NSMutableArray alloc] init];
    m_log = [[UILabel alloc] initWithFrame:self.view.frame];
    
    m_log.textAlignment = NSTextAlignmentCenter;

    m_log.font = [UIFont systemFontOfSize:30];
    m_log.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    m_log.adjustsFontSizeToFitWidth = YES;
    
    m_count = 0;
    
    [self.view addSubview:m_log];
    
    [self startPolling];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) handlePolling
{
    NSString * log = [NSString stringWithFormat:@"%d - logging %08X", m_count++, rand()];
    [[Logger instance] appendInfoLog:log withSummary:@"POLL"];
    m_log.text = log;
    
    if (rand () % 10 == 0)
    {   
        // make a request
        HttpRequest * request = [[HttpRequest alloc] init];
        [request addDelegate:self];
        [request start:@"http://www.google.com/"];
        
        // add our new request to the request list
        [m_requestList addObject:request];
    }

}

- (void) startPolling
{
    if (m_pollTimer)
        return;
    
    [[Logger instance] appendInfoLog:@"startPolling" withSummary:@"START_POLLING"];
    
    m_pollTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                   target:self
                                                 selector:@selector(handlePolling)
                                                 userInfo:nil
                                                  repeats:YES];
}

- (void)httpRequest:(HttpRequest*)request
   finishedWithData:(NSData*)data
           andError:(NSString*)error
            andCode:(NSInteger)code
{
    m_log.text = @"Got data";
    
    [request cancel];
    [request removeDelegate:self];
    
    // remove it from the request list as well
    [m_requestList removeObject:request];
}

@end
