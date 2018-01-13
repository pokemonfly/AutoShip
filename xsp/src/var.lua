module = {}
module.constant = "这是一个常量"

function module.func1()
    io.write("这是一个公有函数！\n")
end



module['main'] = {
}

return module