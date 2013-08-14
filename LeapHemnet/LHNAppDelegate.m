//
//  LHNAppDelegate.m
//  LeapHemnet
//
//  Created by Stefan Lindbohm on 2013-08-13.
//  Copyright (c) 2013 Stefan Lindbohm. All rights reserved.
//

#import "LHNAppDelegate.h"
#import "LHNMainWindowController.h"

@implementation LHNAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.mainWindowController = [[LHNMainWindowController alloc] initWithWindowNibName:@"MainWindow"];
    
    [self.mainWindowController showWindow:self];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)application {
    return YES;
}

@end
