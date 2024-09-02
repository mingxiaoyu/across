#!/bin/bash

# 下载脚本并处理
install_or_update_script() {
    local new_script_url="https://raw.githubusercontent.com/mingxiaoyu/across/main/om.sh"
    local tmp_script_path="/tmp/om.sh"
    local script_path="/usr/local/bin/om"
    local link_path="/usr/local/bin/om"

    echo "正在处理脚本..."

    # 临时下载新的脚本到 /tmp 目录
    curl -o "$tmp_script_path" "$new_script_url" || { echo "下载失败"; exit 1; }

    # 赋予新的脚本执行权限
    chmod +x "$tmp_script_path" || { echo "赋予执行权限失败"; exit 1; }

    # 复制新脚本到系统目录（覆盖现有脚本）
    sudo cp "$tmp_script_path" "$script_path" || { echo "复制脚本失败"; exit 1; }

    # 创建或更新符号链接
    sudo ln -sf "$script_path" "$link_path" || { echo "创建符号链接失败"; exit 1; }

    echo "脚本处理完成。"
    echo "请重新运行 'om' 命令以应用更新。"
}

# 卸载功能
uninstall_script() {
    local script_path="/usr/local/bin/om"
    local link_path="/usr/local/bin/om"

    # 删除符号链接
    sudo rm -f "$link_path" || { echo "删除符号链接失败"; exit 1; }

    # 删除脚本文件
    sudo rm -f "$script_path" || { echo "删除脚本文件失败"; exit 1; }

    echo "卸载完成。"
    exit 0
}

# 其他功能函数保持不变...

# 主菜单
main_menu() {
    echo "请选择一个操作:"
    echo "1. 安装或更新脚本"
    echo "2. 卸载脚本"
    echo "3. 设置 BBRv3"
    echo "4. 清理防火墙"
    echo "5. 添加 Warp"
    echo "6. 退出"
    read -p "请输入选项编号: " choice

    case $choice in
        1)
            install_or_update_script
            ;;
        2)
            uninstall_script
            ;;
        3)
            setup_bbr3
            ;;
        4)
            clean_firewall
            ;;
        5)
            add_warp
            ;;
        6)
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
