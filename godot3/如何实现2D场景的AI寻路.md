# 如何实现2D场景的AI寻路

<img alt="实现效果" data-id="20240608184220" src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi4vp68kuj30ym0ieq49.jpg" />

## 路径绘制

<img alt="路径绘制" data-id="20240608184238" src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi4vzz78aj309405i74t.jpg" />

点击Polygon2D节点，然后在窗口上方点击添加路径按钮，开始绘制可以活动的范围，效果图如下

<img alt="路径绘制效果" data-id="20240608184255" src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi4wb0vqdj312s0oedm3.jpg" />

将`Polygon2D`创建的路径赋值给`NavigationPolygon`寻路节点, 需要在根节点`Navigation2D`节点中创建一个脚本

```godot
extends Navigation2D

func _ready():
    var polygon = NavigationPolygon.new()
    var outline = $Polygon2D.polygon
    polygon.add_outline(outline)
    polygon.make_polygons_from_outlines()
    $NavigationPolygonInstance.navpoly = polygon
    set_process(false) # 暂停行为逻辑
```

## 寻路逻辑

场景中的Icon节点就是需要响应鼠标事件，并且使其自动移动到目标地址

```godot
extends Navigation2D

var path = []
var speed = 300

func _input(event):
    if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
        path = get_simple_path($icon.position, get_local_mouse_position(), true) # 计算出来运动路径
        # $Polygon2D.draw_path_line(path) # 绘制出运动轨迹，具体实现看下文
        set_process(true) # 只有在有左键点击事件才恢复渲染

func _process(delta):
    var walk_speed = speed * delta
    move_to_path(walk_speed)

func move_to_path(walk_speed):
    var last_point = $icon.position
    while path.size():
        var distance_between_points = last_point.distance_to(path[0])
        if distance_between_points >= 2:
            $icon.position = last_point.linear_interpolate(path[0], walk_speed/distance_between_points)
            return # 返回，等待_process执行下一次移动
        last_point = path[0]
        path.remove(0)
    # 移动到了目标路径，将最后一点的偏差直接赋值即可
    $icon.position = last_point
    set_process(false)
```

## 绘制运动路径

通过脚本绘制出物体的运动轨迹


<img alt="路径效果" data-id="20240608184315" src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi4wn6v9cj31160j2my4.jpg" />

在Polygon2D上创建脚本如下

```godot
extends Polygon2D

var path = []

func draw_path_line(path):
    self.path = path
    update()

func _draw():
    if path.size() > 1:
        for i in range(0, path.size() - 1, 1):
            draw_line(path[i], path[i+1])
            update()
```