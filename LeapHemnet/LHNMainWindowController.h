//
//  LHNMainWindowController.h
//  LeapHemnet
//
//  Created by Stefan Lindbohm on 2013-08-14.
//  Copyright (c) 2013 Stefan Lindbohm. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LHNLeapRangeRecognizer.h"

@interface LHNMainWindowController : NSWindowController <NSWindowDelegate, LHNLeapRangeRecognizerDelegate>

@property (nonatomic) IBOutlet NSTextField *roomsLabel;
@property (nonatomic) IBOutlet NSTextField *instructionsLabel;
@property (nonatomic) IBOutlet NSProgressIndicator *selectionProgressIndicator;
@property (nonatomic) LHNLeapRangeRecognizer *leapRecognizer;

@end
