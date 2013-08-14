//
//  LHNLeapRecognizer.m
//  LeapHemnet
//
//  Created by Stefan Lindbohm on 2013-08-13.
//  Copyright (c) 2013 Stefan Lindbohm. All rights reserved.
//

#import "LHNLeapRangeRecognizer.h"

NSString * const LHNLeapRangeRecognizerUpdateNotification = @"LHNLeapRangeRecognizerUpdateNotification";

// Distance thresholds in mm
NSInteger const LHNMaxValueDistance = 600;
NSInteger const LHNMinValueDistance = 100;

#pragma mark - Private interface

@interface LHNLeapRangeRecognizer ()

@property (nonatomic) LeapController *leapController;
@property (nonatomic) BOOL subscribed;
@property (nonatomic, readwrite) NSNumber *currentValue;

@end

#pragma mark - Implementation

@implementation LHNLeapRangeRecognizer

- (id)init {
    if (self = [super init]) {
        self.leapController = [[LeapController alloc] init];
        self.subscribed = NO;
        self.values = 0;
        self.currentValue = NULL;
    }
    
    return self;
}

#pragma mark - Listening control

- (void)start {
    if (!self.subscribed) {
        [self.leapController addListener:self];
        self.subscribed = YES;
    }
}

- (void)stop {
    [self.leapController removeListener:self];
    self.subscribed = NO;
}

#pragma mark - LeapListener methods

- (void)onFrame:(NSNotification *)notification {
    LeapFrame *frame = [self.leapController frame:0];
    NSNumber *newValue;
    
    if ([[frame hands] count] > 1) {
        LeapHand *firstHand = [frame hands][0];
        LeapHand *secondHand = [frame hands][1];
        
        double deltaX = firstHand.palmPosition.x - secondHand.palmPosition.x;
        double deltaY = firstHand.palmPosition.y - secondHand.palmPosition.y;
        double deltaZ = firstHand.palmPosition.z - secondHand.palmPosition.z;
        
        double distance = sqrt(pow(deltaX, 2) + pow(deltaY, 2) + pow(deltaZ, 2));
        
        if (distance < LHNMinValueDistance) {
            newValue = 0;
        } else if (distance >= LHNMaxValueDistance) {
            newValue = [NSNumber numberWithInteger:self.values - 1];
        } else {
            double factor = (distance - LHNMinValueDistance) / (LHNMaxValueDistance - LHNMinValueDistance);
            
            newValue = [NSNumber numberWithInteger:floor(self.values * factor)];
        }
    } else {
        newValue = NULL;
    }
    
    if (self.currentValue != newValue) {
        self.currentValue = newValue;
        
        [self.delegate rangeValueDidChange:[NSNotification notificationWithName:LHNLeapRangeRecognizerUpdateNotification object:self]];
    }
}

@end
