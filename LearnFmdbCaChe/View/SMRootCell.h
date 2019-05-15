//
//  SMRootCellTableViewCell.h
//  LearnFmdbCaChe
//
//  Created by mac on 2019/5/15.
//  Copyright © 2019 zhihuiketang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRootCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SMRootCell;
@protocol SMRootCellDelegate <NSObject>
@optional
- (void)smRootCellView:(SMRootCell *)cell clickWithFeedModel:(SMFeedModel *)feedModel;
@end

@interface SMRootCell : UITableViewCell
@property (nonatomic, weak) id<SMRootCellDelegate> delegate;
- (instancetype)initWithViewModel:(SMRootCellViewModel *)viewModel;
- (void)updateWithViewModel:(SMRootCellViewModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
