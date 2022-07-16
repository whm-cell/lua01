local redisKey = KEYS[1]

-- 设置重置时间
local restTime = tonumber(ARGV[1])

local cou = redis.call("get", redisKey)

if cou == false then
    redis.call("set", redisKey, 0)
    redis.call("incr", redisKey)
    redis.call("expire", redisKey, restTime)
    local errormsg = string.format("%s%d","密码错误,剩余重试次数：",3)
    return errormsg

else
    -- 判断key值是否大于2
    if tonumber(cou) > 2 then
        -- 输出  同一IP重试次数过多 ，请5分钟后再试
        local errmsg = string.format("%s","同一IP重试次数过多 ，请5分钟后再试")
        return errmsg
    else
        redis.call("incr", redisKey)
        redis.call("expire", redisKey, restTime)
        local errormsg = string.format("%s%d","密码错误,剩余重试次数：",3-tonumber(cou))

        return errormsg
    end
end

