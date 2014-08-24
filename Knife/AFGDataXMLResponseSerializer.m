//
//  AFGDataXMLResponseSerializer.m
//  Knife
//
//  Created by HuangPeng on 8/24/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import "AFGDataXMLResponseSerializer.h"
#import "GDataXMLNode.h"

@implementation AFGDataXMLResponseSerializer

+ (instancetype)serializer {
    AFGDataXMLResponseSerializer *serializer = [[self alloc] init];
    
    return serializer;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml", nil];
    
    return self;
}

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSHTTPURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (!error) {
            return nil;
        }
    }
    
    NSError *error2;
    id responseObject = [[GDataXMLDocument alloc] initWithData:data error:&error2];
    if (error2) {
        return nil;
    }
    else {
        return responseObject;
    }
}

@end
