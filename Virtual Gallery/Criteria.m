//
//  Criteria.m
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 05/11/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import "Criteria.h"

@implementation Criteria

@synthesize category;
@synthesize freeText;
@synthesize year;
@synthesize author;
@synthesize tags;

-(id) initWithData: (NSArray *) searchData {
        
    self = [super init];
    NSString *text = [[NSString alloc] init];
    NSString *tag = [[NSString alloc] init];
    for(int i = 0; i < [searchData count] - 1; i++) {
        text = [text stringByAppendingString:(NSString *)searchData[i]];
        text = [text stringByAppendingString:@"+"];
        tag = [tag stringByAppendingString:(NSString *)searchData[i]];
        tag = [tag stringByAppendingString:@"+"];
    }
    text = [text stringByAppendingString:(NSString *)[searchData lastObject]];
    tag = [tag stringByAppendingString:(NSString *)[searchData lastObject]];
    
    freeText = text;
    tags = tag;
    
    return self;
}

@end
