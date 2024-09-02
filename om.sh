#!/bin/bash

# 下载并更新脚本
update_script() {
    echo "正在更新脚本..."
    local new_script_url="https://raw.githubusercontent.com/mingxiaoyu/across/main/om.sh"
    local tmp_script_path="/tmp/om.sh"
    local script_path="/usr/local/bin/om.sh"
    local link_path="/usr/local/bin/om"

    # 临时下载新的脚本到 /tmp 目录
    curl -o "$tmp_script_path" "$new_script_url" || { echo "下载失败"; exit 1; }

    # 赋予新的脚本执行权限
    chmod +x "$tmp_script_path" || { echo "赋予执行权限失败"; exit 1; }

    # 移动或复制新脚本到系统目录
    sudo cp "$tmp_script_path" "$script_path" || { echo "复制脚本失败"; exit 1; }

    # 创建或更新符号链接
    sudo ln -sf "$script_path" "$link_path" || { echo "创建符号链接失败"; exit 1; }

    echo "脚本更新完成。"
    echo "请重新运行 'om' 命令以应用更新。"
    exit 0
}

# 安装功能
install_script() {
    local tmp_script_path="/tmp/om.sh"
    local script_path="/usr/local/bin/om.sh"
    local link_path="/usr/local/bin/om"

    # 下载脚本到 /tmp 目录
    cp "$0" "$tmp_script_path" || { echo "复制脚本到 /tmp 失败"; exit 1; }

    # 赋予执行权限
    chmod +x "$tmp_script_path" || { echo "赋予执行权限失败"; exit 1; }

    # 复制脚本到系统目录
    sudo cp "$tmp_script_path" "$script_path" || { echo "安装脚本失败"; exit 1; }

    # 创建符号链接
    sudo ln -sf "$script_path" "$link_path" || { echo "创建符号链接失败"; exit 1; }

    echo "安装完成。你可以使用 'om' 命令来调用脚本。"
}

# 卸载功能
uninstall_script() {
    local script_path="/usr/local/bin/om.sh"
    local link_path="/usr/local/bin/om"

    # 删除符号链接
    sudo rm -f "$link_path" || { echo "删除符号链接失败"; exit 1; }

    # 删除脚本文件
    sudo rm -f "$script_path" || { echo "删除脚本文件失败"; exit 1; }

    echo "卸载完成。"
}

# 其余功能函数保持不变...

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
