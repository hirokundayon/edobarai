<# PowerShell サブルーチン #>
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

. "$scriptPath\\edobaraiSub.ps1"

<# 引数で起動するWebブラウザを指定 #>
$browser = $Args -join " ";

<# ブラウザ起動 #>
$sessionURL=newSession

<# Googleのページへ移動 #>
goURL $sessionURL "http://www.google.co.jp/"

<# 表示待ち #>
waitForTitle $sessionURL "Google"

<# 「OSC Fukuoka 太宰府」を検索 #>
$element=getElementByName $sessionURL "q"

sendKeysToElement $sessionURL $element "OSC Fukuoka 太宰府\n"

<# 検索結果が表示されるまで待つ #>
waitForTitle $sessionURL "OSC Fukuoka 太宰府 - Google 検索"

<# OSC2011 Fukuoka のレポートを表示させる #>
$element=getElementByPartialLinkText $sessionURL "OSC2011 Fukuoka 太宰府にて開催！！"

clickElement $sessionURL $element

<# レポートが表示されるまで待つ #>
waitForTitle $sessionURL "OSC2011 Fukuoka 太宰府にて開催！！"

<# LTの写真を表示 #>
$CSSselector = "img[title='仏様に見守られながらのLT']";
$element=getElementByCSSselector $sessionURL $CSSselector

clickElement $sessionURL $element

<# 写真が表示されるまで待つ #>
waitForTitle $sessionURL "仏様に見守られながらのLT"

<# 写真をクリック #>
$CSSselector = "a[href='https://www.ospn.jp/press/wp-content/uploads/2011/12/LT.jpg']"
$element=getElementByCSSselector $sessionURL $CSSselector

clickElement $sessionURL $element

<# 10秒待つ #>
Start-Sleep -s 10
<# 終了処理 #>
closeSession $sessionURL

