---
date: '2022-07-31'
tags: ['godot']
draft: false
---

# 使用PinJoint2D实现可中心旋转的物体

<img src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi5ayeszmj30sa0ig3zc.jpg" data-id="20240608185700" alt="实现效果" />

## 场景搭建

实现可中心旋转的物体需要用到`PinJoin2D`节点，该节点需要链接两个节点，一个中心点，一个旋转物体

中心点使用`StaticBody2D`与`CollisionShape2D`的组合即可

旋转物体可以使用`RigidBody2D`, 然后创建一个`Polygon2D`用于绘制一个多边形

RigidBody2D可以设置以下属性

- Mass: 可以用于控制旋转快慢，值越大转得越慢
- Gravity Scale: 用于设置物体的重力

<img src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi5b96e5vj30ou0fs0xm.jpg" data-id="20240608185717" alt="旋转物体" />

创建一个`CollisionShape2D`为这个多边形添加碰撞体积, 使用脚本赋值

```godot
extends RigidBody2D

func _ready():
    $CollisionPolygon2D.polygon = $Polygon2D.polygon
```

点击Pinjoin2D分别设置NodeA以及NodeB属性

<img src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi5bmvkivj30tw09aabk.jpg" data-id="20240608185739" alt="连接节点" />

## 创建物体来触发旋转效果

随意创建一个物体，让其落到旋转物体上测试旋转效果

<img src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi5bwabj6j306m03y74l.jpg" data-id="20240608185754" alt="人物场景" />

> VisibilityNotifier2D可以用于当物体出屏幕外之后对其进行销毁，链接screen_exited信号

```godot
extends RigidBody2D

func _on_visiblityNotifier2D_screen_exited():
    queue_free()
```

接下来在主场景中加载上述物体，检测到鼠标按键之后创建一个新的物体落下

```godot
extends Node2D

var cube = load("res://cube.tscn")

func _input(event):
    if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
        var c = cube.instance()
        c.position = event.position
        add_child(c)
```