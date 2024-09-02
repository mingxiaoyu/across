#!/bin/bash

# 下载并更新脚本
update_script() {
    echo "正在更新脚本..."
    local new_script_url="https://raw.githubusercontent.com/mingxiaoyu/across/main/om.sh"
    local script_path="/usr/local/bin/om.sh"
    local link_path="/usr/local/bin/om"

    # 临时下载新的脚本到当前目录
    curl -O "$new_script_url"

    # 赋予新的脚本执行权限
    chmod +x om.sh

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
    sudo iptables -t nat -F # 清除所有 NAT 表规则
    sudo iptables -t mangle -F # 清除所有 Mangle 表规则
    sudo iptables -X       # 删除所有自定义链
    sudo iptables -t nat -X # 删除所有自定义 NAT 链
    sudo iptables -t mangle -X # 删除所有自定义 Mangle 链
    sudo systemctl stop nftables
    sudo systemctl disable nftables
}

# 添加 Warp
add_warp() {
    echo "正在添加 Warp..."
    if [ ! -f "menu.sh" ]; then
        wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh
    fi

    echo "请选择要执行的操作:"
    echo "h   帮助"
    echo "4   原无论任何状态 -> WARP IPv4"
    echo "4 lisence name   把 WARP+ Lisence 和设备名添加进去"
    echo "6   原无论任何状态 -> WARP IPv6"
    echo "d   原无论任何状态 -> WARP 双栈"
    echo "o   WARP 开关，自动开或关"
    echo "u   卸载 WARP"
    echo "n   断网时，用于刷WARP网络"
    echo "b   升级内核、开启BBR及DD"
    echo "a   免费 WARP 账户升级 WARP+"
    echo "a lisence   添加 WARP+ Lisence"
    echo "p   刷 Warp+ 流量"
    echo "c   安装 WARP Linux Client，开启 Socks5 代理模式"
    echo "l   安装 WARP Linux Client，开启 WARP 模式"
    echo "c lisence   添加 WARP+ Lisence"
    echo "r   WARP Linux Client 开关"
    echo "v   同步脚本至最新版本"
    echo "i   更换 WARP IP"
    echo "e   安装 iptables + dnsmasq + ipset 分流流媒体方案"
    echo "w   安装 WireProxy 解决方案"
    echo "y   WireProxy 开关"
    echo "k   切换 wireguard 内核 / wireguard-go-reserved"
    echo "g   切换 warp 全局 / 非全局 或首次以 非全局 模式安装"
    echo "s   s 4/6/d，切换优先级 warp IPv4 / IPv6 / 默认"
    echo "其他或空值   显示菜单界面"
    read -p "请输入选项编号或参数: " option

    case $option in
        h)
            bash menu.sh h
            ;;
        4)
            bash menu.sh 4
            ;;
        4*)
            bash menu.sh 4 ${option#4 }
            ;;
        6)
            bash menu.sh 6
            ;;
        d)
            bash menu.sh d
            ;;
        o)
            bash menu.sh o
            ;;
        u)
            bash menu.sh u
            ;;
        n)
            bash menu.sh n
            ;;
        b)
            bash menu.sh b
            ;;
        a)
            bash menu.sh a
            ;;
        a*)
            bash menu.sh a ${option#a }
            ;;
        p)
            bash menu.sh p
            ;;
        c)
            bash menu.sh c
            ;;
        c*)
            bash menu.sh c ${option#c }
            ;;
        l)
            bash menu.sh l
            ;;
        r)
            bash menu.sh r
            ;;
        v)
            bash menu.sh v
            ;;
        i)
            bash menu.sh i
            ;;
        e)
            bash menu.sh e
            ;;
        w)
            bash menu.sh w
            ;;
        y)
            bash menu.sh y
            ;;
        k)
            bash menu.sh k
            ;;
        g)
            bash menu.sh g
            ;;
        s)
            bash menu.sh s
            ;;
        *)
            echo "无效的选项或参数。"
            bash menu.sh
            ;;
    esac
}

# 主菜单
main_menu() {
    echo "请选择一个操作:"
    echo "1. 安装脚本"
    echo "2. 卸载脚本"
    echo "3. 更新脚本"
    echo "4. 设置 BBRv3"
    echo "5. 清理防火墙"
    echo "6. 添加 Warp"
    echo "7. 退出"
    read -p "请输入选项编号: " choice

    case $choice in
        1)
            install_script
            ;;
        2)
            uninstall_script
            ;;
        3)
            update_script
            ;;
        4)
            setup_bbr3
            ;;
        5)
            clean_firewall
            ;;
        6)
            add_warp
            ;;
        7)
            echo "退出程序..."
            exit 0
            ;;
        *)
            echo "无效的选择。"
            ;;
    esac
}

# 运行主菜单
while true; do
    main_menu
done
