//
//  SMRootCellTableViewCell.m
//  LearnFmdbCaChe
//
//  Created by mac on 2019/5/15.
//  Copyright © 2019 zhihuiketang. All rights reserved.
//

#import "SMRootCell.h"


@interface SMRootCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *highlightLabel;
@property (nonatomic, strong) SMFeedModel *feedModel;

@property (nonatomic, strong) UIButton *clickButton;

@end

@implementation SMRootCell

- (instancetype)init {
    if (self = [super init]) {
        [self buildUI];
    }
    return self;
}

- (instancetype)initWithViewModel:(SMRootCellViewModel *)viewModel {
    if (self = [super init]) {
        [self buildUI];
        [self updateWithViewModel:viewModel];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.highlightLabel];
    [self addSubview:self.clickButton];

    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset([SMStyle floatMarginNormal]);
        make.left.equalTo(self).offset([SMStyle floatMarginMassive]);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset([SMStyle floatMarginNormal]);
        make.top.equalTo(self.iconImageView).offset([SMStyle floatMarginMinor]);
        make.right.lessThanOrEqualTo(self).offset(-50);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset([SMStyle floatTextIntervalVertical]);
        make.right.lessThanOrEqualTo(self).offset(-50);
    }];
    [self.highlightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-[SMStyle floatMarginMassive]);
        make.top.equalTo(self.titleLabel).offset([SMStyle floatMarginMinor]);
    }];
}

#pragma mark - Interface
- (void)updateWithViewModel:(SMRootCellViewModel *)viewModel {
    self.titleLabel.text = viewModel.titleString;
    self.contentLabel.text = viewModel.contentString;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.iconUrl]];
    self.highlightLabel.text = viewModel.highlightString;
    if (!viewModel.isSync || [viewModel.highlightString isEqualToString:@"0"]) {
        self.highlightLabel.textColor = [SMStyle colorPaperGray];
        self.titleLabel.textColor = [SMStyle colorPaperGray];
    } else {
        self.highlightLabel.textColor = [SMStyle colorPaperBlack];
        self.titleLabel.textColor = [SMStyle colorPaperBlack];
    }
    
    self.feedModel = viewModel.feedModel;
}

#pragma mark - Private
- (void)clickedButton {
    if ([self.delegate respondsToSelector:@selector(smRootCellView:clickWithFeedModel:)]) {
        [self.delegate smRootCellView:self clickWithFeedModel:self.feedModel];
    }
}

#pragma mark - Getter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor grayColor];
    }
    return _contentLabel;
}
- (UILabel *)highlightLabel {
    if (!_highlightLabel) {
        _highlightLabel = [[UILabel alloc] init];
        _highlightLabel.textAlignment = NSTextAlignmentRight;
        _highlightLabel.textColor = [UIColor grayColor];
    }
    return _highlightLabel;
}
- (UIButton *)clickButton {
    if (!_clickButton) {
        _clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickButton setBackgroundColor:[SMStyle colorBlackLightAlpha] forState:UIControlStateHighlighted];
        [_clickButton addTarget:self action:@selector(clickedButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickButton;
}

@end
