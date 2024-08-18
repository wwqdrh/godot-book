---
date: '2022-07-31'
tags: ['godot']
category: ['godot3']
draft: false
---

# 用Light2D实现遮罩动画

<img alt="实现效果" src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi5fh6d19j30ko0dk0tb.jpg" data-id="20240608190121" />

## 场景搭建

<img alt="场景搭建" src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi5fpkxonj306q04gaae.jpg" data-id="20240608190134" />

为Light2D添加亮光图片材质

设置`Visibility.Light Mask`, 将其全部关闭，这样灯光只会出现在logo上

<img alt="场景搭建" src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi5fx1mwnj30lg0bwgn3.jpg" data-id="20240608190146" />

修改Light2D的模式Mode为Mix

为TextureRect添加材质，选择Material，选择材质CanvasItemMaterial, 并且将Light Mode设置为Light Only，这样设置之后就只有被灯光照到的地方才会显示出来

<img alt="场景搭建" src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi5g53svcj30hy0c60u0.jpg" data-id="20240608190159" />

## 创建动画

创建AnimationPlayer节点，新建动画

为Light2D的缩放大小创建关键帧，从而实现遮罩动画

<img alt="动画" src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi5ge8p56j30a204st99.jpg" data-id="20240608190213" />