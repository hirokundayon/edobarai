<# PowerShell サブルーチン #>

. ".\\edobaraiSub.ps1"

<# 引数で起動するWebブラウザを指定 #>
$browser = $Args -join " ";

<# ブラウザ起動 #>
$sessionId=newSession $browser

<# Windowを最大化 #>
<# maximizeWindow $sessionId #>

<# Googleのページへ移動 #>
goURL $sessionId "http://www.google.co.jp/"

<# 表示待ち #>
waitForTitle $sessionId "Google"

<# 「OSC Fukuoka 太宰府」を検索 #>
$element=getElementByName $sessionId "q"

sendKeysToElement $sessionId $element "OSC Fukuoka 太宰府\n"

<# 検索結果が表示されるまで待つ #>
waitForTitle $sessionId "OSC Fukuoka 太宰府 - Google 検索"

<# OSC2011 Fukuoka のレポートを表示させる #>
$element=getElementByPartialLinkText $sessionId "OSC2011 Fukuoka 太宰府にて開催！！"

clickElement $sessionId $element

<# レポートが表示されるまで待つ #>
waitForTitle $sessionId "OSC2011 Fukuoka 太宰府にて開催！！"

<# LTの写真を表示 #>
$CSSselector = "img[title='仏様に見守られながらのLT']";
$element=getElementByCSSselector $sessionId $CSSselector

clickElement $sessionId $element

<# 写真が表示されるまで待つ #>
waitForTitle $sessionId "仏様に見守られながらのLT"

<# 写真をクリック #>
$CSSselector = "a[href='https://www.ospn.jp/press/wp-content/uploads/2011/12/LT.jpg']"
$element=getElementByCSSselector $sessionId $CSSselector

clickElement $sessionId $element

<# 10秒待つ #>
Start-Sleep -s 10
<# 終了処理 #>
closeSession $sessionId
