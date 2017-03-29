<# JSON付きで呼び出す #>
function curl_json($url ,$method ,$data) {
  $JSON = $data -replace "$([Environment]::NewLine) *","" ;
  if ($PSVersionTable.PSVersion.Major > 2) {
    $AdoDbStream = New-Object -ComObject ADODB.Stream
 
    $AdoDbStream.Charset = "UTF-8"
    $AdoDbStream.Type = 2
    $AdoDbStream.Open()

    $AdoDbStream.WriteText($JSON)

    $pos = $AdoDbStream.Position
    $AdoDbStream.Position = 0
    $AdoDbStream.Type = 1
    $JSON=$AdoDbStream.Read($pos)

    $returnValue=Invoke-RestMethod -Uri $url -Method $method -Body $JSON
    $AdoDbStream.Close()
  } else {
    <# PowerShell V2用 #>
    $Request = [System.Net.WebRequest]::Create($url);
    $Request.Method = $method;
    $Request.ContentType = "application/json";
    $Request.Accept = "application/json";

    $utf8Bytes = [System.Text.Encoding]::UTF8.GetBytes($JSON);
    $request.ContentLength = $utf8Bytes.Length;
    $postStream = $request.GetRequestStream();
    $postStream.Write($utf8Bytes, 0, $utf8Bytes.Length);
    $postStream.Dispose();

    $response = $request.GetResponse();

    $reader = [IO.StreamReader] $response.GetResponseStream();
    $output = $reader.ReadToEnd();

    $reader.Close();
    $response.Close();

    add-type -assembly system.web.extensions
    $ps_js=new-object system.web.script.serialization.javascriptSerializer
    $returnValue=,$ps_js.DeserializeObject($output)
  }

  Write-Output $returnValue
}

<# JSONなしで呼び出す #>
function curl_nothing($url ,$method) {
  if ($PSVersionTable.PSVersion.Major > 2) {
    $returnValue=Invoke-RestMethod -Uri $url -Method $method
  } else {
    <# PowerShell V2用 #>
    $Request = [System.Net.WebRequest]::Create($url);
    $Request.Method = $method;
    $Request.ContentType = "application/json";
    $Request.Accept = "application/json";

    $response = $request.GetResponse();

    $reader = [IO.StreamReader] $response.GetResponseStream();
    $output = $reader.ReadToEnd();

    $reader.Close();
    $response.Close();

    add-type -assembly system.web.extensions
    $ps_js=new-object system.web.script.serialization.javascriptSerializer
    $returnValue=,$ps_js.DeserializeObject($output)
  }

  Write-Output $returnValue
}

<# セッションを起動する #>
function newSession($browser) {
  $url="http://localhost:4444/wd/hub/session"
  $method="POST"
  switch ($browser)
  {
    <# Mozilla Firefox #>
    "Firefox" {
            $JSON='{"desiredCapabilities":{"browserName":"firefox"},"requiredCapabilities":{}}'
        }
    <# Google Chrome #>
    "chrome" {
            $JSON='{"desiredCapabilities":{"browserName":"chrome"},"requiredCapabilities":{}}'
        }
    <# Internet Explorer Win32版 #>
    "ie" {
            $JSON = '{"desiredCapabilities":{"browserName":"internet explorer"},"requiredCapabilities":{}}'
        }
    "Edge" {
            $JSON = '{"desiredCapabilities":{"browserName":"MicrosoftEdge"},"requiredCapabilities":{}}'
       }
    <# それ以外の場合は Google Chrome #>
    default {
            $JSON='{"desiredCapabilities":{"browserName":"chrome"},"requiredCapabilities":{}}'
        }
  }

  $response=curl_json $url $method $JSON
  Write-Output $response.sessionId
}


<# セッションを閉じる #>
function closeSession($sessionId) {
  $url="http://localhost:4444/wd/hub/session/$sessionId"
  $method="DELETE"
  $response=curl_nothing $url $method
}


<# URLへ移動 #>
function goURL($sessionId, $URL) {
  $JSON='{"url":"' + $URL + '"}'
  $url="http://localhost:4444/wd/hub/session/$sessionId/url"
  $method="POST"
  $response=curl_json $url $method $JSON
}

<# タイトル取得 #>
function getTitle($sessionId) {
  $url="http://localhost:4444/wd/hub/session/$sessionId/title"
  $method="GET"
  $response=curl_nothing $url $method
  $title = $response.value;
  Write-Output $title
}

<# タイトル表示待ち #>
<# タイトル1つ #>
function waitForTitle($sessionId, $title1) {
  $url="http://localhost:4444/wd/hub/session/$sessionId/title"
  $method="GET"
  do
  {
    Start-Sleep -s 1
    $response=curl_nothing $url $method
    $title = $response.value;
  } until($title.Contains($title1))
  Write-Output $title
}

<# タイトル2つ #>
function waitForTwoTitles($sessionId, $title1, $title2) {
  $url="http://localhost:4444/wd/hub/session/$sessionId/title"
  $method="GET"
  do
  {
    Start-Sleep -s 1
    $response=curl_nothing $url $method
    $title = $response.value;
  } until($title.Contains($title1) -or $title.Contains($title2))
  Write-Output $title
}

<# 部品取得 #>
function getElement($sessionId, $selector, $locator) {
  $JSON='{"using":"' + $selector + '","value":"' + $locator + '"}'
  $url="http://localhost:4444/wd/hub/session/$sessionId/element"
  $method="POST"
  do
  {
     $response=curl_json $url $method $JSON
  } until($response.status -eq 0)
  Write-Output $response.value.ELEMENT
}

<# By name #>
function getElementByName($sessionId, $name) {
  $response=getElement $sessionId "name" $name
  Write-Output $response
}

<# By partial link text #>
function getElementByPartialLinkText($sessionId, $PartialLinkText) {
  $response=getElement $sessionId "partial link text" $PartialLinkText
  Write-Output $response
}

<# By css selector #>
function getElementByCSSselector($sessionId, $CSSselector) {
  $response=getElement $sessionId "css selector" $CSSselector
  Write-Output $response
}

<# Click Element #>
function clickElement($sessionId, $element) {
  $method="POST"
  $url="http://localhost:4444/wd/hub/session/$sessionId/element/$element/click"

  $response=curl_nothing $url $method
}

<# Send Keys to Element #>
function sendKeysToElement($sessionId, $element, $text) {
  $JSON='{"value":["' + $text + '"]}'
  $method="POST"
  $url="http://localhost:4444/wd/hub/session/$sessionId/element/$element/value"

  $response=curl_json $url $method $JSON
}
