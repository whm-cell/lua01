
local function getRandomCode()
    local localTimes = ARGV[1]

    local rchars = {"1","2","3","4","5","6","7","8","9","0"}

    math.randomseed(tostring(localTimes):reverse():sub(1, 7))
    local rc = ""
    for i=1, 6 do
        local r = math.random(1,#rchars);
        rc = rc..rchars[r]
    end
    return rc
end


local rcode = getRandomCode()

local key = KEYS[1]

-- 递归调用
local function recursion(key, vv)
    local exist = redis.call("sismember", key, vv)
    if exist == 0 then
        -- 将值设置到redis
        local res = redis.call("sadd", key, vv)
        if res == 1 then
            return vv
        end
    end
    if exist == 1 then
        rcode = getRandomCode()
        recursion(key, vv)
    end
    return recursion(key, vv)
end


local res = recursion(key, rcode)
return res
