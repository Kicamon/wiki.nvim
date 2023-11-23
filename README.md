# wiki.nvim
A blazing fast and minimal less than 60 lines. neovim wiki plugin like [vimwiki](https://github.com/vimwiki/vimwiki).

### install
```lua
{
    "Kicamon/wiki.nvim",
    require("wiki").setup({
        path = "~/wiki/", -- wiki dire
        wiki_open = "<leader>ww", -- open wiki index
        wiki_file = "<cr>", -- create or open a file
    })
}
```

### end

If you are interested in the production process of this plugin and good at Chinese, you can watch the video at the link below

nvim插件制作教程，相关视频：https://www.bilibili.com/video/BV1Qb4y1g7fU/

### License MIT
