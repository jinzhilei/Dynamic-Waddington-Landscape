#!/usr/bin/env python3
"""
修改 0-2 目录的输出文件命名和 md-Qsum.dat 格式，
使其与 Solve_Equation.m 代码中的命名方式一致（顺序 k）。

操作：
1. md-Qsum.dat: 增加 k 列（顺序输出索引 0,1,2,...）
2. Q/, f/, Rf/ 下的文件: Qt{idx*200}.dat → Qt{idx}.dat （同理 ft, Rft）
"""
import os
import re

base_dir = "/Users/jzlei/work/1_Students/薛玉玲/program/two_dimensional/output/0-2"

# ========================
# 1. 处理 md-Qsum.dat
# ========================
md_path = os.path.join(base_dir, "md-Qsum.dat")
with open(md_path, "r") as f:
    lines = f.read().strip().splitlines()

new_lines = []
for k, line in enumerate(lines):
    parts = line.strip().split()
    # 当前格式: t Qsum (2列)
    t, qsum = parts[0], parts[1]
    # 目标格式: k t Qsum (3列)
    new_lines.append(f"{k} {t} {qsum}")

with open(md_path, "w") as f:
    f.write("\n".join(new_lines) + "\n")

print(f"md-Qsum.dat: {len(new_lines)} 行, 已增加 k 列 (0 → {len(new_lines)-1})")

# ========================
# 2. 重命名 Q/, f/, Rf/ 下的文件
# ========================
pattern = re.compile(r"^(Qt|ft|Rft)(\d+)\.dat$")

for subdir in ["Q", "f", "Rf"]:
    dir_path = os.path.join(base_dir, subdir)
    if not os.path.isdir(dir_path):
        print(f"跳过不存在目录: {dir_path}")
        continue

    files = os.listdir(dir_path)
    rename_map = {}  # old_name → new_name

    for fname in files:
        m = pattern.match(fname)
        if not m:
            continue
        prefix = m.group(1)     # Qt, ft, Rft
        num_str = m.group(2)   # 数值部分
        num = int(num_str)
        # 当前命名: num = index * 200
        if num % 200 != 0:
            print(f"  [警告] {fname}: {num} 不能被 200 整除，跳过")
            continue
        idx = num // 200
        new_name = f"{prefix}{idx}.dat"
        rename_map[fname] = new_name

    # 按原名字排序执行（确保先重命名小数字）
    for old_name in sorted(rename_map.keys(), key=lambda x: int(pattern.match(x).group(2))):
        new_name = rename_map[old_name]
        old_path = os.path.join(dir_path, old_name)
        new_path = os.path.join(dir_path, new_name)
        if old_path == new_path:
            continue
        if os.path.exists(new_path):
            print(f"  [错误] 目标文件已存在: {new_path}")
            continue
        os.rename(old_path, new_path)
        print(f"  {subdir}/: {old_name} → {new_name}")

print("\n完成！")
