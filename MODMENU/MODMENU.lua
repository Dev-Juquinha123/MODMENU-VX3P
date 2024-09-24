-- > Função de Input
function imgui.CustomInputTextWithHint(name, bool, hint, size, width, color, password)
    if not size then size = 1.0 end
    if not hint then hint = '' end
    if not width then width = 100 end
    if password then flags = imgui.InputTextFlags.Password else flags = '' end
    local clr = imgui.Col
    local pos = imgui.GetCursorScreenPos()
    local rounding = imgui.GetStyle().WindowRounding -- or ChildRounding
    local drawList = imgui.GetWindowDrawList()
    imgui.BeginChild("##"..name, imgui.ImVec2(width + 10, 25), false) -- 
        imgui.SetCursorPosX(5)
        imgui.SetWindowFontScale(size) -- size
        imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0.15, 0.18, 0.27, 0.00)) -- alpha 0.00 or color == WindowBg & ChildBg
        imgui.PushItemWidth(width) -- width
        if password then
            result = imgui.InputTextWithHint(name, u8(hint), bool, sizeof(bool), flags)
        else
            result = imgui.InputTextWithHint(name, u8(hint), bool, sizeof(bool)) -- imgui.InputTextWithHint
        end
        imgui.PopItemWidth()
        imgui.PopStyleColor(1)
        imgui.SetWindowFontScale(1.0) -- defoult size
        drawList:AddLine(imgui.ImVec2(pos.x, pos.y + (25*size)), imgui.ImVec2(pos.x + width + 15, pos.y + (25*size)), color, 3 * size) -- Desenha linha
    imgui.EndChild()
    return result
end

-- > Exemplo De Uso
resX, resY = getScreenResolution()
windows = {
    testwindow = {
        enable = new.bool(),
        login = new.char[256](),
        password = new.char[256]()
    }
}
imgui.OnFrame(
    function() return windows.testwindow.enable[0] and not isPauseMenuActive() end,
    function(self)
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(300, 200), imgui.Cond.FirstUseEver)
        imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(0, 0))
        local flags = imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar
        imgui.Begin('##LoginWindow', windows.newmenu.enable, flags)
            imgui.SetCursorPos( imgui.ImVec2(95, 15) )
            imgui.SubTitle('Autorizacao')
            imgui.SetCursorPos( imgui.ImVec2(60, 45) )
            imgui.CustomInputTextWithHint('##login', windows.testwindow.login, 'Username', 1.2, 150, imgui.ColorConvertFloat4ToU32(mc))
            imgui.SetCursorPos( imgui.ImVec2(60, 95) )
            imgui.CustomInputTextWithHint('##password', windows.testwindow.password, 'Password', 1.2, 150, imgui.ColorConvertFloat4ToU32(mc), true) -- 1. name  2. bool  3. hint  4. size  5. width  6. color  7. password flag
            imgui.SetCursorPos( imgui.ImVec2(100, 150) )
            imgui.Button('Entrar', imgui.ImVec2(100, 30))
        imgui.End()
        imgui.PopStyleVar()
    end
)
