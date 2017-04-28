/*
 *  Copyright (c) 2016 Spotify AB.
 *
 *  Licensed to the Apache Software Foundation (ASF) under one
 *  or more contributor license agreements.  See the NOTICE file
 *  distributed with this work for additional information
 *  regarding copyright ownership.  The ASF licenses this file
 *  to you under the Apache License, Version 2.0 (the
 *  "License"); you may not use this file except in compliance
 *  with the License.  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

#import "HUBComponentCollectionViewCell.h"

#import "HUBComponent.h"
#import "HUBUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@implementation HUBComponentCollectionViewCell

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _identifier = [NSUUID UUID];
    }
    
    return self;
}

#pragma mark - Property overrides

- (void)setComponent:(nullable id<HUBComponent>)component
{
    if (_component == component) {
        return;
    }

    _component = component;

    if (component == nil) {
        return;
    }

    if (self.contentView.subviews.count == 0) {
        [self addComponentView];
    } else {
        // associate existing component view that's embedded in the contentView with the current component
        self.component.view = self.contentView.subviews.firstObject;
    }
}

- (void)addComponentView
{
    id<HUBComponent> const nonNilComponent = self.component;

    UIView * const componentView = HUBComponentLoadViewIfNeeded(nonNilComponent);
    componentView.autoresizingMask |= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    componentView.frame = self.bounds;

    [self.contentView addSubview:componentView];
}

#pragma mark - UICollectionViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];

    [self.component prepareViewForReuse];
    self.component = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.component.view.frame = self.contentView.bounds;
}

@end

NS_ASSUME_NONNULL_END
