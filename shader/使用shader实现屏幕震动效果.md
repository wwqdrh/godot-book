# 使用shader实现屏幕震动效果

<img data-id="20240608183709" src="https://cdn.ipfsscan.io/weibo/large/005ZoLfCgy1hqi4qbh6ncj30vw0hrkbn.jpg" alt="shader屏幕震动效果示例" />

## 代码详解

```python
shader_type canvas_item; # 着色器类型
uniform float ShakeStrength = 0; # 用于控制抖动强度。初始值为0,即不抖动。
uniform vec2 FactorA  = vec2(100.0,100.0); # 影响抖动的频率
uniform vec2 FactorB  = vec2(1.0,1.0); # 影响抖动的相位
uniform vec2 magnitude = vec2(0.01,0.01); # 用于控制抖动的幅度
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap; # 定义了一个统一采样器。hint_screen_texture指定这个纹理是屏幕纹理。

# 像素着色器的主要函数
void fragment() {
    vec2 uv = SCREEN_UV; # 获取当前像素的UV纹理坐标
	uv -= 0.5;
    uv *= 1.0 - 2.0 * magnitude.x;
    uv += 0.5; # 这些操作将UV坐标从[0,1]范围映射到[-magnitude.x, 1+magnitude.x]范围。
	vec2 dt = vec2(0.0, 0.0); # 初始化偏移量向量
	dt.x = sin(TIME * FactorA.x+FactorB.x) * magnitude.x; # 计算X方向的偏移量。
	dt.y = cos(TIME *FactorA.y+ FactorB.y) * magnitude.y; # 计算Y方向的偏移量。
	COLOR = texture(SCREEN_TEXTURE,uv + (dt*ShakeStrength)); # 从屏幕纹理中采样颜色,采样的UV坐标为原始UV坐标加上由抖动偏移量和抖动强度计算得到的偏移。
}
```