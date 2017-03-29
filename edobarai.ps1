<# 引数で起動するWebブラウザを指定 #>
$browser = $Args -join " ";

<# selenium-standalone-server 起動 #>
<# ./selenium-standalone-server.bat #>

switch ($browser)
{
    <# Mozilla Firefox #>
    "Firefox" {
            $data = '{"desiredCapabilities":{"browserName":"firefox"},"requiredCapabilities":{}}'
        }
    <# Google Chrome #>
    "chrome" {
            $data = '{"desiredCapabilities":{"browserName":"chrome"},"requiredCapabilities":{}}'
        }
    <# Internet Explorer #>
    "ie" {
            $data = '{"desiredCapabilities":{"browserName":"internet explorer"},"requiredCapabilities":{}}'
        }
    <# Edge #>
    "Edge" {
            $data = '{"desiredCapabilities":{"browserName":"MicrosoftEdge"},"requiredCapabilities":{}}'
        }
    <# AndroidのGoofle Chrome #>
    "Android" {
            $data = '{"desiredCapabilities":{"chromeOptions": {"androidPackage":"com.android.chrome"},"browserName":"chrome"},"requiredCapabilities":{}}'
        }
    <# それ以外の場合は Google Chrome #>
    default {
            $browser = "chrome";
            $data = '{"desiredCapabilities":{"browserName":"chrome"},"requiredCapabilities":{}}'
        }
}

$url = "http://localhost:4444/wd/hub/session"
$method = "POST"

$response = Invoke-RestMethod -Uri $url -Body $data -Method $method
$sessionId = $response.sessionId

<# Webブラウザのウィンドウを最大化 #>
$url = "http://localhost:4444/wd/hub/session/$sessionId/window/maximize"
$method = "POST"
$response = Invoke-RestMethod -Uri $url -Method $method

<# Googleのページへ移動 #>
$url = "http://localhost:4444/wd/hub/session/$sessionId/url"
$method = "POST"
$data = '{"url":"https://www.google.co.jp/"}'
$response = Invoke-RestMethod -Uri $url -Body $data -Method $method

<# 表示待ち #>
$url = "http://localhost:4444/wd/hub/session/$sessionId/title"
$method = "GET"
do
{
  Start-Sleep -s 1
  $response = Invoke-RestMethod -Uri $url -Method $method
  $title = $response.value
} until($title.Contains("Google"))

<# 検索 #>
$url = "http://localhost:4444/wd/hub/session/$sessionId/element"
$method = "POST"
$data = '{"using":"name","value":"q"}'
$response = Invoke-RestMethod -Uri $url -Body $data -Method $method
$elementId = $response.value.ELEMENT

$url = "http://localhost:4444/wd/hub/session/$sessionId/element/$elementId/value"
$method = "POST"
$data = '{"value":["OSC Fukuoka\n"]}'
$response = Invoke-RestMethod -Uri $url -Body $data -Method $method

<# 検索結果が表示されるまで待つ #>
$url = "http://localhost:4444/wd/hub/session/$sessionId/title"
$method = "GET"
do
{
  Start-Sleep -s 1
  $response = Invoke-RestMethod -Uri $url -Method $method
  $title = $response.value;
} until($title.Contains("OSC Fukuoka"))

Start-Sleep -s 10

<# セッション終了 #>
$url = "http://localhost:4444/wd/hub/session/$sessionId"
$method = "DELETE"
$response = Invoke-RestMethod -Uri $url -Method $method
