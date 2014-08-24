//
//  Utility.m
//  Knife
//
//  Created by HuangPeng on 8/23/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import "Utility.h"

@implementation NSDate (Utility)

- (NSInteger)year {
    return self.solarComponents.year;
}

- (NSInteger)month {
    return self.solarComponents.month;
}

- (NSInteger)day {
    return self.solarComponents.day;
}

- (NSInteger)week {
    return self.solarComponents.weekday;
}

- (NSDateComponents *)solarComponents {
    return [self dateComponentsWithIdentifier:NSGregorianCalendar];
}

- (NSDateComponents *)lunarComponents {
    return [self dateComponentsWithIdentifier:NSChineseCalendar];
}

- (NSDateComponents *)dateComponentsWithIdentifier:(NSString *)identifier {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:identifier];
    NSCalendarUnit units = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitWeekday;
    return [calendar components:units fromDate:self];
}

@end

@implementation LunarDate

- (id)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        self.day = date.day;
        self.month = date.month;
        self.year = date.year;
    }
    return self;
}

- (NSString *)dayString {
    NSArray *days = @[ @"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                       @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                       @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十" ];
    return days[self.day];
}

- (NSString *)monthString {
    NSArray *months = @[ @"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊" ];
    return months[self.month];
}


@end


@implementation Utility

@end
