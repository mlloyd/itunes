//
//  Song.m
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import "Song.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
static NSDateFormatter *dateFormatter = nil;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation Song

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if(self = [super init]) {
        self.artistName  = dictionary[@"artistName"];
        self.trackName   = dictionary[@"trackName"];
        self.imageURL    = [NSURL URLWithString:dictionary[@"artworkUrl100"]];
        self.albumName   = dictionary[@"collectionName"];
        self.price       = dictionary[@"trackPrice"];
        self.releaseDate = [self.class formatDate:dictionary[@"releaseDate"]];
        self.audioURL    = [NSURL URLWithString:dictionary[@"previewUrl"]];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)formatDate:(NSString *)strDate
{
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    }
    
    return [dateFormatter dateFromString:strDate];
}

@end
