---
date: '2022-07-31'
tags: ['godot']
category: ['godot3']
draft: false
---

# 教你实现PC和手机端的虚拟摇杆

<img data-id="20240608183841" src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi4rw2wfij30pg0c6mx7.jpg" alt="效果展示" />

## 场景搭建

素材本身就是两个大小圆，主要是通过坐标检测是否在摇杆作用范围内，然后根据坐标计算更新中心小圆的位置，并且在松开手后将其归位

<img data-id="20240608183859" src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi4s737inj308y04q74f.jpg" alt="效果展示" />

```godot
extends Sprite

var maxLen = 70
var ondraging = -1 # 用于解决范围内点击然后移动到范围外能够继续滚动

func _input(event):
    if event is InputEventScreenDrag or (event is InputEventScreenTounch and event.is_pressed()):
        var mouse_pos = (event.position - self.global_position).length()

        if mouse_pos <= maxLen or event.get_index() == ondraging:
            ondraging = event.get_index() # 手指点击的索引
            
            $point.set_global_position(event.position)

            if get_point_pos().length() > maxLen:
                $point.set_position(get_point_pos().normalized() * maxLen)
    
    if event is InputEventScreenTounch and !event.is_pressed():
        # 松手
        set_center()
        if event.get_index() == ondraging:
            ondraing = -1

func get_point_pos():
    return $point.position

func set_center():
    # 添加缓动效果
    $Tween.interpolate_property($point, "position", get_point_pos(), Vector2(0, 0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.start()

func get_now_pos():
    return get_point_pos().normalized()
```

## 移动映射

获取鼠标在摇杆上的位置，可以将这个位置映射到物体的移动上

```godot
extends Node2D

onready var joystick = $joystick

func _process(delta):
    $KinematicBody2D.move_and_slide(joystick.get_now_pos() * 230)

---
date: '2022-07-31'
tags: ['godot']
draft: false
---

# 将摇杆放置在按下的位置，而不是固定位置
func _input(event):
    if event is InputEventScreenTouch and event.is_pressed():
        joystick.visible = true
        joystick.position = event.position
    if event is InputEventScreenTouch and !event.is_pressed():
        joystick.visible = false
```

## 设置

需要注意在桌面环境中需要开启`Emulate Touch From Mouse`才能够响应`InputEventScreenDrag`, `InputEventScreenTounch`触摸事件

<img data-id="20240608183921" src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi4sll2g6j313c0smagd.jpg" alt="效果展示" />