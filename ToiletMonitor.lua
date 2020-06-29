require "core"

-- FineToilet --
-- Toilet Monitor --
-- author:shiqian42

-- Define --
DOOR_STATUS = 0
DOOR_PIN = 1
MONITOR_RSSI = 0
MAC_ADD = nil
CONTENT_TYPE = 'Content-Type: application/json\r\n'

-- Set GPIO Mode INPUT --
gpio.mode(DOOR_PIN, gpio.INPUT)

-- WiFI Configuration --
station_cfg={}
station_cfg.ssid = core.SSID_CON
station_cfg.pwd = core.SSID_PASSWD

-- Get Mac as unique Device Code--
getMac()

-- -- --

-- Methods --
-- Get Rssi --
function getRSSI()
    MONITOR_RSSI = wifi.getrssi()
end

-- Get MAC Address --
function getMac()
    MAC_ADD = wifi.sta.getmac()
end

-- Wifi Connect --
function setupWifi()
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
end

-- Register Service --
-- Use MAC as device code, register a service. Register every time after reboot.
function registerService(deviceCode)

end

-- Message Deliver Service --
-- {"key": "4F-NORTH","status": "FREE"} --
-- No need to accomplish JSON support, so u need to encode urself. --
function deliverMessage(message)
    print(message)
    http.post(URL_API,CONTENT_TYPE,
    message,
    function(code, data)
     if (code < 0) then
         print("HTTP request failed")
     else
         print(code, data)
     end
    end)
end

-- Battery Test --


-- HeartBeat --
-- Send HeartBeat & Battery Condition --






