<# JSON付きで呼び出す #>
function curl_json($url ,$method ,$data) {
  $JSON = $data -replace "$([Environment]::NewLine) *","" ;
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

  Write-Output $returnValue
}

<# JSONなしで呼び出す #>
function curl_nothing($sessionURL ,$method) {
  $returnValue=Invoke-RestMethod -Uri $sessionURL -Method $method

  Write-Output $returnValue
}

<# セッションを起動する #>
function newSession() {
  $response = "http://localhost:9515/session"
  $method="POST"
  Start-Process -FilePath chromedriver
  <# Google Chrome #>
  $JSON='{"desiredCapabilities":{"browserName":"chrome"},"requiredCapabilities":{}}'
  $response = $response + "/" + (curl_json $response $method $JSON).sessionId
  Write-Output $response
}


<# セッションを閉じる #>
function closeSession($sessionURL) {
  $method="DELETE"
  $response=curl_nothing $sessionURL $method
  Stop-Process -Name chromedriver
}


<# Windowを最大化 #>
function maximizeWindow($sessionURL) {
  $url=$sessionURL + "/window/maximize"
  $method = "POST"
  $response=curl_nothing $url $method
}


<# URLへ移動 #>
function goURL($sessionURL, $URL) {
  $JSON='{"url":"' + $URL + '"}'
  $url=$sessionURL + "/url"
  $method="POST"
  $response=curl_json $url $method $JSON
}

<# タイトル取得 #>
function getTitle($sessionURL) {
  $url=$sessionURL + "/title"
  $method="GET"
  $response=curl_nothing $url $method
  $title = $response.value;
  Write-Output $title
}

<# タイトル表示待ち #>
<# タイトル1つ #>
function waitForTitle($sessionURL, $title1) {
  $url=$sessionURL + "/title"
  $method="GET"
  do
  {
    Start-Sleep -s 1
    $response=curl_nothing $url $method
    $title = $response.value;
  } until($title.Contains($title1))
  Write-Output $title
}

<# 部品取得 #>
function getElement($sessionURL, $selector, $locator) {
  $JSON='{"using":"' + $selector + '","value":"' + $locator + '"}'
  $url=$sessionURL + "/element"
  $method="POST"
  do
  {
     $response=curl_json $url $method $JSON
  } until($response.status -eq 0)
  Write-Output $response.value.ELEMENT
}

<# By name #>
function getElementByName($sessionURL, $name) {
  $response=getElement $sessionURL "name" $name
  Write-Output $response
}

<# By partial link text #>
function getElementByPartialLinkText($sessionURL, $PartialLinkText) {
  $response=getElement $sessionURL "partial link text" $PartialLinkText
  Write-Output $response
}

<# By css selector #>
function getElementByCSSselector($sessionURL, $CSSselector) {
  $response=getElement $sessionURL "css selector" $CSSselector
  Write-Output $response
}

<# Click Element #>
function clickElement($sessionURL, $element) {
  $method="POST"
  $url=$sessionURL + "/element/$element/click"

  $response=curl_nothing $url $method
}

<# Send Keys to Element #>
function sendKeysToElement($sessionURL, $element, $text) {
  $JSON='{"value":["' + $text + '"]}'
  $method="POST"
  $url=$sessionURL + "/element/$element/value"

  $response=curl_json $url $method $JSON
}
