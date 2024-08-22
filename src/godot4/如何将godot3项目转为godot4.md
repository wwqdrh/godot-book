<!-- toc -->

# 如何将godot3项目转为godot4

- `onready`修改为`@onready`
- `export`修改为`@export`

```gdscript
# 如果变量后面是 := 那么就需要定义get或者set，如果是 = 就不需要定义
@export var detail := 0  :
	set = set_tileset
    get = get_tileset
```

- 枚举值修改为`@export_enum(...) var v: String = ""`
- tween节点使用`create_tween()`进行创建
- `yield`改为`await`
- 信号的连接改为`signala.connect(funca)`
- 时间的获取

```gdscript
# 修改前
var d = OS.get_datetime()
d.erase("dst")
var s = ""

for i in (d.values()):
    s += str(i) + " "

# 修改后
var time = Time.get_datetime_dict_from_system()
time.erase("dst") # 删除夏令时标志

var datetime_string := ""
for value in time.values():
    datetime_string += str(value) + " "

print(datetime_string)
```

- Engine相关

```gdscript

# 修改前
func set_iterations(arg := iterations):
	iterations = max(1, arg)
	Engine.iterations_per_second = iterations

func set_target_fps(arg := target_fps):
	target_fps = abs(arg)
	#print("target_fps: ", target_fps)
	Engine.target_fps = target_fps
    
# 修改后
func set_iterations(arg := iterations):
    iterations = max(1, arg)
    ProjectSettings.set_setting("physics/iterations_per_second", iterations)

func set_target_fps(arg := target_fps):
    target_fps = abs(arg)
    ProjectSettings.set_setting("display/window/target_fps", target_fps)
```

- `MainLoop.NOTIFICATION_WM_QUIT_REQUEST`修改为``
- 文件操作相关, `File`修改为`FileAccess`, `Dir`修改为`DirAccess`
- `PoolVector2Array`修改为`PackedVector2Array`
- `update()`修改为`queue_redraw()`方法，重新绘制
- `deg2rad`修改为`deg_to_rad`
- `color.white`修改修改为`color.WHITE`，所有颜色名称都变成大写了
- `extends VisibilityNotifier2D`修改为`extends VisibleOnScreenNotifier2D`
- `Engine.editor_hint`修改为`Engine.is_editor_hint()`
- `KinematicBody2D`修改为`CharacterBody2D`
- `Sprite`修改为`Sprite2D`
- `stepify`修改为`snapped`
- `InputMap.get_action_list`修改为`InputMap.action_get_events`
- `set_shader_param`修改为`set_shader_parameter`