//
//  LHNAppDelegate.h
//  LeapHemnet
//
//  Created by Stefan Lindbohm on 2013-08-13.
//  Copyright (c) 2013 Stefan Lindbohm. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LHNMainWindowController;

@interface LHNAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic) IBOutlet LHNMainWindowController *mainWindowController;

@end
