//
//  LHNMainWindowController.m
//  LeapHemnet
//
//  Created by Stefan Lindbohm on 2013-08-14.
//  Copyright (c) 2013 Stefan Lindbohm. All rights reserved.
//

#import "LHNMainWindowController.h"

#import "LHNLeapRangeRecognizer.h"

@interface LHNMainWindowController ()

- (void)updateLabels;
- (void)updateSelectionProgress;
- (void)selectValue;

@property (nonatomic) NSArray *roomValues;
@property (nonatomic) NSTimeInterval selectionStart;
@property (nonatomic) NSTimer *selectionTimer;
@property (nonatomic) NSTimer *progressBarTimer;

@end

@implementation LHNMainWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName
{
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        self.roomValues = @[ @"1", @"2", @"3", @"4", @"5", @"ASMÅNGA" ];
        
        self.window.delegate = self;
    }
    
    return self;
}

- (void)updateLabels {
    if (self.leapRecognizer.currentValue != NULL) {
        self.instructionsLabel.hidden = YES;
        self.roomsLabel.hidden = NO;
        self.roomsLabel.stringValue = [NSString stringWithFormat:@"%@ RUM", self.roomValues[[self.leapRecognizer.currentValue integerValue]]];
    } else {
        self.instructionsLabel.hidden = NO;
        self.roomsLabel.hidden = YES;
    }
}

- (void)updateSelectionProgress {
    if ([self.selectionTimer isValid]) {
        double selectionProgress = ([NSDate timeIntervalSinceReferenceDate] - self.selectionStart) / 2.0;
        
        self.selectionProgressIndicator.doubleValue = selectionProgress * 100;
    } else {
        self.selectionProgressIndicator.doubleValue = 0;
    }
}

- (void)selectValue {
    [self.progressBarTimer invalidate];
    
    self.selectionProgressIndicator.doubleValue = 100;
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://hemnet.dev:3000/resultat?rooms=%li", ([self.leapRecognizer.currentValue integerValue] + 1)]]];
}

#pragma mark - NSWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    if (self.leapRecognizer == NULL) {
        self.leapRecognizer = [[LHNLeapRangeRecognizer alloc] init];
        self.leapRecognizer.values = self.roomValues.count;
        self.leapRecognizer.delegate = self;
    }
    
    [self.leapRecognizer start];
    
    [self updateLabels];
}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification {
    [self.leapRecognizer stop];
}

#pragma mark - LHNLeapRangeRecognizerUpdateNotification

- (void)rangeValueDidChange:(NSNotification *)notification {
    [self updateLabels];
    
    if (self.selectionTimer != NULL) {
        [self.selectionTimer invalidate];
        [self.progressBarTimer invalidate];
    }
    
    if (self.leapRecognizer.currentValue != NULL) {
        self.selectionStart = [NSDate timeIntervalSinceReferenceDate];
        self.selectionTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(selectValue) userInfo:nil repeats:NO];
        self.progressBarTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateSelectionProgress) userInfo:nil repeats:YES];
    }
    
    [self updateSelectionProgress];
}

@end
