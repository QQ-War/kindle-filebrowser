local WidgetContainer = require("ui/widget/container/widgetcontainer")
local UIManager = require("ui/uimanager")
local InfoMessage = require("ui/widget/infomessage")
local InputDialog = require("ui/widget/inputdialog")
local DataStorage = require("datastorage")
local LuaSettings = require("luasettings")
local _ = require("gettext")
local logger = require("logger")

local FileBrowser = WidgetContainer:extend({
    name = "File Browser",
})

local function show_msg(text, timeout)
    UIManager:show(InfoMessage:new({
        text = text,
        timeout = timeout or 2,
    }))
end

function FileBrowser:init()
    self.settings_data = LuaSettings:open(self:_settingsPath())
    if self.ui and self.ui.menu then
        self.ui.menu:registerToMainMenu(self)
    end
end

function FileBrowser:_settingsPath()
    return DataStorage:getSettingsDir() .. "/filebrowser.lua"
end

function FileBrowser:_getExtensionsDirName()
    return self.settings_data and self.settings_data.data and self.settings_data.data.extensions_dir_name or nil
end

function FileBrowser:_setExtensionsDirName(name)
    if not self.settings_data then return end
    self.settings_data.data.extensions_dir_name = name
    self.settings_data:flush()
end

function FileBrowser:_baseDir()
    local dir_name = self:_getExtensionsDirName()
    if dir_name and dir_name ~= "" then
        return "/mnt/us/extensions/" .. dir_name
    end
    return self.path or "."
end

function FileBrowser:_exec(cmd)
    local base = self:_baseDir()
    local full_cmd = string.format('cd "%s" && %s', base, cmd)
    logger.info("filebrowser exec:", full_cmd)
    return os.execute(full_cmd)
end

function FileBrowser:_isRunning()
    local handle = io.popen("ps aux | grep '[f]ilebrowser'")
    if not handle then
        return false
    end
    local output = handle:read("*a") or ""
    handle:close()
    return output ~= ""
end

function FileBrowser:addToMainMenu(menu_items)
    if not (self.ui and menu_items) then
        return
    end
    if self.ui.document then
        return
    end

    menu_items.filebrowser_main = {
        text = _("File Browser"),
        sorting_hint = "filemanager",
        sub_item_table = {
            {
                text_func = function()
                    local name = self:_getExtensionsDirName()
                    if name and name ~= "" then
                        return _("MRPI dir: ") .. name
                    end
                    return _("MRPI dir: (plugin bundled)")
                end,
                keep_menu_open = true,
                callback = function()
                    local dialog
                    dialog = InputDialog:new{
                        title = _("Set MRPI dir name"),
                        input_hint = "kindle-filebrowser",
                        description = _("Only directory name under /mnt/us/extensions"),
                        buttons = {{{
                            text = _("Cancel"),
                            callback = function()
                                UIManager:close(dialog)
                            end
                        }, {
                            text = _("OK"),
                            is_enter_default = true,
                            callback = function()
                                local input_text = dialog:getInputText() or ""
                                input_text = input_text:gsub("^%s+", ""):gsub("%s+$", "")
                                if input_text == "" then
                                    self:_setExtensionsDirName(nil)
                                    show_msg(_("MRPI dir cleared"))
                                else
                                    self:_setExtensionsDirName(input_text)
                                    show_msg(_("MRPI dir saved"))
                                end
                                UIManager:close(dialog)
                            end
                        }}}
                    }
                    UIManager:show(dialog)
                    dialog:onShowKeyboard()
                end
            },
            {
                text = _("Start"),
                callback = function()
                    self:_exec("./filebrowser_wrapper.sh sh ./filebrowser_start.sh")
                    show_msg(_("File Browser starting"))
                end
            },
            {
                text = _("Start (Auth)"),
                help_text = _("Default user/password: admin / admin"),
                callback = function()
                    self:_exec("./filebrowser_wrapper.sh sh ./filebrowser_start_auth.sh")
                    show_msg(_("File Browser starting (auth)"))
                end
            },
            {
                text = _("Start (root path)"),
                help_text = _("Requires mntroot rw first"),
                callback = function()
                    self:_exec("./filebrowser_wrapper.sh sh ./filebrowser_start_auth.sh /")
                    show_msg(_("File Browser starting (root path)"))
                end
            },
            {
                text = _("Show Status"),
                keep_menu_open = true,
                callback = function()
                    local running = self:_isRunning()
                    show_msg(running and _("File Browser is running") or _("File Browser is not running"), 2)
                end
            },
            {
                text = _("Kill"),
                keep_menu_open = true,
                callback = function()
                    self:_exec("./kill.sh")
                    show_msg(_("File Browser stopped"))
                end
            },
            {
                text = _("Update binary file"),
                keep_menu_open = true,
                callback = function()
                    self:_exec("./update_binfile.sh > log.txt 2>&1; ./viewtxt.sh log.txt")
                end
            },
            {
                text = _("Reset"),
                keep_menu_open = true,
                callback = function()
                    self:_exec("rm -f ./filebrowser.db ./BINFILE_VERSION ./linux-armv7-filebrowser*")
                    show_msg(_("Reset done"))
                end
            },
        },
    }
end

return FileBrowser
