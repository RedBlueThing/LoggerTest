//
//  AppDelegate.h
//  LoggerTest
//
//  Created by Tom Horn on 3/10/12.
//  Copyright (c) 2012 Tom Horn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Logger.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Logger * m_logger;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
