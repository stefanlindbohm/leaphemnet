//
//  LHNLeapRecognizer.h
//  LeapHemnet
//
//  Created by Stefan Lindbohm on 2013-08-13.
//  Copyright (c) 2013 Stefan Lindbohm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeapObjectiveC.h"

extern NSString * const LHNLeapRangeRecognizerUpdateNotification;

@protocol LHNLeapRangeRecognizerDelegate <NSObject>

- (void)rangeValueDidChange:(NSNotification *)notification;

@end

@interface LHNLeapRangeRecognizer : NSObject <LeapListener>

- (void)start;
- (void)stop;

@property (assign, nonatomic) id<LHNLeapRangeRecognizerDelegate> delegate;
@property (nonatomic) NSInteger values;
@property (nonatomic, readonly) NSNumber *currentValue;

@end
