#!/bin/bash

# 临时文件路径
TEMP_SCRIPT="/tmp/om_temp_script.sh"

# 下载最新脚本到临时文件
curl -s https://raw.githubusercontent.com/mingxiaoyu/across/main/om.sh -o "$TEMP_SCRIPT"

# 赋予临时文件执行权限
chmod +x "$TEMP_SCRIPT"

# 执行脚本
exec "$TEMP_SCRIPT"

# 确保所有定义的函数都能正确执行
update_script() {
    echo "正在更新脚本..."
    local new_script_url="https://raw.githubusercontent.com/mingxiaoyu/across/main/om.sh"
    local script_path="/usr/local/bin/om.sh"
    local link_path="/usr/local/bin/om"

    # 临时下载新的脚本到当前目录
    curl -s "$new_script_url" -o om.sh

    # 赋予新的脚本执行权限
    chmod +x om.sh

    # 确保目录存在
    sudo mkdir -p /usr/local/bin

    # 移动或复制新脚本到系统目录
    sudo cp om.sh "$script_path"

    # 创建或更新符号链接
    sudo ln -sf "$script_path" "$link_path"

    echo "脚本更新完成。"
    echo "请重新运行 'om' 命令以应用更新。"
    exit 0
}


# 安装功能
install_script() {
    local script_path="/usr/local/bin/om.sh"
    local link_path="/usr/local/bin/om"

    # 确保目录存在
    sudo mkdir -p /usr/local/bin

    # 复制脚本到系统目录
    sudo cp "$0" "$script_path"

    # 赋予执行权限
    sudo chmod +x "$script_path"

    # 创建符号链接
    sudo ln -sf "$script_path" "$link_path"

    echo "安装完成。你可以使用 'om' 命令来调用脚本。"
}


# 卸载功能
uninstall_script() {
    local script_path="/usr/local/bin/om.sh"
    local link_path="/usr/local/bin/om"

    # 删除符号链接
    sudo rm -f "$link_path"

    # 删除脚本文件
    sudo rm -f "$script_path"

    echo "卸载完成。"
}

# 设置 BBRv3
setup_bbr3() {
    echo "正在设置 BBRv3..."
    bash <(curl -Ls https://raw.githubusercontent.com/Naochen2799/Latest-Kernel-BBR3/main/bbr3.sh)

    # 配置 TCP 拥塞控制
    echo 'net.ipv4.tcp_congestion_control=bbr' | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p

    # 显示当前和可用的 TCP 拥塞控制算法
    echo "当前的 TCP 拥塞控制算法:"
    sysctl net.ipv4.tcp_congestion_control
    echo "可用的 TCP 拥塞控制算法:"
    sysctl net.ipv4.tcp_available_congestion_control
}

# 清理防火墙规则
clean_firewall() {
    echo "正在清理防火墙规则..."
    sudo ufw disable
    sudo iptables -F       # 清除所有规则
    sudo iptables -t nat -F
