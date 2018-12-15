---
title: CAD x Python 开发之坑（一)
top: 0
date: 2018/12/15 00:04:17
categories:
- Program
tags:
- CAD
- ActiveX Automation
- Python
---

目前因工作相关，在做一些 CAD 的二次开发，这里刚好记录一下中间遇到的坑。

---

# CAD 开发工具

目前采用 Python 对接 CAD 的 ActiveX Automation 接口，需求包为 pyautocad，该包需适当扩展方可完成设计需求。
<!-- more -->

---

# CAD 整理

## CAD 软件现状及接口调整

目前无论 `天正 CAD` 这类基于AutoCAD做出的二次开发，还是 `中望 CAD` 这类所谓的完全自主研发，经测试只是主接口名称改变，一般只需参考该软件文档修改 `AutoCAD.Application` 为对应接口名称即可。

---

# CAD 坑

## pyautocad 包 无法获取 Attributes

pyautocad 包采用 comtypes 连接，在对对象进行 `object.GetAttributes()` 时，会出现以下错误（ [comtypes/issues/63](https://github.com/enthought/comtypes/issues/63) 中提及 ）：

```
...\lib\site-packages\comtypes\automation.pyc in _get_value(self, dynamic)
    391             return value
    392         elif self.vt & VT_ARRAY:
--> 393             typ = _vartype_to_ctype[self.vt & ~VT_ARRAY]
    394             return cast(self._.pparray, _midlSAFEARRAY(typ)).unpack()
    395         else:
```

据此，可引入 win32com 包，另作一个 CAD 接口，将 pyautocad 中 api.py 内的以下方法

```python
self._app = comtypes.client.GetActiveObject('AutoCAD.Application', dynamic=True)
```

修改为

```python
self._app = win32com.client.Dispatch("AutoCAD.Application")
```

即可调用。

## comtypes (pyautocad) 和 win32com 接口需同时使用

### 数据传输的便捷

win32com 包可能在传输数据时与 comtypes 不太一致，如 pyautocad 采用的 `aDouble` 、 `aInt` 、 `aShort` 方法在 comtypes 接口时可传输，但在 win32com 接口时会产生错误。该方法实际效果如下：

```python
array.array("d", list)
```

### 两个接口各自的便利

comtypes 具有 `comtypes.client.GetBestInterface(obj)` 方法，对应 pyautocad 中 api.py 内的 `best_interface(self, obj)` 方法。可快速检索接口。

win32com 可采用 `help()` 查看参数需求。

目前测试中两者不易互相取代。

> 综上所述，建议在开发时同时调用 comtypes 方法和 win32com 方法。
> 对 CAD 操作时除获取 Attributes 时采用 win32com 包外，其他时候均采用 pyautocad 自带 comtypes 包即可。