-- North Version --
-- author:shiqian42
-- Define --
STATUS=0
LAST_STATUS=1
-- PIN is D1 on Board--
HOT_WATER_PIN=1

-- Set GPIO Mode INPUT --
gpio.mode(HOT_WATER_PIN, gpio.INPUT)

-- WiFI Config --
station_cfg={}
station_cfg.ssid="fanruan"
station_cfg.pwd="fanruan234567"

-- Setup Connection --
wifi.setmode(wifi.STATION)
wifi.sta.autoconnect(1)
wifi.sta.config(station_cfg)
tmr.create():alarm(1000,tmr.ALARM_AUTO,function(wifi_timer)
    if wifi.sta.getip() == nil then
        print("Connecting to AP...\n")
    else
        print("Connect OK!")
        wifi_timer:unregister()
    end
end)

print("############ STAGE2 ##############")

-- Check Every 500ms
tmr.create():alarm(500,tmr.ALARM_AUTO,function(wifi_timer)
    LAST_STATUS = STATUS
    STATUS = gpio.read(HOT_WATER_PIN)
    
    if STATUS == LAST_STATUS then
        print("############ No Change! ##############")
    elseif STATUS == 1 then
        HotWaterReady()
        print("############ HotWaterReady! ###########")
    elseif STATUS == 0 then
        HotWaterNotReady()
        print("############ HotWaterNotReady! ########")
    end
end)

-- Messages Sending Methods
-- Ready Method
function HotWaterReady()
    print("HotWaterReady()")
    http.post('https://tomcat.zyee.me/happy/api/water/status',
       'Content-Type: application/json\r\n',
       '{"key": "4F-NORTH","status": "FREE"}',
       function(code, data)
        if (code < 0) then
            print("HTTP request failed")
        else
            print(code, data)
        end
    end)
end
    
-- Not Ready Method
function HotWaterNotReady()
    print("HotWaterNotReady()")
    http.post('https://tomcat.zyee.me/happy/api/water/status',
        'Content-Type: application/json\r\n',
        '{"key": "4F-NORTH","status": "BUSY"}',
        function(code, data)
         if (code < 0) then
             print("HTTP request failed")
         else
             print(code, data)
         end
        end)
end