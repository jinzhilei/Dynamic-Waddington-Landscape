#!/usr/bin/env python3
"""
将目录中的输出文件重命名为顺序 k 格式，并给 md-Qsum.dat 增加 k 列。
支持两种目录结构：
  Type A: baseDir/md-Qsum.dat + baseDir/Q/, baseDir/f/, baseDir/Rf/
  Type B: baseDir/output_X_Y_Qsum/md-Qsum.dat + baseDir/output_X_Y_Q/, etc.
"""
import os
import re
import sys

def process_directory(base_dir):
    """自动检测目录结构并执行重命名"""
    
    # --- 检测目录结构 ---
    # 优先找 Type B: output_XXX_Y_Qsum 等子目录
    qsum_dirs = [d for d in os.listdir(base_dir) if d.endswith("_Qsum") and os.path.isdir(os.path.join(base_dir, d))]
    q_dirs = [d for d in os.listdir(base_dir) if d.endswith("_Q") and not d.endswith("_Qsum") and os.path.isdir(os.path.join(base_dir, d))]
    f_dirs = [d for d in os.listdir(base_dir) if d.endswith("_f") and os.path.isdir(os.path.join(base_dir, d)) and not d.endswith("_Qsum")]
    rf_dirs = [d for d in os.listdir(base_dir) if d.endswith("_Rf") and os.path.isdir(os.path.join(base_dir, d))]
    
    if qsum_dirs and q_dirs and f_dirs and rf_dirs:
        # Type B
        qsum_subdir = qsum_dirs[0]
        q_subdir = q_dirs[0]
        f_subdir = f_dirs[0]
        rf_subdir = rf_dirs[0]
        print(f"  检测为 Type B: {qsum_subdir}, {q_subdir}, {f_subdir}, {rf_subdir}")
        md_path = os.path.join(base_dir, qsum_subdir, "md-Qsum.dat")
        subdirs = {
            "Q":  os.path.join(base_dir, q_subdir),
            "f":  os.path.join(base_dir, f_subdir),
            "Rf": os.path.join(base_dir, rf_subdir),
        }
    else:
        # Type A: 直接查找
        md_path = os.path.join(base_dir, "md-Qsum.dat")
        subdirs = {}
        for name in ["Q", "f", "Rf"]:
            p = os.path.join(base_dir, name)
            if os.path.isdir(p):
                subdirs[name] = p
        if not os.path.exists(md_path):
            print(f"  [跳过] 找不到 md-Qsum.dat: {md_path}")
            return
        print(f"  检测为 Type A: Q/, f/, Rf/ + md-Qsum.dat")
    
    # --- 1. 处理 md-Qsum.dat ---
    with open(md_path, "r") as f:
        lines = f.read().strip().splitlines()
    
    new_lines = []
    for k, line in enumerate(lines):
        parts = line.strip().split()
        t, qsum = parts[0], parts[1]
        new_lines.append(f"{k} {t} {qsum}")
    
    with open(md_path, "w") as f:
        f.write("\n".join(new_lines) + "\n")
    
    print(f"  md-Qsum.dat: {len(new_lines)} 行, 已增加 k 列 (0 → {len(new_lines)-1})")
    
    # --- 2. 重命名各子目录下的文件 ---
    pattern = re.compile(r"^(Qt|ft|Rft)(\d+)\.dat$")
    total_renamed = 0
    
    for label, dir_path in sorted(subdirs.items()):
        if not os.path.isdir(dir_path):
            print(f"  [跳过] 目录不存在: {dir_path}")
            continue
        
        files = os.listdir(dir_path)
        rename_pairs = []
        
        for fname in files:
            m = pattern.match(fname)
            if not m:
                continue
            prefix = m.group(1)
            num = int(m.group(2))
            # 仅在能被 200 整除时做重命名（否则已经是顺序命名）
            if num % 200 != 0:
                continue
            idx = num // 200
            new_name = f"{prefix}{idx}.dat"
            if fname != new_name:
                rename_pairs.append((fname, new_name))
        
        # 按旧名编号排序执行
        rename_pairs.sort(key=lambda x: int(pattern.match(x[0]).group(2)))
        for old_name, new_name in rename_pairs:
            old_path = os.path.join(dir_path, old_name)
            new_path = os.path.join(dir_path, new_name)
            if os.path.exists(new_path):
                print(f"  [错误] 目标文件已存在: {new_path}")
                continue
            os.rename(old_path, new_path)
            total_renamed += 1
            # 不打印每个文件，避免日志过长
        
        n_ok = len(rename_pairs)
        print(f"  {label}/: 重命名 {n_ok}/{len(files)} 个文件 (Qt{rename_pairs[0][0] if rename_pairs else '?'} → Qt{rename_pairs[0][1] if rename_pairs else '?'} ...)")
    
    return total_renamed


if __name__ == "__main__":
    base = "/Users/jzlei/work/1_Students/薛玉玲/program/two_dimensional/output"
    
    # 指定要处理的目录
    targets = ["0-3", "0-4", "0-5", "0-6"]
    
    for name in targets:
        dir_path = os.path.join(base, name)
        if not os.path.isdir(dir_path):
            print(f"[跳过] 目录不存在: {dir_path}")
            continue
        print(f"\n处理 {name}/ ...")
        n = process_directory(dir_path)
        print(f"  完成，共重命名 {n} 个文件")
    
    print("\n所有目录处理完毕！")
