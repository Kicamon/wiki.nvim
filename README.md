# wiki.nvim
#### nvim插件制作教程，相关视频：https://www.bilibili.com/video/BV1Qb4y1g7fU/

```lua
{
    "Kicamon/wiki.nvim",
    require("wiki").setup({
        path = "~/wiki/", -- wiki路径
        wiki_open = "<leader>ww", -- 打开wiki
        wiki_file = "<cr>", -- 打开或者创建文件
    })
}
```

> 希望可以帮到想要写插件的萌新捏，大家一起为nvim社区做贡献！
