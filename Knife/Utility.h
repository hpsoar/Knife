//
//  Utility.h
//  Knife
//
//  Created by HuangPeng on 8/23/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utility)

@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger week;

@property (nonatomic, readonly) NSDateComponents *solarComponents;
@property (nonatomic, readonly) NSDateComponents *lunarComponents;

@end

@interface LunarDate : NSObject

@property (nonatomic, readonly) NSString *dayString;
@property (nonatomic, readonly) NSString *monthString;
@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger month;
@property (nonatomic) NSInteger year;

- (id)initWithDate:(NSDate *)date;

@end

@interface Utility : NSObject

@end
