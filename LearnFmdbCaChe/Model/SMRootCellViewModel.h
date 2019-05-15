//
//  SMRootCellViewModel.h
//  LearnFmdbCaChe
//
//  Created by mac on 2019/5/15.
//  Copyright © 2019 zhihuiketang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMFeedModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMRootCellViewModel : NSObject
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *contentString;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *highlightString;
@property (nonatomic) BOOL isSync;
@property (nonatomic, strong) SMFeedModel *feedModel;
@end

NS_ASSUME_NONNULL_END
