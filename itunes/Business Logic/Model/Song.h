//
//  Song.h
//  itunes
//
//  Created by Martin Lloyd on 31/10/2015.
//  Copyright © 2015 Martin Lloyd. All rights reserved.
//

#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface Song : NSObject

@property (nonatomic, copy) NSString *artistName;
@property (nonatomic, copy) NSString *trackName;
@property (nonatomic, copy) NSURL    *imageURL;

@property (nonatomic, copy) NSString *albumName;
@property (nonatomic, copy) NSNumber *price;
@property (nonatomic, copy) NSDate   *releaseDate;

@property (nonatomic, copy) NSURL    *audioURL;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
